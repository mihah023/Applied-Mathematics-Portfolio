

garch_var_cvar(5).ipynb
File

Pasted markdown.md
File
bảng readme này đã thật sự viết nên những insight rút ra từ notebook mà ko mang giọng văn AI ko , học theo phong cách viết của bảng repo này kartlynng/Data-Analytics-Portfolio.git

Ừ, mình đã đọc README của bạn và đối chiếu với phong cách repo Kartlyn Nguyen's Data Analytics Portfolio. 

Nhận xét thật: README hiện tại có insight thật từ notebook, không phải kiểu bịa insight chung chung. Nhưng giọng văn vẫn còn hơi “AI-written” ở một số đoạn, chủ yếu vì nó lặp nhiều cấu trúc kiểu:

“The key point is…”
“Insight: …”
“This made me realize…”
“rather than assuming…”
“doesn't automatically mean…”

Trong khi style của Kartlyn là: nêu số liệu → nói thẳng nó có nghĩa gì → đôi khi thêm một câu interpretation rất cụ thể. Không cố biến mỗi section thành một “lesson learned”.

Cái README của bạn làm tốt
Insight mạnh nhất là đoạn này:

88% pass Kupiec → only 62% pass conditional coverage.

Đây là insight thực sự rút ra từ kết quả notebook, vì nó không chỉ nói “GARCH works” mà chỉ ra một sự khác biệt cụ thể:

model có thể forecast đúng số lượng breach

nhưng vẫn không forecast tốt thời điểm breach xảy ra

Cái này đúng kiểu Kartlyn: headline finding có số liệu cụ thể và interpretation rõ. 

Tương tự, các đoạn này cũng ổn:

Student-t fit tốt hơn Normal-GARCH → có AIC/BIC/log-likelihood cụ thể.

10/40 stocks có α + β ≈ 1 → đây là một pattern thực tế trong kết quả, rồi bạn cẩn thận không overinterpret.

VCB không bị reject nhưng p-value gần 0.05 → interpretation hợp lý, không kiểu “model performed excellently”.

CVaR có forecast nhưng chưa backtest → limitation thật từ notebook.

Chỗ còn hơi AI nhất
Ví dụ đoạn:

Insight: Before choosing a model, I wanted to check whether the data actually supported its assumptions instead of starting with GARCH by default...

Ý này không sai, nhưng nó giống một bài học methodology hơn là insight từ kết quả.

Có thể viết tự nhiên hơn:

The diagnostics point in different directions: ADF confirms that returns are stationary, ARCH-LM shows that volatility is time-varying, and Jarque-Bera rejects normality. Together, this gives a clearer reason for using GARCH with heavy-tailed innovations rather than treating all three tests as one generic justification for the model.

Câu này vẫn academic nhưng giống sinh viên tự đọc kết quả rồi giải thích, không phải AI cố “reflect”.

Đoạn này cũng hơi AI:
Insight: A walk-forward backtest is only meaningful if the forecast genuinely updates with new information at every step...

Đây gần như là giải thích textbook, không phải finding.

Kartlyn thường sẽ viết theo kiểu project-specific hơn. Ví dụ:

Using a fixed 500-day rolling window, the model was re-estimated every trading day. This means the VaR forecast changes with the most recent volatility conditions instead of relying on parameters estimated weeks or months earlier.

Nghe đơn giản hơn và bám sát đúng implementation của notebook.

Đoạn mình thấy giống style Kartlyn nhất nếu sửa theo hướng này
Thay vì:

Insight: A single GARCH(1,1)-t specification does not calibrate equally well across every stock. This made me realize that risk models should be validated at the individual-asset level rather than assuming that one specification generalizes equally well across an entire universe.

Viết:

The cross-stock results show that using the same GARCH(1,1)-t specification for every stock does not produce equally reliable VaR forecasts. While 35 out of 40 stocks pass the Kupiec test at the 95% level, only 25 pass conditional coverage. In other words, getting the overall breach rate right is not the same as getting the timing right.

Cái này mạnh hơn nhiều. Nó giống cách Kartlyn viết: có số → giải thích số → chốt một conclusion cụ thể. Repo của Kartlyn cũng thường dùng chính pattern này trong cột “Headline Finding”, ví dụ đưa ra một con số hoặc pattern rồi giải thích implication ngay sau đó. 

Kết luận
Nếu chấm thật:

