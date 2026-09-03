# Fed Rate-Change Event Study

*Does the stock market react to Fed interest rate decisions — and if it does, where does that reaction actually live: the market as a whole, or individual stocks?*

---

## The question

"The market reacts to Fed decisions" is conventional wisdom in finance — this project checks it with data, and goes one step further: **if the market does react, where does that reaction live?** Does a specific stock do something "special" of its own, or does it just move because the whole market moves?

Three questions, each using a different method, each one opening up the next:

1. **Does the market as a whole (SPY) get more volatile around FOMC rate-decision dates?**
2. **Do individual assets (AAPL, XLF, TLT) move together with the market around these events** — and after netting out that normal co-movement, **is there any abnormal reaction left over?**
3. *(Exploratory)* **Does VIX — the market's own uncertainty gauge — rise before and fall after the announcement, as theory predicts?**

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

---

## Step 2: Q1 — Is the market unusually volatile?

**Method:** For each of the 31 events, collapse the 3-day window `[-1, 0, +1]` into one number (mean `|return|` across those 3 days), rather than treating all 93 days as independent — the 3 days within an event are correlated, so treating them separately would understate the standard error. Compare against **1,061 non-overlapping "normal" 3-day windows**, built by excluding a ±2-day buffer around every event so anticipation or drift doesn't leak into the baseline. Four tests run in parallel: Welch's t-test, Mann-Whitney U (robust to fat tails), a permutation test, and a bootstrap 95% CI.

**Results:**

| | Mean \|return\| | Welch p | Mann-Whitney p | Permutation p | Bootstrap 95% CI |
|---|---|---|---|---|---|
| 31 events | 1.22% | 0.055 | 0.021 | ~0.000 | [0.0012, 0.0116] |
| Normal days | 0.67% | | | | |

3 of 4 tests are significant at 5% (Welch is borderline) — volatility around FOMC is nearly double a normal day's, and the CI is entirely positive.

Excluding the 2 emergency COVID cuts (March 3 and March 15, 2020):

| | Mean \|return\| | Welch p | Mann-Whitney p | Permutation p | Bootstrap 95% CI |
|---|---|---|---|---|---|
| 29 events (COVID removed) | 0.88% | 0.063 | 0.078 | 0.022 | [0.00004, 0.0043] |

The gap shrinks by roughly half, Mann-Whitney loses significance, and the CI stays positive but its lower bound sits just above zero. **Elevated volatility around FOMC is real, but a meaningful share of the signal's strength comes from the two extreme COVID days — for a typical meeting, the effect is present but weaker and less certain.**

On direction: mean return isn't significantly different between event and normal days (p=0.674) — the Fed doesn't "signal" a price direction, it mainly affects how much things swing.

---

## Step 3: Q2a — Do individual assets move with the market?

Before asking whether an asset has an *abnormal* reaction, it needs a baseline: does it move in the same direction as the market around these events at all?

**Method:** for each event, compute each asset's compounded 3-day return (`(1+R₁)(1+R₂)(1+R₃)-1`), compare its sign to SPY's, and compute the correlation across all 31 events.

| Asset | % same direction as SPY | Correlation (r) |
|---|---|---|
| AAPL | 74% | 0.83 |
| XLF (financials) | 84% | 0.90 |
| TLT (Treasuries) | 52% | -0.07 |

AAPL and XLF track the market closely, as expected for equities. **TLT is essentially a coin flip** — Treasuries respond to their own rate-expectation logic, which doesn't necessarily align with equity sentiment.

---

## Step 4: Q2b — Is there any reaction beyond just moving with the market?

**Method — Market Model, run for AAPL, TLT, and XLF:**

1. For each event, take the 120 trading days before it (with a 21-day gap to avoid contamination from pre-event anticipation) and regress `asset_return = alpha + beta × market_return`.
2. Use that alpha/beta to compute the asset's *expected* return during the 3-day event window.
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

A null result is only trustworthy if it isn't a product of violated test assumptions. Residuals from the 31 estimation regressions were checked **per window, not pooled** (pooling would mix different volatility regimes — calm 2016 vs. chaotic 2022 — and could manufacture a false signal):

| Asset | % windows failing normality (Jarque-Bera) | % windows showing ARCH | Mean Durbin-Watson |
|---|---|---|---|
| AAPL | 87% | 10% | 1.84 |
| TLT | 10% | 10% | 2.01 |
| XLF | 52% | 16% | 1.97 |

Non-normality (fat tails) in AAPL is real and widespread, a known feature of tech-stock returns. ARCH effects, however, only show up in 10–16% of individual windows — far lower than a pooled ARCH-LM test would suggest — indicating that apparent volatility clustering across the full sample largely reflects mixing different regimes together, not a within-window effect.

Wilcoxon (no normality assumption) and the bootstrap CI (no distributional assumption) agree with the t-test in every case. Three methods with different assumptions converging on "nothing here" is what makes the null result trustworthy, not any single test in isolation.

---

## Step 6 (exploratory): Does VIX rise before and fall after, as theory predicts?

If FOMC decisions resolve uncertainty, VIX should rise beforehand and fall afterward (the "vol crush").

**Method:** VIX change from 3 days before to the event day, and from the event day to 3 days after, across all 31 events.

**Results:** VIX rises modestly before (+1.05 points, p=0.367) but does not fall afterward as expected (+0.38 points, p=0.637). The classic vol-crush pattern doesn't clearly appear at daily resolution.

This section is exploratory, not a main finding — in the academic literature the vol-crush effect plays out over a window of minutes around the ~2pm ET release, while daily data blends the whole session together, which likely dilutes the signal rather than the effect not existing.

---

## What I'd do differently with more time/data

- **Use intraday data instead of daily** — the highest-impact change, since most of the FOMC reaction happens within minutes of the release and gets diluted when averaged over the full day.
- **Expand the sample to the full ~104 FOMC meetings**, including meetings where rates were held, not just the 31 rate-change events — a preliminary run on a partial extended sample already showed a stronger Q1 signal, suggesting sample size, not absence of an effect, may be the binding constraint.
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
│   └── fomc_event_study_final_clean.ipynb
└── README.md
```

Open the notebook and run all cells top to bottom — each section is numbered to match the Steps above (Step 2 = Q1, Steps 3–5 = Q2a/Q2b, Step 6 = Q3).

**Tools used:** Python, `pandas`, `scipy` (t-test, Mann-Whitney, Wilcoxon), `statsmodels` (regression + Jarque-Bera/ARCH-LM/Durbin-Watson diagnostics), `matplotlib`.
