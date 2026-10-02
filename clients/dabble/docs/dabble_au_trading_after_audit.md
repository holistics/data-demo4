# Audit — `dabble_au_trading_after.page.aml`

**Subject:** Dabble AU Trading Performance Command Center ("after" concept)
**Files under review:** `clients/dabble/dashboards/dabble_au_trading_after.page.aml`
**Baseline for comparison:** `clients/dabble/dashboards/dabble_au_trading.page.aml` ("before")
**Supporting layer:** `clients/dabble/datasets/dabble_trading.dataset.aml`, `clients/dabble/models/*`
**Prospect:** Dabble — Australian social betting operator
**Audience for the dashboard:** Dabble trading leadership / executives
**Date:** 2026-07-30

> All figures in §1 were obtained by querying the live `dabble_trading` dataset via
> `holistics mcp execute_aql`, not estimated from screenshots.

---

## Verdict

The information architecture is a genuine improvement. You've gone from two dump-everything tabs to a staged narrative, and the KPI row, metric sheet, and combination chart show off real Holistics capability.

Three things will cost you the room:

1. **The synthetic numbers aren't plausible** to a wagering trading exec.
2. **The "after" is bigger than the "before" rather than sharper** — 32 viz blocks vs 23, and 13 of the 32 are still tables.
3. **Several visuals expose the seams** — a donut legend reading `true`/`false`, a risk axis in the wrong order, and the largest risk bucket literally labelled "Unclassified".

---

## 1. The thing that will actually lose the room

You're presenting to people who price books for a living. They will do this arithmetic in their heads within thirty seconds of the KPI row appearing.

| Metric | Demo value | AU market reality (approx.) | Read |
|---|---|---|---|
| Gross Win % (blended) | **25.0%** | ~11–15% blended (racing ~13–16%, sport ~8–11%) | ~2× too high |
| Avg Bet Size | **$104.31** | ~$25–40 industry; Dabble is social/micro-stakes → lower | 3–4× too high |
| Combined Stake, 2.5 yrs | **$9.39M** (~$3.7M/yr) | Dabble operates orders of magnitude above this | Reads as a toy dataset |
| Rocket Boost | **$30,054** = 0.32% of stake | Rocket is their flagship social/copy product | Implies the feature barely exists |
| Actives / Bets | **exactly 3,000 / exactly 90,000** | — | Exactly 30.00 bets per active |
| Bets per risk bracket | **exactly 7,500 × 12 brackets** | Heavily skewed in reality | Uniform = obviously generated |

> Treat the benchmark column as directional — verify against whatever Dabble has published before quoting it in the meeting. The *shape* of the problem holds regardless of the exact figure.

### 1.1 `Other / Unclassified` is the largest and most profitable risk bucket

$1,005,677 stake (10.7% of turnover) at 45.7% gross win — the biggest bar on "Stake by Risk Factor Bracket".

The cause is real, not cosmetic. The case statement in `clients/dabble/models/dabble_fact_bet.model.aml:70-87` has two uncovered gaps:

- `0.31 – 0.49` — no branch
- `1.12 – 4.99` — no branch

Everything falling in those ranges lands in the `else`.

### 1.2 Risk bracket margin is random

Actual gross win % by bracket, as returned by the dataset:

```
-1            24.2%
0.01 - 0.30   -1.3%
0.50 - 0.80   31.5%
0.90          24.5%
0.91 - 0.99    7.2%
1.00          27.5%
1.01 - 1.05   23.9%
1.06 - 1.10   27.4%
1.11         -10.8%
5.00 - 9.99   37.8%
10.00+        33.3%
Other         45.7%
```

Risk factor is supposed to be *the* lever that protects margin. This chart tells a trading exec their risk framework does nothing — the exact opposite of the intended message.

### 1.3 Two sports run at −75% margin

`Boxing` at **−74.6%** and `Ice Hockey` at **−74.8%** gross win. No book runs a whole sport at −75% for two and a half years. These two points are also what wrecks the scatter's y-axis (§3).

### 1.4 Recommendation

This is the highest-leverage fix on the list, and it lives in the seed generator (`clients/dabble/database/seed.sql`), not the dashboard.

> **Tracked separately:** [`issue-01-seed-data-plausibility.md`](./issue-01-seed-data-plausibility.md) — full root-cause analysis traced to specific `seed.sql` lines, the architectural fix, constraints that must survive regeneration, open questions for the user, and a verification procedure. Written to be actioned in a fresh session without this document.