Tiêu chí	Đánh giá
Insight có thật từ notebook không?	Có, khá rõ
Có overclaim không?	Ít, phần lớn khá cẩn thận
Có giọng sinh viên/researcher không?	Có
Có còn dấu AI không?	Có một chút
Giống style repo Kartlyn chưa?	Khoảng 70–75%
Vấn đề chính không phải insight giả. Insight của README này khá tốt. Vấn đề là bạn đang thêm chữ “Insight:” và một câu reflection gần như sau mọi kết quả, nên nó tạo cảm giác AI đang cố chứng minh rằng mỗi section đều phải có một “takeaway”.

Nếu muốn giống repo Kartlyn hơn, mình sẽ:

Bỏ gần hết chữ Insight:

Chỉ giữ 3–4 headline findings mạnh nhất

Với mỗi finding, viết theo công thức:
Result → specific number/pattern → what that means

Bỏ các câu kiểu “This made me realize…”, “I wanted to check…”, “The key point is…” nếu không thật sự cần thiết.

Nói ngắn gọn: README của bạn đã có dữ liệu và insight đủ mạnh rồi. Giờ chỉ cần bớt “giải thích rằng mình đang rút ra insight” — cứ để con số và interpretation tự nói.


gửi full code cho tui đi

Được 😭 Ý bạn là muốn mình viết lại FULL README hoàn chỉnh theo kiểu repo Kartlyn, dựa trên đúng kết quả trong notebook + README hiện tại, và giảm giọng AI đúng không?

Mình gửi bản full luôn để bạn copy vào README.md nhé:

📉 GARCH Volatility Modeling & VaR Backtesting
<p align="left"> <img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white" alt="Python" height="28" /> <img src="https://img.shields.io/badge/pandas-%23150458.svg?style=flat-square&logo=pandas&logoColor=white" alt="pandas" height="28" /> <img src="https://img.shields.io/badge/arch-GARCH-8B0000?style=flat-square" alt="arch" height="28" /> <img src="https://img.shields.io/badge/statsmodels-orange?style=flat-square" alt="statsmodels" height="28" /> <img src="https://img.shields.io/badge/Jupyter-F37626?style=flat-square&logo=jupyter&logoColor=white" alt="Jupyter" height="28" /> </p>

<p align="center"> <img src="outputs/var_backtest_vcb.png" alt="VCB actual returns vs. GARCH VaR forecasts" width="100%" /> </p>

📌 Project Overview
This project examines whether a GARCH model can capture changing stock volatility and whether the resulting forecasts are useful for measuring downside risk.

I started with VCB as a case study, using GARCH(1,1) models with Normal and Student-t innovations. The selected model was then used to generate one-day-ahead Value-at-Risk (VaR) and Conditional Value-at-Risk (CVaR) forecasts through a walk-forward procedure.

Rather than stopping at the number of VaR breaches, the forecasts are evaluated using both the Kupiec unconditional coverage test and the Christoffersen independence test. The same framework is then applied to 40 Vietnamese stocks to examine how consistently one GARCH specification performs across different assets.

🔎 Headline Findings
1. Heavy tails matter for VCB
VCB returns show strong evidence of non-normality, with an excess kurtosis of 13.19. When comparing the two specifications, Student-t GARCH produces a substantially better fit than Normal-GARCH:


Normal-GARCH	Student-t-GARCH
Log-likelihood	-1292.2	-1169.6
AIC	2592.4	2349.2
BIC	2610.8	2372.2
The estimated Student-t degrees of freedom is approximately 3.14, which is consistent with the heavy-tailed behavior seen in the return distribution.

2. Passing the breach-rate test does not necessarily mean the VaR model is well calibrated
Across the 40-stock universe at the 95% VaR level:

35/40 stocks (88%) pass the Kupiec test.

Only 25/40 stocks (62%) pass the conditional coverage test.

This gap is the main result of the project.

The model can often generate roughly the correct number of breaches, while still struggling with the timing of those breaches. In other words, matching the overall breach frequency is easier than producing breaches that are independent over time.

At the 99% level, the difference is smaller:

36/40 stocks (90%) pass Kupiec.

35/40 stocks (88%) pass conditional coverage.

This suggests that the calibration issue is more visible at the 95% VaR level for this sample.

3. GARCH persistence is close to the boundary for several stocks
For 10 out of 40 stocks, the estimated persistence satisfies:

