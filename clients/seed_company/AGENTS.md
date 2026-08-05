# Seed Company

Seed Company is a US non-profit (tsco.org) in onboarding, running a PoC on
Holistics. Warehouse is **unconfirmed**: Lori said Snowflake on the onboarding
call, Chukwudi saw Redshift on the instance. Confirm before building anything
that depends on SQL dialect.

## Data source

Seed's own data is **not** in this tenant. Everything here runs on the shared
ecommerce demo data (`demodb`) as a stand-in, so these are proofs of concept for
mechanics and design, not real Seed numbers. Nothing under `01 demo ecommerce/`
is modified; the models are referenced read-only.

## Files

| File | What it is |
|---|---|
| `seed_company_demo_dashboard.page.aml` | Brand theme showcase on `demo_ecommerce_version_2` |
| `themes/`, `blocks/` | Seed brand theme, header and footer |
| `seed_fy_param.model.aml` | Fiscal year param, a plain year number |
| `seed_fiscal_year.dataset.aml` | Param-driven fiscal year metrics |
| `seed_fiscal_year_demo.page.aml` | Walkthrough dashboard |

## Fiscal year (the open PoC question)

Seed's fiscal year runs **1 Oct to 30 Sep, named by the ending calendar year**:
2026 = 1 Oct 2025 to 30 Sep 2026. On the onboarding call Lori asked for a
reusable "current fiscal year" that cards resolve automatically, because they do
not want visualizations that name specific years. Their reporting sits on one
wide table with no date dimension, and the relevant date field differs per
dataset (the forecast model uses close date).

**Two constraints came from the operator, both deliberate:**

1. **No derived fiscal dimensions.** An earlier version had a `fiscal_year`
   dimension and it was rejected as redundant with the parameter. Do not add one
   back without asking.
2. **No `case()` mapping table.** A version mapping each FY to a literal date
   range was rejected as ineffective. The parameter is a **year number** and AQL
   resolves it into the window.
3. **Keep the metrics short.** A version with an inline current-FY fallback was
   rejected as clunky and repetitive.

The current shape, two lines of filter per metric:

```
>= cast(concat(cast(N - 1, 'text'), '-10-01'), 'date')
<  cast(concat(cast(N,     'text'), '-10-01'), 'date')
```

where `N` is `seed_fy_param.fy_year | first()`. Upper bound is "< 1 Oct of
year N" rather than "<= 30 Sep", which sidesteps any end-of-day question.
Works for any year with no AML change.

### Why it is repeated per metric

It would be nicer to bind the window once. **AQL cannot, in a row-level
filter.** Four routes were tried against this instance and all failed:

| Route | Result |
|---|---|
| `matches <computed string>` | rejected at parse |
| reference a number metric | "must be grouped or aggregated" |
| reference a param-model dimension | same aggregate-context error |
| reference date-typed metrics | works with ONE in the where, fails with two |

So the repetition is structural, not sloppiness. Do not spend time trying to
DRY it again without new platform capability.

### Where the default year lives

The dashboard filter's `default`, so a year appears in exactly one place per
dashboard and gets bumped on 1 October. An earlier version carried a
`coalesce(param, <fiscal year containing today>)` fallback so a blank filter
meant "current FY". It made each metric ~14 lines with the same block repeated
four times and was dropped as not worth it. If zero annual edits becomes a hard
requirement, that fallback or a derived dimension is the price.

### Traps, all hit and verified

- **A `number` param with numeric `allowed_values` breaks the dataset.** Every
  query against it returns HTTP 500, including unrelated base metrics, while
  `holistics aml validate` still passes locally. `allowed_values` is omitted for
  this reason. Worth reporting to the product team.
- **If `@now` is ever reintroduced, do not write
  `date_diff('month', @(2000-10-01), @now)`.** That inlines `@now` as a full
  timestamp, so the generated SQL changes on every execution and the query cache
  never hits. Route `@now` through a comparison with the date column so it
  coerces to a plain date. Seed is cost-sensitive about warehouse queries.
- **`cast(...)` bounds and `matches @(a to b)` disagree slightly.** `matches`
  applies a timezone conversion that `cast` does not, so rows within the tenant's
  UTC offset of a boundary fall differently. On this demo data FY26 is 6,996,534
  (cast) vs 6,990,976 (matches). Confirm which timezone Seed defines fiscal
  boundaries in before porting.

### What this shape gives up

Filtering only. No fiscal year chart axis, no drill by fiscal year, and
Holistics AI cannot group by it. If Seed asks for "GMV by fiscal year" as a bar
chart, that needs a dimension and this file is the wrong shape. The verified
dimension expression, if ever reinstated, is
`2001 + floor(date_diff('month', @(2000-10-01), <date> | month()) / 12)`.

## Porting to Seed's tenant

Swap `ecommerce_orders.created_at` for Seed's close date in
`seed_fiscal_year.dataset.aml`. The param and dashboard carry over unchanged.

## Rules

Keep changes inside this folder, namespace with `seed_`, and never edit
`01 demo ecommerce/`, `library/` or `Datasets Library/`. Per `clients/AGENTS.md`,
ask the operator before putting anything about Seed into
`settings/ai/context.aml` — it is tenant-wide.

Validate: `holistics aml validate clients/seed_company/`