Summary of what needs to change:

- Plausible margin distribution — racing ~14%, sport ~9%, novelty markets wider
- Non-uniform risk-factor skew (most volume at 1.00, thin tails)
- Bet sizes skewed and centred near ~$20 rather than uniform $1–91
- Turnover scaled up via volume, not stake size
- No whole-sport negative margins at −75%
- Risk factor must actually influence margin — it currently influences nothing

Everything else in this document is polish by comparison.

---

## 2. Weekly Stake and Margin Pulse

### 2.1 How common is this visual?

**Extremely — it is the single most standard chart in wagering trading.** Turnover as columns plus margin % as a line on a dual axis is how Tabcorp, Entain, and Flutter/Sportsbet present segment performance, and how trading floors run their weekly reviews.

**Keep the concept.** It is your most instantly recognisable visual to this audience.

What is *not* common is 134 weekly periods with a period-over-period overlay on an executive landing view. Trading teams do look weekly — at **13–26 weeks** — and usually plot margin against *theoretical* margin rather than against last year.

### 2.2 Why it is crowded, precisely

| Cause | Detail |
|---|---|
| 134 columns | `reporting_date_filter` defaults to `'last 2 years to today'` (`:13-16`), resolving to Jan 1 2024 → Jul 30 2026. Data confirms min `Jan 01 2024`, max `Jul 26 2026` = 134 ISO weeks. |
| × 2 series | PoP adds "Previous 1 year", plus 268 line points ≈ **536 marks in an 820px block** (`:1373-1375`) — about 1.5px per column. |
| ~78% dead ink | Bars must start at zero, but data lives in 60,000–78,000, so all variation happens in the top fifth of the plot. |
| Margin line reads as noise | `axis_min: 0` on the right axis (`:710`) with data at 22–28% compresses the entire signal into the top ~15% of its range. |
| Prior-year overlay is empty for ~52 weeks | No data exists before Jan 1 2024. The left third shows a comparison that doesn't exist — which is why the pale series only becomes dense from 2025. |
| Axis format | Renders `80,000.00` — two decimals, no currency symbol, not compact. `pattern: 'inherited'` isn't resolving to the dataset's `$#,##0`. |
| Title breaks on interaction | `date_drill` is wired to this block (`:1659-1667`), so drilling to month leaves the chart still titled "Weekly". |

### 2.3 Fixes, in order of impact

1. **Default `reporting_date_filter` to `last 13 weeks`** (or `last 12 months`). This alone takes you from 134 columns to 13. The 2.5-year default is a poor exec default in its own right.
2. **Rename the block `'Stake & Margin Trend'`** and let the existing `date_drill` own granularity.
3. **Drop the PoP overlay from this chart.** PoP reads beautifully as a delta chip on the KPI tiles; as a duplicated column series it is only noise. If comparison must stay, make it a single dashed prior-year *margin* line.
4. **Right axis: `axis_min: 0.15`, `axis_max: 0.35`.** Rates on a line do not need a zero baseline.
5. **Add `analytic: ReferenceLine { type: 'avg' }` on the margin series.** "Are we above or below our own average margin" is the actual executive question and is currently unanswerable.
6. **Explicit compact pattern on stake**, e.g. `'[$$]#,###0.00,"K"'` — already used elsewhere in this project.

---

## 3. Sport Profitability Map

The chart isn't wrong; it is defeated by its own scale. Live numbers across all 24 sports:

| Issue | Detail |
|---|---|
| x-axis spans 14× | Football $126,648 → Greyhound Racing $1,840,029. Three racing codes (Greyhound 1.84M, Harness 1.70M, Thoroughbred 1.58M) sit 5–14× above every other sport, so **21 of 24 sports jam into the leftmost ~16%** of the axis. |
| y-axis wasted | Boxing −74.6% and Ice Hockey −74.8% force the range to −100%…+100%, so the band where **22 of 24 sports actually live (8.1%–50.2%)** gets about a quarter of the plot height. |
| 24 anonymous dots | `label_col` (`:801-807`) gives hover text only. The chart's entire promise — "which sports make money" — cannot be read without mousing over 24 points. In a live demo that is death. |
| Bubble area unused | It is a `ScatterChart`, so stake is burned on a linear axis and no channel is left for bet volume or actives. |
| No quadrant lines | "Good" and "bad" have no visual boundary. |
| `row_limit: 25` | Against 24 sports (`:809`) — silently truncates the day a 26th sport appears. |

### 3.1 Fixes

