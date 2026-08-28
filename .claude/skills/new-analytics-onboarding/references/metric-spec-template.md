# Metric specification template

One file per metric under `04-metric-specs/{metric_name}.md`. The spec is the source for the AML
`metric` block, and the **Description** field below is written to be pasted verbatim into
`metric.description` — on any given query that description may be the only thing the AI reads
about this metric, so write it to stand alone.

---

```markdown
# {metric_name}

**Label:** {Human Label}
**Tier:** T0 | T1 | T2
**Owner:** {name} <{email}>
**Dataset:** {dataset_name}
**Status:** draft | validated | endorsed

## Decision it serves
{Which decision changes when this number moves, and who makes it. If you cannot answer this,
the metric should not be built — record it under "considered and rejected" in the tree instead.}

## Grain
{What one unit of this metric is. One sentence. "One paid subscription-month for one account."}

## Definition
- **Numerator:** {exactly what is summed or counted}
- **Denominator:** {exactly what it is divided by — required for every rate and ratio}
- **Basis:** {gross | net} · {paid | free | total} · {recognised | billed} · {incl | excl tax}
- **Currency:** {base currency, and that conversion goes through the governed FX table}
- **Time basis:** {which date field, and what "as of" means}

## Inclusions
- {the specific rows that count}

## Exclusions
- {the specific rows that do not — free/trial, add-ons, internal/test, gifts, cancelled}

## Derivation notes
{Bundle expansion, identity resolution, dedup rule, how refunds are applied. The mechanics
that make the definition reproducible.}

## Aliases
{Everyday words that should resolve to this metric, from interview Q14: "sales", "topline".}

## Never confuse with
{Near-neighbour metrics and how they differ. Unusually effective at preventing wrong answers —
be specific: "not order-line quantity", "not gross of refunds", "not the platform-attributed
version".}

## Caveats
{Coverage gaps, fragile joins, late-arriving data, history that starts mid-series. Anything
that should qualify an answer. These go into the description verbatim.}

## Known data-quality issues
{`dq-NNN` IDs from `docs/data-quality/`, with one line each on how the issue affects this metric
and whether it is open. Cite the ID *and* state the substance — the in-product AI reads the
description and cannot open a git file, so an ID on its own tells it nothing.}

## Source models
{Which models this reads, so the dependency is traceable.}

## Format
{e.g. "[$$]#,###0.00" · "#,###0.00%" · "#,###"}

## Reconciliation
{What known number this was spot-checked against, the result, and any explained gap.}

## Description (paste into `metric.description`)
> {The self-contained prose. Basis, scope, exclusions, never-confuse-with, caveats. Written for
> a reader with no other context. Verbose is correct here.}

## AML
```aml
metric {metric_name} {
  label: '{Human Label}'
  type: 'number'
  description: '''{the Description above}'''
  definition: @aql {...} ;;
  format: "{format}"
}
```

## Open questions
{each with a named owner}
```

---

## Notes on filling this in

**Numerator and denominator are not optional.** "Retention" is not a definition. If a metric has
no denominator because it is a straight count, say so explicitly rather than leaving the field
blank — a blank field reads as an oversight.

**Composite metrics reference other metrics.** Write `safe_divide(net_revenue, valid_orders)`,
not a fresh sum over raw fields. Two metrics independently summing the same revenue will drift
apart within a quarter, and nobody will notice until they disagree in a board deck.

**Guard against NULL poisoning.** Wrap components in `coalesce(..., 0)` where a NULL would
propagate through arithmetic and silently void the result.

**Never hardcode an FX rate or a target.** Functional thresholds needed for the query to run are
logic and stay; a currency rate or a business target is a figure that will go stale.

**"Never confuse with" earns its place.** It is the field that most often prevents a
plausible-but-wrong answer, because near-neighbour confusion is how the AI fails when everything
else is right. Name the specific neighbours.

**Validate before marking status.** Nothing moves past `draft` without `holistics aml validate`
passing, and nothing reaches `endorsed` without a reconciliation result recorded above.
