---
name: sql-to-semantic
description: >-
  Convert a complex SQL query that currently powers a report in another BI tool into a Holistics
  semantic layer — models, relationships, and dataset metrics — plus an exploration that reproduces
  the original report for offline parity checking. Use whenever a customer asks how to turn a SQL
  query or a SQL-based report into Holistics data models, pastes a large query and asks what it
  would look like in Holistics, is migrating off Looker / Tableau / Power BI / Metabase /
  QuickSight, or has an existing project with business logic trapped in query models that should be
  decomposed. Also trigger on 'convert this SQL', 'migrate this query', 'turn this query into
  models', 'SQL to semantic layer', 'how do I model this query', 'decompose this query', 'replace
  this query-based report', or 'can Holistics do what this query does'.
---

# SQL to semantic layer

A complex BI SQL query is a **report-shaped artifact** — denormalized, pre-filtered,
pre-aggregated, with the grain already collapsed. A dimensional model is the opposite: reusable,
grain-preserving, composable. So this is a **decomposition problem, not a translation problem**.

The failure mode this skill exists to prevent is wrapping the query in a query model, hanging a few
dimensions off it, and calling it converted. That output validates, returns the right numbers, and
teaches the customer that Holistics is a SQL runner with charts. Customers ask this question while
deciding whether the modelling layer is worth paying for. A query model answers "no".

**Scope is narrow on purpose: SQL in, semantic layer out.** This skill only knows how to start from
a query. For general warehouse modelling with no query to start from, use `scaffold-semantic-layer`.

Follow `AGENTS.md`: develop AML with the holistics CLI/MCP, and run `holistics aml validate` after
every new or edited AML file. Client work stays inside `clients/<company>/` and is namespaced.

## Rules

1. **Decompose. Never wrap.** There is no lift-and-shift fast path and no flag to enable one.
   Every construct in the source SQL gets an explicit placement and a one-line reason.

2. **The dataset metric is the default home.** Not the report layer, not a model measure. Any
   named, reusable, derived or aggregate business logic is a dataset metric unless there is a
   reason it cannot be.

3. **The report layer is a whitelist, not a fallback.** Only these belong there: ad-hoc
   exploration, filters, conditions, and advanced conditions. Everything else has a home further
   down.

4. **A SQL query model is for what AQL genuinely cannot express — and you must prove it.**
   Before demoting any construct, attempt the AQL and check it with `validate_aql`. Only a real
   failure justifies the demotion. Record every verified failure in
   `references/aql-capability-matrix.md`. Holistics publishes no capability boundary, so the matrix
   is a prior, never an authority.

5. **Metrics live in the dataset, not as measures buried in fact models.** This is a deliberate
   divergence from the public modeling-patterns docs; do not "correct" it back. AQL references
   model dimensions directly, so a model measure is usually an extra object with no owner that
   cannot span models. **Carve-out:** create a model measure when the same computation feeds two or
   more metrics, or when it is model-local and non-trivial enough that inlining duplicates real
   logic. The metric then references it.

6. **Hardcoded literals in a WHERE clause are report artifacts until proven otherwise.**
   `status = 'completed'` and `region = 'APAC'` look identical in SQL and are usually different
   things. Appears once and scopes this report → report filter. Repeated across CTEs, or true for
   every future consumer → model filter.

7. **Never invent a table, column, or key.** Every name you write must have been read from the
   source, a DDL, or an existing model. A model over a column that does not exist fails validation
   at best and silently returns nothing at worst.

8. **Every model states its grain and how the grain was established.** Tag each one `reused`,
   `profiled`, `declared`, `inferred`, or `asserted-by-user`. Anything tagged `inferred` blocks any
   parity claim you would otherwise make.

9. **Pick and flag. Do not stop and ask mid-decomposition.** Where a placement is genuinely
   ambiguous, choose, and write one concise line saying what you chose and why. Questions are
   batched into a single round (step 3), never drip-fed.

10. **Validation is offline.** Never run parity checks against a live tenant during a session. Emit
    a re-validation checklist and let a human run it afterwards, impersonating the client account.

11. **Reuse beats creation.** Inventory the existing project before proposing any model. The
    seventh query a customer converts should be accreting a semantic layer, not generating a
    seventh copy of `dim_customer`.

