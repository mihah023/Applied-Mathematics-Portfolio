# 🏛️ Fed Rate-Change Event Study: Market-Wide Reaction & AAPL Abnormal Return
<p align="left">
  <img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white" alt="Python" height="28" />
  <img src="https://img.shields.io/badge/pandas-%23150458.svg?style=flat-square&logo=pandas&logoColor=white" alt="pandas" height="28" />
  <img src="https://img.shields.io/badge/SciPy-%230C55A5.svg?style=flat-square&logo=scipy&logoColor=white" alt="SciPy" height="28" />
  <img src="https://img.shields.io/badge/statsmodels-8B0000?style=flat-square" alt="statsmodels" height="28" />
  <img src="https://img.shields.io/badge/Jupyter-F37626?style=flat-square&logo=jupyter&logoColor=white" alt="Jupyter" height="28" />
</p>

<p align="center">
  <img src="outputs/part_a_market_reaction.png" alt="SPY with Fed rate-change dates and volatility comparison" width="100%" />
</p>

---
## 📌 Executive Summary
This project asks two questions in sequence: does the U.S. equity market (SPY) react abnormally around Fed rate-change dates, and if so, does **AAPL specifically** react differently from what its market beta alone predicts?

Using **Python (pandas, statsmodels, scipy)**, 31 Fed rate-change events (2013–2026) were identified directly from FRED's `DFEDTARU` series, then tested with an event-study design (Part A) and a Market-Model abnormal-return analysis (Part B) — cross-checked with both parametric and non-parametric tests throughout.

---
## 💻 Tech Stack
- **Language:** Python 3
- **Data Wrangling:** `pandas`, `NumPy`
- **Statistical Testing:** `scipy.stats` (`ttest_ind`, `ttest_1samp`, `wilcoxon`)
- **Regression & Diagnostics:** `statsmodels` (`OLS`, `jarque_bera`, `durbin_watson`, `het_arch`)
- **Visualization:** `matplotlib`
- **Data Sources:** FRED (`DFEDTARU` — Fed Funds Target Rate), Yahoo Finance (SPY, AAPL daily OHLCV)
- **Techniques:**
  - Event-study design with independence-correct (event-level) hypothesis testing
  - Market-Model regression per event (rolling estimation window, 21-day leakage gap)
  - Cumulative Abnormal Return (CAR) construction
  - Robustness via Wilcoxon signed-rank test + bootstrap confidence intervals
  - Residual diagnostics: normality, heteroskedasticity, autocorrelation

---
## 📁 Repository Structure

```text
02-fomc-event-study/
│
├── data/
│   ├── spy_2013_2026.csv         # SPY daily OHLCV (Yahoo Finance)
│   ├── aapl_2013_2026.csv        # AAPL daily OHLCV (Yahoo Finance)
│   └── DFEDTARU.csv              # Fed Funds Target Rate, Upper Limit (FRED)
│
├── notebooks/
│   └── fomc_event_study_clean.ipynb   # Full analysis: Part A + Part B
│
└── outputs/
    ├── part_a_market_reaction.png
    └── part_b_car_by_event.png
```

---
## 📂 Dataset Overview
Daily SPY and AAPL prices (Yahoo Finance) merged against the Fed Funds Target Rate (FRED `DFEDTARU`), which pins down every date the rate actually changed — not every FOMC meeting, only the ones where it moved.

### Key Metrics
* **Trading days:** 3,431 (2013-01-02 to 2026-08-24)
* **Rate-change events:** 31 total — **20 hikes, 11 cuts**
* **Event window:** [-1, 0, +1] trading days around each event
* **Market-Model estimation window:** 120 trading days, ending 21 days before each event (no leakage)

---
## 🚨 Methodology Note

> [!WARNING]
> The first version of Part A pooled all 93 event-window days as if they were independent observations and got **p=0.0007**. But 3 days from the same event are correlated — they're not independent. Re-running the test at the correct statistical unit (**31 events**, not 93 days) moved the result to **p=0.0341**. Still significant, but the naive version overstated confidence by ~20x. Both versions are kept in the notebook for comparison; the event-level result is the one reported below.

---
## 📊 Key Findings & Insights

**1. The market is significantly more volatile around Fed rate-change dates — confirmed at the correct statistical unit.** Average absolute daily return jumps to **1.279%** in the event window vs. **0.682%** on normal days (event-level test, n=31 independent events: t=2.221, **p=0.0341**).
* **Insight:** For any daily-frequency event study, always aggregate to one observation per event before testing significance — pooling correlated days (as the exploratory version did) can manufacture false confidence.

