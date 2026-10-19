# Issue 01 — Dabble demo seed data is not plausible to a wagering audience

**Status:** Open — not started
**Severity:** P0. Blocks showing either Dabble dashboard to the prospect.
**Owner:** unassigned
**Raised:** 2026-07-30, during the audit of `dabble_au_trading_after.page.aml`
**Parent document:** [`dabble_au_trading_after_audit.md`](./dabble_au_trading_after_audit.md) §1
**Primary file to change:** `clients/dabble/database/seed.sql`
**Also in scope:** `clients/dabble/models/dabble_fact_bet.model.aml:70-87` (one modelling bug)

---

## Read this first

This issue is self-contained. You do not need the audit document or the prior session to act on it, though §1 of the audit is the short version of the argument.

**One-line summary:** the demo data is internally consistent but externally implausible, and the numbers that are wrong are precisely the numbers a betting-company executive checks first.

**Do not start editing until you have read §6 (Open questions).** Two of the fixes involve a genuine tradeoff that needs the user's call, and one of them determines how large the regenerated dataset should be. Guessing wrong means doing the work twice.

---

## 1. Context — why this matters more than usual

The audience is not generic. From `clients/dabble/dashboards/AGENTS.md`, Dabble's three audiences are executives and senior leadership, ~20–40 business users across **Strategy, Trading, Marketing and Finance**, and 5 BI analysts. They are evaluating a move off AWS QuickSight.

That means the room contains people who price books for a living. A trading manager reads a gross-win-% figure the way a developer reads a stack trace — instantly, and with strong priors about what it should say. Every implausible number is a credibility deduction, and the deductions compound: once someone decides the data is fake, they stop evaluating the product and start looking for more errors.

Two of the symptoms below are worse than merely wrong, because they actively argue *against* the sale:

- **Margin by risk bracket is random** (§4.7). A trading exec reads this as "your risk framework does nothing."
- **The largest and most profitable risk bucket is labelled `Other / Unclassified`** (§4.5). This reads as "your semantic layer has holes" — to a prospect whose single loudest complaint about QuickSight is *"lack of a proper semantic layer."*

There is also a requirement this data cannot currently satisfy at all. `AGENTS.md` names **cohort analysis** as both a QuickSight frustration and a product requirement. Every one of the 3,000 users signs up inside a single 365-day window in 2023 (`seed.sql:12`), before the fact data starts, and every user is active in essentially every period. There are no cohorts to analyse. Any cohort demo built on this data will be degenerate.

---

## 2. Evidence

Measured by querying the live `dabble_trading` dataset (`holistics mcp execute_aql`), not estimated:

| Metric | Demo value | AU market reality (approx.) | Read |
|---|---|---|---|
| Gross Win % (blended) | **25.0%** | ~11–15% blended (racing ~13–16%, sport ~8–11%) | ~2× too high |
| Avg Bet Size | **$104.31** | ~$25–40 industry; Dabble is social/micro-stakes → lower | 3–4× too high |
| Combined Stake, 2.5 yrs | **$9.39M** (~$3.7M/yr) | Dabble operates orders of magnitude above this | Reads as a toy dataset |
| Rocket Boost | **$30,054** = 0.32% of stake | Rocket is Dabble's flagship social/copy product | Implies the feature barely exists |
| Actives / Bets | **exactly 3,000 / exactly 90,000** | — | Exactly 30.00 bets per active, for every user |
| Bets per risk bracket | **exactly 7,500 × 12 brackets** | Heavily skewed in reality | Uniform = obviously generated |
| Worst sports by margin | **Boxing −74.6%, Ice Hockey −74.8%** | — | No book runs a sport at −75% for 2.5 years |
| `Other / Unclassified` risk bucket | **$1.01M (10.7% of turnover), 45.7% margin** | — | Biggest and best bucket is the catch-all |

> The benchmark column is from general knowledge of the AU wagering market, **not** looked up for this document. Verify against Dabble's published figures or a market source before quoting any of it in front of the client. The *direction and rough magnitude* of each gap is what matters here, and that holds regardless of the precise benchmark.

---

## 3. The root cause behind the root causes

Fixing these one at a time will not work, and it is worth understanding why before touching the file.

`seed.sql` generates **dividend and payout independently of each other**, and generates **payout independently of risk factor**:

- `dividend` (`seed.sql:168`) — `1.05 + ((bet_id*17 + leg*29) % 695)/100.0`, a uniform 1.05–8.00 hash. It is written to `fact_bet_leg` and never used for anything.
- `cash_payout` (`seed.sql:103-107`) — a separate hash on `bet_id`, `leg_number` and `sport_id`. It does **not** reference `dividend`.
- `risk_factor` (`seed.sql:15`) — assigned to users, joined into `fact_bet`, and **never referenced in any financial calculation**.

