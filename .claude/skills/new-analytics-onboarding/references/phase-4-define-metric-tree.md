# Define the metric tree

Metrics are the enforcement layer. Everything else in this engagement is orientation; this is
the part the AI cannot ignore. A definition encoded as a governed metric is applied on every
query. The same definition written as prose is a suggestion the AI may drop.

Input: `03-business-context-raw.md` (especially the **Metric candidates** section) and
`02-data-inventory.md` (the answerability ledger). Read both.

## The architectural rule

**Metrics are first-class citizens of datasets, not measures buried in models.**

- **Models** expose dimensions and raw additive facts.
- **Datasets** compose them into named, formatted, described **metrics** — which is what lets
  a metric span models.

Do not bury a reusable business metric as a per-model measure. A metric locked inside one
model cannot be reused across the dataset graph, cannot combine facts from two models, and
is invisible to the AI as a governed concept. Define it in the dataset — which already exists
with a deliberately empty metric section, built in Phase 1:

```aml
metric net_revenue {
  label: 'Net revenue'
  type: 'number'
  description: '...'                       // the basis, scope, and caveats — mandatory
  definition: @aql ... ;;
  format: "[$$]#,###0.00"
}
```

Every metric carries a `description` and an explicit `format`. An empty description is not a
cosmetic omission — it is the AI losing the definition, which is the entire point.

## Rules

1. **Numerator and denominator, always.** No metric ships without both (where applicable),
   stated explicitly. A ratio with an unstated denominator is not a definition.
2. **Every metric names a decision.** If no decision changes when it moves, it does not get
   built. Record it in the "considered and rejected" list instead — that list is a deliverable,
   because it stops the customer relitigating it.
3. **Every metric is answerable.** Cross-check the ledger. A metric the data cannot populate
   is a data-acquisition ask, not a metric. Do not define it and hope. Where the ledger says
   "answerable with caveats", the caveat's `dq-NNN` entry is part of the spec — a metric whose known
   defect is undocumented is worse than no metric, because it will be trusted.
4. **Name in the customer's vocabulary.** `bottles_sold`, not `units_sold`. `scans_completed`,
   not `events`. This is how you make "default question interpretation" unnecessary — when the
   metric is named the way the team speaks, the AI reaches for it without a translation rule.
5. **One default per concept, explicitly.** When three definitions of retention exist, one is
   `retention` and the others get qualified names (`revenue_retention`, `logo_retention_90d`).
   Never leave the default implicit.
6. **Distinguish the cuts and never let them be interchangeable.** Gross vs net, paid vs
   free, recognised vs billed, including vs excluding tax. Where more than one cut matters,
   define each as its own metric and state in every description that they are not
   substitutes.
7. **No hardcoded FX, no hardcoded targets.** Currency conversion goes through a governed FX
   table. Targets are retrieved from planning data at query time. A rate or target frozen into
   a definition is a wrong number waiting to happen.
8. **Composite metrics reference other metrics** rather than recomputing from raw fields.
   `aov` is `net_revenue ÷ valid_orders`, referencing both — not a fresh sum. This is what
   keeps the tree consistent when a base definition changes.
9. **Tier ruthlessly.** T0 is 5–8 metrics. Not 20.

## Procedure

### 1. Establish the north star

One metric. It should be the thing the business would optimise if it could only see one
number — usually close to the core commercial unit from interview block D, or its value
equivalent.

Test it: does it move for good reasons and stay flat for bad ones? A north star that goes up
when the business gets worse (raw signups when they don't convert, gross revenue when refunds
climb) is the wrong choice. Pair it with the quality measure that keeps it honest.

### 2. Decompose into drivers, MECE

Build a tree. Each level must be **mutually exclusive** (no double-counting) and
**collectively exhaustive** (the children account for the parent). Decompose multiplicatively
or additively — whichever reflects how the business actually operates:

```
Net revenue
├── New business
│   ├── Volume:  leads × qualification rate × close rate
│   └── Value:   average contract value
└── Existing business
    ├── Retention:  logo retention × ...
    └── Expansion:  seat growth × price realisation
```

Two tests per node:

- **The sum test.** Do the children actually reconstruct the parent? If not, name what's in
  the residual. An unexplained residual is either a missing driver or a grain error.
- **The lever test.** Is there a team that owns this node and can move it? A driver nobody
  owns is a description, not a driver.

Stop decomposing when you reach something a team acts on weekly. Going deeper produces
metrics nobody looks at.

### 3. Add guardrails

