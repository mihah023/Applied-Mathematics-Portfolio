# Fed Rate-Change Event Study 🏛️
*A mini quant-research project: does the stock market react to Fed interest rate decisions — and does Apple react differently from everyone else?*

---

## The question I wanted to answer

Every few weeks, the Federal Reserve announces whether it's raising, cutting, or holding interest rates. People in finance always say "the market reacts to Fed decisions" — but I wanted to actually check that with data instead of just assuming it's true. And then I wanted to go one step further: **does a specific stock, like AAPL, react in its own special way, or does it just move because the whole market moves?**

So this project has two parts:
1. Does the market as a whole (SPY) move differently around Fed rate-change dates?
2. If it does, does AAPL specifically do anything *beyond* what you'd expect just from it being a stock that tracks the market?

---

## Step 1: Getting the data

Three things needed to be lined up by date:

- **SPY prices** (an ETF that tracks the S&P 500 — basically "the market") — daily, 2013 to 2026, from Yahoo Finance
- **AAPL prices** — same range, also Yahoo Finance
- **The actual Fed interest rate, every day** — from FRED (the Federal Reserve's own economic database), series called `DFEDTARU`

The clever part: instead of manually looking up every Fed meeting date (which takes forever and is easy to get wrong), I just took the rate series and asked pandas "which days did this number actually change?" (`.diff()` — this shows the difference between today's value and yesterday's). That gave me **31 exact dates** where the Fed changed rates between 2013–2026 — 20 times they raised it, 11 times they cut it. Fully automatic, no manual typing, no chance of a typo in a date.

---

## Step 2: Question 1 — does the whole market react?

For each of the 31 dates, I looked at a 3-day window: the day before, the day of, and the day after. Then I compared: **are these 93 days, on average, more volatile than a normal day?**

First attempt: I just averaged all 93 days together and compared them to normal days. Result: **p = 0.0007** — a really strong result, volatility was clearly higher around Fed dates.

---

## Step 3: I caught a mistake in my own analysis

Here's the thing — those 93 days aren't really 93 independent data points. They come in **groups of 3** (day before / day of / day after), and days next to each other tend to move together. Treating them as 93 separate, unrelated observations is basically cheating — it makes the result look more certain than it actually is.

So I redid it properly: for each of the 31 events, I averaged its own 3-day window down to **one number per event**, giving me 31 real, independent data points instead of 93 fake-independent ones. Result: **p = 0.0341**.

Still significant — the market really is more volatile around Fed dates — but the p-value jumped from 0.0007 to 0.034 just from fixing that one mistake. That's a big lesson: **the way you count your data points can make a result look way more confident than it should.**

(Average |return| in the event window: 1.28%, vs. 0.68% on a normal day — direction of the *return* itself wasn't significant though, p=0.21, so it's volatility that jumps, not a predictable up-or-down move.)

---

## Step 4: Question 2 — does AAPL do anything extra?

Knowing the market moves doesn't tell you anything about AAPL specifically, because AAPL obviously moves *with* the market most of the time anyway (that's what "beta" means). So the real question is: **does AAPL move more, or differently, than what its normal relationship with the market would predict?**

To check this, for each of the 31 events I did the following:
1. Looked at the ~120 trading days *before* the event (skipping the 21 days right before it, just to be safe) and ran a simple regression: `AAPL return = alpha + beta × market return`. This tells me how AAPL normally behaves relative to the market.
2. Used that alpha/beta to predict what AAPL *should* have done during the 3-day event window.
3. Subtracted: `actual AAPL return − predicted AAPL return` = the "abnormal" part, the bit the market alone doesn't explain.
4. Added those 3 days together per event → one **Cumulative Abnormal Return (CAR)** per event, 31 numbers total.

**Result: mean CAR = +0.22%, but p = 0.599 — not significant.** AAPL doesn't seem to do anything special around Fed dates beyond what its normal market-beta relationship already predicts.

---

## Step 5: making sure that "not significant" result is trustworthy

A regular t-test assumes the data is roughly bell-curve shaped. I checked, and mine wasn't — it has "fat tails" (a few really extreme days pulling things around), which is honestly pretty normal for stock returns. So instead of trusting just the t-test, I also ran:

- **Wilcoxon signed-rank test** — doesn't assume a bell curve at all → p = 0.433
- **Bootstrap 95% confidence interval** — resample the 31 events 10,000 times and see where the average usually lands → **[-0.61%, +1.01%]**, which includes 0

All three methods agree: no significant AAPL-specific effect. That agreement across 3 different approaches is what actually makes me trust the "nothing here" result — one test alone saying "not significant" isn't as convincing.

---

## Step 6: one more thing I noticed — hikes vs. cuts

Out of curiosity, I split the 31 events into the 20 times the Fed *raised* rates and the 11 times it *cut* them, since lumping "good news" and "bad news" together could hide something:

| | n | Mean CAR | t-test p | Wilcoxon p |
|---|---|---|---|---|
| Hikes | 20 | -0.23% | 0.68 | 0.90 |
| Cuts | 11 | **+1.05%** | 0.086 | 0.10 |

Cuts lean positive, hikes lean flat — which makes economic sense (lower rates → future cash flows worth more today, especially for a growth stock like AAPL). But with only 11 cut events, neither test actually clears the usual 5% bar, so I'm calling this "worth watching," not "proven." I only checked this *because* the combined result came back null, which is exactly the kind of after-the-fact digging that can accidentally manufacture a fake pattern — so I'm not overselling it.

---

## What I'd do differently with more time

- Control for other news that might land on the same day (AAPL earnings, market-wide shocks) — right now those could be quietly mixed into some of the 31 events.
- Use more robust standard errors (Newey-West) in the regression step, since I confirmed the residuals aren't well-behaved (ARCH-LM test, p<0.0001).
- Wait for more rate-cut events to accumulate (the 2024–25 cutting cycle is still ongoing) before treating the hikes-vs-cuts split as anything more than a hint.
- Instead of just hike/cut, classify events by whether they were a *surprise* to the market or fully expected — the research literature suggests surprises move prices more than scheduled, expected decisions.

---

## How to run this

```text
02-fomc-event-study/
├── data/
│   ├── spy_2013_2026.csv       # SPY daily prices
│   ├── aapl_2013_2026.csv      # AAPL daily prices
│   └── DFEDTARU.csv            # Fed Funds Target Rate, daily (FRED)
├── notebooks/
│   └── fomc_event_study_clean.ipynb   # everything above, runnable top to bottom
└── outputs/
    ├── part_a_market_reaction.png
    └── part_b_car_by_event.png
```

Open the notebook and run all cells in order — each section is labeled to match the steps above (Part A = Steps 2–3, Part B = Steps 4–6).

**Tools used:** Python, `pandas`, `scipy` (t-tests, Wilcoxon), `statsmodels` (regression + diagnostics), `matplotlib`.
