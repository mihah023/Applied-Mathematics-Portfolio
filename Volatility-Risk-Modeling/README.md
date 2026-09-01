# GARCH Volatility Modeling & VaR Backtesting: VCB

This project applies GARCH(1,1) modeling to VCB stock returns and uses the model to estimate and backtest Value-at-Risk (VaR) and Conditional VaR (CVaR).

The project started with a basic analysis of the return distribution and then developed into a complete risk modeling process, including stationarity checks, volatility modeling, walk-forward forecasting, and VaR backtesting.

## What I Did

### 1. Return Distribution & Stationarity Analysis

I first examined VCB returns using:

- Augmented Dickey-Fuller (ADF) test, to check the series is stationary before modeling
- Histogram + Q-Q plot
- Skewness and kurtosis
- Jarque-Bera normality test
- ARCH-LM test

The results showed VCB returns are stationary (ADF p ≈ 0.000000), not normally distributed, and exhibit fat tails and volatility clustering. The Q-Q plot makes the fat tails visible directly — points curve away from the normal line at both ends. These findings motivated the use of a GARCH model.

### 2. GARCH(1,1) Model

I fitted a GARCH(1,1) model with Student-t errors using the `arch` package, and compared it against a Normal-GARCH alternative on log-likelihood, AIC, and BIC to confirm Student-t is actually the better fit rather than just assuming it:

| | Normal-GARCH | Student-t-GARCH |
|---|---:|---:|
| AIC | 2592.36 | **2349.16** |
| BIC | 2610.82 | **2372.24** |

The estimated degrees of freedom parameter was ν ≈ 3.14, consistent with the heavy-tailed behavior observed in the return data.

### 3. VaR and CVaR Forecasting


Using the fitted GARCH model, I produced one-day-ahead VaR and CVaR forecasts at the 95% and 99% confidence levels, walk-forward — only information available before each forecast date was used, to avoid look-ahead bias.

I initially refit the GARCH model every 20 days to save computation, but found this was a bug: calling `.forecast()` on an unrefit model returns the exact same forecast every time, so the VaR was effectively frozen for 19 out of every 20 days. I fixed this by refitting **every trading day** instead (~5 minutes for all 40 stocks).

### 4. VaR Backtesting

I used two tests: the **Kupiec test** (checks if the total number of breaches matches the expected rate) and the **Christoffersen independence test** (checks if breaches cluster in time instead of happening independently — a model can have the right breach count but still fail this if breaches bunch together).

For VCB:

| Metric | VaR 95% | VaR 99% |
|---|---:|---:|
| Expected breach rate | 5.00% | 1.00% |
| Observed breach rate | 6.50% | 2.03% |
| Kupiec p-value | 0.30 | 0.15 |
| Christoffersen p-value | 0.07 | 0.06 |
| Conditional coverage p-value | 0.11 | 0.06 |

VCB passes all three tests at both confidence levels — no p-value below 0.05.

(Note: my first version of the Christoffersen test had a formula bug that made VCB look much worse than it actually was. Caught it on a second review and verified the fix with `sympy` before trusting the corrected numbers.)

## Testing Other Stocks

After VCB, I applied the same checks and the same daily-refit VaR backtest to **all 40 stocks** in the dataset, not just a sample.

**Do the modeling assumptions hold universe-wide?**
- ADF: 40/40 stocks (100%) stationary
- Jarque-Bera: 40/40 stocks (100%) non-normal
- ARCH-LM: 35/40 stocks (88%) show significant volatility clustering — 5 stocks (HCM, HAH, VSC, FPT, REE) don't


**VaR backtest across all 40:**

| Test | VaR 95% | VaR 99% |
|---|---:|---:|
| Kupiec-only pass rate | 35/40 (88%) | 36/40 (90%) |
| Conditional coverage pass rate | 25/40 (62%) | 35/40 (88%) |

Most stocks calibrate well on both breach count and timing. The 95% level shows the biggest gap between the simple pass rate and the stricter joint test (62% vs 88%), which is worth digging into further, but it's nowhere close to a universal failure.

## Visualizations

### Return Distribution + Q-Q Plot

![Return distribution](outputs/return_distribution_qq.png)

### GARCH Conditional Volatility

![GARCH conditional volatility](outputs/garch_conditional_volatility.png)

### VaR Backtest

![VaR backtest](outputs/var_backtest_vcb.png)

### Cross-Stock Tail Comparison

![Cross-sectional tail comparison](outputs/cross_sectional_tail_comparison.png)

## Data

The project uses daily closing prices for 40 Vietnamese listed stocks from **2023-03-31 to 2026-03-31**.

VCB is used as the main example, while the other stocks are used to compare how well the same risk model performs across different assets.


## Limitations

There are several limitations to the current approach:

- Daily refit is correct but computationally heavier than a proper recursive variance update would be.
- The out-of-sample period contains around 246 trading days, which is relatively small for evaluating 1% VaR.
- The VaR forecasts are based on a parametric Student-t distribution. Historical simulation could be used as an additional robustness check.
- Each stock is modeled independently, so this project does not estimate portfolio-level VaR or time-varying correlations.
- CVaR is forecast at every step but not independently backtested.
- 10/40 stocks show persistence right at the theoretical boundary (α+β ≈ 1) — reported but not fully explained; could be a short-sample artifact.
- The same GARCH(1,1)-t specification is applied to all stocks. Some stocks (especially the 5 without significant ARCH effects, or the ones with the biggest Kupiec/conditional-coverage gap) may need alternative specifications such as GJR-GARCH.

## How to Run

```bash
pip install pandas numpy scipy arch statsmodels matplotlib jupyter
jupyter notebook notebooks/garch_var_cvar.ipynb
```

## Tools

Python · pandas · NumPy · SciPy · `arch` · statsmodels · Matplotlib · sympy (for verifying the Christoffersen formula) · Jupyter Notebook
