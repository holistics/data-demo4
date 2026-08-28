# Dabble AU Trading Analytics — Context & Operating Model

**Client:** Dabble — Australian social betting operator
**Scope:** `clients/dabble/` — `dabble_trading` dataset, seven models, two dashboards, one theme
**Audience for this document:** anyone (human or AI) picking up a Dabble analytics request cold
**Status:** prototype built on deterministic synthetic data. Read §8 before quoting any number.

---

## 1. Why these dashboards exist

Dabble runs its BI on AWS QuickSight and has named seven frustrations with it: no semantic layer, poor version control, SPICE extracts that go stale, limited chart flexibility, no viable cohort analysis, self-service that non-technical users cannot actually use, and no credible path to AI-assisted analytics.

Those seven frustrations are the buying criteria. Everything in `clients/dabble/` is built to answer them in the language of a trading floor rather than the language of a BI tool. A dashboard that is beautiful but does not make a trading exec say *"that is the number I argue about on Monday"* has failed, regardless of how well it validates.

Three audiences, three different jobs:

| Audience | Size | What they need | Failure mode to avoid |
|---|---|---|---|
| Executives & senior leadership | ~10 | Consistent, trusted KPIs across AU / UK / US. One screen, one story, a decision. | Density. An exec who has to scroll or hover to read the answer stops reading. |
| Business users — Strategy, Trading, Marketing, Finance | ~20–40 | Answer their own questions without queuing behind BI. Slice, drill, export, move on. | Pre-building every table for them. It signals "you cannot ask your own questions." |
| BI analysts | 5 | Flexible querying, fast iteration, a governed metric layer they maintain rather than re-derive. | Metric logic that lives in dashboards instead of the semantic layer. |

Only AU is modelled today. Every metric definition, filter default, and label must survive the addition of UK and US without being rewritten — that is the whole point of the semantic layer argument.

---

## 2. The business we are measuring

Dabble is a social wagering app: customers place bets, then share, follow and copy each other's bets in a feed. That social layer is the differentiator and it is also a trading exposure — copied bets concentrate liability on the same selections at the same time, which no traditional sportsbook P&L view is built to see.

### 2.1 Where the money comes from — the trading P&L chain

Read every Dabble financial question against this chain. It is the spine of the dataset and of both dashboards.

```
                Combined Stake  ──────────────────────────  "Turnover"
                (cash + bonus)         the top line; volume, not revenue
                       │
                       ├─ less  Combined Payout            settled returns to customers
                       ├─ plus  Rocket Boost               social/copy incentive cost
                       ▼
                  Gross Win  ────────────────────────────  the book's hold
                       │        Gross Win % = Gross Win / Combined Stake
                       │
                       ├─ less  BRG                        bonus & generosity give-back
                       ▼
              Trading Net Win  ───────────────────────────  hold after generosity
                       │
                       ├─ less  COGS                       product/racing fees, POCT, GST
                       ▼
          Trading Net Revenue  ───────────────────────────  what Finance recognises
                                Trading Net Revenue % = / Combined Stake
```

Four things follow from this shape, and they are the four things a wagering exec will test you on:

1. **Turnover is not revenue.** Turnover up with margin down is usually worse than both flat. Never report stake growth without the margin beside it.
2. **The gap between Gross Win and Trading Net Revenue is a cost story, not a trading story.** If Gross Win % holds but Net Revenue % falls, the problem is generosity (bonus, BRG, Rocket boost) or COGS — not pricing. Different owner, different fix.
3. **Percentages compound down the chain.** In this dataset Gross Win % → Trading Net Win % → Trading Net Revenue % should decline monotonically. If it doesn't, distrust the slice before you distrust the book.
4. **Rocket Boost sits *inside* Gross Win** as an acquisition/engagement cost. Rising Rocket Boost is not automatically good news — it is spend, and it should be judged on the turnover and actives it buys.

### 2.2 Domain mechanics that actually move the numbers

**Racing versus sport are two different businesses sharing one app.** Racing (thoroughbred, harness, greyhound, plus racing futures) is high-frequency, short-cycle, and runs a structurally wider hold than sport. Sport is lower-frequency, event-driven, and thinner. In this dataset racing is ~57.5% of turnover across four codes. Blending them into one margin number hides both. Split by `dabble_dim_sport.is_racing` / `sport_category` before drawing a conclusion about "our margin".

