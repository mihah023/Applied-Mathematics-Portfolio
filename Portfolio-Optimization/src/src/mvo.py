"""
mvo.py
------
Mean-Variance (Markowitz) portfolio optimization.

This replaces the Excel Solver step from the original group assignment:
    minimize   w' Sigma w                (portfolio variance)
    subject to w' mu = target_return     (hit a target expected return)
               sum(w) = 1                (fully invested)
               w >= 0                    (no short-selling)

Uses cvxpy (a convex-optimization solver) instead of Excel Solver.
"""

import numpy as np
import pandas as pd
import cvxpy as cp


def min_variance_for_target_return(mu: pd.Series, cov: pd.DataFrame, target_return: float,
                                    allow_short: bool = False) -> pd.Series:
    """Solve for the minimum-variance portfolio that achieves `target_return`."""
    n = len(mu)
    w = cp.Variable(n)

    portfolio_variance = cp.quad_form(w, cov.values)
    constraints = [cp.sum(w) == 1, mu.values @ w == target_return]
    if not allow_short:
        constraints.append(w >= 0)

    problem = cp.Problem(cp.Minimize(portfolio_variance), constraints)
    problem.solve()

    if problem.status not in ("optimal", "optimal_inaccurate"):
        raise RuntimeError(f"Solver failed for target_return={target_return}: {problem.status}")

    return pd.Series(w.value, index=mu.index)


def global_min_variance(mu: pd.Series, cov: pd.DataFrame, allow_short: bool = False) -> pd.Series:
    """Solve for the minimum-variance portfolio with no return target (global min-vol)."""
    n = len(mu)
    w = cp.Variable(n)
    constraints = [cp.sum(w) == 1]
    if not allow_short:
        constraints.append(w >= 0)

    problem = cp.Problem(cp.Minimize(cp.quad_form(w, cov.values)), constraints)
    problem.solve()
    return pd.Series(w.value, index=mu.index)


def max_sharpe_portfolio(mu: pd.Series, cov: pd.DataFrame, risk_free_rate: float = 0.0,
                          allow_short: bool = False) -> pd.Series:
    """
    Solve for the tangency (maximum Sharpe ratio) portfolio.
    Uses the standard trick of converting the fractional Sharpe objective
    into a convex quadratic program (Cornuejols & Tutuncu formulation).
    """
    n = len(mu)
    excess = mu.values - risk_free_rate
    y = cp.Variable(n)
    kappa = cp.Variable()

    constraints = [excess @ y == 1, cp.sum(y) == kappa]
    if not allow_short:
        constraints.append(y >= 0)
    constraints.append(kappa >= 0)

    problem = cp.Problem(cp.Minimize(cp.quad_form(y, cov.values)), constraints)
    problem.solve()

    w = y.value / kappa.value
    return pd.Series(w, index=mu.index)


def efficient_frontier(mu: pd.Series, cov: pd.DataFrame, n_points: int = 25,
                        allow_short: bool = False) -> pd.DataFrame:
    """Trace the efficient frontier across a range of target returns."""
    target_returns = np.linspace(mu.min(), mu.max(), n_points)
    records = []
    for target in target_returns:
        try:
            w = min_variance_for_target_return(mu, cov, target, allow_short=allow_short)
            variance = float(w.values @ cov.values @ w.values)
            records.append({
                "target_return": target,
                "portfolio_variance": variance,
                "portfolio_std": np.sqrt(variance),
            })
        except RuntimeError:
            continue
    return pd.DataFrame(records)


def portfolio_stats(w: pd.Series, mu: pd.Series, cov: pd.DataFrame) -> dict:
    """Expected return, volatility, and Sharpe ratio for a given weight vector."""
    ret = float(w.values @ mu.values)
    vol = float(np.sqrt(w.values @ cov.values @ w.values))
    sharpe = ret / vol if vol > 0 else np.nan
    return {"expected_return": ret, "volatility": vol, "sharpe_ratio": sharpe}


if __name__ == "__main__":
    from data_prep import load_prices, get_stock_prices, compute_daily_returns, \
        compute_expected_returns, compute_covariance_matrix

    raw = load_prices()
    prices = get_stock_prices(raw)
    returns = compute_daily_returns(prices)
    mu = compute_expected_returns(returns)
    cov = compute_covariance_matrix(returns)

    gmv = global_min_variance(mu, cov)
    print("Global Min-Variance portfolio (top 5 weights):")
    print(gmv.sort_values(ascending=False).head())
    print(portfolio_stats(gmv, mu, cov))

    tangency = max_sharpe_portfolio(mu, cov, risk_free_rate=0.03)
    print("\nMax-Sharpe (tangency) portfolio (top 5 weights):")
    print(tangency.sort_values(ascending=False).head())
    print(portfolio_stats(tangency, mu, cov))