12. **Do not guess AML syntax.** Use `develop-amql` to author and `search-docs` for any feature
    question.

## Procedure

### 1. Probe and scope

Establish what you can actually do before promising anything:

| Check | Consequence if absent |
| --- | --- |
| AML project + `holistics aml validate` | You cannot ship validated AML; produce the conversion record only |
| Holistics MCP against the tenant | No `validate_aql`, so rule 4 degrades to the static matrix |
| An existing dataset covering the source tables | No profiling, no `execute_aql`; grain becomes `inferred` |
| Source dialect named | Dialect-specific functions get mistranslated silently |

State which tier you are in. Do not narrate a capability you do not have.

**The MCP is dataset-scoped.** `execute_aql` needs a `dataset_uname`; `fetch_sample_data` and
`lookup_values` need a dataset *and* a model. There is no raw-SQL execution path, so you cannot
profile source tables before they are modelled, and **you cannot run the customer's original SQL
through the MCP at all.** Plan the parity check around that (step 8), do not discover it late.

### 2. Normalize and inventory the SQL

Queries arrive pasted through Slack, chat, or email and arrive mangled. Normalize first, off-call:
fix whitespace and smart quotes, strip the pager artifacts, and **name the source dialect
explicitly**.

Dialect matters more than it looks. T-SQL `DATEPART(WEEKDAY, …)` depends on `SET DATEFIRST`, so
week boundaries silently differ on the target warehouse. Record every dialect-specific function you
encounter and what it maps to.

Then build the **construct inventory** — one row per construct, nothing skipped:

| Construct | Where it appears | Proposed home | Confidence | Why |

Read `references/construct-catalog.md` before classifying. It carries the seeded patterns with
worked before/afters. Anything you cannot match to a catalog entry goes into the
**unrecognised constructs** section of the output *and* gets appended to
`references/patterns-inbox.md`. A catalog with no inbox is a catalog frozen at v1.

### 3. One batched clarification round

Derive the unknowns from the inventory, then ask them **all at once**. A skill that interrogates a
customer one join at a time gets abandoned at question four.

Ask about intent, lightly — this is a prompt, not a gate. Proceed with stated assumptions if
nobody answers:

1. **Consumption** — scheduled export, interactive dashboard, or ad-hoc? A `GETDATE()` run
   timestamp column and `ISNULL(x,'')` blanking both mean the output lands in Excel.
2. **Audience and the decision** it drives.
3. **Column liveness** — which output columns are actually used. On a wide extract, expect a third
   to be vestigial.
4. **Tenancy** — is a tenant discriminator a security boundary or a legitimate join key? See the
   reframe note in step 5.
5. **Filter provenance** — per hardcoded literal: business truth, data quality, or report scope?
6. **Grain confirmation** — one row per what, and is the output expected to be unique on it?
7. **Known wrongness** — does anyone already suspect this query is wrong? The answer is often yes,
   and it changes whether parity is even the goal.

### 4. Resolve grain and cardinality

Grain cannot be read off SQL text. The SQL tells you what the author believed, which is evidence,
not truth. Sources in descending reliability: an existing model, warehouse profiling through an
existing dataset, declared constraints, inference from `GROUP BY` / `DISTINCT` / `row_number() = 1`,
and finally a human.

Per join, produce an explicit cardinality verdict before it becomes a relationship. Two things
that silently produce wrong numbers that still execute:

- **Fan-out.** Joining a header to its lines multiplies the header's additive facts. Know which
  side you are aggregating before you declare anything. If the source SQL sums a header-level
  column across a line-level join, the original query is already wrong — say so rather than
  reproducing or silently fixing it.
- **Non-unique dimension keys.** A `primary_key: true` that has duplicates fans out every join into
  it. `holistics aml validate` will not tell you.

**Composite keys.** Relationships are equi-join only and cannot be composite. A multi-column join
needs a `concat(a, b)` compound-key dimension on both sides.

**Before you build eleven compound keys, ask the tenancy question.** A discriminator appearing in
every join predicate of a multi-tenant platform is usually a **security boundary**, and in
Holistics that is a row-level permission, not a join key. Getting it wrong ships either a
cross-tenant leak or a pile of dimensions nobody needed. This is a **note, not a rebuild** — flag
it prominently, keep converting what was asked for.

