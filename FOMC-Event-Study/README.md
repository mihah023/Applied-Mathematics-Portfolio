# Fed Rate-Change Event Study

*Does the stock market actually react to Fed rate decisions — and if it does, where does that reaction live: the whole market, or individual stocks?*

---

## The question

We often hear that the market reacts to the Fed so I wanted to actually check that with data, and push it one step further: **if the market does react, where does the reaction live?** Is a specific stock doing something of its own, or is it just getting dragged along because the whole market moves?

Three questions, each building on the last:

1. **Does the market as a whole (SPY) get more volatile around FOMC rate-decision dates?**
2. **Do individual stocks (AAPL, XLF, TLT) just move with the market around these events, or is there something extra going on once you strip out normal market co-movement?**
3. *(bonus)* **Does VIX — the market's own "fear gauge" — move around the announcement the way theory says it should?**

---

## Data and event dates

Five series, all daily, 2013–2026, pulled from Yahoo Finance:

- **SPY** — stands in for "the market"
- **AAPL, TLT (long Treasuries), XLF (financials ETF)** — the individual assets
- **VIX** — implied volatility index

The 31 event dates are actual FOMC rate-change announcements, checked against the official Fed history. Each one has a `timing` tag (announced during market hours, or after-hours — only the March 15, 2020 emergency cut falls in the second bucket), which decides which trading day counts as the "reaction day":

```python
def map_to_event_day(ann_date, timing, trading_dates_sorted):
    if timing == "after_hours":
        candidates = [d for d in trading_dates_sorted if d > ann_date]
    else:
        candidates = [d for d in trading_dates_sorted if d >= ann_date]
    return candidates[0] if candidates else None
```

Every event window is checked for overlap with the others (in case two announcements land close together) — none found in this sample.

---

## Q1: Is the market more volatile around FOMC?

The main measure is **|return|**, or the absolute daily return, averaged over the 3-day window `[-1, 0, +1]` around each event. This directly shows how much the market moved.

I compare it with 1,061 normal 3-day windows, leaving a buffer around FOMC events. One limitation is that these normal windows are **not matched by time period**, so some of the difference could come from periods when the market was already more volatile.

**Results (31 events):**

| | Mean \|return\| | Welch p | Mann-Whitney p | Permutation p | Bootstrap 95% CI |
|---|---|---|---|---|---|
| FOMC events | 1.22% | 0.055 | 0.021 | 0.0002 | [0.11%, 1.15%] |
| Normal days | 0.67% | | | | |

Volatility around FOMC is nearly double a normal day's, and 3 of 4 tests clear 5% (Welch is right on the border). A quick sensitivity check — repeatedly resampling the normal-day pool down to 31 windows — gives a similar positive range, so it's not purely a sample-size thing.

Pulling out the 2 emergency COVID cuts (March 2020), leaving 29 events:

| | Mean \|return\| | Welch p | Mann-Whitney p | Permutation p | Bootstrap 95% CI |
|---|---|---|---|---|---|
| FOMC events (COVID removed) | 0.88% | 0.063 | 0.078 | 0.026 | [0.01%, 0.44%] |

The gap shrinks by more than half (+0.55pp → +0.22pp), and Welch/Mann-Whitney both lose significance — only permutation and the bootstrap CI (barely) still hold. So the honest read is: **there's a real signal, but it's weaker and less certain for a typical meeting than the full sample makes it look — a meaningful chunk of the full-sample strength comes from two extreme COVID days.**

**Robustness check — GARCH volatility**

GARCH gives a similar but weaker result. After removing the two COVID events in March 2020, the difference almost disappears (0.98% vs. 0.93%) and is no longer significant.

**Takeaway:** the higher FOMC volatility is mainly driven by the extreme COVID events, not a stable pattern in normal meetings.



---

## Q2a: Do the individual stocks move with the market?

Before looking at abnormal returns, I first checked if these assets usually move in the same direction as SPY around FOMC days.

For each event I take the compounded 3-day return of each asset, check its sign against SPY's, and correlate across all 31 events:

| Asset | % same direction as SPY | Correlation (r) |
|---|---|---|
| AAPL | 74% | 0.83 |
| XLF (financials) | 84% | 0.90 |
| TLT (Treasuries) | 52% | -0.07 |

AAPL and XLF move pretty closely with the market around FOMC days, which makes sense since they are stocks. TLT is more mixed, which also makes sense because Treasuries react more to rate expectations than stock market moves.


---

## Q2b: Is there anything left over after accounting for that?

For each event, I estimate each asset's alpha/beta against SPY using the 120 trading days before it (with a 21-day gap so I'm not accidentally training on pre-event anticipation), use that to get an "expected" return during the event window, and take actual minus expected — the abnormal return. Sum the 3 days and that's the CAR for that event.

| Asset | Mean beta | Mean CAR | t-test p | Wilcoxon p | Bootstrap 95% CI |
|---|---|---|---|---|---|
| AAPL | 1.24 | +0.07% | 0.845 | 0.750 | [-0.65%, +0.77%] |
| TLT | -0.14 | +0.44% | 0.117 | 0.107 | [-0.10%, +0.96%] |
| XLF | 0.98 | -0.25% | 0.307 | 0.189 | [-0.70%, +0.22%] |

Betas line up with what Q2a already showed: AAPL is more sensitive than the market, XLF trades pretty much at market beta, TLT is close to zero.

**None of the three have a significant CAR.** TLT is the closest (p=0.12) but not close enough to call it real with only 31 events.

---

## Making sure the null result actually means something

Checked residuals from each of the 31 regressions individually (not all mashed together, since that would mix calm years with wild ones):

| Asset | % windows failing normality | % windows with ARCH | Mean Durbin-Watson |
|---|---|---|---|
| AAPL | 87% | 10% | 1.84 |
| TLT | 10% | 10% | 2.01 |
| XLF | 52% | 16% | 1.97 |

AAPL returns have some extreme values, which is pretty normal for a tech stock. But actual ARCH effects only appear in about 10–16% of the windows. Wilcoxon, bootstrap, and t-test all give the same result: **no clear ARCH effect**.

**Takeaway:** since different tests all give the same result, I’m more confident that there isn’t a strong ARCH effect here.


---

## Bonus: does VIX move the way theory predicts?

The idea: if FOMC resolves uncertainty, VIX should tick up beforehand and come back down after.

Looking at the VIX change from 3 days before the event to the event day, and from the event day to 3 days after:

VIX goes up a little before FOMC (+1.05), but the change is not significant (p=0.37). After the event, it also goes up slightly (+0.38, p=0.64), but again not significant.

**Takeaway:** I can’t say FOMC clearly affects VIX here. The effect might happen around the 2pm announcement and get missed by daily data.

---

## What I'd do with more time

* Match normal days with FOMC days by time period instead of pooling everything.
* Use intraday data for VIX to better capture the reaction around the 2pm announcement.
* Include all ~104 FOMC meetings instead of only the 31 rate-change events.
* Use Fed Funds futures to measure the actual rate surprise instead of the 2-year yield.
* Check if any events overlap with AAPL earnings or other major news.


---

## Running it

```text
fomc-event-study/
├── data/
│   ├── spy_2013_2026.csv
│   ├── aapl_2013_2026.csv
│   ├── tlt_2013_2026.csv
│   ├── xlf_2013_2026.csv
│   └── vix_2013_2026.csv
├── notebooks/
│   └── fomc_event_study.ipynb
└── README.md
```

Run the notebook top to bottom, sections are numbered to match the questions above.

**Tools:** Python, `pandas`, `scipy`, `statsmodels`, `arch` (for GARCH), `matplotlib`.
