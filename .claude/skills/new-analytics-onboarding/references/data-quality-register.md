# Data-quality register — `dq-NNN` convention

Every data-quality issue found in the engagement gets a **numbered, individually-addressable
document** in the customer's project under `docs/data-quality/`, plus a machine-readable index of
what is open.

`profile-warehouse` owns filling this register; `scaffold-semantic-layer` opens entries for
structural defects it cannot fix; every later phase cites entries by ID rather than restating the
problem. Read the orchestrator's **Project `docs/`** section for the folder convention and the
sensitive-figure gate before writing anything here.

## Why numbered issues rather than a findings section

A profiling report that lists twenty problems in prose produces exactly one outcome: the problems
get read once and none of them get closed. Numbering changes three things:

- **A metric caveat can point at a specific ID.** "Excludes orders with no customer (`dq-004`)" is
  traceable; "excludes some orders" is not.
- **Status becomes a property of the issue rather than of somebody's memory.** You can answer "what
  is still open?" without re-reading the report.
- **The register survives the engagement.** The next person to touch a metric finds out why the
  caveat exists, and the customer can close issues after you have gone.

## Layout

```
docs/data-quality/
├── dq-index.yml                              # generated rollup — status of every issue
├── dq-001-orders-null-customer-id.md
├── dq-002-status-casing-variants.md
├── dq-003-subscriptions-no-unique-key.md
└── closed/                                   # optional, once the folder gets unwieldy
```

Filename: `dq-{NNN}-{kebab-slug}.md`. Three-digit zero-padded, slug describing the issue rather than
the table.

**ID allocation rules — these matter more than they look:**

- Allocate the next unused integer. Read `dq-index.yml` first; do not guess from the highest
  filename you happen to see.
- **Never reuse an ID**, even after an issue closes.
- **Never renumber.** IDs get cited in metric descriptions, commit messages, tickets, and Slack
  threads you will never see. A renumber silently redirects all of them.
- Superseding an issue is a new ID plus a `superseded_by` pointer, not an edit in place.

## Per-issue front matter

The front matter is the **single source of truth for status**. It travels with the explanation, so
the two cannot drift apart.

```yaml
---
id: dq-001
title: Orders with a null customer_id cannot be attributed to an account
status: open              # open | closed | deferred | wontfix | superseded
severity: high            # high — corrupts a T0 metric
                          # medium — corrupts a secondary metric or a common cut
                          # low — cosmetic, or affects a diagnostic only
class: referential_integrity
                          # completeness | referential_integrity | identity | grain |
                          # vocabulary | currency | timezone | freshness | duplication |
                          # sign_convention | test_data | late_arrival
opened: 2026-07-30
opened_by: profile-warehouse
closed:                   # date — required when status is closed
owner: dana@customer.com  # a named human. Never a team, never blank.
blocks_metrics: true      # does this stop a metric being trusted today?
affects:
  models: [fct_orders]
  datasets: [revenue]
  metrics: [orders, net_revenue]
  relationships: ["fct_orders.customer_id > dim_customers.id"]
detected_by: aql          # aql | sql | sample_inspection | customer_report
supersedes:
superseded_by:
---
```

`owner` blank is the one field that makes the whole register worthless. An unowned issue closes
never. If nobody will own it, its status is `wontfix` and that is an honest answer.

## Per-issue body