### 5. Place every construct

Apply the placement table. Every construct lands somewhere, including "dropped".

| Destination | What goes there |
| --- | --- |
| **Dataset metric** | **Default.** Any named, reusable, derived or aggregate business logic |
| Model dimension | Row-level attributes |
| Model measure | Only per the rule 5 carve-out |
| Model filter | Repeated across CTEs, or true for every consumer |
| **Report / viz** | **Only:** ad-hoc, filters, conditions, advanced conditions |
| Viz field formatting | Presentation — date formats, number formats |
| SQL query model | Only what `validate_aql` proves AQL cannot express |
| Dropped | Report artifacts with no destination |

Three placements agents reliably get wrong:

- **Presentation logic moves, it does not vanish.** `FORMAT(d,'yyyy-MM-dd')` becomes viz field
  formatting. `CONVERT(VARCHAR, CAST(score AS INT))` gets dropped *as a cast* — never leave a
  numeric cast to text, it destroys aggregation — but the field still needs its format set. Only
  genuinely dead things get dropped outright: a `GETDATE()` run-timestamp column, `ISNULL(x,'')`
  blanking that destroys the null semantics filters rely on.
- **Derived date parts collapse.** Six columns computed from one timestamp (year, month name, month
  start, week number, week start, time-of-day) become **one date dimension plus granularity**. This
  is usually the most visible win in the whole conversion; call it out.
- **The same table joined N times with different filters** becomes **one relationship plus filtered
  measures**, not N relationships. Holistics does rank ambiguous paths and you *can* use
  `relationship(..., false)` with `with_relationships()` — reserve that for genuinely different
  roles of one dimension (`user_city` vs `merchant_city`), not for "same table, different filter".
  Filtered measures keep the dataset surface small; `with_relationships()` pushes join mechanics
  back into the report layer, which is what the semantic layer is supposed to absorb.

### 6. Build the models

Bottom-up, and only what this query touches. A 200-table warehouse does not become a 200-model
project.

1. **Query models** over raw tables where extraction is genuinely needed — the sanctioned SQL.
2. **Table models** for tables that are already clean.

Per model: `label`, a `description` stating the grain and its provenance tag, `data_source_name`,
`owner`, every dimension explicitly typed. Hide plumbing columns with `hidden: true` rather than
dropping them. Classify each model fact or dimension and name it accordingly — that classification
decides join direction. Relationships point fact → dimension, many-to-one; the reverse is an error,
not a style choice.

Keep source column names unless actively misleading. Renaming into invented business terms before
you know the customer's vocabulary is churn that breaks every reference you already wrote.

### 7. Build the dataset, and verify before demoting

One dataset per coherent analytical subject. Declare relationships active with no
`filter_direction` unless you have a documented reason.

Then write the metrics. **This is where rule 4 gets exercised.** For every construct the inventory
marked as a demotion candidate:

1. Write the AQL you think might not work.
2. Run `validate_aql`.
3. Passes → it is a dataset metric. The matrix entry was stale; update it.
4. Fails → demote to a SQL query model, record the verbatim failure in
   `references/aql-capability-matrix.md`.

Check SQL passthrough before demoting. `agg_text('STRING_AGG', …)` and friends mean "no native AQL
function" does not imply "needs a SQL model".

### 8. Reproduce the report as an exploration

The deliverable is an **exploration** that returns the original report's columns. Not a
`.page.aml` dashboard.

This is also the parity artifact, and per rule 10 it is checked offline: someone impersonates the
client account, runs the exploration and the original SQL against the same warehouse, and diffs
row count, totals per measure, and a spot-check of the widest grain. Emit the checklist; do not run
it live.

Reproduce before you improve. Where the intent round surfaced a wanted improvement the original
query could not do, list it as a follow-up — do not substitute it for the reproduction.

### 9. Validate

Mechanical, and it gates the work:

1. `holistics aml validate` passes.
2. `list_datasets` returns the dataset.
3. One real `execute_aql` crossing at least one relationship.

Report the actual result. Never claim a validation you did not run.

## Output — `docs/sql-conversions/{report-slug}.md`

