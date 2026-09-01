# GARCH Volatility Modeling & VaR Backtesting: VCB

This project applies GARCH(1,1) modeling to VCB stock returns and uses the model to estimate and backtest Value-at-Risk (VaR) and Conditional VaR (CVaR).

The project started with a basic analysis of the return distribution and then developed into a complete risk modeling process, including stationarity checks, volatility modeling, walk-forward forecasting, and VaR backtesting.

## Hypotheses Tested

A quick reference for what each test's null hypothesis (H0) actually claims, before diving into results:

| Test | H0 (null hypothesis) | Rejecting H0 means... |
|---|---|---|
| ADF | The return series has a unit root (non-stationary) | Series is stationary — safe to model with GARCH |
| Jarque-Bera | Returns are normally distributed | Returns are skewed / fat-tailed — motivates Student-t errors |
| ARCH-LM | Squared returns are not autocorrelated (no volatility clustering) | Volatility clustering is present — motivates GARCH over a constant-variance model |
| Kupiec | The VaR breach rate equals the stated confidence level (e.g. 5%) | Breach count is significantly off — VaR is miscalibrated |
| Christoffersen | VaR breaches are independent over time | Breaches cluster together — VaR is miscalibrated even if the total count looks right |
| Conditional Coverage | Breaches have the correct rate AND occur independently | At least one of the two conditions above is violated |

## What I Did

### 1. Return Distribution & Stationarity Analysis

I first examined VCB returns using:

**Augmented Dickey-Fuller (ADF) test** — checks whether the series is stationary before modeling.
- H0: the return series has a unit root (is non-stationary).
- H1: the series is stationary.

Result: ADF statistic = -25.62, p ≈ 0.000000 → H0 rejected. Returns are stationary.

**Jarque-Bera test** — checks whether returns are normally distributed, using skewness (S) and kurtosis (K).
- H0: returns are normally distributed (S=0, K=3).
- H1: returns are not normally distributed.

JB = (n/6) * (S^2 + (K-3)^2 / 4)

Result: JB = 5369.5, p ≈ 0.000000 → H0 rejected decisively. Skewness -0.59, excess kurtosis 13.19 (very fat-tailed).

**ARCH-LM test** — checks whether squared returns are autocorrelated (volatility clustering).
- H0: no autocorrelation in squared returns (no ARCH effects).
- H1: squared returns are autocorrelated (volatility clustering present).

Result: statistic = 39.00 (5 lags), p ≈ 0.000000 → H0 rejected. Volatility clustering confirmed.

I also plotted a histogram + Q-Q plot against the normal distribution. The Q-Q plot makes the fat tails visible directly — points curve away from the normal line at both ends, with one point (a ~-13% return) sitting well off the line by itself.

**Together, these three results are the actual justification for GARCH**: stationary (model assumptions hold), non-normal (a normal model would understate risk), volatility-clustered (a constant-variance model would miss real time-varying risk).

### 2. GARCH(1,1) Model

sigma_t^2 = omega + alpha * epsilon_{t-1}^2 + beta * sigma_{t-1}^2

I fitted this with Student-t errors using the `arch` package, and compared it against a Normal-GARCH alternative on log-likelihood, AIC, and BIC to confirm Student-t is actually the better fit rather than just assuming it:

| | Normal-GARCH | Student-t-GARCH |
|---|---:|---:|
| AIC | 2592.36 | **2349.16** |
| BIC | 2610.82 | **2372.24** |

Student-t wins on both. Fitted parameters: omega=0.563, alpha=0.452, beta=0.419 (persistence alpha+beta=0.871, stationary), nu=3.14 — a low nu confirms independently what Jarque-Bera already found.

### 3. VaR and CVaR Forecasting

Using the fitted GARCH model, I produced one-day-ahead VaR and CVaR forecasts at the 95% and 99% confidence levels, walk-forward — only information available before each forecast date was used, to avoid look-ahead bias.

I initially refit the GARCH model every 20 days to save computation, but found this was a bug: calling `.forecast()` on an unrefit model returns the exact same forecast every time, so the VaR was effectively frozen for 19 out of every 20 days. I fixed this by refitting **every trading day** instead (~5 minutes for all 40 stocks).

### 4. VaR Backtesting

**Kupiec test (unconditional coverage)** — checks whether the total number of breaches matches the expected rate.
- H0: the observed breach rate equals the expected confidence level (e.g. 5%).
- H1: the observed breach rate differs significantly from the expected level.

**Christoffersen independence test (1998)** — checks whether VaR breaches occur independently over time rather than clustering together.
- H0: VaR breaches are independent over time.
- H1: VaR breaches are dependent and tend to cluster.

The test is based on the transition probabilities between two states: `0` (no breach) and `1` (breach).
- pi_01: probability of a breach after a non-breach day
- pi_11: probability of a breach after a breach day
- pi_2: unconditional probability of a breach

Under H0, today's breach status should not depend on yesterday's status, so pi_01 = pi_11 = pi_2. The test compares the likelihood under this independence restriction against the unrestricted likelihood. Under H0, the restricted likelihood is:

L0 = (1 - pi_2)^(n00+n10) * pi_2^(n01+n11)

where n_ij is the number of transitions from state i to state j. In particular, **n11 captures consecutive VaR breaches** — this is exactly why the test can catch clustering that a simple breach-rate check (Kupiec) would miss entirely.

If one of the states doesn't occur at all (e.g. zero breaches in the sample), some transition probabilities can't be estimated and the test returns `NaN` — this is a limitation of the statistical calculation, not a coding error.

*Note: my first implementation of this formula had a real bug (grouped exponents by starting state instead of ending state), caught on a second review and confirmed with `sympy` before trusting the corrected numbers — it had made VCB look considerably worse than it actually was.*

**Christoffersen conditional coverage test** — combines the Kupiec and independence tests.
- H0: VaR breaches have the correct unconditional frequency AND occur independently over time.
- H1: at least one of these two conditions is violated.

LR_cc = LR_uc + LR_ind, compared against a chi-square distribution with 2 degrees of freedom.

**Results for VCB:**

| Metric | VaR 95% | VaR 99% |
|---|---:|---:|
| Expected breach rate | 5.00% | 1.00% |
| Observed breach rate | 6.50% | 2.03% |
| Kupiec p-value | 0.30 | 0.15 |
| Christoffersen p-value | 0.07 | 0.06 |
| Conditional coverage p-value | 0.11 | 0.06 |

VCB passes all three tests at both confidence levels — no p-value below 0.05.

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
