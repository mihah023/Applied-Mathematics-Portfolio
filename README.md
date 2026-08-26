# Welcome to My Quantitative Finance World 📈

---

### 👋 Hi there, I'm Nguyễn Trần Minh Anh!

🎓 **International University – Vietnam National University, Ho Chi Minh City** | B.S. Applied Mathematics — Financial Engineering & Risk Management

🏆 **Fun Flex:** GPA **3.32/4.00** | Thesis grade **90/100**

🎯 **Target Role:** Quantitative Researcher / Quantitative Analyst Intern

---

### 💡 About Me

I'm an Applied Mathematics student specializing in **Financial Engineering & Risk Management**, with a strong interest in quantitative research, financial markets, statistical modeling, and systematic strategies.

I enjoy turning financial questions into testable research problems — from asking whether markets react abnormally to macroeconomic events, to modeling volatility and evaluating risk forecasts. My approach is to **build the model, test the assumptions, backtest the results, and report what the data actually says**, including when the evidence is statistically insignificant.

My current portfolio focuses on **quantitative finance, statistical inference, financial econometrics, and machine learning for portfolio optimization**. I aim to build projects that demonstrate not only technical implementation, but also sound methodology, statistical reasoning, and an honest discussion of limitations.

---

## 🛠️ Tech Stack & Favorite Tools 🎯

* **Quantitative Finance:** Event Study Methodology, Market Model, CAPM, Portfolio Optimization, Volatility Modeling, VaR / CVaR, Risk Analysis
* **Statistics & Econometrics:** Hypothesis Testing, Welch's t-test, Wilcoxon Test, Bootstrap Inference, Regression Analysis, Time-Series Analysis
* **Machine Learning:** Graph Neural Networks (GNN), Reinforcement Learning, PPO, Portfolio Allocation
* **Data Science & Scripting:** Python (`pandas`, `numpy`, `scipy`, `statsmodels`, `arch`, `matplotlib`), Jupyter Notebook
* **Financial Data:** FRED, Yahoo Finance, `yfinance`
* **Other Tools:** Excel, Git, GitHub

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

```
<tr>
  <td valign="top">
    <a href="https://github.com/mihah023/Quantitative-Finance-Portfolio/tree/main/01-volatility-var-model"><b>📉 Volatility Forecasting & VaR/CVaR Model</b></a><br>
    <sub><a href="https://github.com/mihah023/Quantitative-Finance-Portfolio/blob/main/01-volatility-var-model/notebooks/var_cvar_analysis.ipynb">Notebook ↗</a></sub>
  </td>
  <td valign="top">
    • Python<br>
    • GARCH(1,1)<br>
    • VaR / Expected Shortfall<br>
    • Kupiec Backtest<br>
    • scipy / arch
  </td>
  <td valign="top">
    • AAPL daily returns<br>
    • 3 competing VaR models<br>
    • Rolling 250-day windows
  </td>
  <td valign="top">
    • All three 99% VaR models — Historical, Parametric, and GARCH — pass the Kupiec backtest.<br><br>
    • <b>GARCH responds fastest to volatility clustering</b>, while Historical Simulation VaR naturally reacts more slowly.<br><br>
    • Demonstrates the complete risk-model lifecycle: <b>estimate → forecast → formally backtest</b>.
  </td>
</tr>

<tr>
  <td valign="top">
    <a href="https://github.com/mihah023/Quantitative-Finance-Portfolio/tree/main/02-fomc-event-study"><b>🏛️ Fed Rate-Change Event Study</b></a><br>
    <sub><a href="https://github.com/mihah023/Quantitative-Finance-Portfolio/blob/main/02-fomc-event-study/notebooks/fomc_event_study_clean.ipynb">Notebook ↗</a></sub>
  </td>
  <td valign="top">
    • Python<br>
    • Market Model<br>
    • Event Study<br>
    • Welch's / Wilcoxon Tests<br>
    • Bootstrap Inference
  </td>
  <td valign="top">
    • SPY & AAPL, 2013–2026<br>
    • 31 Fed rate-change events<br>
    • FRED + Yahoo Finance
  </td>
  <td valign="top">
    • The market exhibits a statistically significant response to Fed rate changes (<b>p = 0.034</b>).<br><br>
    • However, AAPL shows <b>no significant stock-specific abnormal return</b> after controlling for market movements across three independent tests.<br><br>
    • Corrected a methodological issue during analysis: an early pooled approach overstated significance (<b>p = 0.0007 → 0.034</b>) because the independence assumption was inappropriate.
  </td>
</tr>

<tr>
  <td valign="top">
    <b>🧠 Dynamic Graph Neural Networks for Portfolio Optimization</b><br>
    <sub>🎓 Undergraduate Thesis</sub>
  </td>
  <td valign="top">
    • Python<br>
    • Graph Neural Networks<br>
    • PPO Reinforcement Learning<br>
    • PyTorch<br>
    • Portfolio Optimization
  </td>
  <td valign="top">
    • US equities, 2016–2026<br>
    • Dynamic correlation graphs<br>
    • 5- & 7-asset universes<br>
    • GNN + PPO framework
  </td>
  <td valign="top">
    • Developed a hybrid <b>GNN-PPO portfolio allocation framework</b> that incorporates dynamic asset correlations into reinforcement learning.<br><br>
    • In the 5-asset experiment, GNN-PPO achieved approximately <b>82.8% return</b> with a <b>1.13 Sharpe ratio</b> and ~22.5% maximum drawdown.<br><br>
    • The GNN component improved cumulative return by approximately <b>16.6 percentage points</b> over PPO without graph information in the main ablation.
  </td>
</tr>
```

  </tbody>
</table>

---

## 💼 Industry Experience

**MB Bank — Corporate Customers Department, Eastern Saigon Branch**
*Banking Intern | Jun 2025 – Aug 2025*

* Supported corporate banking operations and documentation processes, including **L/C issuance workflows**.
* Assisted customers with account opening and digital banking services.
* Coordinated documentation and processes across **Credit, Transaction, and Accounting** teams.
* Gained practical exposure to trade finance instruments including **L/C, T/T, D/P, and D/A**, with reference to **UCP 600**.

---

## 📜 Relevant Certifications & Credentials

| Certification                                           | Issuing Organization |           Status           |
| :------------------------------------------------------ | :------------------- | :------------------------: |
| *DataCamp Certifications*                               | DataCamp             | 🟢 Completed / In Progress |
| *Additional quantitative finance & data certifications* | —                    |         🚧 Updating        |

> This section will be updated as additional certifications are completed.

---

## 🔬 Research Interests

* Quantitative Research
* Systematic Trading
* Financial Econometrics
* Volatility & Risk Modeling
* Portfolio Optimization
* Statistical Arbitrage
* Machine Learning for Finance
* Reinforcement Learning in Financial Markets
* Market Microstructure

---

## 📚 Currently Building

I'm continuing to expand this portfolio toward more rigorous quantitative research projects, with an emphasis on:

**Market Data → Statistical Model → Backtest → Robustness Checks → Interpretation**

The goal is not simply to produce a profitable backtest, but to understand **why a strategy works, when it fails, and whether the result survives reasonable statistical scrutiny.**

---

## 💌 Let's Connect!

* 💼 **LinkedIn:** [linkedin.com/in/nguyentranminhanh](https://www.linkedin.com/in/nguyentranminhanh/)
* 📧 **Email:** [mihah023@gmail.com](mailto:mihah023@gmail.com)
* 🐙 **GitHub:** [mihah023](https://github.com/mihah023)

---

### ⭐ Selected Work

> **"Build the model. Test the assumptions. Trust the evidence."**