```markdown
# SQL conversion — {report name}

**Converted:** {date} · **Source dialect:** {dialect} · **Tier:** {from step 1}
**Original:** {where the query came from, and what tool ran it}
**Grain:** {one row per …} · **Provenance:** {reused / profiled / declared / inferred / asserted}
**Parity:** {verified / pending offline re-validation / blocked — inferred grain}

## Summary
{3–5 sentences: what now exists, what the report became, the biggest risk carried forward.}

## Construct inventory
| Construct | Where in the SQL | Home | Confidence | Why |
{every construct. Nothing omitted. This table is the artifact the customer argues with,
and every argument it enables is a scoped disagreement instead of "the numbers are wrong".}

## Dropped as report artifacts
| Construct | Why it has no home |

## AQL verification log
| Construct | AQL attempted | validate_aql result | Outcome |
{every demotion candidate from step 7. A demotion with no row here is not justified.}

## Models built
| Model | Type | Source table | One row is | Key | Grain provenance |

## Relationships
| From | To | Key | Cardinality | Aggregate side | Compound key? | Verdict source |

## Dataset and metrics
| Metric | Definition | Backed by model measure? | Source construct |

## Exploration
{the AQL, and the column mapping from the original SELECT list}

## Assumptions to confirm
{one concise line each, per rule 9. Anything that would change the numbers goes first.}

## Reframes noted, not applied
{platform-native alternatives found and deliberately not built — row-level permissions instead of
tenant join keys, date drills instead of derived date parts. Scope stays: replace the report.}

## Unrecognised constructs
{anything the catalog could not classify. Also appended to references/patterns-inbox.md.}

## Offline re-validation checklist
{the parity steps someone must run against the client account, in order}

## Validation
{`holistics aml validate` result · `list_datasets` output · smoke query, verbatim}

## Follow-ups
{improvements the original query could not do, surfaced by the intent round}
```

## Handing off

The conversion record is the deliverable, not the AML. It is what makes a review meeting a
walkthrough of a finished artifact instead of a live decomposition under time pressure — which is
the actual value of this skill. Generating AML faster is incidental.

Where a customer is converting several reports, the second one should reuse the first one's models.
Read the existing conversion records before starting; the whole point is accretion.

If the engagement is broader than one report — business context, metric governance, a metric tree —
this skill is the wrong entry point. Use `new-analytics-onboarding`.

## Anti-patterns

- **Wrapping the query in a query model and adding dimensions.** It validates, the numbers match,
  and it demonstrates that the modelling layer is optional. This is the failure the skill exists to
  prevent.
- **Demoting to SQL without running `validate_aql`.** A stale matrix entry then exiles that logic
  into a query model permanently. The more query models a project has, the more fragmented its
  business definitions are.
- **Reading grain off the SQL.** The SQL records the author's beliefs. Two identical-looking queries
  differ by whether the summed column is header-level or line-level, and only one of them is right.
- **Baking the report's WHERE clause into the model.** Over-modelling is silent and permanent;
  pulling a filter out of a model four dashboards depend on is not a small edit.
- **Building compound keys for a discriminator that is actually a permission.** Eleven compound-key
  dimensions where one row-level rule belonged, or worse, a cross-tenant leak.
- **Translating presentation logic instead of relocating it.** Deleting `FORMAT()` calls without
  setting the viz field format ships a report the customer immediately notices is uglier.
- **Reproducing six derived date columns as six dimensions.** They are one date dimension. Shipping
  six is shipping the old tool's limitations into the new one.
- **N relationships for a table joined N times with different filters.** Filtered measures. The
  join mechanics belong in the semantic layer, not back in the report.
- **Asking the intent questions one at a time.** The customer stops answering at question four.
- **Asking the intent questions and then not acting on the answers.** A stated requirement that
  lives only in the conversation does not survive into the output. Put it in the record.
- **Running parity checks live during a session.** Large queries take minutes; the session becomes
  dead air and the demo dies. Offline, with a checklist.
- **Claiming parity on an `inferred` grain.** The assumption is fine. Silence about it is not.
- **Shipping without the unrecognised-constructs section.** An empty catalog inbox after a real
  customer query means the classification was lazy, not that the catalog was complete.