```markdown
# dq-001 — Orders with a null customer_id cannot be attributed to an account

## What we observed
{Shape, not amount. "Roughly one order in eight over the last full year, concentrated before the
2025 checkout migration and rare since." Not the revenue those orders represent.}

## How we detected it
{The actual AQL or SQL, verbatim, so anyone can re-run it and see whether it is still true.
A finding nobody can reproduce cannot be closed with confidence.}

## Why it matters for AI answers
{The specific wrong answer this produces. "Any per-customer metric silently drops these rows, so
revenue-by-segment does not sum to total revenue — and the AI will present both without noticing."}

## Current handling
{What the semantic layer does about it today: excluded, bucketed as `unattributed`, or nothing yet.
This is what the metric description must state.}

## What closing this requires
{The concrete change and who makes it — a backfill, a source-system fix, an identity-resolution
rule, or an accepted business decision to bucket them.}

## Decision needed from the business
{Where closing depends on a judgement rather than a fix. "Do unattributed orders count in total
revenue?" Record the decision and the date once made.}

## History
| Date | Event |
|---|---|
| 2026-07-30 | Opened during Phase 2 profiling |
```

## The index — `dq-index.yml`

A **generated** rollup so status is queryable without opening ten files.

```yaml
generated: 2026-07-30
generated_by: profile-warehouse
counts:
  open: 4
  deferred: 1
  closed: 2
  wontfix: 1
blocking_metrics: [orders, net_revenue]
issues:
  - id: dq-001
    title: Orders with a null customer_id cannot be attributed to an account
    status: open
    severity: high
    class: referential_integrity
    owner: dana@customer.com
    blocks_metrics: true
    affects_metrics: [orders, net_revenue]
    file: dq-001-orders-null-customer-id.md
```

**Regenerate it from the front matter; never hand-edit it.** Two hand-maintained copies of a status
guarantee that one is stale, and the stale one is the one somebody reads. If you change a status,
change it in the issue file and regenerate.

Keep closed issues in the index with `status: closed` rather than deleting the rows — the value of a
closed issue is that it stops being rediscovered and re-litigated in six months.

## Lifecycle

| Transition | What must be true |
| --- | --- |
| → `open` | Reproducible detection query recorded, named owner, severity set |
| → `deferred` | Owner has explicitly decided to live with it *for now*, with a revisit trigger written down |
| → `wontfix` | Accepted permanently. Any affected metric description states the limitation as a caveat |
| → `closed` | Re-ran the detection query and it now returns clean. Evidence pasted into History |
| → `superseded` | A new ID covers it more precisely; `superseded_by` set both ways |

**Do not close an issue because the fix was deployed.** Close it because you re-ran the query and it
came back clean. Those are different events and only the second one is evidence.

Where a folder gets large, moving closed issues into `closed/` is fine — but the regenerated index
must carry the new `file:` path, or every citation elsewhere breaks.

## Counts, proportions, and the figure rule

Data-quality docs are unavoidably full of numbers, and the "never write figures into artifacts" rule
still applies — but it applies to **business facts**, not structural measurements. The line:

| Fine in a git-tracked DQ doc | Not fine |
| --- | --- |
| Row counts and orders of magnitude | Total revenue, MRR, ARR, cash balances |
| Null rates, duplicate rates, unmatched-key percentages | Customer counts presented as a business fact |
| Date spans, load lag, backfill boundaries | Deal sizes, salaries, headcount |
| Distinct values of a status column | Named person next to a compensation figure |
| "Concentrated before the 2025 migration" | "The affected orders total $1.4M" |

The test: would this number appear in a board pack? Then it is a business figure — describe the
shape and keep the amount out. `1.2% of rows are unmatched` is a measurement of the pipeline.
`$1.4M of revenue is unmatched` is a disclosure.

## Citing issues elsewhere

- **Metric descriptions** should cite the ID *and* state the caveat in full: the in-product AI reads
  the description and cannot open a git file. `"Excludes unattributed orders — see dq-004"` alone
  tells the AI nothing. `"Excludes orders with no linked customer, roughly one in eight before the
  2025 migration (dq-004)"` tells it what it needs and gives a human the trail.
- **The answerability ledger** cites the IDs behind each "answerable with caveats" row.
- **The verification report** cites the ID when a failed answer traces back to a known data problem
  rather than a context bug. That distinction is the difference between "fix the context" and "fix
  the pipeline", and conflating them wastes everyone's time.
