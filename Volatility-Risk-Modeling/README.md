# GARCH Volatility Modeling & VaR/CVaR Backtesting: VCB

This project applies GARCH(1,1) modeling to VCB stock returns and uses the model to estimate and backtest Value-at-Risk (VaR) and Conditional VaR (CVaR).

The project started with a basic analysis of the return distribution and then developed into a complete risk modeling process, including volatility modeling, walk-forward forecasting, and VaR backtesting.

## What I Did

### 1. Return Distribution Analysis

I first examined the distribution of VCB returns using:

- Histogram
- Skewness and kurtosis
- Jarque-Bera normality test
- ARCH-LM test

The results showed that VCB returns are not normally distributed and exhibit fat tails and volatility clustering. These findings motivated the use of a GARCH model.

### 2. GARCH(1,1) Model

I fitted a GARCH(1,1) model with Student-t errors using the `arch` package.

The estimated degrees of freedom parameter was approximately $\nu \approx 3.1$, which is consistent with the heavy-tailed behavior observed in the return data.

### 3. VaR and CVaR Forecasting

Using the fitted GARCH model, I produced one-day-ahead VaR and CVaR forecasts at the 95% and 99% confidence levels.

The forecasts were generated using a walk-forward approach, where only information available before each forecast date was used. This helps avoid look-ahead bias.

### 4. VaR Backtesting

I used the Kupiec Proportion-of-Failures test to check whether the observed VaR breach rate was consistent with the expected breach rate.

For VCB:

| Metric | VaR 95% | VaR 99% |
|---|---:|---:|
| Expected breach rate | 5.00% | 1.00% |
| Observed breach rate | 6.91% | 2.44% |
| Kupiec p-value | 0.19 | 0.06 |
| Result | Well-calibrated | Borderline |

Overall, the GARCH(1,1)-t model produced reasonably well-calibrated VaR forecasts for VCB, although the 99% VaR result was relatively close to the rejection threshold.

## Testing Other Stocks

After testing VCB, I applied the same GARCH(1,1)-t model to 40 Vietnamese listed stocks to see whether the model worked similarly across different companies.

I then selected a 6-stock basket covering different sectors and performed the same walk-forward VaR backtest.

| Ticker | Sector | VaR 95% | VaR 99% |
|---|---|---|---|
| HPG | Steel | Yes (p=0.84) | Borderline (p=0.06) |
| FPT | Technology | Yes (p=0.19) | Yes (p=0.15) |
| VCB | Banking | Yes (p=0.19) | Borderline (p=0.06) |
| VIC | Real Estate | **No (p=0.002)** | **No (p=0.02)** |
| VNM | Consumer Staples | **No (p=0.01)** | **No (p=0.02)** |
| GAS | Energy | **No (p<0.001)** | Yes (p=0.15) |

The results were quite different across stocks. **Half of the 6-stock basket failed the 95% Kupiec calibration test.**

This was an important finding because it showed that a GARCH(1,1)-t model can work reasonably well for some stocks, but its performance is not necessarily consistent across different stocks.

## Visualizations

### Return Distribution

![Return distribution](outputs/chart_0_cell5.png)

### GARCH Conditional Volatility

![GARCH conditional volatility](outputs/chart_1_cell12.png)

### VaR Backtest

![VaR backtest](outputs/chart_2_cell15.png)

### Cross-Stock Tail Comparison

![Cross-sectional tail comparison](outputs/chart_3_cell22.png)

## Data

The project uses daily closing prices for 40 Vietnamese listed stocks from **2023-03-31 to 2026-03-31**.

VCB is used as the main example, while the other stocks are used to compare how well the same risk model performs across different assets.

## Limitations

There are several limitations to the current approach:

- The GARCH model is refitted every 20 trading days rather than every day to reduce computational time.
- The out-of-sample period contains around 246 trading days, which is relatively small for evaluating 1% VaR.
- The VaR forecasts are based on a parametric Student-t distribution. Historical simulation could be used as an additional robustness check.
- Each stock is modeled independently, so this project does not estimate portfolio-level VaR or time-varying correlations.
- The same GARCH(1,1)-t specification is applied to all stocks. Some stocks may require alternative specifications such as GJR-GARCH to better capture asymmetric volatility.

## How to Run

```bash
pip install pandas numpy scipy arch statsmodels matplotlib jupyter
jupyter notebook notebooks/garch_var_cvar.ipynb
```

## Tools

Python · pandas · NumPy · SciPy · `arch` · statsmodels · Matplotlib · Jupyter Notebook
