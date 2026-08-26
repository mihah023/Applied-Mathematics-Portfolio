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

<table>
  <tr>
    <th>Project</th>
    <th>Stack</th>
    <th>Scope</th>
    <th>Headline Finding</th>
  </tr>

  <tr>
    <td>
      <a href="https://github.com/mihah023/Quantitative-Finance-Portfolio/tree/main/01-volatility-var-model">
        <b>📉 Volatility Forecasting & VaR/CVaR Model</b>
      </a>
      <br><br>
      <a href="https://github.com/mihah023/Quantitative-Finance-Portfolio/blob/main/01-volatility-var-model/notebooks/var_cvar_analysis.ipynb">
        📓 Notebook ↗
      </a>
    </td>

```
<td>
  Python<br>
  GARCH(1,1)<br>
  VaR / CVaR<br>
  Kupiec Backtest
</td>

<td>
  AAPL daily returns<br>
  3 competing VaR models<br>
  Rolling 250-day windows<br>
  99% confidence level
</td>

<td>
  All three 99% VaR models pass the Kupiec backtest, but
  <b>GARCH reacts fastest to volatility clustering</b>,
  while Historical Simulation VaR lags by design.
  <br><br>
  Demonstrates the full risk-model lifecycle:
  estimate → forecast → <b>formally backtest</b>.
</td>
```

  </tr>

  <tr>
    <td>
      <a href="https://github.com/mihah023/Quantitative-Finance-Portfolio/tree/main/02-fomc-event-study">
        <b>🏛️ Fed Rate-Change Event Study</b>
      </a>
      <br><br>
      <a href="https://github.com/mihah023/Quantitative-Finance-Portfolio/blob/main/02-fomc-event-study/notebooks/fomc_event_study_clean.ipynb">
        📓 Notebook ↗
      </a>
    </td>

```
<td>
  Python<br>
  Market Model<br>
  Welch's / Wilcoxon<br>
  Bootstrap Inference
</td>

<td>
  SPY & AAPL<br>
  31 Fed rate-change events<br>
  2013–2026<br>
  FRED + Yahoo Finance
</td>

<td>
  The market reacts significantly to Fed rate changes
  (<b>p = 0.034</b>), but AAPL shows
  <b>no significant stock-specific abnormal return</b>
  across three independent tests.
  <br><br>
  Corrected a methodology issue that initially overstated significance
  (<b>p = 0.0007 → 0.034</b>).
</td>
```

  </tr>

  <tr>
    <td>
      <b>🧠 Dynamic GNN-PPO Portfolio Optimization</b>
      <br><br>
      🎓 Undergraduate Thesis
    </td>

```
<td>
  Python<br>
  Graph Neural Networks<br>
  PPO<br>
  PyTorch
</td>

<td>
  US equities, 2016–2026<br>
  5 & 7 asset universes<br>
  Dynamic correlation graphs<br>
  Portfolio allocation
</td>

<td>
  Main 5-asset experiment achieved approximately
  <b>82.8% return</b>,
  <b>1.13 Sharpe</b>, and
  <b>~22.5% maximum drawdown</b>.
  <br><br>
  GNN-PPO improved return by approximately
  <b>16.6 percentage points</b> over PPO-only.
</td>
```

  </tr>

  <tr>
    <td>
      <b>🎯 Options Pricing & Greeks</b>
      <br><br>
      🚧 In Progress
    </td>

```
<td>
  Python<br>
  Black-Scholes<br>
  Monte Carlo
</td>

<td>
  European options<br>
  Option pricing<br>
  Greeks<br>
  Sensitivity analysis
</td>

<td>
  <i>Coming soon</i> ⏳
</td>
```

  </tr>

</table>



## 📜 Relevant Certifications & Credentials

| Certification                               | Issuing Organization | Status / Completion |       Link      |
| :------------------------------------------ | :------------------- | :------------------ | :-------------: |
| *DataCamp Certification*                    | *DataCamp*           | 🟢 Completed        |    *Add link*   |
| *Quantitative Finance / Data Certification* | *—*                  | 🟡 In Progress      | *Coming Soon* ⏳ |
| ...                                         | ...                  | ...                 |       ...       |

---

## 💌 Let's Connect!

* 💼 **LinkedIn:** https://www.linkedin.com/in/nguyentranminhanh/
* 📧 **Email:** [mihah023@gmail.com](mailto:mihah023@gmail.com)
* 🐙 **GitHub:** [mihah023](https://github.com/mihah023)