**2. But the market doesn't move in a consistent direction.** Average return in the event window is actually slightly negative (-0.117%) vs. +0.066% normally, and this gap is not significant (p=0.215).
* **Insight:** Fed rate decisions raise *dispersion*, not a predictable directional edge — consistent with an efficient-market reaction to a resolved-uncertainty event rather than a systematic mispricing.

![AAPL Cumulative Abnormal Return by event](outputs/part_b_car_by_event.png)

**3. AAPL shows no significant abnormal return once its market beta is accounted for — and three independent tests agree.** Mean CAR across all 31 events is **+0.223%**, but the t-test (p=0.599), Wilcoxon signed-rank test (p=0.433), and a 10,000-draw bootstrap 95% CI (**[-0.61%, +1.01%]**, includes 0) all reach the same conclusion.
* **Insight:** AAPL's sensitivity to Fed policy is fully explained by its ordinary market beta — there's no AAPL-specific "Fed-news" channel on top of that. A desk hedging AAPL's Fed-day exposure could reasonably do so with an index position rather than a stock-specific overlay.

**4. Splitting by direction hints at an asymmetry — but it's not confirmed.** Rate **cuts** show a **+1.05%** average CAR (n=11, t-test p=0.086, Wilcoxon p=0.102), while **hikes** show essentially nothing (-0.23%, n=20, p=0.68).
* **Insight:** Directionally consistent with discounted-cash-flow logic — lower rates raise the present value of AAPL's future cash flows more than symmetric hikes lower it. But at n=11, neither test clears the 5% threshold; this is a hypothesis worth revisiting as more cutting-cycle events accumulate, not a confirmed edge.

**5. Market-Model residuals have fat tails and volatility clustering — exactly why the robustness checks in #3 mattered.** Jarque-Bera rejects normality (p<0.0001, kurtosis=7.96), and ARCH-LM confirms heteroskedasticity (p<0.0001). Autocorrelation is not a concern (Durbin-Watson=1.84).
* **Insight:** With residuals this non-normal, a plain t-test alone would be a weak basis for a null-result claim — this is why Finding #3's conclusion rests on t-test, Wilcoxon, *and* bootstrap agreeing, not the t-test in isolation.

### Part A — Market-Wide Reaction (event-level test, n=31)

| Hypothesis | Event mean | Normal baseline | t-stat | p-value | Verdict |
|:---|:---:|:---:|:---:|:---:|:---|
| Return | -0.117% | +0.066% | -1.268 | 0.2147 | Not significant |
| \|Return\| (volatility proxy) | 1.279% | 0.682% | 2.221 | **0.0341** | **Significant** |

### Part B — AAPL Abnormal Return (Market Model)

| Sample | n | Mean CAR | t-test p | Wilcoxon p | Verdict |
|:---|:---:|:---:|:---:|:---:|:---|
| All events | 31 | +0.223% | 0.599 | 0.433 | Not significant |
| Hikes only | 20 | -0.232% | 0.683 | 0.898 | Not significant |
| Cuts only | 11 | +1.050% | 0.086 | 0.102 | Not significant, suggestive |

Bootstrap 95% CI for mean CAR (all events): **[-0.61%, +1.01%]**

### Residual Diagnostics (pooled across all 31 estimation windows)

| Test | Statistic | p-value | Result |
|:---|:---:|:---:|:---|
| Jarque-Bera (normality) | 4117.9 | <0.0001 | Not normal (skew=0.70, kurtosis=7.96) |
| ARCH-LM (heteroskedasticity) | 52.1 | <0.0001 | Heteroskedasticity present |
| Durbin-Watson (autocorrelation) | 1.84 | — | No major concern |

---
## 🔍 Next Steps (What I Would Do If I Had More Time)
- **Control for confounding events:** AAPL earnings dates and market-wide macro shocks (e.g. the Aug-2015 China deval selloff, visible as a sharp drawdown in the price chart) can land near rate-change dates and bias specific event windows.
- **Use Newey-West (HAC) standard errors** in the underlying Market-Model regressions — the confirmed heteroskedasticity means individual alpha/beta standard errors may be understated, even though the CAR-level conclusions are already cross-checked non-parametrically.
- **Revisit the cuts>hikes asymmetry with a larger sample** as the 2024–25 easing cycle continues, or test it with a BMP-style test (Boehmer, Musumeci & Poulsen 1991), which explicitly adjusts for event-induced volatility changes.
- **Classify meetings by surprise vs. expected** using Fed funds futures-implied probabilities (CME FedWatch) rather than by outcome alone — surprises, not scheduled decisions, are what the literature suggests move markets most.