1. **Switch to `BubbleChart`** — confirmed available in this AML version (`x_col` / `y_col` / `z_col` / `group_col`). Put `combined_stake` on `z_col` (bubble *area*) instead of the x-axis: area compresses the 14× range naturally and the outlier problem dissolves.
   Suggested encoding: x = `avg_bet_size` or `bets`, y = `gross_win_pct`, z = `combined_stake`, `group_col` = racing/sport.
2. **Add `ReferenceLine { type: 'avg' }` on both axes.** This converts a dot cloud into a decision — four labelled quadrants:
   - high stake / high margin → **protect**
   - high stake / low margin → **price review**
   - low stake / high margin → **grow**
   - low stake / low margin → **deprioritise**
3. **Separate racing from sport**, or filter to one. Racing ($5.39M, 57.5% of turnover) and sport are genuinely different scales and shouldn't share an axis.
4. **Raise `row_limit`**, and fix the −75% sports upstream (§1.3).

> **Safer alternative:** a horizontal bar of Gross Win % sorted by turnover contribution, with an average reference line. Less impressive, impossible to misread. Recommendation is to lead with the bubble-quadrant and keep this as the fallback.

---

## 4. Do the visuals make sense? Is it clear what to analyse?

### 4.1 The narrative is sound but mis-ordered

The dashboard description promises four stages — "KPI pulse, performance drivers, customer risk, and audit-grade detail" — yet the landing tab is **Executive Metrics Sheet** (`:1313-1334`), a 30-row × 12-month sheet 1,100px tall. An exec opens the dashboard and lands on the densest object in it.

**Swap to:** Pulse → Metrics Sheet → Drivers → Customer/Risk.

### 4.2 Copy that leaks internal framing — fix before sending

| Location | Problem |
|---|---|
| `:105-107` | Callout literally reads **"After concept"**. Exposes your before/after sales framing to the client. |
| `:2-3` | Title/description say "Alternative executive-to-operator dashboard design for the… prototype." Internal language. |
| `:736` | Block labelled **"Reusable YoY Scorecard"** — "reusable" is Holistics-internal vocabulary. Rename "Stake & Net Revenue vs Last Year". |
| `:108-118` | `drivers_intro` / `risk_intro` / `audit_intro` are *instructions for using the dashboard* ("move from sport mix to competition, fixture…"). Executives read that as "this dashboard needs a manual." Replace with a one-line **finding**, or delete. |

### 4.3 Redundancy

The "after" is **39% bigger** than the "before" — 32 viz blocks vs 23 — and 13 of 32 are tables. A strong before/after halves the surface area.

- `competition_leaderboard` (`:908-934`) and `audit_competition_overview` (`:1219-1239`) have **identical field lists**. Same for `fixture_leaderboard` (`:935-962`) vs `audit_fixture_overview` (`:1240-1261`). The audit versions add nothing but an unsorted 5,000-row dump.
- The Pulse tab has **five blocks answering "which sports matter"**: the scatter, `top_sports_stake`, `top_sports_margin`, `category_summary`, plus the metric sheet's mix section.
- **Drill-through is already wired** on `sport_filter` / `competition_filter` / `fixture_filter` with `AutoDrillthroughSource`. That is Holistics' answer to this, and it is your differentiator. **Delete the audit tab and demo the drill live** — right-clicking a leaderboard row into detail is a far stronger sales moment than showing a 5,000-row table.

### 4.4 Pairs that should be single combination charts

You already prove you can do this in `weekly_trading_pulse`.

| Current | Should be |
|---|---|
| `risk_stake` + `risk_margin` (`:963-992`) | One combo. The point is the *relationship*; two charts force the exec to eyeball across. |
| `top_sports_stake` + `top_sports_margin` (`:813-858`) | One combo sorted by stake. They are currently **independently sorted**, so bar #1 on the left is a different sport than bar #1 on the right — a classic misreading trap. |
| `rocket_category_performance` + `rocket_boost_by_category` | The bar chart is one column of the table. |

### 4.5 Concrete defects

