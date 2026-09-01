# GARCH Volatility Modeling & VaR Backtesting: VCB

This project applies GARCH(1,1) modeling to VCB stock returns and uses the model to estimate and backtest Value-at-Risk (VaR) and Conditional VaR (CVaR).

The project started with a basic analysis of the return distribution and then developed into a complete risk modeling process, including stationarity checks, volatility modeling, walk-forward forecasting, and VaR backtesting.

## Hypotheses Tested

| Test | H0 (null hypothesis) | Rejecting H0 means... |
|---|---|---|
| ADF | The return series has a unit root | The return series is stationary |
| Jarque-Bera | Returns are normally distributed | Returns depart from normality, supporting heavy-tailed innovations |
| ARCH-LM | No ARCH effects (no autocorrelation in squared returns) | Conditional heteroskedasticity is present, motivating GARCH |
| Kupiec | The VaR breach rate equals the stated confidence level (e.g. 5%) | Breach count is significantly off — VaR is miscalibrated |
| Christoffersen | VaR breaches are independent over time | Breaches cluster together — VaR is miscalibrated even if the total count looks right |
| Conditional Coverage | The VaR model has correct unconditional coverage and breach independence | At least one of these two conditions is violated |

## What I Did

### 1. Return Distribution & Stationarity Analysis

**Augmented Dickey-Fuller (ADF) test**
- H0: the return series has a unit root (is non-stationary).
- H1: the series is stationary.

Result: ADF statistic = -25.62, p ≈ 0.000000 → H0 rejected. The return series is stationary.

**Jarque-Bera test**
- H0: returns are normally distributed (S=0, K=3).
- H1: returns are not normally distributed.

$$JB = \frac{n}{6}\left(S^2 + \frac{(K-3)^2}{4}\right)$$

Result: JB = 5369.5, p ≈ 0.000000 → H0 rejected. Skewness -0.59, excess kurtosis 13.19 — returns depart substantially from normality, with the excess kurtosis and Q-Q plot together pointing to heavy tails rather than just asymmetry.

**ARCH-LM test**
- H0: no autocorrelation in squared returns (no ARCH effects).
- H1: squared returns are autocorrelated (volatility clustering present).

Result: statistic = 39.00 (5 lags), p ≈ 0.000000 → H0 rejected. Conditional heteroskedasticity is present.

I also plotted a histogram + Q-Q plot against the normal distribution — the Q-Q plot shows points curving away from the normal line at both ends, with one point (a ~-13% return) sitting well off the line by itself.

**Together, the diagnostics support the overall modeling framework:** the return series is stationary (ADF), ARCH effects motivate conditional volatility modeling with GARCH (ARCH-LM), and the heavy-tailed distribution motivates Student-t innovations (Jarque-Bera + kurtosis + Q-Q plot) — three separate pieces of evidence pointing to three separate modeling decisions, not one blanket justification.

### 2. GARCH(1,1) Model

$$\sigma_t^2 = \omega + \alpha\epsilon_{t-1}^2 + \beta\sigma_{t-1}^2$$

I fitted this with Student-t errors using the `arch` package, and compared it against a Normal-GARCH alternative on log-likelihood, AIC, and BIC:

| | Normal-GARCH | Student-t-GARCH |
|---|---:|---:|
| AIC | 2592.36 | **2349.16** |
| BIC | 2610.82 | **2372.24** |

Student-t wins on both. Fitted parameters: ω=0.563, α=0.452, β=0.419 — persistence α+β=0.871, indicating persistent but mean-reverting conditional volatility, consistent with covariance-stationarity under the standard GARCH(1,1) specification (a distinct concept from the return-series stationarity tested via ADF above — same word, different object). Estimated ν≈3.14 implies substantially heavier tails than a normal distribution, consistent with the non-normality and excess kurtosis observed earlier.

### 3. VaR and CVaR Forecasting

Using the fitted GARCH model, I produced one-day-ahead VaR and CVaR forecasts at the 95% and 99% confidence levels, walk-forward — only information available before each forecast date was used, to avoid look-ahead bias.

I initially refit the GARCH model every 20 days to save computation, but found a real bug: calling `.forecast()` repeatedly on a model that hasn't been refit returns the exact same variance forecast every time (I verified this directly — 5 repeated calls returned an identical number), so the VaR was effectively frozen for 19 out of every 20 days. I fixed this by refitting **every trading day** instead (~5 minutes for all 40 stocks).

### 4. VaR Backtesting