So price, outcome, and risk are three unrelated random streams. Nothing ties together, which is why margin by risk bracket is noise and why `weighted_dividend` is meaningless.

**The fix is to invert the generation order.** Instead of hashing payout directly:

1. Pick `dividend` per leg (realistic odds distribution — most legs short-priced, thin long-odds tail).
2. Derive an implied win probability from it: `p_win ≈ (1 − target_margin) / dividend`.
3. Modulate `target_margin` by sport type and by the bettor's `risk_factor`.
4. Decide win/loss from a deterministic hash compared against `p_win`.
5. `cash_payout = cash_stake * dividend` when won, `0` when lost.

Everything else then falls out for free: blended margin lands where you aimed it, margin varies coherently by sport and by risk bracket, `result` becomes consistent with payout, and `weighted_dividend` becomes a real quantity you can build an expected-margin metric on. That last point matters — the parent audit's highest-value recommendation (§4.6, actual vs expected margin) is **not implementable until this is fixed**.

Keep the hashes deterministic (no `random()`). The existing file is deliberately reproducible, `clients/dabble/database/README.md` documents it as such, and reproducibility is what lets `assertions.sql` be meaningful.

---

## 4. Symptom-by-symptom root cause

### 4.1 Gross Win % is ~25% instead of ~13%

`seed.sql:103-107`:

```sql
round((s.cash_stake * case
  when c.sport_id in (11, 14) then 1.35 + ((s.bet_id % 80) / 100.0)
  when (s.bet_id + s.leg_number * 3) % 10 < 7 then 0
  else 1.65 + ((s.bet_id % 140) / 100.0)
end)::numeric, 2) as cash_payout
```

For normal sports: 70% of legs pay 0, 30% pay `1.65 + avg(0.695)` ≈ 2.345× stake. Expected payout ratio ≈ `0.30 × 2.345` ≈ **0.703**, so margin ≈ 29.7% on cash stake, diluting to the observed 25.0% once divided by *combined* stake (cash + bonus).

To land near 13%, expected payout ratio needs to be ≈ 0.87. Under the §3 rewrite this becomes a directly settable `target_margin` parameter rather than something to reverse-engineer, which is the main reason to do the rewrite rather than tweak the constants.

### 4.2 Boxing and Ice Hockey at −75%

Same block, `seed.sql:104`. `sport_id in (11, 14)` is Ice Hockey and Boxing (indices into the `dim_sport` name array at `seed.sql:21`). That branch pays out **1.35–2.14× on every single leg, unconditionally** — those two sports have no losing legs at all. Expected ≈ 1.75× → margin ≈ −75%, matching the observed −74.6% / −74.8%.

This looks like it was intended to create "a couple of loss-making sports" for visual interest. It overshot by roughly an order of magnitude. Delete the branch; under the §3 rewrite, express sport-level variation as a few points of `target_margin` difference instead.

### 4.3 Avg bet size is $104 instead of ~$20

`seed.sql:94` — `cash_stake = 1 + ((bet_id*47 + leg_number*19) % 9000)/100.0`, a uniform **$1.00–$91.00** per leg, mean ≈ $46. Average legs per bet ≈ 2.33 from the `leg_count` distribution at `seed.sql:78-85`. `$46 × 2.33` ≈ $107, matching the observed $104.31.

Two problems: the level is ~4× too high, and the *shape* is wrong. Real stake distributions are heavily right-skewed (many small bets, a thin tail of large ones); this is flat. Replace with a skewed deterministic distribution — squaring or cubing a normalised hash is enough — targeting a mean around $8–10 per leg.

**This interacts with §4.4 — read that before choosing numbers.**

### 4.4 Turnover reads as a toy dataset

`$9.39M` over 2.5 years is ~$3.7M/yr for what is presented as a national operator's trading book.

This is the one symptom with a real tradeoff, because §4.3 pushes stake *down* while this pushes turnover *up*, so the entire adjustment has to come from volume:

| Approach | Bets | Legs | Avg bet | Turnover / yr | Notes |
|---|---|---|---|---|---|
| Current | 90k | 210k | $104 | $3.7M | Implausible on both axes |
| **A — moderate** | ~2.5M | ~5.8M | ~$20 | ~$50M | Comfortable in Postgres/Neon. Still below Dabble's real scale; label it as a sample. |
| B — aggressive | ~20M | ~46M | ~$20 | ~$400M | Closer to real scale. Seed runtime and Neon storage need checking first. |
| C — keep small, relabel | 90k | 210k | ~$20 | ~$0.7M | Cheapest, but makes the scale problem worse, not better. |

**Recommendation: A**, with the dashboard framed as a representative sample rather than the whole book. It also happens to demo Holistics better — 5.8M leg rows exercises real warehouse pushdown, whereas 210k rows invites "so it just extracts it all anyway?", which is exactly the SPICE objection you are there to counter.

