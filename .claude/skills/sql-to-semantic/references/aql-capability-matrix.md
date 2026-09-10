# AQL capability matrix

**Holistics does not publish a "what AQL cannot express" list.** The placement rule in SKILL.md
rule 4 depends entirely on one, so this file exists. It is a **prior, never an authority.**

## How to use it

1. Look up the construct here for the fast path.
2. **Attempt the AQL anyway** and check it with `validate_aql`.
3. Passes → dataset metric. Update the row below; it was stale.
4. Fails → demote to a query model. Record the verbatim failure below.

Never demote on the strength of a row here alone. A stale entry silently exiles logic into a query
model forever, and query models are what fragment a customer's business definitions. Verifying costs
one round trip; being wrong costs the migration.

## Status vocabulary

| Status | Meaning |
| --- | --- |
| `native` | AQL expresses it directly |
| `passthrough` | Needs a SQL passthrough function (`agg_text`, …). Still a dataset metric, **not** a query model |
| `restructure` | Not expressible as written, but the intent re-expresses in AML (a relationship, a dimension, a different grain) |
| `query-model` | Verified failure. Demotion justified |
| `unverified` | Assumed, never tested. **Treat as unknown and test before relying on it** |

## Matrix

| Construct | Status | Verified | Notes |
| --- | --- | --- | --- |
| Aggregates (`sum`, `count`, `avg`, `min`, `max`) | `native` | 2026-08-17 | `model \| sum(model.col)` |
| Filtered aggregate | `native` | 2026-08-17 | `(model \| sum(x)) \| where(cond)` |
| Conditional expression | `native` | 2026-08-17 | `case(when:, then:, else:)`, used in demo4 dimensions |
| Metric arithmetic | `native` | 2026-08-17 | `gmv - revenue` in `metrics_store.aml` |
| Percent-of-total | `native` | `unverified` | Docs cite `of_all()` as the replacement for window functions |
| Period comparison / prior period | `native` | `unverified` | Docs cite `relative_period()` |
| Running total, rank | `unverified` | — | Docs position AQL primitives over window functions; scope unconfirmed |
| String aggregation | `passthrough` | — | `agg_text('STRING_AGG' \| 'GROUP_CONCAT' \| 'LISTAGG', …)`. Match the **target** warehouse |
| Database-specific functions | `passthrough` | — | Documented escape hatch. Prefer over a query model |
| Multi-column join | `restructure` | 2026-08-17 | Relationships are equi-join only. `concat()` compound-key dimension on both sides |
| Same table joined N times, different filters | `restructure` | — | One relationship + filtered measures. See catalog 1.2 |
| Two paths between the same models | `restructure` | 2026-08-17 | Holistics ranks paths; `relationship(…, false)` + `with_relationships()` override |
| Arbitrary join predicates | `restructure` | — | AQL is relationship-driven, not a free-form join language |
| Latest-record-per-key dedup | `query-model` | — | Grain correction; must precede the model. Catalog 4.1 |
| Range / non-equi join | `unverified` | — | Undocumented. **Test** — a bounded range sometimes re-expresses as an equi-join on a derived bucket key |
| As-of / SCD2 join | `unverified` | — | Undocumented. Test before demoting |
| Self join | `unverified` | — | No free-form join syntax; for period comparison use `relative_period()` instead |
| Recursive CTE | `query-model` | `unverified` | Assumed outside AQL. Log the attempt anyway |
| `PIVOT` / `UNPIVOT` | `query-model` | `unverified` | Assumed outside AQL |
| Sessionization | `query-model` | `unverified` | Assumed outside AQL |
| `UNION ALL` of like shapes | `query-model` | — | One query model + a `source_type` dimension. Catalog 4.5 |

## Verified failures

Append every real `validate_aql` failure. Verbatim error, the AQL attempted, and the date. A
failure with no entry here is a demotion nobody can audit or revisit.

<!-- Format:
### {construct}
**Date:** {date} · **Target warehouse:** {dialect}
**AQL attempted:**
```
{aql}
```
**Error:**
```
{verbatim validate_aql output}
```
**Resolution:** {query model / restructured as … }
-->

_None recorded yet._

## Maintenance

Every AQL release moves the boundary. This file does not update itself from release notes — it
updates from step 7 of the procedure, one verified attempt at a time. A row that has been
`unverified` for a long time is a row nobody has needed, which is fine; a row marked `query-model`
with no entry in the verified-failures section is a bug in how the skill was run.