**Multi-leg bets are the margin engine.** Each leg carries its own overround, and combining legs multiplies them — a four-leg multi holds far more than four singles. `dabble_fact_bet.leg_count` and `bet_type` are therefore not cosmetic dimensions: a shift in leg-count mix will move blended margin with no pricing change whatsoever. Always check mix before declaring a pricing problem. The same logic is why the leg-count × bet-type cross-tab earns its place on the dashboard.

**Dividend, overround and expected margin.** `dividend` is the price paid on a leg. The book's theoretical hold is implied by the overround across a market (`expected_margin_rate` at leg level, surfaced as `Expected Gross Win %`). The single most credible question a trading exec asks is not *"how did we do versus last year"* but **"did we hold what we priced?"** That is `Margin Variance (pts)` = realised Gross Win % − Expected Gross Win %. Positive means results ran the book's way; negative means they didn't, or the pricing was wrong. Last year's margin is a far weaker benchmark than the book you actually priced.

**Generosity is a lever with a lag.** Bonus cash stake, BRG and Rocket Boost are all deliberate give-back. `Bonus Cash %` tells you how much of turnover is promotional rather than real money. Marketing owns the spend; Trading owns the margin it dilutes; the dashboard has to let both see the same number without arguing about definitions.

**Risk factor and restricted stake are the sharp-customer defence.** `risk_rating`, `risk_factor` and `risk_factor_bracket` express how much the book trusts a customer's money. `restricted_stake` is turnover accepted under a stake limit. The management question is whether the framework works: risk brackets should show a *monotonic* relationship with realised margin. If margin is flat or random across brackets, the framework is decorative — and that is a finding worth escalating, not a chart to quietly publish. (In the current synthetic data it *is* random. See §8.)

**Copy/Rocket concentrates liability.** `rocket_category` separates Rocket bets from the rest. Copy behaviour means correlated exposure: one popular selection copied hundreds of times is a single position, not hundreds of independent ones. Treat Rocket turnover growth as both an engagement win and a risk-concentration signal.

---

## 3. Regulatory and compliance overlay

Australian online wagering is among the most tightly regulated consumer markets in the country. This constrains what the dashboards may show and how findings may be phrased. Confirm current specifics with Dabble Legal/Compliance before quoting them externally — the framework has moved repeatedly and continues to.

**What shapes the numbers:**

- **Point of Consumption Tax** is levied by the state of the *customer's* residence, not the licence jurisdiction, at rates that have ratcheted upward and now sit broadly in the 10–20% band depending on state. This is why `dabble_dim_user.home_state` is a financial dimension, not a demographic one — state mix change moves net revenue with no trading change at all. Verify the current rate schedule with Finance before modelling tax in a metric.
- **Racing product and race-field fees** paid to racing bodies, plus sports controlling-body fees, are the bulk of COGS. They scale with racing turnover, which is why racing's higher gross margin does not translate one-for-one into net revenue.
- **Point-of-consumption structure means market-level comparability is not automatic.** When UK and US arrive, "Net Revenue %" will not be like-for-like across markets unless the tax and fee treatment is explicit in the semantic layer.

**What constrains the analytics:**

- **National Consumer Protection Framework** obligations — the national self-exclusion register (BetStop), mandatory activity statements, customer-set deposit limits, prohibition on credit betting, consistent gambling-harm messaging, and account-verification timeframes. Customers on self-exclusion must never be targetable from an analytics output.
- **AML/CTF obligations to AUSTRAC** make customer-level financial views sensitive by default.
- **Advertising and inducement restrictions** mean any output that looks like a targeting list for promotions is a compliance artefact, not just a report.

**Practical rules this imposes on every Dabble dashboard:**

1. **No direct PII.** The prototype uses generated `source_user_id` and `display_alias` values by design. Customer-level views identify by alias, never by name, email or account number.
2. **"Least profitable customer" is a risk-management view, not a harm view — and vice versa.** A high-turnover, high-loss customer is a responsible-gambling question before it is a profitability question. Phrase customer-level findings in risk and pricing language, and never recommend increasing exposure to a customer showing harm indicators.
3. **Profitability rankings are internal.** Customer leaderboards belong in Trading and Risk hands, not in a broadly-shared executive view.
4. **State is financial.** Any market or margin comparison that ignores state mix is incomplete.

---

## 4. Audiences, decision rights, and cadence