Drivers are what you push. Guardrails are what must not degrade while you push. Every
optimisation target needs one, or the business optimises itself into damage — the "strategic
don't" from interview block H, made measurable.

Blended efficiency ratios are usually the honest guardrail where per-channel attribution
overlaps. Where several attribution sources exist, mark platform-attributed metrics as
**diagnostics, not guardrails**, and state in the description that attributed values must
never be summed across sources and presented as incremental impact.

### 4. Specify each metric

Use `metric-spec-template.md`. Every T0 metric gets a full spec. The fields that
carry the most weight in practice:

| Field | Why it matters |
| --- | --- |
| **Grain** | What one unit of this metric is. Wrong grain is the most common metric bug. |
| **Numerator / denominator** | Non-negotiable for rates and ratios. |
| **Inclusions / exclusions** | The specific rows in and out. This is what stops the AI reconstructing a near-miss version. |
| **Default cut** | Gross or net, paid or free, recognised or billed. Stated, not assumed. |
| **Aliases** | The everyday words that should resolve to this metric — from interview Q14. |
| **Caveats** | Coverage gaps, fragile joins, late-arriving data. Goes into the description verbatim, citing the `dq-NNN` entry behind it — state the caveat in full as well, since the in-product AI cannot open a git file. |
| **Never confuse with** | The near-neighbour metrics it gets mistaken for. Unusually effective at preventing wrong answers. |
| **Owner** | A named human. Whoever owns the metric owns its description. |
| **Source models** | Which models it reads, so the dependency is traceable. |

Write the `description` as if it is the only thing the AI will read about this metric —
because on any given query it may be. Include the basis, the scope, the exclusions, and the
"never confuse with". Terseness is not a virtue here.

### 5. Tier and sequence

| Tier | Contents | Rule |
| --- | --- | --- |
| **T0** | 5–8 metrics: the north star, its top drivers, the primary guardrail | Ship first. These must be perfect. |
| **T1** | Second-level drivers and secondary guardrails | Ship after T0 verifies clean. |
| **T2** | Diagnostics, long-tail, nice-to-have | Backlog. Named so they aren't reinvented. |

Sequence T0 by **leverage ÷ effort**: a metric that resolves three ambiguous words at once
and reads from one clean model goes first. Metrics needing new modelling go later regardless
of importance.

Resist the pull to expand T0. A customer who trusts six metrics will ask for the seventh
themselves. A customer handed twenty trusts none of them.

### 6. Reconcile against reality

Before declaring the tree done:

- **Spot-check each T0 metric against a known number.** Run it and compare to whatever the
  customer currently trusts — a finance report, an existing dashboard. Where it differs,
  explain the gap. An unexplained difference is a bug in the definition, not a rounding issue.
- **Validate.** Use `develop-amql` to author and `holistics aml validate` (or `validate_aql`)
  to check. **Do not report a metric complete without running validation, and report the real
  result.** Never claim a green validation you did not run.
- **Check the alias coverage.** Every ambiguous word from interview Q14 should now resolve to
  exactly one T0 or T1 metric. Words that resolve to nothing are gaps; words that resolve to
  two are unresolved defaults.

## Output

### `04-metric-tree.md`

```markdown
# Metric tree — {Company}

## North star
{metric, why, and the quality measure that keeps it honest}

## Tree
{the decomposition, with the sum test and lever owner noted per node}

## Guardrails
{what must not degrade, and against which target basis}

## Tiering
{T0 / T1 / T2 tables with sequence and effort}

## Alias map
{everyday word → governed metric. From interview Q14. This is the section customers
find most immediately useful.}

## Considered and rejected
{metrics deliberately not built, and why — usually failed the so-what test or the
answerability check}

## Data-acquisition asks
{metrics that need source data that does not exist yet}

## Open definitional decisions
{where the business must choose between two definitions. Named owner, and the
consequence of each choice.}
```

### `04-metric-specs/{metric_name}.md`

One file per T0 and T1 metric, per the template.

## Anti-patterns

- **A tree that is really a list.** If nothing decomposes into anything, you have a glossary.
  Glossaries are useful, but they do not tell the AI how the business connects.
- **Defining metrics the data cannot produce.** Check the ledger. Every time.
- **Twenty T0 metrics.** This is the most common failure and it reliably kills adoption.
- **Formulas that duplicate rather than reference.** Two metrics independently summing the
  same revenue will drift apart within a quarter.
- **Descriptions that restate the label.** "Net revenue: the net revenue." Say the basis, the
  exclusions, and what it is not.
