# Routing table — where each kind of context belongs

The reference classifier for `route-context-artifacts`. Also usable standalone in a call: it is
the fastest way to explain to a customer why their good document underperformed.

## The enforcement hierarchy

Holistics AI reads several layers with **different enforcement strength**. This is the whole
reason routing matters:

| Layer | Strength | Read when |
| --- | --- | --- |
| `metric.definition` | **Enforced** — the AI computes with it | Every query touching that metric |
| `metric.description`, `dataset.description`, `model.description`, field descriptions | **Ground truth** — treated as authoritative | Whenever that object is in scope |
| Tags (`Endorsed` / `Archived`) | **Respected** — steers source selection | Dataset selection |
| AI Skill | **Loaded on demand** | When the request matches the skill description |
| `context.aml` custom context | **Suggestion** — may be honoured or dropped | Every query |

A definition written as prose in `context.aml` can still produce a wrong-formula answer. The same
definition as a `metric` cannot. **Prose is a suggestion; a governed object is enforcement.**

## The six tests, in order

First match wins.

| # | Test | Signal | Destination |
| --- | --- | --- | --- |
| 1 | Is it a number that will change? | A target, price, budget, headcount, current performance figure, catalogue contents | **Discard** — replace with a pointer to governed data |
| 2 | Does it contain or imply arithmetic? | `÷ / × % + -`, "divided by", "per", "ratio", "sum of", "net of", "gross of", "excluding", "including", "minus", "expanded to", "adjusted for", "counts only", "where status =" | **`metric`** — prose → `description`, arithmetic → `definition` |
| 3 | Is it a multi-step procedure? | Steps, defaults-then-exceptions, a checklist, "how we analyse X" | **AI Skill** |
| 4 | Does it apply to one object only? | Channel-specific rule, what one dataset is for, one source's coverage caveat | **That object's `description`** |
| 5 | Is it org-wide orientation? | Business overview, segments and do-not-blend, timezone/currency/week, trust hierarchy, house style, answer shape | **`context.aml`** |
| 6 | Anything left? | Genuinely ambiguous | **`unrouted`** in the routing map, with an owner |

## Worked routing of a typical context document

The section list below is what a well-written customer context doc actually contains. Note how
little of it belongs in `context.aml`.

| Original section | Destination | Test | Why |
| --- | --- | --- | --- |
| Business overview | `context.aml` | 5 | Org-wide background |
| How the business grows / segments | `context.aml` | 5 | Orientation needed everywhere; carries the do-not-blend rule |
| Customers and occasions | `context.aml` | 5 | Background; guards against collapsing every customer into one label |
| Product hierarchy / classification | Product model `description` | 4 | A classification rule belongs on the object that carries it |
| **"Core unit sold" definition** | **`metric` `definition` + `description`** | **2** | Bundle expansion, exclusions, gross/net/paid/free — this is a formula |
| Commercial priorities / trading view | Trading dataset `description` | 4 | Describes what that dataset is for |
| Channel rules and caveats | One `description` per channel dataset | 4 | Per-dataset interpretation |
| Markets, currency, time conventions | `context.aml` | 5 | Cross-cutting conventions |
| **Metric interpretation** | **`metric.description` fields** | **2** | The heart of it — every rule here is a definition |
| Cohort analysis rules | AI Skill | 3 | A repeatable procedure with defaults |
| Promotions and incrementality | AI Skill | 3 | A checklist-driven workflow |
| Operational / diagnostic context | Ops model `description` + short note in `context.aml` | 4/5 | The checklist ties to ops models |
| Data sources and trust hierarchy | `context.aml` + tags | 5 | Trust is partly encoded via tags the AI already respects |
| Common analytical traps | AI Skill, or `context.aml` tail | 3/5 | Cross-cutting do-not-do list |
| How to answer questions | `context.aml` | 5 | Global response style |
| Default question interpretations | `context.aml`, but **prefer fixing metric names** | 5 | A translation table is a workaround; the real fix is naming metrics the way the team speaks |
| Current strategic reference points | `context.aml` framing only; **figures discarded** | 1/5 | The north-star *concept* stays; the target *value* must be retrieved live |

**The load-bearing observation:** the product-hierarchy, channel-rules, and metric-interpretation
sections are typically ~40% of a context document, and all three are the wrong thing to keep as
prose. Encode them and the AI applies them automatically on every query — you stop needing to
repeat the rule, and a wrong-formula answer becomes impossible.

## What `context.aml` may and may not say

| May | May not |
| --- | --- |
| "Use the governed `net_revenue` metric; always state gross vs net" | "Net revenue = gross revenue − refunds − tax" |
| "Never sum two currencies without governed FX conversion" | "Convert at 1.34 SGD/USD" |
| "The north star is bottles sold, supported by repeat rate" | "The 24-month LTV:CAC target is 3×" |
| "Do not blend UK and US results without stating the mix" | "UK is 70% of revenue" |
| "Prefer endorsed datasets; finance wins for recognised revenue" | "Use table `fct_orders_v2`" |

The line: `context.aml` says **which** metric to use and **what to state alongside it**. It never
says **how to compute it**, and it never states a value.

## The default-interpretation trap

Teams reach for a "when the user says X, interpret it as Y" table. It works, but it is a
workaround — it lives in the suggestion layer and it needs maintaining forever.

The durable fix is **naming metrics in the customer's own vocabulary**. If the team says
"bottles", the metric is `bottles_sold`. If they say "scans", it is `scans_completed`. When the
governed metric is named the way people speak, the AI reaches for it without translation and the
table shrinks to genuine edge cases.

Keep a small table for period shorthand ("last week" = previous completed week) and for words that
are irreducibly ambiguous. Do not use it as a substitute for good metric names.

## Rollout order (fastest payback first)

1. **Trim the overview** into `context.aml`. Immediate, and it stops the monolith crowding out
   everything else.
2. **Encode the metric-interpretation section** as governed metrics. Highest leverage by a wide
   margin — this is where wrong answers come from.
3. **Add dataset descriptions** for the channel/segment rules, and tag endorsed sources.
4. **Write 2–3 AI Skills** for the recurring procedures.
5. **Point local agents at it** — in the customer's repo `AGENTS.md`, instruct agents to fetch org
   context via MCP and to list/load available skills rather than reinventing definitions locally.

## Discard list — never write these into any artifact

Current targets · current prices · budgets · headcount · this period's performance · FX rates ·
catalogue contents · named individuals' compensation · anything that changes on a quarterly cycle.

All of these must be retrieved from governed data at query time. A stale figure quoted
confidently is indistinguishable from a hallucination, and it costs more trust than a missing
answer.
