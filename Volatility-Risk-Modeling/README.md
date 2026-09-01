# 📉 GARCH Volatility Modeling & VaR Backtesting (with CVaR Forecasting)
<p align="left">
  <img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white" alt="Python" height="28" />
  <img src="https://img.shields.io/badge/pandas-%23150458.svg?style=flat-square&logo=pandas&logoColor=white" alt="pandas" height="28" />
  <img src="https://img.shields.io/badge/arch-GARCH-8B0000?style=flat-square" alt="arch" height="28" />
  <img src="https://img.shields.io/badge/statsmodels-orange?style=flat-square" alt="statsmodels" height="28" />
  <img src="https://img.shields.io/badge/Jupyter-F37626?style=flat-square&logo=jupyter&logoColor=white" alt="Jupyter" height="28" />
</p>

<p align="center">
  <img src="outputs/var_backtest_vcb.png" alt="VCB actual returns vs. daily-refit GARCH VaR forecasts" width="100%" />
</p>

---
## 📌 Executive Summary
I wanted to see how well a GARCH model can capture changing stock volatility, and whether those forecasts are actually useful for measuring downside risk — not just theoretically, but when you formally check them against what happened.

I started with **VCB** as a case study, using GARCH(1,1) with both Normal and Student-t innovations to forecast one-day-ahead **VaR and CVaR**. I then backtested the VaR forecasts using the **Kupiec** and **Christoffersen** tests before extending the analysis to 40 Vietnamese stocks.

The main takeaway wasn't simply that "GARCH works." The more interesting result was that **breach frequency and breach timing tell different stories**: 88% of stocks pass the Kupiec test at the 95% level, but only 62% pass the stricter conditional-coverage test. I also caught and fixed an implementation issue in my original walk-forward procedure, where the VaR forecast was unintentionally staying frozen between refits.

---
## 💻 Tech Stack
- **Language:** Python 3
- **Volatility Modeling:** `arch` (GARCH(1,1), Normal vs. Student-t innovations)
- **Statistical Testing:** `scipy.stats`, `statsmodels` (ADF, Jarque-Bera, ARCH-LM)
- **Risk Backtesting:** Kupiec (1995) unconditional coverage, Christoffersen (1998) independence, joint conditional coverage
- **Data Wrangling:** `pandas`, `numpy`
- **Visualization:** `matplotlib`
- **Data:** 40 VN-listed equities, daily closing prices, 2023-03-31 to 2026-03-31 (747 trading days)

---
## 📁 Repository Structure
```text
01-garch-var-cvar/
│
├── data/
│   └── vn_stock_prices_raw.csv     # 40 VN-listed equities, daily closes
│
├── notebooks/
│   └── garch_var_cvar.ipynb        # full analysis, VCB deep-dive + 40-stock extension
│
└── outputs/
    ├── return_distribution.png
    ├── conditional_volatility.png
    ├── garch_model_comparison.png
    ├── var_backtest_vcb.png
    ├── tail_persistence_40stocks.png
    └── full_40stock_var_backtest_corrected.csv
```

---
## 📂 Dataset Overview
### Key Metrics (VCB, the primary case study)
* **Sample:** 746 daily log returns, 2023-04-03 to 2026-03-31
* **Mean daily return:** -0.0059% | **Std dev:** 1.50%
* **Skewness:** -0.59 | **Excess kurtosis:** 13.19 — far fatter-tailed than a normal distribution
* **Out-of-sample backtest window:** 246 daily forecasts (2025-04-03 to 2026-03-31), 500-day rolling training window, **refit every single day**

---
## 🚨 Methodology Note
> [!WARNING]
> An earlier version of this notebook refit the GARCH model every 20 days but called `.forecast()` on that same, unrefit model in between. An `arch` model's forecast doesn't change unless you refit it — so the VaR line was effectively **frozen for 19 out of every 20 days**, not a genuine walk-forward forecast. This version refits daily using a trailing 500-day window (~5 minutes for all 40 stocks), so every forecast reflects everything known up to that point. The chart above should visibly track volatility day-to-day — compare that to a flat, stair-stepping line, which is what the bug produced.

---
## 📊 Key Findings & Insights

**1. VCB returns are stationary, heavy-tailed, and show clear volatility clustering.** The ADF test confirms stationarity (p<0.000001) — the precondition GARCH's constant-mean assumption needs. The **ARCH-LM test is what actually motivates using GARCH** in the first place: it finds significant volatility clustering (p<0.000001), meaning big moves bunch together in time rather than being scattered randomly. On top of that, the Jarque-Bera test and Q-Q plot show the return distribution is far from normal (excess kurtosis = 13.19).

![Return distribution vs. Normal](outputs/return_distribution.png)

* **Insight:** Before choosing a model, I wanted to check whether the data actually supported its assumptions instead of starting with GARCH by default — stationarity, volatility clustering, and fat tails are three separate checks, not one.