| Forum | Cadence | Who | Primary surface | Decision it produces |
|---|---|---|---|---|
| Trading huddle | Daily | Trading managers | Executive Pulse, 13-week window | Price and limit adjustments for the day's card |
| Trading review | Weekly | Head of Trading + analysts | Sport & Competition Drivers | Which sports/competitions get a price review, which get promoted |
| Commercial review | Monthly | Exec + Finance | Monthly Trading Scorecard | Generosity envelope, COGS challenge, forecast reset |
| Risk & compliance review | Monthly | Risk + Compliance | Customer, Rocket & Risk | Restrictions, RG interventions, framework calibration |
| Board / investor | Quarterly | CEO/CFO | Scorecard + YoY | Market-level strategy, investment |

Note the asymmetry: executives need **one number and a direction**; the weekly trading review needs **variance decomposition**; the monthly review needs **the cost chain**. The same metric serves all three only if its definition is governed centrally — which is the semantic-layer argument made concrete.

---

## 5. The dashboard portfolio — what each screen owns

### 5.1 `dabble_au_trading_kpi_prototype` — "Dabble AU Trading KPI Prototype"

The parity baseline: a faithful rebuild of how this reporting looks today, plus one Holistics-native addition (year-over-year comparison). Two tabs — *AU – KPI Overview* and *Sport Overview* — 23 viz blocks, mostly tables.

Its role is not to be good. Its role is to be **recognisable**, so the command centre has something to be better than. Do not tidy it into a second command centre; the contrast is the asset.

### 5.2 `dabble_au_trading_performance_command_center` — "Dabble AU Trading Performance"

A staged narrative. Each tab answers one question and hands off to the next.

| Tab | Question it owns | Owner | Key blocks | Escalation trigger |
|---|---|---|---|---|
| **Executive Pulse** | Are turnover and margin where they should be? | Exec | Six KPI tiles (Actives, Bets, Combined Stake, Gross Win %, Trading Net Revenue, Rocket Boost), Stake & Margin Trend, racing/sport stake mix, key competition cards | Gross Win % outside its band, or Net Revenue % falling while Gross Win % holds |
| **Monthly Scorecard** | How did the month close across scale, profitability, customer economics and risk? | Finance + Exec | Monthly metric sheet, Stake & Net Revenue vs Last Year, definitions note | Any month where the % chain does not decline monotonically |
| **Sport & Competition Drivers** | Where is realised margin diverging from the book we priced? | Trading | Realised vs Priced Margin, sport profitability quadrant, turnover-and-margin by sport, sport driver matrix, competition and fixture leaderboards | A sport or competition with material turnover and negative margin variance |
| **Customer, Rocket & Risk** | Who carries the exposure, and is the risk framework working? | Risk + Trading | Margin by risk bracket, market group, leg count, restricted stake by bet type, Rocket category performance, customer turnover-vs-net-revenue scatter, three customer leaderboards | Margin flat or non-monotonic across risk brackets; Rocket boost growing faster than the turnover it buys |

### 5.3 `dabble_au_trading_board_pack` — "Dabble AU Executive Board Pack"

One page, board/quarterly cadence. It answers the question no command-centre tab answers end
to end: *where did turnover become net revenue, what is dragging it, and how much of this can
the board trust?*

| Block | What it owns |
|---|---|
| Six KPI tiles | Turnover, Gross Win %, Trading Net Revenue, Net Revenue %, Actives, Avg Bet Size — all against the same period last year |
| Trading P&L Waterfall | The whole chain in one chart, each step labelled in dollars and as % of turnover. Custom Vega-Lite chart (`dabble_pnl_waterfall`) |
| Margin Chain by Month | Gross Win % → Trading Net Win % → Trading Net Revenue % against the priced book, with turnover as columns behind it |
| Customer Home State | POCT exposure — state is a financial dimension |
| Net Revenue Drag by Sport | Which sports add and which destroy net revenue, worst first |
| Racing vs Sport cost chain | Racing's wider gross hold against what survives BRG and COGS |
| Monthly Board Scorecard | Scale, margin chain and cost chain, one governed metric per row |
| Data confidence panel | Per-figure trust / do-not-quote / artefact ruling, inline on the page |

**Settled-date lens only, on purpose.** A board pack that mixes date lenses invites the wrong
argument, so there is no event-date filter on this page. Filters are Settled Date (default
last 12 months), Sport, Customer Home State and the `Compare` control.

Two date filters coexist deliberately on the command centre and are the most common source of
confusion:

- **Settled Date (financials)** — `dabble_fact_bet.reporting_date`. Governs every financial metric. This is the default lens.
- **Event Date (fixtures)** — `dabble_dim_fixture.advertised_start`. Governs event-shaped questions ("how did Saturday's card go").

A bet placed Friday on a Sunday fixture and settled Monday lands in three different windows. State which lens a number uses, every time.

