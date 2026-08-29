# Fed Rate-Change Event Study 🏛️
*Does the stock market react to Fed interest rate decisions — and if it does, where does that reaction actually live: the market as a whole, or individual stocks?*

---

## The question I wanted to answer

Everyone in finance says "the market reacts to Fed decisions" — but I wanted to check that with data instead of just assuming it's true. And I wanted to go one step further: **if the market does react, where does that reaction actually live?** Does a specific stock do something "special" of its own, or does it just move because the whole market moves?

So the project is built around 3 questions, each using a different method, each one opening up the next:

1. **Does the market as a whole (SPY) get more volatile around FOMC rate-decision dates?**
2. **Do individual assets (AAPL, XLF, TLT) move together with the market around these events** — and after netting out that normal co-movement, **is there any abnormal reaction left over?**
3. *(Exploratory)* **Does VIX — the market's own uncertainty gauge — rise before and fall after the announcement, as theory predicts?**

---

## Step 1: Getting the data — and a trap I almost fell into

Three data sources needed to line up by date:

- **SPY** (an ETF tracking the S&P 500 — "the market") — daily, 2013–2026, Yahoo Finance
- **AAPL, TLT (long-term Treasuries), XLF (financial sector ETF)** — same range, also Yahoo Finance
- **VIX** — the implied-volatility index, also Yahoo Finance (ticker `^VIX`)

**The "clever" shortcut that turned out to be wrong:** I originally planned to get Fed rate-change dates by just asking the FRED interest rate series (`DFEDTARU`) "which days did this number change" (`.diff() != 0`). Fast, fully automatic, no manual date lookup.

**But when I cross-checked against the official FOMC action history, I found that 29 of the 31 dates this method produced were off by exactly one day from the date the Fed actually announced the decision.** Reason: `DFEDTARU` records the date the new rate becomes **effective**, not the date it's **announced** — these are usually one day apart. The clearest example: the Fed's emergency cut was announced Sunday evening, March 15, 2020, but `DFEDTARU` records the change on Monday, March 16.

Lesson: **automatic and "fast" doesn't mean correct.** I dropped this shortcut and built a table of the 31 actual announcement dates (cross-checked against official sources), with a `timing` column flagging whether the announcement happened during market hours (`intraday`, most cases) or after hours (`after_hours` — only the March 15, 2020 case). From that, a function maps "announcement date" → "the trading day the market could actually react on":

```python
def map_to_event_day(ann_date, timing, trading_dates_sorted):
    if timing == "after_hours":
        candidates = [d for d in trading_dates_sorted if d > ann_date]   # must wait for the next session
    else:
        candidates = [d for d in trading_dates_sorted if d >= ann_date]  # announced during market hours, use that day
    return candidates[0] if candidates else None
```

---

## Step 2: Question 1 — Is the market unusually volatile?

**Method:**

For each of the 31 events, take the 3-day window `[-1, 0, +1]` and collapse it into **one number per event** (the mean `|return|` across those 3 days) — instead of treating all 93 days (31×3) as 93 independent observations. Reason: the 3 days within one event are correlated with each other (if the market reacts strongly, all 3 days tend to move together) — treating them as independent artificially deflates the standard error, making the p-value look better than it should.

Then, instead of comparing those 31 numbers against **individual days** in the data (a mismatched unit — a 3-day average has very different variance than a single day), I built **1,061 non-overlapping "normal" 3-day windows**, explicitly excluding a ±2-day buffer around every event (so anticipation or drift doesn't leak into the baseline). Comparing 3-day-window to 3-day-window keeps the unit of measurement consistent.

Finally, instead of trusting a single test, I ran **4 tests in parallel**: Welch's t-test (no equal-variance assumption), Mann-Whitney U (no normality assumption — important since financial returns have fat tails), a permutation test (directly simulates the null hypothesis by shuffling labels), and a bootstrap 95% CI (measures the uncertainty of the observed difference itself).

**Results:**

| | Mean \|return\| | Welch p | Mann-Whitney p | Permutation p | Bootstrap 95% CI |
|---|---|---|---|---|---|
| 31 events | 1.22% | 0.055 | 0.021 | ~0.000 | [0.0012, 0.0116] |
| Normal days | 0.67% | | | | |

3 of 4 tests are statistically significant (Welch is borderline) — volatility around FOMC is nearly double a normal day's, and the CI is entirely positive.

**But I didn't stop there** — I tried excluding the 2 emergency COVID rate cuts (March 3 and March 15, 2020) to see whether the signal depended on them:

| | Mean \|return\| | Welch p | Mann-Whitney p | Permutation p | Bootstrap 95% CI |
|---|---|---|---|---|---|
| 29 events (COVID removed) | 0.88% | 0.063 | 0.078 | 0.022 | [0.00004, 0.0043] |

The mean drops by nearly half the gap, Mann-Whitney loses significance, and the CI is still positive but its lower bound is almost touching zero. **Honest conclusion: elevated volatility around FOMC is real, but much of the finding's strength comes from 2 extreme COVID days — for a "typical" meeting, the effect is still there but weaker and less certain.**

(On direction: mean return isn't significantly different between the two groups, p=0.674 — as expected, the Fed doesn't "signal" a price direction, it mainly affects how much things swing.)

---

## Step 3: Question 2a — Do individual assets move together with the market?

Knowing the market moves doesn't tell you anything specific about AAPL/XLF/TLT, because they already move *with* the market most of the time anyway (that's what "beta" means). Before asking "is there an abnormal reaction," I first need a baseline: **do they actually move in the same direction as the market around these events at all?**

