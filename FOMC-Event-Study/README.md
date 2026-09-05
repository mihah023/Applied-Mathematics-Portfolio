# Fed Rate-Change Event Study

*Does the stock market react to Fed interest rate decisions — and if it does, where does that reaction actually live: the market as a whole, or individual stocks?*

---

## The question

"The market reacts to Fed decisions" is conventional wisdom in finance — this project checks it with data, and goes one step further: **if the market does react, where does that reaction live?** Does a specific stock do something "special" of its own, or does it just move because the whole market moves?

Three questions, each using a different method, each one opening up the next:

1. **Does the market as a whole (SPY) get more volatile around FOMC rate-decision dates?**
2. **Do individual assets (AAPL, XLF, TLT) move together with the market around these events** — and after netting out that normal co-movement, **is there any abnormal reaction left over?**
3. *(Exploratory)* **Does VIX — the market's own uncertainty gauge — change around the announcement, as theory predicts?**

---

## Step 1: Data and event-date construction

Three data sources aligned by date:

- **SPY** (S&P 500 ETF — "the market") — daily, 2013–2026, Yahoo Finance
- **AAPL, TLT (long-term Treasuries), XLF (financial sector ETF)** — same range, Yahoo Finance
- **VIX** — implied-volatility index, Yahoo Finance (ticker `^VIX`)

Event dates are the 31 actual FOMC rate-change **announcement** dates, cross-checked against the official FOMC action history — not the dates in FRED's `DFEDTARU` series, which record when a new rate becomes *effective*. Effective dates typically lag the announcement by one trading day, so using them directly would misalign the event window with the day the market actually had the information (e.g. the emergency cut was announced Sunday evening, March 15, 2020, but took effect Monday, March 16).

Each event carries a `timing` flag — `intraday` (announced during market hours, the large majority) or `after_hours` (only March 15, 2020) — which a mapping function uses to find the correct trading day for the reaction window:

```python
def map_to_event_day(ann_date, timing, trading_dates_sorted):
    if timing == "after_hours":
        candidates = [d for d in trading_dates_sorted if d > ann_date]   # wait for the next session
    else:
        candidates = [d for d in trading_dates_sorted if d >= ann_date]  # same-day reaction is possible
    return candidates[0] if candidates else None
```

All 31 event windows were checked for overlap (a ±1 window could double-count a trading day if two announcements landed close together) — none found; every FOMC announcement in the sample is far enough from the next that this isn't a concern here.

---

## Step 2: Q1 — Is the market unusually volatile?

**Method:** rather than using `|return|` as a rough volatility proxy, this section fits a **GARCH(1,1)** model and uses its conditional volatility, $\sigma_t = \sqrt{Var(R_t \mid \mathcal{F}_{t-1})}$ — an estimate that accounts for volatility clustering, not just a single day's noisy return.

To avoid look-ahead bias, GARCH is estimated **walk-forward**: refit periodically (every ~250 trading days) using only the return history available up to that point, then $\sigma_t$ is updated day-by-day with the fixed parameters and the actual realized returns. A parameter estimated in 2018 never sees 2023 data. Each event's window `[-1, 0, +1]` is collapsed to its mean $\sigma_t$; **30 of the 31 events** have enough pre-event history (~3 years minimum) for this — the earliest event is excluded.

The comparison group is 814 non-overlapping "normal" 3-day windows, built by excluding a ±2-day buffer around every event. **Important limitation:** these windows are not matched to events by time period or volatility regime — if event windows disproportionately fall in high-volatility periods, part of any observed difference could reflect that regime rather than FOMC itself. The results below (particularly what happens after removing March 2020) illustrate this limitation directly.

**Results (30 events):**

| | Mean conditional volatility | Welch p | Mann-Whitney p | Permutation p | Bootstrap 95% CI |
|---|---|---|---|---|---|
| 30 events | 1.22% | 0.187 | 0.473 | 0.011 | [-0.05%, 0.76%] |
| Normal days | 0.93% | | | | |

