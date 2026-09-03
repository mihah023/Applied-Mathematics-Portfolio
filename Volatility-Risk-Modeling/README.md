# 📉 GARCH Volatility Modeling & VaR Backtesting

<p align="left">
  <img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white" alt="Python" height="28" />
  <img src="https://img.shields.io/badge/pandas-%23150458.svg?style=flat-square&logo=pandas&logoColor=white" alt="pandas" height="28" />
  <img src="https://img.shields.io/badge/arch-GARCH-8B0000?style=flat-square" alt="arch" height="28" />
  <img src="https://img.shields.io/badge/statsmodels-orange?style=flat-square" alt="statsmodels" height="28" />
  <img src="https://img.shields.io/badge/Jupyter-F37626?style=flat-square&logo=jupyter&logoColor=white" alt="Jupyter" height="28" />
</p>

<p align="center">
  <img src="outputs/var_backtest_vcb.png" alt="VCB actual returns vs. GARCH VaR forecasts" width="100%" />
</p>

---

## 📌 Project Overview

This project examines whether a GARCH model can capture changing stock volatility and whether the resulting forecasts are useful for measuring downside risk.

I started with **VCB** as a case study, using GARCH(1,1) models with Normal and Student-t innovations. The selected model was then used to generate one-day-ahead Value-at-Risk (VaR) and Conditional Value-at-Risk (CVaR) forecasts through a walk-forward procedure.

Rather than stopping at the number of VaR breaches, the forecasts are evaluated using both the **Kupiec unconditional coverage test** and the **Christoffersen independence test**. The same framework is then applied to 40 Vietnamese stocks to examine how consistently one GARCH specification performs across different assets.

---

## 🔎 Headline Findings

### **1. Heavy tails matter for VCB**

VCB returns show strong evidence of non-normality, with an excess kurtosis of **13.19**. When comparing the two specifications, Student-t GARCH produces a substantially better fit than Normal-GARCH:

|                | Normal-GARCH | Student-t-GARCH |
| -------------- | -----------: | --------------: |
| Log-likelihood |      -1292.2 |     **-1169.6** |
| AIC            |       2592.4 |      **2349.2** |
| BIC            |       2610.8 |      **2372.2** |

The estimated Student-t degrees of freedom is approximately **3.14**, which is consistent with the heavy-tailed behavior seen in the return distribution.

---

### **2. Passing the breach-rate test does not necessarily mean the VaR model is well calibrated**

Across the 40-stock universe at the 95% VaR level:

* **35/40 stocks (88%)** pass the Kupiec test.
* Only **25/40 stocks (62%)** pass the conditional coverage test.

This gap is the main result of the project.

The model can often generate roughly the correct **number of breaches**, while still struggling with the **timing of those breaches**. In other words, matching the overall breach frequency is easier than producing breaches that are independent over time.

At the 99% level, the difference is smaller:

* **36/40 stocks (90%)** pass Kupiec.
* **35/40 stocks (88%)** pass conditional coverage.

This suggests that the calibration issue is more visible at the 95% VaR level for this sample.

---

### **3. GARCH persistence is close to the boundary for several stocks**

For **10 out of 40 stocks**, the estimated persistence satisfies:

$$
\alpha + \beta \geq 0.9999
$$

These stocks are:

`KDC`, `TLH`, `CNG`, `KDH`, `VIC`, `DGC`, `CMG`, `VHM`, `GAS`, and `VSC`.

Values this close to one sit at the boundary of the standard GARCH stationarity condition. However, with only around 2.4 years of data, this should not automatically be interpreted as evidence of permanent volatility persistence.

A longer sample or a direct comparison with IGARCH would be needed before making a stronger conclusion.

---

### **4. VCB passes the backtests, but the result is not completely comfortable**

Using 246 out-of-sample forecasts:

| Level   | Breaches | Observed Rate | Expected Rate | Kupiec p | Christoffersen p | Conditional Coverage p |
| ------- | -------: | ------------: | ------------: | -------: | ---------------: | ---------------------: |
| VaR 95% |       16 |         6.50% |         5.00% |   0.2999 |           0.0699 |                 0.1131 |
| VaR 99% |        5 |         2.03% |         1.00% |   0.1533 |           0.0579 |                 0.0598 |

At the 5% significance level, the model is not rejected by any of the tests.

However, several p-values are close to the rejection threshold. For example, the Christoffersen independence p-value is **0.0579** at the 99% VaR level.

So the result is better described as **not rejected** than as evidence that the VaR model is perfectly calibrated.

---

## 📂 Dataset

The analysis uses daily closing prices for **40 Vietnamese listed stocks**.