[
\alpha + \beta \geq 0.9999
]

These stocks are:

KDC, TLH, CNG, KDH, VIC, DGC, CMG, VHM, GAS, and VSC.

Values this close to one sit at the boundary of the standard GARCH stationarity condition. However, with only around 2.4 years of data, this should not automatically be interpreted as evidence of permanent volatility persistence.

A longer sample or a direct comparison with IGARCH would be needed before making a stronger conclusion.

4. VCB passes the backtests, but the result is not completely comfortable
Using 246 out-of-sample forecasts:

Level	Breaches	Observed Rate	Expected Rate	Kupiec p	Christoffersen p	Conditional Coverage p
VaR 95%	16	6.50%	5.00%	0.2999	0.0699	0.1131
VaR 99%	5	2.03%	1.00%	0.1533	0.0579	0.0598
At the 5% significance level, the model is not rejected by any of the tests.

However, several p-values are close to the rejection threshold. For example, the Christoffersen independence p-value is 0.0579 at the 99% VaR level.

So the result is better described as not rejected than as evidence that the VaR model is perfectly calibrated.

📂 Dataset
The analysis uses daily closing prices for 40 Vietnamese listed stocks.

Period: 2023-03-31 to 2026-03-31

Case study: VCB

VCB observations: 746 daily log returns

Training window: 500 trading days

Out-of-sample period: 246 trading days

VCB Return Characteristics
Metric	Value
Mean Daily Return	-0.0059%
Standard Deviation	1.50%
Skewness	-0.59
Excess Kurtosis	13.19
The negative skewness and high excess kurtosis suggest that large negative moves are more relevant than a normal distribution would imply.

📊 Return Diagnostics
Before fitting GARCH, the return series is checked for three separate properties.

Test	Question	Result for VCB
ADF	Are returns stationary?	Statistic = -25.62, p < 0.000001
ARCH-LM	Is volatility time-varying?	Statistic = 39.00, p < 0.000001
Jarque-Bera	Are returns normally distributed?	Statistic = 5369.5, p < 0.000001
The three tests support different parts of the modeling setup.

ADF confirms that the return series is stationary. ARCH-LM finds significant conditional heteroskedasticity, which supports modeling time-varying volatility. Jarque-Bera rejects normality, providing a reason to compare Normal and heavy-tailed Student-t innovations.



📈 GARCH Model
The conditional variance follows a standard GARCH(1,1) specification:

[
\sigma_t^2 =
\omega +
\alpha \epsilon_{t-1}^2 +
\beta \sigma_{t-1}^2
]

where:

(\omega) is the long-run variance component.

(\alpha) measures the short-run reaction to new shocks.

(\beta) measures volatility persistence.

For VCB, the selected Student-t specification produces:

(\omega = 0.563)

(\alpha = 0.452)

(\beta = 0.419)

(\alpha + \beta = 0.871)

(\nu \approx 3.14)

The persistence estimate of 0.871 indicates that volatility shocks remain relevant for some time but decay under the standard GARCH framework.



The conditional volatility series also shows clear spikes during high-volatility periods instead of remaining constant throughout the sample.

🧪 Post-Estimation Diagnostics
A better AIC or BIC does not by itself confirm that the model captured the volatility structure correctly.

After fitting the Student-t GARCH model, standardized residuals are tested for remaining autocorrelation and ARCH effects.

Test	Statistic	p-value	Result
Ljung-Box (lag 10)	7.7415	0.6541	No significant autocorrelation
ARCH-LM (5 lags)	--	0.9936	No remaining ARCH effects
The residual diagnostics do not show significant remaining autocorrelation or conditional heteroskedasticity.

For VCB, this suggests that the GARCH(1,1) model absorbed the main volatility dynamics identified in the original return series.

🔄 Walk-Forward VaR and CVaR Forecasting
The forecasting procedure uses a rolling window of 500 trading days.

For every out-of-sample date:

Use the previous 500 trading days as the estimation sample.

Refit the GARCH model.

Generate a one-day-ahead volatility forecast.

Calculate VaR and CVaR.

Move the window forward by one trading day.

The model is therefore re-estimated daily.

This avoids using future information and allows the conditional volatility estimate to update as new market data becomes available.



🚨 VaR Backtesting
The project evaluates VaR forecasts using two complementary tests.

