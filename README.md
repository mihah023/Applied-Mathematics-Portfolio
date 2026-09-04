# Welcome to My Financial World 📈

---

### 👋 Hi there, I'm Nguyễn Trần Minh Anh!

🎓 **International University – Vietnam National University, Ho Chi Minh City** | B.S. Applied Mathematics — Financial Engineering & Risk Management

🏆 **Academic Scholarship:** 2025–2026 Academic Year

🎯 **Target Role:** Quantitative Researcher / Quantitative Analyst / Risk Analyst / Financial Analyst Intern

---

### 💡 About Me

I'm an Applied Mathematics student focused on Financial Engineering & Risk Management, drawn to the problems that sit at the intersection of statistics, markets, and code. I like taking a research question — does the market really react to X, is this risk model actually well-calibrated — and following it all the way through: build the model, backtest it honestly, and report what the data actually says, including when it says "not significant."

👉 I'm currently building a portfolio of quantitative research projects — event studies, volatility/risk models, and machine learning-based portfolio optimization — as preparation for quantitative research roles. Every project here emphasizes reproducible methodology, statistical validation, and an honest account of limitations, not just the headline result.

---

## 🛠️ Tech Stack & Favorite Tools 🎯

* **Quantitative Methods:** Event-Study Methodology, Market Model Regression, GARCH Volatility Modeling, VaR/CVaR, Hypothesis Testing, Bootstrap Inference
* **Data Science & Scripting:** Python (`pandas`, `numpy`, `scipy`, `statsmodels`, `arch`, `matplotlib`, `yfinance`), Jupyter Notebooks
* **Machine Learning:** Graph Neural Networks, Reinforcement Learning, PPO, PyTorch
* **Data Sources:** FRED (Federal Reserve Economic Data), Yahoo Finance (`yfinance`), public market datasets
* **Spreadsheets & Database:** Excel, SQL

---

## 📂 Portfolio Projects 📂

<table width="100%">
<thead>
<tr>
<th width="28%" align="left">Project</th>
<th width="16%" align="left">Stack</th>
<th width="22%" align="left">Scope</th>
<th width="34%" align="left">Headline Finding</th>
</tr>
</thead>

<tbody>
<tr>
<td valign="top">
<a href="https://github.com/mihah023/Applied-Mathematics-Portfolio/tree/main/Volatility-Risk-Modeling">
<b>📉 GARCH Volatility Modeling & VaR Backtesting</b>
</a>
<br><br>
<sub>
<a href="https://github.com/mihah023/Applied-Mathematics-Portfolio/blob/main/Volatility-Risk-Modeling/notebooks/garch_var_cvar.ipynb">
Notebook ↗
</a>
</sub>
</td>

<td valign="top">
Python<br>
<code>arch</code><br>
<code>statsmodels</code><br>
Time Series<br>
Risk Modeling
</td>

<td valign="top">
40 Vietnamese stocks<br>
2023–2026<br>
GARCH(1,1)-t<br>
VaR 95% / 99%<br>
Kupiec + Christoffersen
</td>

<td valign="top">
<b>40/40 stocks reject normality</b>, while <b>35/40 show significant ARCH effects</b>, supporting volatility modeling with heavy-tailed innovations.
<br><br>
Student-t-GARCH substantially improves VCB model fit over Normal-GARCH (AIC <b>2349 vs 2592</b>).
<br><br>
<b>88% pass Kupiec at 95%, but only 62% pass conditional coverage</b>, showing that matching breach frequency is easier than capturing breach clustering.
</td>
</tr>
<tr>

<td valign="top">
<a href="https://github.com/mihah023/Applied-Mathematics-Portfolio/tree/main/FOMC-Event-Study">
<b>🏛️ Fed Rate-Change Event Study</b>
</a>
<br><br>
<sub>
<a href="https://github.com/mihah023/Applied-Mathematics-Portfolio/blob/main/FOMC-Event-Study/fomc_event_study_(1).ipynb">
Notebook ↗
</a>
</sub>
</td>