Evidence is **mixed, not consistent**: only the permutation test clears 5% significance, Welch and Mann-Whitney don't, and the bootstrap CI still (barely) contains zero. A sample-size sensitivity check — repeatedly subsampling the non-event pool down to 30 windows — gives a similarly positive range ([0.08%, 0.44%]), so the result isn't simply an artifact of the non-event pool being much larger. It does *not*, however, address the regime-matching limitation above.

Excluding the 2 emergency COVID cuts (March 3 and March 15, 2020, leaving 28 events):

| | Mean conditional volatility | Welch p | Mann-Whitney p | Permutation p | Bootstrap 95% CI |
|---|---|---|---|---|---|
| 28 events (COVID removed) | 0.98% | 0.638 | 0.914 | 0.648 | [-0.13%, 0.24%] |

The gap collapses from +0.29pp to +0.05pp, and **no test remains significant**. In other words: **the full-sample volatility difference is largely driven by two extreme COVID-era events, not a stable pattern across ordinary FOMC meetings.** This is a materially different — and more honest — conclusion than "FOMC increases volatility," and it's a direct consequence of properly separating regime effects from the event itself once enough data was excluded to test it.

On direction: mean return isn't significantly different between event and normal days (Welch p=0.605, Mann-Whitney p=0.167, permutation p=0.414) — the Fed doesn't "signal" a price direction around these events, at least not detectably in this sample.