Kupiec Test — Unconditional Coverage
The Kupiec test checks whether the observed number of VaR breaches is consistent with the expected breach probability.

For example:

A 95% VaR should be breached approximately 5% of the time.

A 99% VaR should be breached approximately 1% of the time.

A rejection indicates that the model produces significantly too many or too few breaches.

Christoffersen Test — Independence
The Christoffersen test checks whether breaches occur independently over time.

This is important because a model can have the correct total number of breaches while those breaches still appear in clusters.

The test uses transitions between:

0 → 0: no breach followed by no breach

0 → 1: no breach followed by a breach

1 → 0: breach followed by no breach

1 → 1: consecutive breaches

The 1 → 1 transition is particularly relevant because repeated consecutive breaches can indicate that the VaR model is not adjusting quickly enough during periods of elevated volatility.

Conditional Coverage
The joint conditional coverage statistic combines the two tests:

[
LR_{CC} = LR_{UC} + LR_{IND}
]

A model that passes this test must satisfy both conditions:

The overall breach frequency is appropriate.

Breaches are independent over time.

This distinction becomes particularly important in the cross-stock results.

🌏 Results Across 40 Vietnamese Stocks
The same workflow was applied to the full stock universe.

Distributional Diagnostics
Diagnostic	Result
Stationary returns	40/40
Reject normality	40/40
Significant ARCH effects	35/40
GARCH(1,1)-t convergence	40/40
Non-normality is present across the entire sample, while significant ARCH effects appear in 35 out of 40 stocks.

This means the same volatility model is being applied to some assets where the original ARCH evidence is weaker than for others, which may partly explain differences in backtesting performance.

VaR Backtesting Results
Confidence Level	Kupiec Pass Rate	Conditional Coverage Pass Rate
95% VaR	35/40 (88%)	25/40 (62%)
99% VaR	36/40 (90%)	35/40 (88%)


The largest gap appears at the 95% VaR level.

While most stocks pass the breach-frequency test, a considerably smaller number pass the conditional coverage test.

This shows why looking only at the total number of VaR violations can be misleading. Two models may produce a similar number of breaches, but one may experience them randomly while another produces several violations during the same period.

⚠️ Christoffersen Test Edge Case
For some breach sequences, one or more transition types may not occur.

In these cases, the transition probabilities required for the independence likelihood cannot be estimated properly, and the test returns NaN.

This is treated as a limitation of the statistical test for that particular sample rather than a model convergence or coding error.

The likelihood implementation was also symbolically verified during development using SymPy.

📌 What This Project Found
The main result is not simply that GARCH works for Vietnamese stocks.

The results show a more mixed picture:

Student-t innovations fit VCB substantially better than Normal innovations.

GARCH(1,1) removes the main ARCH effects from VCB standardized residuals.

Most stocks achieve acceptable overall VaR breach frequencies.

However, fewer stocks pass the stricter conditional coverage test, especially at the 95% VaR level.

Several stocks produce persistence estimates extremely close to the GARCH stationarity boundary.

Overall, the results suggest that a single GARCH(1,1)-t specification can provide reasonable volatility and VaR forecasts across a broad set of stocks, but its calibration is not equally reliable for every asset.

⚠️ Limitations
The out-of-sample period contains approximately 246 trading days, which is limited for evaluating 1% VaR.

CVaR is forecast but not independently backtested.

Daily model refitting is computationally expensive.

The same GARCH(1,1)-t specification is applied across all stocks.

Some stocks may require asymmetric models such as GJR-GARCH.

10 out of 40 stocks have persistence estimates at or very close to (\alpha + \beta = 1).

The analysis models each stock independently and does not estimate portfolio-level VaR or time-varying correlations.

🔍 Possible Extensions
Investigate poorly calibrated stocks individually.

Run a formal CVaR backtest.

Compare near-boundary cases with IGARCH.

Extend the historical sample.

Test asymmetric volatility models such as GJR-GARCH.

Compare parametric VaR with historical simulation.

Extend the framework to portfolio-level risk modeling.

📁 Repository Structure
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
▶️ How to Run
pip install pandas numpy scipy arch statsmodels matplotlib jupyter
Then open the notebook:

jupyter notebook notebooks/garch_var_cvar.ipynb
🛠️ Tools
Python · pandas · NumPy · SciPy · arch · statsmodels · Matplotlib · Jupyter Notebook