Drill-through is wired on the sport, competition and fixture filters via `AutoDrillthroughSource`. That is the self-service answer — it should be *demonstrated*, not described.

---

## 6. Reading the numbers correctly

These are the traps that turn a correct query into a wrong answer.

**Never sum a percentage.** `Gross Win %`, `Trading Net Win %`, `Trading Net Revenue %`, `Bonus Cash %`, `Restricted Stake %`, `Expected Gross Win %` and `Margin Variance (pts)` are all ratios. Recalculate from the additive components at every level of grouping. A "total" row built by averaging sport-level margins is wrong and will be spotted instantly.

**Actives do not add up.** `Actives #` is a distinct user count. Twelve monthly actives do not sum to an annual figure. Same for `Racing Actives #`, `Sport Actives #`, `Copy Actives #`. Sum stake, count users.

**Additive measures are allocated to bet legs on purpose.** Every financial measure sits at leg grain so that sport, competition and fixture totals stay additive and multi-leg bets don't double-count. Bet and user counts use `count_distinct` for the same reason. Never sum a bet-level figure across leg-level dimensions.

**Margin variance beats year-over-year.** Prefer `Margin Variance (pts)` — realised versus priced — over prior-year comparison when explaining a margin move. YoY conflates pricing, mix, result variance and growth into one uninterpretable number.

**Decompose a margin move in this order:** mix (did racing/sport or leg-count share shift?) → price (did `Expected Gross Win %` move?) → result (did realised diverge from expected?) → generosity (did bonus, BRG or Rocket Boost grow?) → cost (did COGS or state mix move?). Stopping at the first plausible explanation is how trading floors get bad advice.

**Weekly margin on a thin book is noise.** Gross Win % on a single week of one sport carries huge variance. Quote the stake behind any margin figure, and prefer 4- or 13-week views over week-on-week. Recommending action on one noisy week is the fastest way to lose credibility with this audience.

**Comparison mechanisms conflict.** The `Compare` control (PopBlock) drives the KPI tiles and the trend chart. The YoY scorecard uses metrics with a hard-coded `relative_period(-1 year)` and does *not* follow that control. Set Compare to "previous quarter" and the two disagree on purpose. Say which one a number came from.

---

## 7. Analytical playbooks

**"Margin is down."**
Confirm the window and the lens (settled date). Split racing vs sport. Check leg-count and bet-type mix. Compare realised against `Expected Gross Win %` — if expected also moved, it's pricing; if only realised moved, it's result variance. Size the affected turnover before recommending anything: a −20pt swing on 0.4% of turnover is a rounding error, and saying so is more valuable than a chart.

**"Net revenue is down but gross win is fine."**
Walk the cost chain: `Bonus Cash %` → BRG (Gross Win → Trading Net Win) → COGS (Trading Net Win → Trading Net Revenue). Check state mix for a tax-driven move. This is a Marketing/Finance conversation, not a Trading one — route it accordingly.

**"Is Rocket working?"**
Rocket Boost is spend. Judge it on `Copy Actives #`, `Copy Bets #` and `Copy Combined Stake` against the boost, and compare `Copy Gross Win %` with the book overall. Flag correlated exposure: copied bets are one position, not many.

**"Which sports should we prioritise?"**
Turnover *and* margin together, with average reference lines to form quadrants: high stake / high margin → protect; high stake / low margin → price review; low stake / high margin → grow; low stake / low margin → deprioritise. Never rank on margin alone — a 50% hold on $130k of turnover is not a priority.

**"Is the risk framework working?"**
Realised margin by `risk_factor_bracket`. The bracket labels are now zero-padded (`00.31 - 00.49`, `01.11`, `05.00 - 09.99`, `10.00+`), so lexical sort and numeric sort agree and there is no longer an "Other / Unclassified" catch-all. A working framework is monotonic. Flat or random means the framework is not protecting margin, which is an escalation, not a chart — and in the current seed it *is* random (see §8).

---

## 8. Data reality check — read before quoting a number

This prototype runs on deterministic synthetic seed data (`clients/dabble/database/seed.sql`). Several figures are not plausible to a wagering audience, and the fix lives in the seed generator, not the dashboards. Full analysis: [`dabble_au_trading_after_audit.md`](./dabble_au_trading_after_audit.md) and [`issue-01-seed-data-plausibility.md`](./issue-01-seed-data-plausibility.md).

