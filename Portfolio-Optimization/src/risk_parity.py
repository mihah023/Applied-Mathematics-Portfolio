"""
risk_parity.py
--------------
Equal Risk Contribution (Risk Parity) portfolio.

Instead of maximizing return per unit of risk (Markowitz), Risk Parity
allocates weights so that every asset contributes the SAME share of total
portfolio risk. This tends to produce more diversified, less concentrated
portfolios than mean-variance optimization -- useful as a comparison
baseline against the MVO / tangency portfolios.

Solved with scipy.optimize (not a convex problem in the standard cvxpy
sense, so we use SLSQP instead).
"""

import numpy as np
import pandas as pd
from scipy.optimize import minimize


def _risk_contributions(w: np.ndarray, cov: np.ndarray) -> np.ndarray:
    """Each asset's contribution to total portfolio variance."""
    portfolio_vol = np.sqrt(w @ cov @ w)
    marginal_contrib = cov @ w
    return w * marginal_contrib / portfolio_vol


def _risk_parity_objective(w: np.ndarray, cov: np.ndarray) -> float:
    """Sum of squared deviations between each asset's risk share and the 1/n target."""
    n = len(w)
    contribs = _risk_contributions(w, cov)
    target = contribs.sum() / n
    return float(np.sum((contribs - target) ** 2))


def risk_parity_portfolio(cov: pd.DataFrame) -> pd.Series:
    """Solve for the equal-risk-contribution portfolio (long-only, fully invested)."""
    n = cov.shape[0]
    cov_np = cov.values

    w0 = np.repeat(1 / n, n)
    bounds = [(0.0, 1.0)] * n
    constraints = [{"type": "eq", "fun": lambda w: np.sum(w) - 1.0}]

    result = minimize(
        _risk_parity_objective, w0, args=(cov_np,),
        method="SLSQP", bounds=bounds, constraints=constraints,
        options={"maxiter": 1000, "ftol": 1e-12},
    )
    if not result.success:
        raise RuntimeError(f"Risk parity solver failed: {result.message}")

    return pd.Series(result.x, index=cov.columns)


if __name__ == "__main__":
    from data_prep import load_prices, get_stock_prices, compute_daily_returns, \
        compute_covariance_matrix

    raw = load_prices()
    prices = get_stock_prices(raw)
    returns = compute_daily_returns(prices)
    cov = compute_covariance_matrix(returns)

    rp = risk_parity_portfolio(cov)
    print("Risk Parity portfolio (top 5 weights):")
    print(rp.sort_values(ascending=False).head())

    contribs = _risk_contributions(rp.values, cov.values)
    print("\nRisk contribution spread (should be near-equal across assets):")
    print(f"min={contribs.min():.6f}  max={contribs.max():.6f}  mean={contribs.mean():.6f}")
