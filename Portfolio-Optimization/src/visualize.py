"""
visualize.py
------------
Generates the two key charts for the project:
  1. Efficient frontier (target return vs. portfolio std. dev.)
  2. Cumulative growth of $1 for each backtested strategy
"""

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd

from data_prep import load_prices, get_stock_prices, compute_daily_returns, \
    compute_expected_returns, compute_covariance_matrix
from mvo import efficient_frontier, max_sharpe_portfolio, global_min_variance, portfolio_stats
from backtest import run_backtest

OUT = "../outputs"


def plot_efficient_frontier():
    raw = load_prices()
    prices = get_stock_prices(raw)
    returns = compute_daily_returns(prices)
    mu = compute_expected_returns(returns)
    cov = compute_covariance_matrix(returns)

    frontier = efficient_frontier(mu, cov, n_points=30)

    gmv = global_min_variance(mu, cov)
    gmv_stats = portfolio_stats(gmv, mu, cov)
    tangency = max_sharpe_portfolio(mu, cov, risk_free_rate=0.03)
    tangency_stats = portfolio_stats(tangency, mu, cov)

    fig, ax = plt.subplots(figsize=(8, 6))
    ax.plot(frontier["portfolio_std"], frontier["target_return"],
            color="#17324D", linewidth=2, label="Efficient Frontier")
    ax.scatter([gmv_stats["volatility"]], [gmv_stats["expected_return"]],
               color="#0E7770", s=80, zorder=5, label="Global Min-Variance")
    ax.scatter([tangency_stats["volatility"]], [tangency_stats["expected_return"]],
               color="#C0392B", s=80, zorder=5, label="Max Sharpe (Tangency)")

    ax.set_xlabel("Portfolio Std. Dev. (annualized)")
    ax.set_ylabel("Target Return (annualized)")
    ax.set_title("Efficient Frontier -- 40 VN Stocks (Long-Only)")
    ax.legend()
    ax.grid(alpha=0.3)
    fig.tight_layout()
    fig.savefig(f"{OUT}/efficient_frontier.png", dpi=150)
    plt.close(fig)
    print("Saved outputs/efficient_frontier.png")


def plot_backtest_growth():
    raw = load_prices()
    prices = get_stock_prices(raw)
    returns = compute_daily_returns(prices)

    daily = run_backtest(returns, lookback_days=126)
    growth = (1 + daily).cumprod()

    fig, ax = plt.subplots(figsize=(10, 6))
    colors = {"Max Sharpe": "#C0392B", "Min Variance": "#0E7770",
              "Risk Parity": "#8E44AD", "Equal Weight": "#7F8C8D"}
    for col in growth.columns:
        ax.plot(growth.index, growth[col], label=col, color=colors.get(col), linewidth=1.8)

    ax.set_xlabel("Date")
    ax.set_ylabel("Growth of $1")
    ax.set_title("Backtest: Monthly-Rebalanced Strategies (6-month lookback)")
    ax.legend()
    ax.grid(alpha=0.3)
    fig.tight_layout()
    fig.savefig(f"{OUT}/backtest_growth.png", dpi=150)
    plt.close(fig)
    print("Saved outputs/backtest_growth.png")


if __name__ == "__main__":
    plot_efficient_frontier()
    plot_backtest_growth()