**2. Student-t GARCH wins on every metric, not just intuition.** Comparing Normal-GARCH vs. Student-t-GARCH head to head: Student-t has higher log-likelihood (-1169.6 vs. -1292.2) and lower AIC (2349.2 vs. 2592.4) and BIC (2372.2 vs. 2610.8) — a clean sweep.

![Normal-GARCH vs Student-t-GARCH model comparison](outputs/garch_model_comparison.png)

* **Insight:** The heavy-tailed distribution wasn't just something I assumed from the data — the Student-t specification also performed better when the two models were actually compared side by side.

**3. After fixing the stale-forecast bug, VCB's VaR forecasts were not rejected by the backtests at either the 95% or 99% level.** Out of 246 out-of-sample days: 16 breaches at VaR 95% (6.50% vs. an expected 5%, Kupiec p=0.30) and 5 breaches at VaR 99% (2.03% vs. an expected 1%, Kupiec p=0.15). The Christoffersen independence test also doesn't reject at either level (p=0.070 and p=0.058 — the 99% one sits close enough to 0.05 that I'd call it a pass with a note, not a comfortable margin), and the joint conditional-coverage test agrees (p=0.113 and p=0.060).
* **Insight:** Passing Kupiec alone isn't enough — a model can get the total number of breaches roughly right while still failing to capture *when* those breaches happen.

![Conditional volatility](outputs/conditional_volatility.png)

### 🚨 The main takeaway: breach frequency ≠ breach independence

**4. Extending the same daily-refit backtest to all 40 VN stocks is where the real story is.** The Kupiec-only pass rate looks solid — 88% at VaR 95%, 90% at VaR 99%. But requiring the *joint* conditional-coverage test (Kupiec + Christoffersen together) drops the 95% pass rate all the way to **62%** (25/40), a much bigger gap than at the 99% level (88%, 35/40).

**This was the most interesting result for me:** getting the total number of VaR breaches approximately right does not necessarily mean the model captures how risk evolves through time. A single fixed GARCH(1,1)-t specification does not calibrate equally well across every stock — which means a real risk system built this way would need to check each asset individually, not assume one backtest generalizes to the whole universe.

**5. Some stocks push GARCH persistence to the boundary — but I don't want to over-interpret it.** 10 of 40 stocks (`KDC`, `TLH`, `CNG`, `KDH`, `VIC`, `DGC`, `CMG`, `VHM`, `GAS`, `VSC`) show persistence (α+β) at or above 0.9999, right at the edge of GARCH's stationarity boundary.

![Tail fatness and persistence across 40 stocks](outputs/tail_persistence_40stocks.png)

With only about 2.4 years of data, I don't think this is enough evidence to claim these stocks have genuinely permanent volatility persistence — it could just as easily be the optimizer converging near a boundary on a fairly short sample. A longer sample or an explicit IGARCH comparison would be needed before reading much into it.
* **Insight:** One thing I learned here is that a model output can be statistically interesting without necessarily having an obvious economic interpretation attached to it yet.

---
## 📈 Results Tables

### VCB — Backtest Summary (246 out-of-sample days)

| Level | Breaches | Breach Rate | Expected Rate | Kupiec p | Christoffersen p | Conditional Coverage p |
|:---|:---:|:---:|:---:|:---:|:---:|:---:|
| VaR 95% | 16 | 6.50% | 5.00% | 0.2999 | 0.0699 | 0.1131 |
| VaR 99% | 5 | 2.03% | 1.00% | 0.1533 | 0.0579 | 0.0598 |

### Universe-Wide Diagnostics (40 stocks)

| Test | Result |
|:---|:---|
| ADF (stationarity) | 40/40 stocks stationary (100%) |
| Jarque-Bera (normality) | 40/40 stocks reject normality (100%) |
| ARCH-LM (volatility clustering) | 35/40 stocks show significant clustering (88%) |
| GARCH(1,1)-t convergence | 40/40 converged (100%) |

### Universe-Wide VaR Calibration (40 stocks, daily-refit backtest)

| Level | Kupiec-Only Pass Rate | Conditional-Coverage Pass Rate |
|:---|:---:|:---:|
| VaR 95% | 35/40 (88%) | 25/40 (62%) |
| VaR 99% | 36/40 (90%) | 35/40 (88%) |

---
## 🔍 Next Steps (What I Would Do If I Had More Time)
- **Look at the worst-calibrated names individually** (e.g. `KDC`, `NLG`, `KDH` — lowest Kupiec p-values at the 95% level) instead of treating the 62% pass rate as a single number; a stock-specific volatility regime could explain some of these failures.
- **Run a formal CVaR backtest.** CVaR is forecast at every step here, but only VaR is validated against actuals — Expected Shortfall needs its own backtesting approach (e.g. the Acerbi-Székely test) before I'd call it "validated" rather than just "forecast."
- **Test whether an IGARCH specification fits significantly better** for the 10 stocks sitting at the persistence boundary, instead of treating α+β≈1 as the final word for those names.
- **Extend the sample period** beyond ~2.4 years — a longer history would make both the persistence-boundary finding and the cross-sectional calibration results more reliable.