`actives` should rise with it — ~150k–250k users rather than 3,000 — so that bets per active lands in a realistic 15–40/yr band.

**Confirm the choice with the user before generating** (see §6).

### 4.5 `Other / Unclassified` is the biggest and best risk bucket

This one has two independent causes and needs both fixed.

**Cause A — a genuine modelling bug.** `clients/dabble/models/dabble_fact_bet.model.aml:70-87` builds `risk_factor_bracket` from a `case` with two uncovered ranges:

- `0.31 – 0.49` — no branch
- `1.12 – 4.99` — no branch

Anything landing there falls to `else 'Other / Unclassified'`. This is a bug independent of the seed data and should be fixed regardless.

**Cause B — the seed feeds exactly one value into the gap.** `seed.sql:15`:

```sql
(array[-1.00, 0.15, 0.40, 0.65, 0.90, 0.95, 1.00, 1.03, 1.08, 1.11, 5.50, 10.50])[1 + ((n * 13) % 12)]
```

Of those twelve values, exactly one — **`0.40`** — falls into the `0.31–0.49` gap. One of twelve values × 250 users each = 7,500 bets = the 10.7% of turnover observed in the catch-all. The arithmetic closes exactly.

Fix both: make the AML `case` exhaustive, and replace the uniform 12-value array with a weighted distribution (§4.6).

Separately, `seed.sql:14` puts the literal string `'Other / Unclassified'` into the `risk_rating` array as one of four ratings. Different field, same smell — reconsider it while you are in there.

### 4.6 Exactly 7,500 bets in every risk bracket

`seed.sql:15` — `(n * 13) % 12` over `generate_series(1, 3000)` cycles uniformly, giving exactly 250 users per risk factor. Bets attach via `user_id = 1 + ((n * 1543) % 3000)` (`seed.sql:75`), and since `gcd(1543, 3000) = 1` that is a perfect permutation — so **every user gets exactly 30 bets**, not 30 on average.

That single line is the source of three separate tells: uniform risk brackets, exactly 30.00 bets per active, and exactly 3,000 actives with zero dormant users.

Replace with a weighted risk-factor distribution (most volume at 1.00, thin restricted tail) and a skewed user-to-bet assignment (a few whales, a long casual tail, and some genuinely dormant accounts).

### 4.7 Margin by risk bracket is random

Observed, by bracket: `24.2%, −1.3%, 31.5%, 24.5%, 7.2%, 27.5%, 23.9%, 27.4%, −10.8%, 37.8%, 33.3%, 45.7%`.

Cause: as noted in §3, `risk_factor` never enters any financial calculation. `seed_finance` (`seed.sql:101-121`) joins `dim_market`, `dim_fixture` and `dim_competition` — but **not** `dim_user`, so the bettor's risk factor is not even in scope where payout is computed.

Fix requires a plumbing change: join `seed_bet → dim_user` into `seed_finance` so `u.risk_factor` is available, then feed it into `target_margin` per §3.

**This is the most important fix in this document for a trading audience.** Everything else is a number being wrong; this is a chart actively asserting that their risk framework is worthless.

### 4.8 Rocket Boost is 0.32% of stake

`seed.sql:96` grants boost only when `(bet_id + leg_number) % 23 = 0` — ~4.3% of legs — at $1.00–$6.00 each. Meanwhile `seed.sql:87` marks **20%** of bets as Rocket (`Copied Rocket Bet` or `Non Copied Rocket Bet`). So a fifth of the book is flagged as Rocket while almost none of it receives a boost.

Fix: tie boost to `rocket_category` so Rocket bets are the ones that get boosted, and size it as a percentage of stake rather than a flat dollar band. **The right percentage is a question for the user** (§6) — it is a product-economics assumption, not a data-generation detail.

### 4.9 Dividend is decorative

`seed.sql:168` — uniform 1.05–8.00 hash, unrelated to payout, result, or margin. Resolved as a side effect of the §3 rewrite, and required before the parent audit's actual-vs-expected-margin recommendation can be built.

---

## 5. Constraints that must survive the regeneration

`clients/dabble/database/assertions.sql` exists and must still pass. Its checks are structural, not value-range, so a regeneration will not break them *if* these hold:

| Constraint | Source |
|---|---|
| `gross_win = cash_stake − cash_payout + rocket_boost` | `assertions.sql:32` |
| `trading_net_win = gross_win − brg` | `assertions.sql:33` |
| `fact_bet` totals must equal the sum of their `fact_bet_leg` rows across **all 14 financial columns** | `assertions.sql:60-61` |
| `fact_user_day` must reconcile to `fact_bet` | `assertions.sql:89-90` |
| Leg counts 1 through 25 must all be present | `assertions.sql:100` |
| At least one user with `risk_factor` between 0.91 and 0.99 | `assertions.sql:107` |
| PII-safe schema — generated IDs and aliases only, no real customer data | `assertions.sql:117` |

