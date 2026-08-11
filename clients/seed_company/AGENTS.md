# Seed Company

Seed Company is a US non-profit (tsco.org) in onboarding, running a PoC on
Holistics. Warehouse is **unconfirmed**: Lori said Snowflake on the onboarding
call, Chukwudi saw Redshift on the instance. The fiscal year work below is
warehouse-agnostic on purpose, but confirm before building anything that
depends on SQL dialect.

## Data source

Seed's own data is **not** in this tenant. Everything here runs on the shared
ecommerce demo data (`demodb`) as a stand-in, so these are proofs of concept for
mechanics and design, not real Seed numbers. Nothing under `01 demo ecommerce/`
is modified; `dim_dates` is extended, not edited.

## Files

| File | What it is |
|---|---|
| `seed_company_demo_dashboard.page.aml` | Brand theme showcase on `demo_ecommerce_version_2` |
| `themes/`, `blocks/` | Seed brand theme, header and footer |
| `seed_dim_dates.model.aml` | `dim_dates` extended with fiscal year columns |
| `seed_fiscal_year.dataset.aml` | Dataset wiring orders to the fiscal calendar |
| `seed_fiscal_year_demo.page.aml` | Walkthrough dashboard |

## Fiscal year

Seed's fiscal year runs **1 Oct to 30 Sep, named by the ending calendar year**:
2026 = 1 Oct 2025 to 30 Sep 2026. On the onboarding call Lori asked for a
reusable "current fiscal year" that cards resolve automatically, because they do
not want visualizations that name specific years.

**Fiscal year is a column on the date dimension.** That is the whole design.
Filter it, group by it, put it on an axis, let the AI use it. No parameter, no
`case()` mapping table, no per-metric date arithmetic.

`fiscal_year_offset` is 0 for the current fiscal year and -1 for the prior one,
so a card pinned to 0 is permanently "current FY" with no date written down.

### The one real trap: do not use date_diff on `date_key`

The obvious derivation counts months from an anchor Oct 1 with `date_diff`.
**It is off by a whole month.** `date_key` is a DATE; Holistics casts it to
timestamptz and applies the tenant timezone (America/Los_Angeles), which rolls
every month-start back into the previous month, while the anchor literal carries
its own offset and does not shift. This was verified live: it produced fiscal
years running 1 Nov to 31 Oct, and it looked correct on the orders table only
because that data had no rows on the first few days of October.

Use `year` and `month_number` instead. They come from `to_char()` evaluated in
the warehouse on the raw date, so they carry no timezone distortion:

```
case(when: cast(month_number,'number') >= 10, then: cast(year,'number') + 1,
     else: cast(year,'number'))
```

Verified boundaries: every fiscal year runs exactly Oct 01 to Sep 30.

### Why `max(fiscal_year)` is the current fiscal year

The base `dim_dates` query is `generate_series(..., current_date, ...)`, so the
last row of the calendar is always today. `max(fiscal_year)` is therefore the
fiscal year containing today, by construction. That is what makes
`fiscal_year_offset` self-maintaining.

It also means **no `@now` anywhere in this folder**, which is deliberate. `@now`
inlines as a full timestamp, so the generated SQL changes on every execution and
the query cache never hits. Seed is cost-sensitive about warehouse queries.

If the date dimension is ever repointed at a fixed-end calendar rather than
`current_date`, `fiscal_year_offset` silently breaks. Check that first if
"current FY" ever looks wrong.

### Multiple date fields

Lori noted the relevant date differs per dataset (forecast uses close date).
Only ONE relationship to the date dimension can be active. For a second date
role, either add an inactive relationship and reach it with
`with_relationships()`, or extend `seed_dim_dates` again into a separate role
model with its own active relationship.

### Approaches already tried and rejected

Do not re-litigate these without new information:

| Approach | Why it went | 
|---|---|
| `case()` mapping each FY to a literal date range | clunky, and filter-only |
| Year-number param resolved into date bounds in each metric | clunky, repetitive, filter-only |
| Derived fiscal dimensions on the orders table | works, but duplicates per fact table |

The parameter versions were all **filter-only**: with no field to group by, you
could not put fiscal year on a chart axis or let the AI use it. A column on the
date dimension gives that for free, and matches what Chukwudi told the customer
on the call: "we're just going to route it through the date dimension model,
which means it can adapt to any field it needs to adapt".

One unrelated bug found along the way, still worth reporting: a `number` param
with numeric `allowed_values` makes a dataset return HTTP 500 on every query,
including unrelated base metrics, while `holistics aml validate` passes locally.

## Porting to Seed's tenant

Two things: point `seed_dim_dates` at their date dimension (or ship this one,
it is warehouse-agnostic), and repoint the single relationship line in
`seed_fiscal_year.dataset.aml` from `ecommerce_orders.created_date` to their
close date.

## Rules

Keep changes inside this folder, namespace with `seed_`, and never edit
`01 demo ecommerce/`, `library/` or `Datasets Library/`. Per `clients/AGENTS.md`,
ask the operator before putting anything about Seed into
`settings/ai/context.aml` — it is tenant-wide.

Validate: `holistics aml validate clients/seed_company/`