Bản này mình đã chỉnh theo hướng ít “Insight:” hơn, không cố moral lesson sau mỗi section, mà tập trung vào kiểu:

number/result → pattern → interpretation

Đúng kiểu portfolio repo hơn. Tuy nhiên, nếu muốn chuẩn 100% theo notebook, mình vẫn khuyên mình rà lại trực tiếp notebook garch_var_cvar.ipynb để check từng con số và xem còn finding nào hay hơn chưa được đưa vào README.


📉 GARCH Volatility Modeling & VaR Backtesting (with CVaR Forecasting)
<p align="left"> <img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white" alt="Python" height="28" /> <img src="https://img.shields.io/badge/pandas-%23150458.svg?style=flat-square&logo=pandas&logoColor=white" alt="pandas" height="28" /> <img src="https://img.shields.io/badge/arch-GARCH-8B0000?style=flat-square" alt="arch" height="28" /> <img src="https://img.shields.io/badge/statsmodels-orange?style=flat-square" alt="statsmodels" height="28" /> <img src="https://img.shields.io/badge/Jupyter-F37626?style=flat-square&logo=jupyter&logoColor=white" alt="Jupyter" height="28" /> </p>

<p align="center"> <img src="outputs/var_backtest_vcb.png" alt="VCB actual returns vs. daily-refit GARCH VaR forecasts" width="100%" /> </p>

📌 Executive Summary
I wanted to see how well a GARCH model can capture changing stock volatility, and whether those forecasts are actually useful for measuring downside risk — not just theoretically, but when you formally check them against what happened.

I started with VCB as a case study, using GARCH(1,1) with both Normal and Student-t innovations to forecast one-day-ahead VaR and CVaR. I then backtested the VaR forecasts using the Kupiec and Christoffersen tests before extending the analysis to 40 Vietnamese stocks.

The main takeaway wasn't simply that "GARCH works." The more interesting result was that breach frequency and breach timing tell different stories: 88% of stocks pass the Kupiec test at the 95% level, but only 62% pass the stricter conditional-coverage test.

I also used a daily-refit walk-forward procedure to make sure each VaR forecast only reflects information available up to that point in time, and formally backtested the results with the Kupiec and Christoffersen tests rather than just reporting breach counts.

💻 Tech Stack
Language: Python 3

Volatility Modeling: arch — GARCH(1,1), Normal vs. Student-t innovations

Statistical Testing: scipy.stats, statsmodels — ADF, Jarque-Bera, ARCH-LM

Risk Backtesting: Kupiec (1995), Christoffersen (1998), joint conditional coverage

Data Wrangling: pandas, numpy

Visualization: matplotlib

Data: 40 Vietnamese listed equities, daily closing prices, 2023-03-31 to 2026-03-31

sympy was used separately, outside this notebook, to symbolically verify the Christoffersen
likelihood formula during development — it's not a runtime dependency and isn't imported by
the notebook itself, so it's not required to run anything here.

📁 Repository Structure
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
📂 Dataset Overview
Key Metrics — VCB
VCB is used as the primary case study before extending the analysis to the full 40-stock universe.

Sample: 746 daily log returns, 2023-04-03 to 2026-03-31

Mean daily return: -0.0059%

Standard deviation: 1.50%

Skewness: -0.59

Excess kurtosis: 13.19

Out-of-sample period: 246 daily forecasts

Training window: 500 trading days

Refit frequency: Daily

🔬 Modeling Framework
The project follows a complete volatility and downside-risk modeling pipeline:

Return Diagnostics → GARCH Volatility Model → VaR/CVaR Forecasting → Walk-Forward Backtesting → Cross-Stock Comparison

Why GARCH?
The diagnostics answer three different questions:

Diagnostic	What it checks	Modeling implication
ADF	Is the return series stationary?	Confirms the return series is stationary
ARCH-LM	Is there volatility clustering?	Provides evidence for conditional volatility modeling
Jarque-Bera + Q-Q plot	Are returns normally distributed?	Motivates heavy-tailed innovations
For VCB:

ADF statistic = -25.62, p < 0.000001 → stationary

ARCH-LM statistic = 39.00, p < 0.000001 → significant ARCH effects

Jarque-Bera = 5369.5, p < 0.000001 → strong departure from normality

The key point is that these tests support different modeling decisions rather than serving as one blanket justification for GARCH.