| # | Finding |
|---|---|
| a | **Donut legend will read `true` / `false`.** `channel_mix_donut` (`:757-760`) uses `dabble_dim_sport.is_racing`, a `truefalse` dimension — query confirms values render as `'true'`/`'false'` under the label "Racing Flag". Add `dimension sport_category { case when is_racing then 'Racing' else 'Sport' end }` to `dabble_dim_sport.model.aml` and use it everywhere. Two lines, disproportionate polish gain. |
| b | **Risk bracket x-axis is in the wrong order.** `risk_factor_bracket` is a text dimension with no `sort` on either chart, so bars order lexically — `10.00+` lands between `1.11` and `5.00 - 9.99`. Confirmed in the query result ordering. Zero-pad the labels (`'05.00 - 09.99'`) or add a numeric sort dimension. |
| c | **"Customer Profitability Map" plots an arbitrary sample.** `row_limit: 100` with **no sort** (`:1108-1110`) against 3,000 customers. It is not the top 100 — it is 100 whichever ones come back. Add `sorts` on `combined_stake desc` and relabel "Top 100 Customers by Turnover". |
| d | **Two conflicting comparison mechanisms side by side.** `period_comparison` (PopBlock) drives the 6 KPIs and the weekly chart, but `yoy_scorecard` uses hardcoded `relative_period(-1 year)` metrics and is **absent from the PopInteraction list** (`:1668-1684`). Set Compare to "previous quarter" and the KPIs go QoQ while the table beside them still says "Prior Year". Live-demo landmine — either add it to the interaction or relabel it as fixed. |
| e | **`kpi_rocket_boost` colours a cost like revenue.** Rocket Boost going up renders as a green up-arrow, when it may be margin erosion. Invert the sentiment on that tile. |
| f | **Cross-tab filter surprise.** `sport_filter` applies to `executive_metric_sheet` but isn't *placed* on that tab. Set Sport on the Drivers tab, return to the Metrics Sheet, and the numbers have quietly changed with no visible filter chip. |
| g | **Two overlapping date filters, both defaulting to 2 years** — `reporting_date_filter` (settled date, drives financials) and `fixture_start_filter` (advertised start). Nobody will know which governs. Relabel "Settled Date (financials)" / "Event Date (fixtures)". |
| h | **Aggregate awareness is decorative.** Enabled on the metric sheet (`:671-674`), but the generated SQL says `[Aggregate Awareness - missed] (no valid PreAggregate in this Dataset)`. If you want to *pitch* it, define a PreAggregate — otherwise drop the flag. A real sales point currently left on the table. |
| i | **Canvas heights: 1,280 / 1,820 / 2,140 / 2,140 / 2,710 px** ≈ 10,000px across five tabs. "Executive Pulse" needs 2.5 screens of scrolling. An exec pulse should fit one screen: filters + KPI row + trend + one driver chart. Push the rest to Drivers. |

### 4.6 What's missing — the biggest analytical gap

1. **No actual vs expected margin.** You have `weighted_dividend`, from which theoretical margin (≈ 1 − 1/overround) is derivable. A trading exec's first question is *"is realised margin tracking the book we priced?"* — variance vs theoretical, not vs last year. Right now `weighted_dividend` appears in exactly one audit-table column (`:1273`). Adding an `expected_margin` metric and plotting Gross Win % against it with the gap shaded would be the single most credible addition to this dashboard.
2. **No volatility framing.** Weekly gross win % on ~$70K stake is noisy. Without a 4- or 13-week moving average, you are inviting them to chase noise.
3. **No target or plan line anywhere.** Nothing answers "are we ahead or behind budget". `ReferenceLine` is available and unused.
4. **No sparklines on the KPI tiles** — six numbers with deltas but no shape.

### 4.7 Does this answer Dabble's stated buying criteria?

`clients/dabble/dashboards/AGENTS.md` records Dabble's three audiences and the seven things they dislike about AWS QuickSight. Since those frustrations are the actual buying criteria, the "after" dashboard should visibly answer them. Scored as it stands:

| Stated frustration | Answered? | Evidence / gap |
|---|---|---|
| Lack of a proper semantic layer | **Strong** | `dabble_trading.dataset.aml` with ~40 governed metrics, descriptions on each, and non-additivity warnings is the single best asset in this build. **Undercut by** `Other / Unclassified` being the biggest risk bucket (§1.1) — a semantic-layer hole on the exact axis you are claiming strength. |
| Poor version control | **Not shown** | It is true (this is AML in git) but nothing in the dashboard demonstrates it. Needs to be a talk-track or a screen-share of a diff, not a block. |
| SPICE extracts / stale data | **Weakened** | 210k leg rows invites "so it just extracts it all anyway?" Scaling volume (issue-01 §4.4) turns this into a live-warehouse-pushdown proof point instead of a liability. |
| Limited chart flexibility | **Partial** | KPI tiles, combination chart, metric sheet, pivot and donut is a decent spread — but 14 of 32 blocks are still plain tables (§4.3), and the two most visually distinctive charts are the two that render badly (§2, §3). Currently this criterion is being argued *against*. |
| Difficulty with cohort analysis | **Not answered at all** | No cohort visual anywhere, and the data cannot support one: all 3,000 users sign up in a single 2023 window and every user is active in every period. See issue-01 §1 and §6.4. **Biggest uncovered criterion.** |
| Self-service not viable for non-technical users | **Partial** | Drill-through is wired on three filters and `AutoDrillthroughSource` is configured — genuinely good — but it is invisible unless demoed. The redundant audit tab (§4.3) actively signals the opposite: "we pre-built every table for you because you can't ask your own questions." |
| No path to AI-assisted analytics | **Not shown** | Nothing in the build gestures at it. The governed metric layer is the credible foundation for the argument; the dashboard does not make it. |