**Kupiec test (unconditional coverage)**
- H0: the observed breach rate equals the expected confidence level.
- H1: the observed breach rate differs significantly from the expected level.

**Christoffersen independence test (1998)**
- H0: VaR breaches are independent over time.
- H1: VaR breaches are dependent and tend to cluster.

The test is based on transition probabilities between two states: `0` (no breach) and `1` (breach).
- π₀₁: probability of a breach after a non-breach day
- π₁₁: probability of a breach after a breach day
- π₂: unconditional probability of a breach

Under H0, π₀₁ = π₁₁ = π₂. The restricted likelihood under H0 is:

$$L_0 = (1-\pi_2)^{(n_{00}+n_{10})}\pi_2^{(n_{01}+n_{11})}$$

where n_ij is the number of transitions from state i to state j. In particular, **n₁₁ captures consecutive VaR breaches** — this is exactly why the test can catch clustering that a simple breach-rate check (Kupiec) would miss entirely.

If one state doesn't occur at all, some transition probabilities can't be estimated and the test returns `NaN` — a limitation of the statistical calculation, not a coding error.

*Note: an earlier implementation contained an exponent-grouping error in this likelihood (grouped by starting state instead of ending state). The formula was corrected and independently verified symbolically using SymPy before producing the reported results.*

**Christoffersen conditional coverage test**
- H0: the VaR model has correct unconditional coverage and breach independence.
- H1: at least one of these two conditions is violated.

$$LR_{cc} = LR_{uc} + LR_{ind} \sim \chi^2_2$$

**Results for VCB:**

| Metric | VaR 95% | VaR 99% |
|---|---:|---:|
| Expected breach rate | 5.00% | 1.00% |
| Observed breach rate | 6.50% | 2.03% |
| Kupiec p-value | 0.30 | 0.15 |
| Christoffersen p-value | 0.07 | 0.06 |
| Conditional coverage p-value | 0.11 | 0.06 |

At the 5% significance level, VCB is not rejected by any of the three backtests at either confidence level. Several p-values (0.06–0.07) sit close to the threshold, though, so this should be read as "not rejected" rather than strong evidence of perfect calibration.

## Do the Diagnostic Patterns Generalize Across Stocks?

After VCB, I applied the same checks and the same daily-refit VaR backtest to **all 40 stocks** in the dataset, not just a sample.

**Cross-stock diagnostics:**
- ADF: 40/40 stocks (100%) stationary
- Jarque-Bera: 40/40 stocks (100%) non-normal
- ARCH-LM: 35/40 stocks (88%) show significant volatility clustering — 5 stocks (HCM, HAH, VSC, FPT, REE) don't, so GARCH is less well-motivated for those specifically

**VaR backtest across all 40:**

| Test | VaR 95% | VaR 99% |
|---|---:|---:|
| Kupiec-only pass rate | 35/40 (88%) | 36/40 (90%) |
| Conditional coverage pass rate | 25/40 (62%) | 35/40 (88%) |

Most stocks pass the simpler Kupiec breach-frequency test, while performance under the stricter conditional coverage test is more mixed, especially at the 95% confidence level. **The gap between the 95% Kupiec pass rate (88%) and conditional-coverage pass rate (62%) suggests matching the total number of breaches is easier than modeling their temporal independence** — arguably the more informative finding here than either number alone.

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

- Daily refit is correct but computationally heavier than a proper recursive variance update would be.
- The out-of-sample period contains around 246 trading days, which is relatively small for evaluating 1% VaR.
- The VaR forecasts are based on a parametric Student-t distribution. Historical simulation could be used as an additional robustness check.
- Each stock is modeled independently, so this project does not estimate portfolio-level VaR or time-varying correlations.
- CVaR is forecast at every step but not independently backtested.
- 10/40 stocks show persistence estimates at or very close to the boundary α+β=1. These cases are reported but not investigated further and warrant additional analysis (e.g. longer samples or an IGARCH specification test) rather than being explained here.
- The same GARCH(1,1)-t specification is applied to all stocks. Some stocks (especially the 5 without significant ARCH effects, or the ones driving the Kupiec/conditional-coverage gap) may need alternative specifications such as GJR-GARCH.

## How to Run

```bash
pip install pandas numpy scipy arch statsmodels matplotlib jupyter
jupyter notebook notebooks/garch_var_cvar.ipynb
```

## Tools

Python · pandas · NumPy · SciPy · `arch` · statsmodels · Matplotlib · sympy (for verifying the Christoffersen formula) · Jupyter Notebook