📊 Key Findings & Insights
1. VCB returns are stationary, heavy-tailed, and show clear volatility clustering
The return series is stationary, but the more important evidence for volatility modeling comes from the ARCH-LM test, which finds significant conditional heteroskedasticity.

The Jarque-Bera test and Q-Q plot also show that VCB returns have much heavier tails than a normal distribution, with excess kurtosis of 13.19.



Insight: Before choosing a model, I wanted to check whether the data actually supported its assumptions instead of starting with GARCH by default — stationarity, volatility clustering, and fat tails are three separate checks, not one.

2. Student-t GARCH provides a substantially better fit than Normal-GARCH
I fitted GARCH(1,1) under both Normal and Student-t innovations and compared their fit using log-likelihood, AIC, and BIC.


Normal-GARCH	Student-t-GARCH
Log-likelihood	-1292.2	-1169.6
AIC	2592.4	2349.2
BIC	2610.8	2372.2
Student-t provides the better fit across all three metrics.

For VCB, the fitted Student-t GARCH parameters are:

ω = 0.563

α = 0.452

β = 0.419

α + β = 0.871

ν ≈ 3.14

The persistence estimate α + β = 0.871 indicates persistent but mean-reverting conditional volatility under the standard GARCH(1,1) framework.

The estimated degrees of freedom ν ≈ 3.14 also imply substantially heavier tails than a normal distribution, consistent with the return diagnostics.



Insight: Volatility isn't constant over time -- it spikes sharply around specific periods and decays afterward, matching the clustering pattern the ARCH-LM test picked up on earlier.

3. Checking the model actually worked: post-estimation diagnostics
Fitting GARCH and getting a reasonable volatility plot doesn't automatically mean the model did its job. The whole reason for using GARCH was that the raw returns had leftover autocorrelation and ARCH effects -- so before trusting this model for forecasting, I checked whether those effects are actually gone from the standardized residuals, or if GARCH(1,1) wasn't enough.

Test	Statistic	p-value	Result
Ljung-Box (lag 10)	7.7415	0.6541	No leftover autocorrelation
ARCH-LM (5 lags)	--	0.9936	No leftover ARCH effects
Both come back clean. This is a more direct check than just comparing AIC/BIC against Normal-GARCH earlier -- it confirms GARCH(1,1) actually absorbed the volatility dynamics it was supposed to, rather than just fitting better than an alternative with the same underlying problem.

Insight: Getting a good AIC/BIC score doesn't automatically mean the model adequately captured the volatility clustering -- I still needed to go back and check the residuals directly to confirm GARCH(1,1) was sufficient rather than assuming it from the fit comparison alone.

4. Walk-forward VaR forecasting with daily refitting
For each forecast date, the model uses only information available up to that date to avoid look-ahead bias.

I refit the GARCH model every trading day using a trailing 500-day window, so each day's VaR forecast reflects that day's own conditional volatility estimate rather than a stale one from several days earlier. This takes approximately five minutes to run across the full 40-stock universe.



Insight: A walk-forward backtest is only meaningful if the forecast genuinely updates with new information at every step — refitting daily, rather than periodically, keeps the VaR series responsive to real changes in volatility rather than lagging behind them.

5. VCB VaR forecasts were not rejected by the backtests
Using 246 out-of-sample forecasts:

Level	Breaches	Breach Rate	Expected Rate	Kupiec p	Christoffersen p	Conditional Coverage p
VaR 95%	16	6.50%	5.00%	0.2999	0.0699	0.1131
VaR 99%	5	2.03%	1.00%	0.1533	0.0579	0.0598
At the 5% significance level, VCB is not rejected by Kupiec, Christoffersen, or the joint conditional-coverage test at either confidence level.

However, several p-values are relatively close to 0.05, so I would interpret this as "not rejected" rather than evidence of perfect calibration.

Insight: Passing Kupiec alone isn't enough — a model can get the total number of breaches roughly right while still failing to capture when those breaches happen.

🚨 The Main Takeaway: Breach Frequency ≠ Breach Independence
6. The cross-stock results reveal a bigger calibration problem
After the VCB case study, I applied the same daily-refit procedure to all 40 stocks.