Two conclusions worth acting on:

1. **Cohort analysis is a named requirement with zero coverage** and is blocked by the seed data. If it matters to the deal, it needs to enter scope explicitly (issue-01 §6.4), not be discovered in the meeting.
2. **Three of the seven criteria are talk-track, not artifact** — version control, self-service, and AI readiness. That is defensible, but decide it deliberately rather than assuming the dashboard speaks for itself. Deleting the audit tab and demoing drill-through live converts self-service from a claim into a demonstration at zero build cost.

---

## 5. Prioritised fix list

### P0 — before this goes in front of anyone

1. Regenerate seed data with plausible margins, bet sizes, turnover scale, and skewed risk distribution (§1.4).
2. Close the `risk_factor_bracket` case gaps so "Unclassified" stops being the biggest, best bucket (§1.1).
3. Strip "After concept", "Alternative… prototype", "Reusable", and the how-to-use callouts (§4.2).
4. Default the date filter to 13 weeks or 12 months — fixes the crowded pulse in one line (§2.3).
5. Fix the donut's `true`/`false` legend (§4.5a).

### P1 — makes it land

6. `BubbleChart` plus quadrant reference lines for the Sport Profitability Map (§3.1).
7. Right-axis range and average reference line on the trend; drop the PoP overlay there (§2.3).
8. Merge the three chart pairs into combos; delete the audit tab and demo drill-through instead (§4.3, §4.4).
9. Add `expected_margin` and plot actual vs expected (§4.6).
10. Resolve the PoP vs `relative_period` conflict (§4.5d).

### P1.5 — decide, don't discover

Not build items; decisions to make before the meeting (§4.7).

10a. Decide whether **cohort analysis** enters scope. Named requirement, zero coverage, blocked by the seed data.
10b. Decide the **talk-track** for version control, self-service and AI readiness — three of seven buying criteria that no block on the dashboard addresses.

### P2 — polish

11. Reorder tabs: Pulse → Metrics Sheet → Drivers → Customer/Risk (§4.1).
12. Sort the customer scatter; fix risk bracket ordering; explicit axis number formats (§4.5b, §4.5c).
13. Add `conditional_formats` with `ScaleFormat` to the leaderboards — available, currently unused across all 13 tables. Cheap, and it makes dense tables scannable.
14. Compress the Pulse tab to one screen; define a PreAggregate (§4.5h, §4.5i).

---

## Appendix — evidence

### A.1 Headline dataset figures

```
Actives              3,000
Bets                90,000
Combined Stake      $9,388,268.31
Gross Win           $2,351,359.52
Gross Win %              25.0%
Trading Net Revenue $1,584,672.49
Trading Net Rev %        16.9%
Rocket Boost           $30,054.19
Restricted Stake %        1.5%
Avg Bet Size            $104.31
Reporting date range  Jan 01 2024 – Jul 26 2026  (134 ISO weeks)
```

### A.2 Sport-level stake and margin (24 sports)