<td valign="top">
Python<br>
Market Model Event Study<br>
Welch's / Wilcoxon Tests<br>
Bootstrap Inference
</td>

<td valign="top">
SPY, AAPL, TLT & XLF<br>
31 Fed rate-change events<br>
2013–2026<br>
FRED + Yahoo Finance
</td>

<td valign="top">
Market-wide volatility rises around FOMC events, significant under Mann–Whitney, permutation, and bootstrap tests (Welch's t-test marginal at p=0.055), while <b>no individual asset (AAPL/TLT/XLF) shows a statistically significant abnormal return</b> under the market model.
<br><br>
Identified and corrected a pooling artifact that had inflated ARCH-LM significance: pooling residuals across all event windows into a single test yields <b>p &lt; 1e-6</b>, while per-window ARCH-LM tests show a much smaller share of windows actually exhibiting ARCH effects.
</td>

</tr>

<tr>

<td valign="top">
<b>🧠 Dynamic GNN-PPO Portfolio Optimization</b>
<br><br>
<sub>🎓 Undergraduate Thesis</sub>
</td>

<td valign="top">
Python<br>
Graph Neural Networks<br>
PPO Reinforcement Learning<br>
PyTorch
</td>

<td valign="top">
US equities, 2016–2026<br>
5 & 7 asset universes<br>
Dynamic correlation graphs<br>
Portfolio allocation
</td>

<td valign="top">
Main 5-asset experiment achieved approximately <b>82.8% return</b>, <b>1.13 Sharpe</b>, and <b>~22.5% maximum drawdown</b>.
<br><br>
GNN-PPO improved return by approximately <b>16.6 percentage points</b> over PPO-only.
</td>

</tr>

<tr>

<td valign="top">
<a href="https://github.com/mihah023/Applied-Mathematics-Portfolio/tree/main/Portfolio-Optimization">
<b>📊 Markowitz MVO vs. Risk Parity: Portfolio Construction & Backtest</b>
</a>
<br><br>
<sub>
<a href="https://github.com/mihah023/Applied-Mathematics-Portfolio/blob/main/Portfolio-Optimization/notebooks/portfolio_optimization.ipynb">
Notebook ↗
</a>
</sub>
</td>

<td valign="top">
Python<br>
Convex Optimization (cvxpy)<br>
Equal Risk Contribution (SciPy)<br>
Walk-Forward Backtest
</td>

<td valign="top">
40 VN-listed equities<br>
2023–2026, daily prices<br>
Monthly rebalancing<br>
6-month lookback window
</td>

<td valign="top">
Out-of-sample, the Max-Sharpe portfolio's realized Sharpe ratio (<b>1.96</b>) diverged sharply from its Global Min-Variance (<b>-0.12</b>) and Equal-Weight (<b>0.81</b>) counterparts, concentrating ~50% of weight in a single name — a textbook illustration of mean-variance optimization's sensitivity to expected-return estimation error.
<br><br>
Risk Parity, which ignores return forecasts entirely and equalizes risk contribution instead, tracked the Equal-Weight benchmark far more closely (<b>16.7% vs. 19.4%</b> annualized return) than either tracked Max-Sharpe — consistent with the theory that covariance estimates are more stable than return estimates.
</td>

</tr>

<tr>

<td valign="top">
<a href="https://github.com/mihah023/Applied-Mathematics-Portfolio/tree/main/Library-Management-System">
<b>📚 Library Management System</b>
</a>
<br><br>
<sub>
🎓 Coursework Project (3-person team)
</sub>
</td>

<td valign="top">
PHP (`mysqli`)<br>
MySQL<br>
Vanilla JavaScript<br>
Prepared Statements
</td>

<td valign="top">
4-table relational schema<br>
(category, author, storage, book)<br>
Dynamic CRUD interface<br>
Multi-table JOIN reporting
</td>

<td valign="top">
Built a whitelist-validated, injection-safe CRUD backend with dynamically generated forms and a normalized <b>1:N author–book relationship</b> (refactored from a fragile text-matching join to a proper foreign key).
<br><br>
My contribution: <b>Insert</b> function + frontend pages.
</td>

</tr>

<tr>

<td valign="top">
<b>🎯 Options Pricing & Greeks</b>
<br><br>
<sub>🚧 In Progress</sub>
</td>

<td valign="top">
Python<br>
Black-Scholes<br>
Monte Carlo
</td>

<td valign="top">
European options<br>
Option pricing<br>
Greeks<br>
Sensitivity analysis
</td>

<td valign="top">
<i>Coming soon</i> ⏳
</td>

</tr>

</tbody>
</table>

---

## 📚 Research Interests

- Quantitative Finance
- Financial Risk Modeling
- Financial Econometrics
- Time Series Analysis
- Portfolio Optimization
- Machine Learning for Finance
- Reinforcement Learning for Portfolio Allocation


---
## 📜 Relevant Certifications & Credentials

Yes, I know this list is already getting a little long—and honestly, it's probably going to keep growing! 🧠✨ I'm just someone who gets curious about new things and enjoys learning along the way, whether it's a new tool, a new concept, or another data problem that makes me go "wait… how does this work?" 🧩

Maybe if you check back in a few years, this section will be ridiculously long. 😂 But for now, I'm still learning, experimenting, and figuring things out one course (and one bug) at a time. 💻

Consider this just a little preview. There's still a lot more I want to learn! 🚀

| Certification | Issuing Organization | Status / Completion | Link |
| :--- | :--- | :--- | :---: |
| *Data Science for Business* | *DataCamp* | 🟢 Completed | *[Verify Certificate](https://www.datacamp.com/statement-of-accomplishment/course/1ee88bb5f5ab32cda9065eb43ccfcabfb7a205fa?raw=1)* |
| *Understanding Machine Learning* | *DataCamp* | 🟢 Completed | *[Verify Certificate](https://www.datacamp.com/statement-of-accomplishment/course/211f466b4fb3c2617ea2fc0a675b23cad23ccc55.png)* |
| *Exploratory Data Analysis in Python* | *DataCamp* | 🟢 Completed | *[Verify Certificate](https://www.datacamp.com/statement-of-accomplishment/course/d8cc4c80662e6442470b66b35b49d5dd7c5301c7.png)* |
| *Data Manipulation and Data Visualization with Python* | *CSC* | 🟢 Completed | *[Verify Certificate](https://drive.google.com/file/d/1IgxitcAuw2KCLnMHZEskYdn7PONt2Jhk/view?usp=sharing)* |
| *Data Manipulation with pandas* | *DataCamp* | 🟢 Completed | *[Verify Certificate](https://www.datacamp.com/statement-of-accomplishment/course/6f379112e1c2e64e608a28a162cd0c5255ff98e3.png)* |
| *Introduction to NumPy* | *DataCamp* | 🟢 Completed | *[Verify Certificate](https://www.datacamp.com/statement-of-accomplishment/course/ca166410c042270f66c27d97f3a9912f8bad9f62.png)* |
| *Introduction to SQL* | *DataCamp* | 🟢 Completed | *[Verify Certificate](https://www.datacamp.com/statement-of-accomplishment/course/8f10034bb78202d6ee9492c15799dd97b377f578.png)* |
| *Intermediate SQL* | *DataCamp* | 🟡 In Progress | *Coming Soon* ⏳ |
| *Manipulating Time Series Data in Python* | *DataCamp* | 🟡 In Progress | *Coming Soon* ⏳ |

---
## 💌 Let's Connect!

* 💼 **LinkedIn:** [Nguyễn Trần Minh Anh](https://www.linkedin.com/in/nguyentranminhanh/)
* 📧 **Email:** [mihah023@gmail.com](mailto:mihah023@gmail.com)
* 🐙 **GitHub:** [mihah023](https://github.com/mihah023)