**Method:** for each event, compute each asset's compounded 3-day return (using the correct compounding formula `(1+R₁)(1+R₂)(1+R₃)-1`, not a linear sum, which is only an approximation), compare its sign (+/-) to SPY's, and compute the correlation across all 31 events.

**Results:**

| Asset | % same direction as SPY | Correlation (r) |
|---|---|---|
| AAPL | 74% | 0.83 |
| XLF (financials) | 84% | 0.90 |
| TLT (Treasuries) | 52% | -0.07 |

AAPL and XLF track the market closely — makes sense since both are equities, subject to the same general market sentiment. **TLT is essentially a coin flip** (52%) — Treasuries respond to their own rate-expectation logic, which doesn't necessarily align with equity sentiment.

---

## Step 4: Question 2b — Is there any reaction *beyond* just moving with the market?

This is the real question: AAPL has a high beta so it swings hard when the market swings — but that's not a "reaction to the Fed," it's just a consequence of high market sensitivity. The right question is: **after subtracting out "what beta alone would predict," is there anything left over?**

**Method — Market Model, run for AAPL, TLT, and XLF:**

1. For each event, take the 120 trading days *before* it (with a 21-day gap to avoid the estimate being contaminated by pre-event anticipation), and regress: `asset_return = alpha + beta × market_return`.
2. Use that alpha/beta to compute the asset's *expected* return during the 3-day event window, if it were only moving normally with the market.
3. Subtract: `actual − expected` = the "abnormal" part each day.
4. Sum the 3 days → **Cumulative Abnormal Return (CAR)**, one number per event, 31 numbers per asset.

**Results:**

| Asset | Mean beta | Mean CAR | t-test p | Wilcoxon p | Bootstrap 95% CI |
|---|---|---|---|---|---|
| AAPL | 1.24 | +0.07% | 0.845 | 0.750 | [-0.65%, +0.76%] |
| TLT | -0.14 | +0.44% | 0.117 | 0.107 | [-0.10%, +0.96%] |
| XLF | 0.98 | -0.25% | 0.307 | 0.189 | [-0.70%, +0.24%] |

Beta confirms Step 3: AAPL is 24% more sensitive than the market, XLF is close to market-level (makes sense — it's essentially *part of* the market), TLT is nearly independent (beta≈0).

**None of the three assets show a statistically significant CAR at the 5% level.** TLT comes closest (p=0.117) — consistent with "Treasuries react most directly to rate expectations" — but not strong enough to call it a real effect with n=31.

---

## Step 5: Making sure that "nothing here" result from Step 4 is trustworthy

A null result (p>0.05) is only trustworthy if it's not the product of violated test assumptions. I checked the residuals from the 31 estimation regressions — **per estimation window, not pooled** (pooling would mix different volatility regimes — calm 2016 vs. chaotic 2022 — together and manufacture a false signal):

| Asset | % windows failing normality (Jarque-Bera) | % windows showing ARCH | Mean Durbin-Watson |
|---|---|---|---|
| AAPL | 87% | 10% | 1.84 |
| TLT | 10% | 10% | 2.01 |
| XLF | 52% | 16% | 1.97 |

Non-normality (fat tails) in AAPL is **real and widespread** — a natural feature of tech-stock returns. But ARCH effects only show up in 10-16% of windows — far lower than the pooled ARCH-LM test suggested (p<0.0001 when pooled). **This shows the "strong ARCH" found earlier when pooling was mostly an artifact of mixing regimes, not a real phenomenon within any single window** — an important methodological lesson: pooling non-homogeneous data can manufacture false signals.

Wilcoxon (no normality assumption) and the bootstrap CI (no distributional assumption at all) both agree with the t-test — 3 independent methods all saying "nothing here" is what actually makes this null result trustworthy, not just one test in isolation.

---

## Step 6 (exploratory): Does VIX rise before and fall after, as theory predicts?

If FOMC decisions genuinely resolve uncertainty, VIX (implied volatility, priced through options) should **rise beforehand** (the market gets nervous) and **fall afterward** (the news is out, uncertainty is gone — the "vol crush" phenomenon).

**Method:** measure the VIX change from 3 days before to the event day, and from the event day to 3 days after, across all 31 events.

**Results:** VIX rises modestly before (+1.05 points, p=0.367 — not significant) but does **not** fall afterward as expected (+0.38 points, p=0.637). The classic "vol crush" pattern doesn't clearly show up at daily resolution.

**I'm labeling this section exploratory, not a main finding** — because this phenomenon, in the academic literature, plays out over a window of **minutes** around the ~2pm ET release, while daily data blends the whole session together, likely diluting the signal rather than the phenomenon not existing.

---

## What I'd do differently with more time/data

- **Use intraday data instead of daily** — the single highest-impact change, since most of the FOMC reaction happens within minutes of the release and gets diluted when the whole day is averaged together.
- **Expand the sample to the full ~104 FOMC meetings** (including meetings where rates were held), not just the 31 rate-change events — a preliminary test with 53 events (only 5 of 13 years of "hold" meetings completed) already showed a stronger Q1 signal, suggesting sample size, not absence of an effect, is the real constraint.
- **Measure actual "surprise" instead of just hike/cut** — I tried using pre-event moves in the 2-year Treasury yield (DGS2) as a proxy for "how much the market had already priced in," but the result went in the wrong direction from theory, likely because the proxy is confounded with general macro uncertainty (COVID, the 2022 hiking cycle). A Fed Funds Futures-based measure (the academic standard) would avoid this confound, but that data usually isn't free.
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