| Sport | Racing | Combined Stake | Gross Win | Gross Win % | Bets |
|---|---|---|---|---|---|
| Greyhound Racing | true | 1,840,029 | 494,981 | 26.9% | 35,990 |
| Harness Racing | true | 1,695,740 | 563,886 | 33.3% | 33,827 |
| Thoroughbred Racing | true | 1,582,181 | 476,105 | 30.1% | 31,545 |
| Boxing | false | 298,385 | **−222,509** | **−74.6%** | 5,875 |
| Rugby League | false | 291,680 | 87,795 | 30.1% | 5,866 |
| Commonwealth Games | false | 289,985 | 104,369 | 36.0% | 5,910 |
| Basketball | false | 284,858 | 90,324 | 31.7% | 5,773 |
| Australian Rules | false | 283,400 | 82,321 | 29.0% | 5,861 |
| Volleyball | false | 282,566 | 102,954 | 36.4% | 5,788 |
| Racing Futures | true | 276,774 | 65,889 | 23.8% | 5,622 |
| Rugby Union | false | 267,368 | 79,517 | 29.7% | 5,443 |
| Daily Dabbles | false | 264,173 | 72,467 | 27.4% | 5,267 |
| Cricket | false | 168,222 | 60,960 | 36.2% | 3,530 |
| Ice Hockey | false | 157,035 | **−117,398** | **−74.8%** | 3,319 |
| Esports | false | 150,250 | 46,255 | 30.8% | 3,170 |
| Darts | false | 149,966 | 75,346 | 50.2% | 3,166 |
| AFL – Brownlow 3 Votes | false | 147,746 | 25,435 | 17.2% | 3,132 |
| American Football | false | 146,579 | 11,902 | 8.1% | 3,100 |
| MMA | false | 146,488 | 72,229 | 49.3% | 3,081 |
| Golf | false | 139,583 | 46,927 | 33.6% | 2,955 |
| Baseball | false | 138,148 | 35,671 | 25.8% | 2,930 |
| Tennis | false | 131,115 | 14,678 | 11.2% | 2,795 |
| Cycling | false | 129,348 | 58,574 | 45.3% | 2,744 |
| Football | false | 126,648 | 22,678 | 17.9% | 2,699 |

Racing subtotal: **$5,394,724 = 57.5%** of turnover across 4 codes.

### A.3 Risk factor bracket distribution

Returned in lexical order — note `10.00+` before `5.00 - 9.99`, and 7,500 bets in every bracket.

| Bracket | Combined Stake | Gross Win % | Bets |
|---|---|---|---|
| -1 | 746,213 | 24.2% | 7,500 |
| 0.01 - 0.30 | 510,986 | −1.3% | 7,500 |
| 0.50 - 0.80 | 869,305 | 31.5% | 7,500 |
| 0.90 | 739,535 | 24.5% | 7,500 |
| 0.91 - 0.99 | 589,207 | 7.2% | 7,500 |
| 1.00 | 1,073,898 | 27.5% | 7,500 |
| 1.01 - 1.05 | 723,950 | 23.9% | 7,500 |
| 1.06 - 1.10 | 743,308 | 27.4% | 7,500 |
| 1.11 | 656,636 | −10.8% | 7,500 |
| 10.00+ | 791,183 | 33.3% | 7,500 |
| 5.00 - 9.99 | 938,371 | 37.8% | 7,500 |
| **Other / Unclassified** | **1,005,677** | **45.7%** | 7,500 |

### A.4 Block inventory

| Type | Count |
|---|---|
| DataTable | 14 |
| BarChart | 7 |
| MetricKpi | 6 |
| ScatterChart | 2 |
| CombinationChart | 1 |
| MetricSheet | 1 |
| PieChart | 1 |
| **Total viz blocks** | **32** (before: 23) |
| TextBlock | 6 |
| FilterBlock | 5 (+ DateDrillBlock, PopBlock) |

> Counted after `audit_margin_by_bet_legs` changed from `PivotTable` to `DataTable` mid-session (see note below). Tables are now **14 of 32 viz blocks — 44%** of the dashboard, which strengthens rather than weakens §4.3.

**Uncommitted change detected during this audit.** `dabble_au_trading_after.page.aml` differs from `HEAD`: `audit_margin_by_bet_legs` was converted from a `PivotTable` (rows = leg count, columns = bet type, with column totals) into a flat `DataTable` with `frozen_columns: 2` and a sort on `leg_count`. This was not authored as part of the audit. The most likely explanation is a cloud-side edit in Holistics Studio being pulled down by the CLI's sync check, but that is not confirmed. Inspect with `git diff clients/dabble/dashboards/dabble_au_trading_after.page.aml` and keep or revert deliberately — note that reverting would discard a Studio edit if that is what it is.

On the merits: the `PivotTable` was the better choice here. Leg count × bet type is a genuine two-dimensional cross-tab, and `show_column_total: true` gave the row that made it readable. The flat table loses both.

### A.5 Validation baseline

`holistics aml validate` reports 61 errors project-wide but **zero in any Dabble file**. The baseline is clean, so every finding above is design, not syntax.