*(One caveat on the permutation test specifically: it assumes observations are exchangeable under the null, which is a stronger assumption for time-dependent financial data with regime effects than for i.i.d. samples — so its p-value shouldn't be read as stronger evidence than Welch/Mann-Whitney disagreeing with it.)*

---

## Step 3: Q2a — Do individual assets move with the market?

Before asking whether an asset has an *abnormal* reaction, it needs a baseline: does it move in the same direction as the market **around these specific events** at all? (This is a correlation over 31 three-day event windows, not an unconditional full-sample beta.)

**Method:** for each event, compute each asset's compounded 3-day return (`(1+R₁)(1+R₂)(1+R₃)-1`), compare its sign to SPY's, and compute the correlation across all 31 events.

| Asset | % same direction as SPY | Correlation (r) |
|---|---|---|
| AAPL | 74% | 0.83 |
| XLF (financials) | 84% | 0.90 |
| TLT (Treasuries) | 52% | -0.07 |

AAPL and XLF track the market closely around FOMC events, as expected for equities. **TLT is essentially a coin flip** — Treasuries respond to their own rate-expectation logic, which doesn't necessarily align with equity sentiment.

---

## Step 4: Q2b — Is there any reaction beyond just moving with the market?

**Method — Market Model, run for AAPL, TLT, and XLF:**

1. For each event, take the 120 trading days before it (with a 21-day gap to avoid contamination from pre-event anticipation) and regress `asset_return = alpha + beta × market_return`.
2. Use that alpha/beta to compute the asset's *expected* return during the 3-day event window (identified by actual calendar date, not table position, so a missing day in one asset's series can't silently shift the window).
3. Subtract: `actual − expected` = the abnormal part each day.
4. Sum the 3 days → **Cumulative Abnormal Return (CAR)**, one number per event, 31 per asset.

| Asset | Mean beta | Mean CAR | t-test p | Wilcoxon p | Bootstrap 95% CI |
|---|---|---|---|---|---|
| AAPL | 1.24 | +0.07% | 0.845 | 0.750 | [-0.65%, +0.76%] |
| TLT | -0.14 | +0.44% | 0.117 | 0.107 | [-0.10%, +0.96%] |
| XLF | 0.98 | -0.25% | 0.307 | 0.189 | [-0.70%, +0.24%] |

Beta confirms Step 3: AAPL is 24% more sensitive than the market, XLF trades close to market-level (it's essentially part of the market), TLT is nearly independent (beta ≈ 0).

**None of the three assets shows a statistically significant CAR at the 5% level.** TLT comes closest (p=0.117) — consistent with Treasuries reacting most directly to rate expectations — but not strong enough to call it a real effect at n=31.

---

## Step 5: Checking the null result in Step 4

A null result is only trustworthy if it isn't a product of violated test assumptions. Residuals from the 31 estimation regressions were checked **per window, not pooled** (pooling would mix residuals from different estimation windows — calm 2016 vs. chaotic 2022 — collapsing distinct market regimes into one artificial series):

| Asset | % windows failing normality (Jarque-Bera) | % windows showing ARCH | Mean Durbin-Watson |
|---|---|---|---|
| AAPL | 87% | 10% | 1.84 |
| TLT | 10% | 10% | 2.01 |
| XLF | 52% | 16% | 1.97 |

Non-normality (fat tails) in AAPL is real and widespread, a known feature of tech-stock returns. ARCH effects, however, only show up in 10–16% of individual windows.

As a sanity check, pooling all residuals across windows into one series and running a single ARCH-LM test gives p ≈ 0 for all three assets — dramatically stronger than any per-window result. This is a **pooling artifact, not evidence of ARCH**: concatenating residuals from 31 different estimation windows destroys the temporal structure the test relies on, and mixes together windows drawn from different volatility regimes. It's kept here only to illustrate why pooled diagnostics shouldn't be trusted — the per-window numbers above are the real evidence.

Wilcoxon (no normality assumption) and the bootstrap CI (no distributional assumption) agree with the t-test in every case. Three methods with different assumptions converging on "nothing here" is what makes the null result trustworthy, not any single test in isolation.

---

## Step 6 (exploratory): Does VIX move around the announcement, as theory predicts?

If FOMC decisions resolve some uncertainty, VIX might rise heading into the meeting and fall afterward — a plausible hypothesis, not a certainty (an unexpected decision could just as easily raise post-announcement uncertainty).

**Method:** two separate one-sample tests — the VIX change from 3 trading days before the event to the event day itself, and from the event day to 3 trading days after.

**Results:** VIX rose modestly in the 3 days heading into the event (+1.05 points), but the change was **not statistically significant** (p=0.367). It also rose slightly (rather than falling) in the 3 days after (+0.38 points), also **not significant** (p=0.637).

Neither leg of the classic "vol-crush" pattern reaches significance here, so this section shouldn't be read as confirming or ruling it out — it's exploratory, not a main finding. In the academic literature the vol-crush effect plays out over a window of minutes around the ~2pm ET release; daily data blends the whole session together, which could plausibly dilute a real intraday effect rather than the effect not existing.

---

## What I'd do differently with more time/data

- **Match non-event windows to events by time period or volatility regime**, rather than pooling all non-event windows together. This is the single biggest methodological gap in Q1 — the March 2020 result shows the current unmatched comparison is sensitive to which regime the events happen to fall in.
- **Use intraday data instead of daily** — the highest-impact change for Q3, since most of the FOMC reaction happens within minutes of the release and gets diluted when averaged over the full day.
- **Expand the sample to the full ~104 FOMC meetings**, including meetings where rates were held, not just the 31 rate-change events — a preliminary run on a partial extended sample already showed a stronger Q1 signal, suggesting sample size, not absence of an effect, may be a binding constraint.
- **Measure actual "surprise" instead of just hike/cut.** Pre-event moves in the 2-year Treasury yield (DGS2), used as a proxy for how much the market had already priced in, produced results in the wrong direction from theory — likely because the proxy is confounded with general macro uncertainty (COVID, the 2022 hiking cycle). A Fed Funds Futures-based surprise measure (the academic standard) would avoid this confound, but that data usually isn't free.
- **Control for same-day news** — a few of the 31 events could coincide with AAPL earnings or other market-wide shocks, which aren't currently filtered out.

---

## How to run this

```text
fomc-event-study/
├── data/
│   ├── spy_2013_2026.csv
│   ├── aapl_2013_2026.csv
│   ├── tlt_2013_2026.csv
│   ├── xlf_2013_2026.csv
│   └── vix_2013_2026.csv
├── notebooks/
│   └── fomc_event_study_garch.ipynb
└── README.md
```

Open the notebook and run all cells top to bottom — each section is numbered to match the Steps above (Step 2 = Q1, Steps 3–5 = Q2a/Q2b, Step 6 = Q3).

**Tools used:** Python, `pandas`, `scipy` (t-test, Mann-Whitney, Wilcoxon), `statsmodels` (regression + Jarque-Bera/ARCH-LM/Durbin-Watson diagnostics), `arch` (GARCH(1,1) conditional volatility), `matplotlib`.