* **Period:** 2023-03-31 to 2026-03-31
* **Case study:** VCB
* **VCB observations:** 746 daily log returns
* **Training window:** 500 trading days
* **Out-of-sample period:** 246 trading days

### VCB Return Characteristics

| Metric             |    Value |
| ------------------ | -------: |
| Mean Daily Return  | -0.0059% |
| Standard Deviation |    1.50% |
| Skewness           |    -0.59 |
| Excess Kurtosis    |    13.19 |

The negative skewness and high excess kurtosis suggest that large negative moves are more relevant than a normal distribution would imply.

---

## 📊 Return Diagnostics

Before fitting GARCH, the return series is checked for three separate properties.

| Test        | Question                          | Result for VCB                   |
| ----------- | --------------------------------- | -------------------------------- |
| ADF         | Are returns stationary?           | Statistic = -25.62, p < 0.000001 |
| ARCH-LM     | Is volatility time-varying?       | Statistic = 39.00, p < 0.000001  |
| Jarque-Bera | Are returns normally distributed? | Statistic = 5369.5, p < 0.000001 |

The three tests support different parts of the modeling setup.

ADF confirms that the return series is stationary. ARCH-LM finds significant conditional heteroskedasticity, which supports modeling time-varying volatility. Jarque-Bera rejects normality, providing a reason to compare Normal and heavy-tailed Student-t innovations.

![Return distribution and Q-Q plot](outputs/return_distribution_qq.png)

---

## 📈 GARCH Model

The conditional variance follows a standard GARCH(1,1) specification:

$$
\sigma_t^2 =
\omega +
\alpha \epsilon_{t-1}^2 +
\beta \sigma_{t-1}^2
$$

where:

* \(\omega\) is the long-run variance component.
* \(\alpha\) measures the short-run reaction to new shocks.
* \(\beta\) measures volatility persistence.

For VCB, the selected Student-t specification produces:

* \(\omega = 0.563\)
* \(\alpha = 0.452\)
* \(\beta = 0.419\)
* \(\alpha + \beta = 0.871\)
* \(\nu \approx 3.14\)

The persistence estimate of **0.871** indicates that volatility shocks remain relevant for some time but decay under the standard GARCH framework.

![GARCH conditional volatility](outputs/garch_conditional_volatility.png)

The conditional volatility series also shows clear spikes during high-volatility periods instead of remaining constant throughout the sample.

---

## 🧪 Post-Estimation Diagnostics

A better AIC or BIC does not by itself confirm that the model captured the volatility structure correctly.

After fitting the Student-t GARCH model, standardized residuals are tested for remaining autocorrelation and ARCH effects.

| Test               | Statistic | p-value | Result                         |
| ------------------ | --------: | ------: | ------------------------------ |
| Ljung-Box (lag 10) |    7.7415 |  0.6541 | No significant autocorrelation |
| ARCH-LM (5 lags)   |        -- |  0.9936 | No remaining ARCH effects      |

The residual diagnostics do not show significant remaining autocorrelation or conditional heteroskedasticity.

For VCB, this suggests that the GARCH(1,1) model absorbed the main volatility dynamics identified in the original return series.

---

## 🔄 Walk-Forward VaR and CVaR Forecasting

The forecasting procedure uses a rolling window of **500 trading days**.

For every out-of-sample date:

1. Use the previous 500 trading days as the estimation sample.
2. Refit the GARCH model.
3. Generate a one-day-ahead volatility forecast.
4. Calculate VaR and CVaR.
5. Move the window forward by one trading day.

The model is therefore re-estimated **daily**.

This avoids using future information and allows the conditional volatility estimate to update as new market data becomes available.

![VCB actual returns vs. daily-refit GARCH VaR forecasts](outputs/var_backtest_vcb.png)

---

## 🚨 VaR Backtesting

The project evaluates VaR forecasts using two complementary tests.

### Kupiec Test — Unconditional Coverage

The Kupiec test checks whether the observed number of VaR breaches is consistent with the expected breach probability.

For example:

* A 95% VaR should be breached approximately 5% of the time.
* A 99% VaR should be breached approximately 1% of the time.

A rejection indicates that the model produces significantly too many or too few breaches.

---

### Christoffersen Test — Independence

The Christoffersen test checks whether breaches occur independently over time.

This is important because a model can have the correct total number of breaches while those breaches still appear in clusters.

The test uses transitions between:

* `0 → 0`: no breach followed by no breach
* `0 → 1`: no breach followed by a breach
* `1 → 0`: breach followed by no breach
* `1 → 1`: consecutive breaches

