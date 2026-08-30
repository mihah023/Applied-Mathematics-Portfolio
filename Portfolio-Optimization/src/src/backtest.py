"""
backtest.py
-----------
Walk-forward backtest comparing three strategies with monthly rebalancing:
  1. Max-Sharpe (tangency) portfolio        -- mvo.py
  2. Global Minimum-Variance portfolio       -- mvo.py
  3. Risk Parity (equal risk contribution)   -- risk_parity.py
  4. Equal-weight (1/N) benchmark

At each month-end, weights are re-estimated using only data available up
to that point (a trailing lookback window) -- no look-ahead bias -- then
held for the following month.
"""

import numpy as np
import pandas as pd

from data_prep import load_prices, get_stock_prices, compute_daily_returns, \
    compute_expected_returns, compute_covariance_matrix
from mvo import max_sharpe_portfolio, global_min_variance
from risk_parity import risk_parity_portfolio

TRADING_DAYS_PER_YEAR = 252
RISK_FREE_RATE = 0.03  # annualized, approx VN government bond yield assumption


def get_month_end_dates(index: pd.DatetimeIndex) -> pd.DatetimeIndex:
    """Trading dates that are the last available date in their calendar month."""
    df = pd.Series(index, index=index)
    month_ends = df.groupby([index.year, index.month]).max()
    return pd.DatetimeIndex(sorted(month_ends.values))


def run_backtest(returns: pd.DataFrame, lookback_days: int = 126,
                  risk_free_rate: float = RISK_FREE_RATE) -> pd.DataFrame:
    """
    lookback_days=126 (~6 months of trading days) is used to estimate mu/cov
    at each rebalance date. Returns a DataFrame of daily portfolio returns
    for each strategy.
    """
    month_ends = get_month_end_dates(returns.index)
    strategies = ["Max Sharpe", "Min Variance", "Risk Parity", "Equal Weight"]
    daily_returns = {s: [] for s in strategies}
    dates_out = []

    for i in range(len(month_ends) - 1):
        rebalance_date = month_ends[i]
        next_rebalance_date = month_ends[i + 1]

        window = returns.loc[:rebalance_date].tail(lookback_days)
        if len(window) < lookback_days:
            continue  # not enough history yet

        mu = compute_expected_returns(window)
        cov = compute_covariance_matrix(window)

        try:
            w_sharpe = max_sharpe_portfolio(mu, cov, risk_free_rate=risk_free_rate)
            w_minvar = global_min_variance(mu, cov)
            w_rp = risk_parity_portfolio(cov)
        except Exception:
            continue  # skip months where the solver fails (e.g. degenerate covariance)

        n = len(mu)
        w_eq = pd.Series(np.repeat(1 / n, n), index=mu.index)

        # Hold each weight vector over the following month's actual realized returns
        period_returns = returns.loc[
            (returns.index > rebalance_date) & (returns.index <= next_rebalance_date)
        ]

        for date, day_ret in period_returns.iterrows():
            daily_returns["Max Sharpe"].append(float(day_ret.values @ w_sharpe.values))
            daily_returns["Min Variance"].append(float(day_ret.values @ w_minvar.values))
            daily_returns["Risk Parity"].append(float(day_ret.values @ w_rp.values))
            daily_returns["Equal Weight"].append(float(day_ret.values @ w_eq.values))
            dates_out.append(date)

    result = pd.DataFrame(daily_returns, index=pd.DatetimeIndex(dates_out))
    result = result[~result.index.duplicated(keep="first")]
    return result.sort_index()


def performance_summary(daily_returns: pd.DataFrame, risk_free_rate: float = RISK_FREE_RATE) -> pd.DataFrame:
    """Annualized return, volatility, Sharpe ratio, and max drawdown per strategy."""
    summary = {}
    for col in daily_returns.columns:
        r = daily_returns[col].dropna()
        cumulative = (1 + r).cumprod()
        ann_return = cumulative.iloc[-1] ** (TRADING_DAYS_PER_YEAR / len(r)) - 1
        ann_vol = r.std() * np.sqrt(TRADING_DAYS_PER_YEAR)
        sharpe = (ann_return - risk_free_rate) / ann_vol if ann_vol > 0 else np.nan
        running_max = cumulative.cummax()
        drawdown = (cumulative - running_max) / running_max
        max_dd = drawdown.min()

        summary[col] = {
            "Annualized Return": ann_return,
            "Annualized Volatility": ann_vol,
            "Sharpe Ratio": sharpe,
            "Max Drawdown": max_dd,
        }
    return pd.DataFrame(summary).T


if __name__ == "__main__":
    raw = load_prices()
    prices = get_stock_prices(raw)
    returns = compute_daily_returns(prices)

    print("Running walk-forward backtest with monthly rebalancing "
          "(6-month lookback window)...")
    daily = run_backtest(returns, lookback_days=126)
    daily.to_csv("../outputs/backtest_daily_returns.csv")

    print(f"\nBacktest covers {daily.index.min().date()} -> {daily.index.max().date()} "
          f"({len(daily)} trading days)")

    summary = performance_summary(daily)
    print("\nPerformance summary:")
    print(summary.round(4))
    summary.to_csv("../outputs/performance_summary.csv")