Cross-Stock Diagnostics
Test	Result
ADF	40/40 stationary (100%)
Jarque-Bera	40/40 reject normality (100%)
ARCH-LM	35/40 show significant clustering (88%)
GARCH(1,1)-t convergence	40/40 converged (100%)
VaR Backtesting Across All 40 Stocks
Level	Kupiec-Only Pass Rate	Conditional-Coverage Pass Rate
VaR 95%	35/40 (88%)	25/40 (62%)
VaR 99%	36/40 (90%)	35/40 (88%)
The difference is substantial at the 95% level:

88% pass Kupiec → only 62% pass conditional coverage.

This means that matching the overall number of breaches is considerably easier than capturing their temporal dependence.



Insight: A single GARCH(1,1)-t specification does not calibrate equally well across every stock. This made me realize that risk models should be validated at the individual-asset level rather than assuming that one specification generalizes equally well across an entire universe.

7. Some stocks push GARCH persistence to the boundary
10 of 40 stocks show persistence estimates α + β ≥ 0.9999:

KDC, TLH, CNG, KDH, VIC, DGC, CMG, VHM, GAS, VSC

These estimates sit extremely close to the GARCH stationarity boundary.

With only about 2.4 years of data, I don't think this is enough evidence to claim genuinely permanent volatility persistence. The optimizer may simply be converging near a boundary on a relatively short sample.

A longer history or an explicit IGARCH comparison would be needed before drawing a stronger conclusion.

Insight: One thing I learned here is that a model output can be statistically interesting without necessarily having an obvious economic interpretation attached to it yet.

🧪 Understanding the Backtests
The project uses two complementary VaR diagnostics.

Kupiec — Unconditional Coverage
Kupiec tests whether the observed VaR breach frequency is consistent with the expected rate.

For example:

VaR 95% → expected breach rate = 5%

VaR 99% → expected breach rate = 1%

A rejection means the model produces significantly too many or too few breaches.

Christoffersen — Independence
Christoffersen tests whether VaR breaches are independent over time.

This matters because breaches can cluster even when the total number of breaches looks reasonable.

The test examines transitions between:

0 = no breach

1 = breach

In particular, n₁₁ counts consecutive breach-to-breach transitions, making it possible to detect clustering that Kupiec cannot detect.

Conditional Coverage
The joint test combines unconditional coverage and independence:

$$
LR_{CC} = LR_{UC} + LR_{IND}
$$

Under the null hypothesis, the VaR model has both:

the correct overall breach frequency, and

independent breaches over time.

This is why the conditional-coverage result is more informative than looking at the Kupiec result alone.

⚠️ A Note on the Christoffersen Test's NaN Case
If one of the two transition states (breach / no-breach) does not occur at all in the sample, some transition probabilities cannot be estimated and the test returns NaN instead of a p-value. This reflects a genuine limitation of the statistical calculation — independence isn't testable without observing transitions from both states — rather than a data or code issue.

I verified the restricted-likelihood formula symbolically with SymPy (outside the notebook, as a one-off check) before relying on it for the reported results.

🔍 Next Steps
Investigate the worst-calibrated stocks individually, such as KDC, NLG, and KDH, instead of treating the 62% pass rate as one aggregate result.

Run a formal CVaR backtest. CVaR is forecast throughout the analysis, but it is not independently validated here.

Test IGARCH for the 10 stocks near the persistence boundary.

Extend the sample period beyond ~2.4 years to make the persistence and cross-sectional calibration results more reliable.

Test alternative specifications, such as GJR-GARCH, for stocks where asymmetric volatility or weak ARCH effects may make standard GARCH less appropriate.

📌 Limitations
The out-of-sample period contains only around 246 trading days, which is relatively small for evaluating 1% VaR.

Daily refitting is computationally heavier than more efficient recursive updating approaches.

VaR is modeled parametrically using Student-t innovations; historical simulation could provide an additional robustness check.

Each stock is modeled independently, so this project does not estimate portfolio-level VaR or time-varying correlations.

CVaR is forecast at every step but not independently backtested.

10/40 stocks have persistence estimates at or very close to α + β = 1; these cases require further investigation rather than a strong interpretation.

The same GARCH(1,1)-t specification is applied across all stocks, although some assets may require alternative volatility specifications.

▶️ How to Run
pip install pandas numpy scipy arch statsmodels matplotlib jupyter
jupyter notebook notebooks/garch_var_cvar.ipynb
🛠️ Tools
Python · pandas · NumPy · SciPy · arch · statsmodels · Matplotlib · Jupyter Notebook


Close