| Symptom | Current | Reality check |
|---|---|---|
| Blended Gross Win % | ~25% | AU blended runs materially lower — roughly 11–15%, racing above sport. Verify against Dabble's own published figures before quoting. |
| Avg Bet Size | ~$104 | Dabble is social/micro-stakes; this reads several times too high |
| Turnover | ~$9.4M over 2.5 years | Orders of magnitude below a real operator — reads as a toy dataset |
| Rocket Boost | 0.32% of stake | Implies the flagship social product barely exists |
| Actives / Bets | exactly 3,000 / exactly 90,000 | Exactly 30.00 bets per active — visibly generated |
| Risk brackets | exactly 7,500 bets and 250 actives each, margin non-monotonic | Risk factor influences nothing: `00.31 - 00.49` holds +45.7% while `01.11` holds −10.8%. The framework is decorative. |
| Restricted stake | exactly 1.5% of turnover in **every** bracket | Restriction is a flat haircut, not a risk response. Nothing to calibrate. |
| Expected Gross Win % | flat at 10.7–10.8% in all 31 months and all 24 sports | Overround is a fixed four-bucket lookup on `dividend`, and `dividend` is uniform-random (stake-weighted mean 4.52 everywhere). So `Margin Variance (pts)` is realised margin minus a constant — the "did we hold what we priced" benchmark carries no information in this seed. |
| BRG and COGS | ≈3.05% and ≈5.10% of turnover in every cut | Both are constant-rate haircuts. COGS does not scale with racing turnover and does not vary by `home_state`, so state-level Net Revenue % differences are pure gross-win result variance, not POCT. |
| Two sports | Boxing −74.6%, Ice Hockey −74.8% | No book runs a whole sport at −75%. Identical to ±3pts in all 10 full quarters — a payout-multiplier defect, not a trading event. Together −$377k of Trading Net Revenue, on 4.8% of turnover. |
| Each Way | +89.5% Gross Win % on $850k | Physically impossible for a real book |
| Year-over-year | 2024 $3,662,785 → 2025 $3,660,832 turnover (−0.05%), Gross Win % 25.0% both years | The book is a flat line. YoY tiles will always read ~0%, so the dashboards cannot demonstrate a growth story. |
| Cohort analysis | Impossible | Signups land in exactly 5 months of 2023, 600 users each, and each month maps 1:1 to one `acquisition_category`. So "channel performance" *is* the signup cohort — Organic +49.0% Net Revenue % vs Referral +1.1% is generator noise, not channel quality. A named buying criterion with zero coverage. |
| Competition names | mismatched to sports | "AFL Matches" sits under Racing Futures, "Brownlow Medal" under Commonwealth Games; most are generic `Competition NN` |

Also documented as demo assumptions pending Dabble confirmation: restricted-stake logic, weighted-dividend aggregation, expected-margin overrounds, Rocket categories, the definition of "active", and use of an Australian settled reporting date.

**How to behave given all this:** answer the question with the data as it stands, then state plainly which figures are synthetic artefacts rather than findings. Do not launder an implausible number into a confident business recommendation, and do not refuse to answer — flag and proceed.

---

## 9. Glossary

| Term | Meaning here |
|---|---|
| Turnover | `Combined Stake` — cash + bonus stake. The top line. |
| Gross Win | Cash stake − cash payout + Rocket Boost. The book's hold. |
| Gross Win % / hold / margin | Gross Win ÷ Combined Stake |
| Expected Gross Win | Stake × the theoretical margin implied by the leg's dividend — what the priced book should have returned |
| Margin Variance (pts) | Realised Gross Win % − Expected Gross Win %. Positive = ran better than priced. |
| BRG | Bonus/generosity give-back deducted between Gross Win and Trading Net Win |
| Trading Net Win | Gross Win − BRG |
| COGS | Product and racing fees, taxes and levies deducted to reach Trading Net Revenue |
| Trading Net Revenue | Trading Net Win − COGS. The Finance-recognised line. |
| Dividend | The price paid on a bet leg |
| Overround | The book's built-in margin across a market's prices |
| Rocket / Rocket Boost | Dabble's social copy-betting mechanic and the incentive cost attached to it |
| Restricted Stake | Turnover accepted under a stake limit applied to a customer |
| Risk Factor / Rating / Bracket | How much of a customer's stake the book is willing to accept — the sharp-customer defence |
| Actives | Distinct users with at least one settled bet in the context. Non-additive. |
| POCT | Point of Consumption Tax, levied by the customer's state of residence |
| NCPF | National Consumer Protection Framework — the national online wagering harm-minimisation regime |
| BetStop | The national self-exclusion register |
| Settled date vs event date | `reporting_date` (financials) vs `advertised_start` (fixtures). Different windows for the same bet. |
