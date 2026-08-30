"""
data_prep.py
------------
Load raw VN stock price data and compute daily returns, expected returns,
and the annualized covariance matrix. Mirrors the "Stock prices" -> "Return"
-> "Covariance matrix" pipeline from the original group Excel workbook,
but done with pandas instead of manual Excel formulas.
"""

import pandas as pd
import numpy as np
from pathlib import Path

DATA_DIR = Path(__file__).resolve().parent.parent / "data"

TRADING_DAYS_PER_YEAR = 252


def load_prices(csv_path: Path = DATA_DIR / "vn_stock_prices_raw.csv") -> pd.DataFrame:
    """Load raw price data, sort chronologically, and index by date."""
    df = pd.read_csv(csv_path, parse_dates=["Date"])
    df = df.sort_values("Date").reset_index(drop=True)
    df = df.set_index("Date")
    return df


def get_stock_prices(df: pd.DataFrame) -> pd.DataFrame:
    """Drop the VNINDEX benchmark column, keep only individual stocks."""
    return df.drop(columns=["VNINDEX"])


def compute_daily_returns(prices: pd.DataFrame) -> pd.DataFrame:
    """Simple daily percentage returns."""
    return prices.pct_change().dropna(how="all")


def compute_expected_returns(returns: pd.DataFrame, annualize: bool = True) -> pd.Series:
    """Mean daily return per stock, optionally annualized."""
    mu = returns.mean()
    if annualize:
        mu = mu * TRADING_DAYS_PER_YEAR
    return mu


def compute_covariance_matrix(returns: pd.DataFrame, annualize: bool = True) -> pd.DataFrame:
    """Sample covariance matrix of daily returns, optionally annualized."""
    cov = returns.cov()
    if annualize:
        cov = cov * TRADING_DAYS_PER_YEAR
    return cov


if __name__ == "__main__":
    raw = load_prices()
    prices = get_stock_prices(raw)
    returns = compute_daily_returns(prices)
    mu = compute_expected_returns(returns)
    cov = compute_covariance_matrix(returns)

    print(f"Loaded {prices.shape[0]} trading days, {prices.shape[1]} stocks")
    print(f"Date range: {prices.index.min().date()} -> {prices.index.max().date()}")
    print("\nAnnualized expected return (top 5):")
    print(mu.sort_values(ascending=False).head())
    print(f"\nCovariance matrix shape: {cov.shape}")
