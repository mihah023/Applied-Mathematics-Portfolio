
# 🏛️ Fed Rate-Change Event Study: Market-Wide Reaction & AAPL Abnormal Return

**31 rate-change events, 13 years of market data, 2 independent statistical tests, 1 self-caught methodology error that changed the headline result.**

**Skills demonstrated:** Event-study methodology (MacKinlay 1997), Market Model regression, parametric + non-parametric hypothesis testing (Welch's t, one-sample t, Wilcoxon signed-rank), bootstrap inference, regression diagnostics (Jarque-Bera, ARCH-LM, Durbin-Watson), Python (pandas, statsmodels, scipy)

> **One number worth a second look**: the first version of this analysis
> pooled all 93 event-window days as if independent and got **p=0.0007**.
> Catching that those 93 days are actually 31 correlated 3-day clusters — and
> re-running the test at the correct statistical unit — moved the result to
> **p=0.0341**. Still significant, but a 40x jump in the p-value from fixing
> one independence assumption. See [Key Insight](#key-insight) below.

## At a glance

| | |
|---|---|
| **Question 1** | Does the market (SPY) react abnormally around Fed rate-change dates? |
| **Question 2** | Does AAPL react *differently* from what its market beta predicts? |
| **Data** | SPY + AAPL daily prices (2013–2026), Fed Funds Target Rate (FRED) |
| **Events** | 31 rate changes (20 hikes, 11 cuts), reproducible via `DFEDTARU.diff()` |
| **Answer 1** | Yes — p=0.0341 (event-level test, n=31) |
| **Answer 2** | No — AAPL's reaction is fully explained by its beta (p=0.60, confirmed by 3 methods) |

## A note on scope

Events here are the 31 dates where the Fed Funds Target Rate **actually
changed** (derived from FRED's `DFEDTARU` series via `.diff()`), not every
FOMC meeting — meetings that left rates unchanged ("held") are excluded. So
this is precisely a study of **market reaction to Fed rate changes**, a
narrower and more precisely-defined scope than "reaction to FOMC meetings"
in general.

## Data

| Source | Content | Range |
|---|---|---|
| Yahoo Finance (`yfinance`) | SPY daily OHLCV | 2013-01 to 2026-08 (3,431 days) |
| Yahoo Finance (`yfinance`) | AAPL daily OHLCV | 2013-01 to 2026-08 (3,431 days) |
| FRED `DFEDTARU` | Fed Funds Target Rate (Upper Limit), daily | 2008-2026 |

31 rate-change dates fall in the sample window (**20 hikes, 11 cuts**),
identified directly from `DFEDTARU.diff()` — fully reproducible and
independently verifiable against the source series, with no manually
compiled meeting calendar involved.

## Methodology

### Part A — Market-wide reaction (event-study design, Fama/Fisher/Jensen/Roll 1969)

For each of the 31 events, an **[-1, 0, +1]** trading-day window is defined.
Two versions of the test are reported:

- **Daily-pooled (exploratory)**: all 93 event-window days pooled and
  compared against ~3,300 normal days via Welch's t-test.
- **Event-level (primary)**: each event's own 3-day window is first
  collapsed into a single average, giving **31 independent observations**,
  which are then tested against the normal-day baseline via a one-sample
  t-test.

The event-level version is the more defensible one: the 3 days inside a
single event window are not independent of each other, so treating all 93
as independent observations understates the true standard error.

### Part B — AAPL-specific reaction (Market-Model event study, MacKinlay 1997)

For each event, AAPL's alpha/beta against SPY is estimated on a **prior**
[-141, -21] trading-day window (ending 21 days before the event, to avoid
any leakage from the event itself). Abnormal Return = actual − (alpha +
beta × market return) inside the [-1,0,+1] window, summed into a
**Cumulative Abnormal Return (CAR)** per event.

Since the Market-Model residuals fail normality and show heteroskedasticity
(see Diagnostics below), results are cross-checked with a **Wilcoxon
signed-rank test** and a **bootstrap 95% confidence interval**, alongside
the parametric one-sample t-test.

## Results

### Part A — Market-wide reaction

| Test | Statistical unit | Event mean | Normal baseline | p-value | Verdict |
|---|---|---|---|---|---|
| Return (H1) | Event (n=31) | -0.117% | +0.066% | 0.215 | Not significant |
| \|Return\|, proxy for volatility (H2), daily-pooled | Day (n=93, exploratory) | 1.279% | 0.682% | 0.0007 | Significant |
| \|Return\|, proxy for volatility (H2), **event-level** | **Event (n=31, primary)** | 1.279% | 0.682% | **0.0341** | **Significant** |

### Part B — AAPL-specific abnormal return

| Sample | n | Mean CAR | t-test p | Wilcoxon p | Verdict |
|---|---|---|---|---|---|
| All events | 31 | +0.223% | 0.599 | 0.433 | Not significant |
| Hikes only | 20 | -0.232% | 0.683 | 0.898 | Not significant |
| Cuts only | 11 | **+1.050%** | 0.086 | 0.102 | Not significant, but suggestive |

Bootstrap 95% CI for mean CAR (all events): **[-0.61%, +1.01%]** — includes 0.

### Market-Model residual diagnostics (pooled across all 31 estimation windows)

| Test | Statistic | p-value | Result |
|---|---|---|---|
| Jarque-Bera (normality) | 4117.9 | <0.0001 | Residuals **not normal** (skew=0.70, kurtosis=7.96 — fat tails) |
| ARCH-LM (heteroskedasticity) | 52.1 | <0.0001 | **Heteroskedasticity present** |
| Durbin-Watson (autocorrelation) | 1.84 | — | No major concern (close to 2.0) |

![Part A chart](outputs/part_a_market_reaction.png)
![Part B CAR by event](outputs/part_b_car_by_event.png)

## Key Insight

**The market as a whole reacts to Fed rate changes; AAPL specifically does not, beyond what its beta already predicts.**

Three things make this conclusion more trustworthy than a single p-value:

1. **The market-wide result held up under a harder test.** The first,
   naive version of Part A (pooling all 93 event-window days as
   independent) gave p=0.0007 — a very strong result. But those 93
   observations are not independent (3 correlated days per event), so the
   more defensible **event-level test (n=31)** was run instead — the result
   dropped to **p=0.0341**. Still significant, but much less dramatic. This
   is the single most important lesson from this project: **the naive
   version overstated confidence by pooling correlated observations**, and
   catching this before drawing conclusions is exactly the kind of
   methodological discipline a production risk/research desk requires.

2. **Part B's null result is robust across methods.** A one-sample t-test,
   a distribution-free Wilcoxon signed-rank test, and a bootstrap
   confidence interval all agree: AAPL shows no significant abnormal return
   around Fed rate changes once its market beta is accounted for. Three
   different tools converging on the same answer is far more convincing
   than any one of them alone — particularly given the Market-Model
   residuals fail the normality assumption the t-test leans on.

3. **The hike/cut split surfaces a real, economically plausible hypothesis
   — without overclaiming it.** Splitting 31 events into 20 hikes and 11
   cuts shows cuts trending toward a positive CAR (+1.05%, p=0.086/0.102)
   while hikes show essentially nothing. This is consistent with standard
   discounted-cash-flow logic: lower rates raise the present value of
   AAPL's future cash flows more than symmetric-sized hikes lower it (a
   textbook "growth stock" sensitivity). But this is a **post-hoc split**
   made *because* the pooled test came back null — exactly the kind of
   multiple-comparisons fishing that can manufacture a false positive by
   chance. At n=11 for cuts, neither test clears the conventional 5%
   threshold, so this is reported as a hypothesis worth testing on a larger
   sample, not a confirmed finding.

## Repo Structure
```
02-fomc-event-study/
├── data/
│   ├── spy_2013_2026.csv           # SPY daily OHLCV (yfinance)
│   ├── aapl_2013_2026.csv          # AAPL daily OHLCV (yfinance)
│   ├── DFEDTARU.csv                # FRED daily Fed Funds Target Rate (Upper), 2008-2026
│   ├── all_stocks_5yr.csv          # 505 S&P 500 tickers, 2013-2018 (used in v2, superseded)
│   ├── equal_weighted_index.csv    # v2 market-proxy index (superseded by SPY in final version)
│   ├── fomc_meeting_dates_v2.csv   # v1/v2 hand-compiled 28-meeting calendar (superseded)
│   └── aapl_prices_raw.csv         # v1 2-year AAPL sample (superseded)
├── notebooks/
│   ├── fomc_event_study_clean.ipynb   # ★ FINAL — Part A + Part B, full analysis (this README)
│   ├── build_index.py / .ipynb        # v2: builds equal-weighted 505-stock index
│   ├── fomc_event_study.py / .ipynb   # v1: single-stock AAPL, 16 hand-typed dates
│   ├── fomc_event_study_v2.py / .ipynb# v2: 505-stock index, 28 dates
│   └── spy_event_study_v3.py / .ipynb # v3: full-history SPY, 31 dates (precursor to final)
└── outputs/
    ├── part_a_market_reaction.png
    ├── part_b_car_by_event.png
    └── [earlier versions' charts and summary CSVs, kept for the version history below]
```

## Version History

| Version | Test asset | Events | Key result | What changed |
|---|---|---|---|---|
| v1 | AAPL alone | 16 (hand-typed) | p=0.14–0.76, nothing significant | Baseline, single noisy stock |
| v2 | 505-stock equal-weighted index | 28 (2013-2018 only) | p=0.070, marginal | Diversified test asset to cut idiosyncratic noise |
| v3 | SPY (real index) | 31 (2013-2026, FRED-verified) | p=0.0007 (daily-pooled) | Extended to full history, all rate-change cycles |
| **Final** | **SPY (Part A) + AAPL vs SPY Market Model (Part B)** | **31** | **p=0.0341 (Part A, event-level)**; **CAR not significant (Part B)** | Fixed the independence assumption in Part A; added a genuine Market-Model abnormal-return test for AAPL; added Wilcoxon + bootstrap robustness checks |

The progression itself is worth narrating in an interview: each version's
limitation motivated the next fix, ending with a methodologically defensible
two-part analysis rather than a single lucky p-value.

## Limitations & Next Steps

- **Confounding events not fully controlled for.** AAPL earnings dates and
  market-wide macro shocks (e.g. the Aug-2015 China deval selloff, visible
  as a sharp drawdown in the price chart) can fall near rate-change dates
  and bias specific event windows.
- **Heteroskedasticity in Market-Model residuals** (confirmed by ARCH-LM)
  means OLS standard errors for individual alpha/beta estimates may be
  understated; a Newey-West (HAC) covariance estimator would be the
  standard fix for the underlying regression, though the CAR-level
  significance tests reported here are already cross-checked
  non-parametrically.
- **n=11 for cuts is small.** The suggestive cuts>hikes asymmetry should be
  revisited once more cutting cycles accumulate, or tested with a
  **BMP-style test** (Boehmer, Musumeci & Poulsen 1991), which explicitly
  adjusts for event-induced volatility changes — a known refinement over a
  plain t-test in event studies.
- **Natural extension**: classify meetings by *surprise* vs. *expected*
  using Fed funds futures-implied probabilities (CME FedWatch) rather than
  by outcome alone — the literature suggests surprises, not scheduled
  decisions, move markets most.

---
*Part of my Quant/Risk Portfolio — built to demonstrate the "fundamental
information + quantitative methodology" workflow, including honest
self-correction of a methodological error, for quantitative research roles.*