Also preserve:

- **Determinism.** No `random()`. `README.md` documents the dataset as reproducible.
- **Leg-level additivity.** The whole semantic layer depends on financials being allocated to legs so sport, fixture and market totals stay additive. This is stated in the dataset description and in every dashboard disclaimer.
- **The five recognisable July 2026 fixtures** (`seed.sql:51-63`) — they exist so the demo has real-looking AFL/UFC fixture names near "today".
- **The 24 sport names and 16 market groups** — these mirror Dabble's actual taxonomy from the supplied report screenshots. Do not invent new ones.

---

## 6. Open questions — resolve with the user before generating

1. **Dataset scale — A, B or C from §4.4?** Determines seed runtime, Neon storage, and how the demo is framed. Recommend A.
2. **Target margins.** Confirm racing ~14% / sport ~9% / novelty wider, or get Dabble's real figures if they have been shared. These drive `target_margin` directly.
3. **Rocket economics.** What should boost cost as a percentage of Rocket-bet stake? Currently 0.32% of total stake, which implies the flagship product barely exists. This is a positioning question as much as a data one.
4. **Cohort support.** `AGENTS.md` names cohort analysis as a requirement. Should signup dates be spread across the full 2024–2026 window with realistic retention decay so a cohort demo is actually possible? This is additional scope beyond fixing plausibility, but it unlocks a named buying criterion — worth raising even if the answer is "later."
5. **Should Boxing and Ice Hockey stay loss-making**, just plausibly so (say −3% to −8%)? A couple of genuinely underperforming sports makes the Sport Profitability Map's "price review" quadrant meaningful instead of empty. Recommend yes, mildly.

---

## 7. Suggested sequence

1. Resolve §6 with the user.
2. Fix the AML `case` gaps in `dabble_fact_bet.model.aml:70-87`. Independent of everything else — do it first, it is small.
3. Rewrite `seed_finance` per §3: join `dim_user`, pick dividend, derive win probability, derive payout. Keep it deterministic.
4. Replace the uniform distributions: risk factor (§4.6), stake magnitude and shape (§4.3), user-to-bet assignment (§4.6).
5. Retie Rocket boost to `rocket_category` (§4.8).
6. Scale volumes per the §6 decision.
7. Run `clients/dabble/database/seed.sql`, then `assertions.sql`. All assertions must pass.
8. Verify with the queries in §8.
9. Update the disclaimer text in both dashboards if any documented assumption changed.
10. Re-check the parent audit's Appendix A tables — they contain the old figures and will be stale.

---

## 8. Verification

After regenerating, run these and check against the target column. Use `holistics mcp execute_aql` from the **project root** (`/Users/vincentwoon/repos/work/demo4`) — running it from a subdirectory makes the CLI treat that directory as the project root and every dataset reference fails to resolve.

```
echo '{"dataset_uname":"dabble_trading","title":"Seed sanity check","refresh_cache":true,
"aql":"explore { measures { actives: actives, bets: bets, stake: combined_stake, gwp: gross_win_pct, avg_bet: avg_bet_size, boost: rocket_boost, div: weighted_dividend } }"}' \
  | holistics mcp execute_aql
```

| Check | Target | Currently |
|---|---|---|
| Blended Gross Win % | 11–15% | 25.0% |
| Avg Bet Size | $15–25 | $104.31 |
| Turnover / yr | per §6 decision | $3.7M |
| Rocket Boost as % of stake | per §6 decision, visibly non-trivial | 0.32% |
| Bets per active | 15–40/yr, **varying** | exactly 30.00, uniform |
| Worst sport margin | mildly negative | −74.8% |
| `Other / Unclassified` bucket | should not exist | 10.7% of turnover, 45.7% margin |
| Margin by risk bracket | monotonic or at least coherent | random |
| Bets per risk bracket | skewed | exactly 7,500 each |
| `weighted_dividend` | consistent with realised margin | unrelated noise |

Then re-run the two grouped queries whose full output is recorded in the parent audit's Appendix A.2 (sport level) and A.3 (risk bracket) and confirm both tables now read plausibly.

---

## 9. Out of scope

Everything in the parent audit outside §1 — dashboard layout, chart type changes, the `BubbleChart` rework, tab order, copy edits. Those are independent and can proceed in parallel; none of them depend on this issue being closed, though several will *look* better once it is.

One dependency runs the other way: the audit's §4.6 recommendation (actual vs expected margin, the single highest-value analytical addition) **cannot be built until §3 and §4.9 here are done**, because it needs `weighted_dividend` to be a real quantity.