The `1 → 1` transition is particularly relevant because repeated consecutive breaches can indicate that the VaR model is not adjusting quickly enough during periods of elevated volatility.

---

### Conditional Coverage

The joint conditional coverage statistic combines the two tests:

$$
LR_{CC} = LR_{UC} + LR_{IND}
$$

A model that passes this test must satisfy both conditions:

1. The overall breach frequency is appropriate.
2. Breaches are independent over time.

This distinction becomes particularly important in the cross-stock results.

---

## 🌏 Results Across 40 Vietnamese Stocks

The same workflow was applied to the full stock universe.

### Distributional Diagnostics

| Diagnostic               | Result |
| ------------------------ | -----: |
| Stationary returns       |  40/40 |
| Reject normality         |  40/40 |
| Significant ARCH effects |  35/40 |
| GARCH(1,1)-t convergence |  40/40 |

Non-normality is present across the entire sample, while significant ARCH effects appear in **35 out of 40 stocks**.

This means the same volatility model is being applied to some assets where the original ARCH evidence is weaker than for others, which may partly explain differences in backtesting performance.

---

### VaR Backtesting Results

| Confidence Level | Kupiec Pass Rate | Conditional Coverage Pass Rate |
| ---------------- | ---------------: | -----------------------------: |
| 95% VaR          |      35/40 (88%) |                    25/40 (62%) |
| 99% VaR          |      36/40 (90%) |                    35/40 (88%) |

![Cross-sectional tail comparison](outputs/cross_sectional_tail_comparison.png)

The largest gap appears at the **95% VaR level**.

While most stocks pass the breach-frequency test, a considerably smaller number pass the conditional coverage test.

This shows why looking only at the total number of VaR violations can be misleading. Two models may produce a similar number of breaches, but one may experience them randomly while another produces several violations during the same period.

---

## ⚠️ Christoffersen Test Edge Case

For some breach sequences, one or more transition types may not occur.

In these cases, the transition probabilities required for the independence likelihood cannot be estimated properly, and the test returns `NaN`.

This is treated as a limitation of the statistical test for that particular sample rather than a model convergence or coding error.

The likelihood implementation was also symbolically verified during development using SymPy.

---

## 📌 What This Project Found

The main result is not simply that **GARCH works for Vietnamese stocks**.

The results show a more mixed picture:

* Student-t innovations fit VCB substantially better than Normal innovations.
* GARCH(1,1) removes the main ARCH effects from VCB standardized residuals.
* Most stocks achieve acceptable overall VaR breach frequencies.
* However, fewer stocks pass the stricter conditional coverage test, especially at the 95% VaR level.
* Several stocks produce persistence estimates extremely close to the GARCH stationarity boundary.

Overall, the results suggest that a single GARCH(1,1)-t specification can provide reasonable volatility and VaR forecasts across a broad set of stocks, but its calibration is not equally reliable for every asset.

---

## ⚠️ Limitations

* The out-of-sample period contains approximately **246 trading days**, which is limited for evaluating 1% VaR.
* CVaR is forecast but not independently backtested.
* Daily model refitting is computationally expensive.
* The same GARCH(1,1)-t specification is applied across all stocks.
* Some stocks may require asymmetric models such as GJR-GARCH.
* 10 out of 40 stocks have persistence estimates at or very close to \(\alpha + \beta = 1\).
* The analysis models each stock independently and does not estimate portfolio-level VaR or time-varying correlations.

---

## 🔍 Possible Extensions

* Investigate poorly calibrated stocks individually.
* Run a formal CVaR backtest.
* Compare near-boundary cases with IGARCH.
* Extend the historical sample.
* Test asymmetric volatility models such as GJR-GARCH.
* Compare parametric VaR with historical simulation.
* Extend the framework to portfolio-level risk modeling.

---

## 📁 Repository Structure

```text
Volatility-Risk-Modeling/
│
├── data/
│   └── vn_stock_prices_raw.csv
│
├── notebooks/
│   └── garch_var_cvar.ipynb
│
└── outputs/
    ├── return_distribution_qq.png
    ├── garch_conditional_volatility.png
    ├── var_backtest_vcb.png
    ├── cross_sectional_tail_comparison.png
    ├── distributional_tests_40stocks.csv
    └── full_40stock_var_backtest.csv
```

---

## ▶️ How to Run

```bash
pip install pandas numpy scipy arch statsmodels matplotlib jupyter
```

Then open the notebook:

```bash
jupyter notebook notebooks/garch_var_cvar.ipynb
```

---

## 🛠️ Tools

**Python · pandas · NumPy · SciPy · `arch` · statsmodels · Matplotlib · Jupyter Notebook**
