# Welcome to My Quantitative Finance World 📈

---

### 👋 Hi there, I'm Nguyễn Trần Minh Anh!

🎓 **International University – Vietnam National University, Ho Chi Minh City** | B.S. Applied Mathematics — Financial Engineering & Risk Management

🏆 **Academic Scholarship:** 2025–2026 Academic Year

🎯 **Target Role:** Quantitative Researcher / Quantitative Analyst Intern

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
<a href="https://github.com/mihah023/Quantitative-Finance-Portfolio/tree/main/01-volatility-var-model">
<b>📉 Volatility Forecasting & VaR/CVaR Model</b>
</a>
<br><br>
<sub>
<a href="https://github.com/mihah023/Quantitative-Finance-Portfolio/blob/main/01-volatility-var-model/notebooks/var_cvar_analysis.ipynb">
Notebook ↗
</a>
</sub>
</td>

<td valign="top">
Python<br>
GARCH(1,1)<br>
VaR / Expected Shortfall<br>
Kupiec Backtest
</td>

<td valign="top">
AAPL daily returns<br>
3 competing VaR models<br>
Rolling 250-day windows<br>
99% confidence level
</td>

<td valign="top">
All three 99% VaR models pass the Kupiec backtest, but <b>GARCH reacts fastest to volatility clustering</b>, while Historical Simulation VaR lags by design.
<br><br>
Demonstrates the full risk-model lifecycle: estimate → forecast → <b>formally backtest</b>.
</td>

</tr>

<tr>

<td valign="top">
<a href="https://github.com/mihah023/Quantitative-Finance-Portfolio/tree/main/02-fomc-event-study">
<b>🏛️ Fed Rate-Change Event Study</b>
</a>
<br><br>
<sub>
<a href="FOMC-Event-Study">
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
SPY & AAPL<br>
31 Fed rate-change events<br>
2013–2026<br>
FRED + Yahoo Finance
</td>

<td valign="top">
The market reacts significantly to Fed rate changes (<b>p = 0.034</b>), but AAPL shows <b>no significant stock-specific abnormal return</b> across three independent tests.
<br><br>
Corrected a methodology issue that initially overstated significance (<b>p = 0.0007 → 0.034</b>).
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
## 📜 Relevant Certifications & Credentials

Yes, I know this list is already getting a little long—and honestly, it’s probably going to keep growing! 🧠✨ I’m just someone who gets curious about new things and enjoys learning along the way, whether it’s a new tool, a new concept, or another data problem that makes me go “wait… how does this work?” 🧩

Maybe if you check back in a few years, this section will be ridiculously long. 😂 But for now, I’m still learning, experimenting, and figuring things out one course (and one bug) at a time. 💻

Consider this just a little preview. There’s still a lot more I want to learn! 🚀

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
