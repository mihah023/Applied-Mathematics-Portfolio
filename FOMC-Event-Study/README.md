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

The main measure here is just **|return|** — the absolute daily return, averaged over the 3-day window `[-1, 0, +1]` around each event. It's the most direct way to answer "did the market swing harder," since it looks straight at what actually happened rather than through a model. I compare it against 1,061 ordinary 3-day windows elsewhere in the sample (excluding a buffer around every event so nothing leaks in). One thing worth flagging up front: these "normal" windows aren't matched to events by time period, so if events happen to cluster in a high-vol stretch, part of the difference below could just be that stretch, not FOMC itself.

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

**Robustness check — does this hold up with a model-based volatility measure instead?** I reran the same comparison using walk-forward GARCH(1,1) conditional volatility (refit periodically using only past data, so it never "cheats" with future information — 30 of the 31 events have enough history for this). It agrees directionally but is noticeably weaker: full sample gives 1.22% vs. 0.93% (only the permutation test is significant, p=0.009; Welch and Mann-Whitney aren't), and after removing the 2 COVID events the gap nearly vanishes (0.98% vs. 0.93%) with **nothing significant at all**. So both measures agree on the main story — most of the apparent "FOMC raises volatility" effect in the full sample comes from two extreme days in March 2020, not a stable pattern at ordinary meetings — but the model-based measure shows that story even more starkly than the raw-return version does.

Direction-wise, mean return isn't different between event days and normal days (p's all well above 0.05) — the Fed doesn't seem to push prices one way or the other, at least not in a way this sample can detect. It just seems to be about how much things swing.

---

## Q2a: Do the individual stocks move with the market?

Before calling anything "abnormal," I wanted a baseline — do these assets even move in the same direction as SPY around FOMC?

For each event I take the compounded 3-day return of each asset, check its sign against SPY's, and correlate across all 31 events:

| Asset | % same direction as SPY | Correlation (r) |
|---|---|---|
| AAPL | 74% | 0.83 |
| XLF (financials) | 84% | 0.90 |
| TLT (Treasuries) | 52% | -0.07 |

AAPL and XLF pretty clearly move with the market around these events — makes sense, they're stocks. TLT is basically a coin flip, which also makes sense: Treasuries care about rate expectations, not equity sentiment.

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

AAPL residuals are pretty fat-tailed (not surprising for a tech stock), but actual ARCH effects only show up in 10-16% of windows — much lower than you'd guess if you pooled everything into one big test. Wilcoxon and bootstrap (neither assumes normality) agree with the t-test everywhere, which is what makes me trust the null result — three different methods landing on "nothing here" is more convincing than any one of them alone.

---

## Bonus: does VIX move the way theory predicts?

The idea: if FOMC resolves uncertainty, VIX should tick up beforehand and come back down after.

Looking at the VIX change from 3 days before the event to the event day, and from the event day to 3 days after:

VIX ticks up a bit heading into the event (+1.05 points) but not significantly (p=0.37). It also ticks up slightly afterward instead of falling (+0.38, p=0.64) — also not significant. So I can't really say this pattern shows up here. It's possible the real effect happens in a tight window right around the 2pm announcement and just gets averaged out over the full trading day — daily data might be too blunt an instrument for this one.

---

## What I'd do with more time

- Match the "normal" comparison windows to events by time period, not just pool everything — this is probably the biggest thing missing from Q1 right now.
- Use intraday data for the VIX question — that's where the real action probably is.
- Run this on all ~104 FOMC meetings instead of just the 31 rate-change ones — more data might sharpen Q1.
- Use an actual "surprise" measure (Fed Funds futures) instead of just hike/cut — I tried a 2-year yield proxy and it went the wrong direction, probably too noisy/confounded with macro stuff.
- Check whether any of the 31 events overlap with AAPL earnings or other big market news.

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
