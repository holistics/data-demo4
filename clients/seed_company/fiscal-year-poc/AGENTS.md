# Seed fiscal-year PoC — relative windows + switchable grain

One dashboard, `seed_fy_poc_fiscal_calendar`, built twice over the same behaviour:
tab **Built in SQL** on a hand-written query model, tab **Built in AQL** with no
fiscal SQL at all. The point of the folder is the comparison, so **both tabs must
keep returning identical numbers** — that is the demo.

Data source `demodb`, on the shared `ecommerce_*` facts. GMV is synthetic
stand-in data.

## Scope boundary

- Prefix every object `seed_fy_poc_`. Keep all changes inside this folder.
- Share no AML object with `solution-a-shifted-date/` or
  `solution-c-date-dimension/`, and never edit them. This folder also does not
  extend the shared `dim_dates`; it carries `seed_fy_poc_date_spine` instead so
  it deploys and demos on its own.
- Never edit `01 demo ecommerce/`, `library/` or `Datasets Library/`.
- Per `clients/AGENTS.md`, ask the operator before putting anything about Seed
  into `settings/ai/context.aml` — it is tenant-wide.

## The two paths

| Object | Path | Job |
|---|---|---|
| `seed_fy_poc_dates_sql` | SQL | Spine, fiscal logic and a five-grain fan-out in one `@sql` query |
| `seed_fy_poc_windows_sql` | SQL | Dataset + the KPI's de-duplicated `gmv_window` |
| `seed_fy_poc_date_spine` | AQL | The only `@sql` on the AQL path: `generate_series` + `to_char()` parts, **no fiscal logic** |
| `seed_fy_poc_dates_aql` | AQL | Fiscal calendar, windows and dynamic grain, all `@aql` |
| `seed_fy_poc_windows_aql` | AQL | Dataset, `gmv`, and the live `window_start` / `window_end` |

## Invariants that a change can silently break

**The SQL model repeats every fact once per grain.** `seed_fy_poc_dates_sql`
CROSS JOINs the spine onto five grains, so any block reading a measure from it
must also be filtered on `grain`, or the total comes back 5x. The KPI therefore
reads `gmv_window` (scoped to the Day copy) and is deliberately **not** wired to
the grain filter. Do not point it at plain `gmv`.

**The AQL model has no fan-out**, so plain `gmv` is correct at every grain. It
needs no de-duplicated twin — do not add one.

**Period maths runs on `year` / `month_number` / `day_of_month`, never on
`date_key`.** Holistics date functions applied to a DATE column are off by a
whole month: the column is cast to timestamptz and shifted by the tenant
timezone, rolling month starts into the previous month. Those three columns are
warehouse-side `to_char()` output and carry no distortion. `date_key <= @today`
is the one date comparison that is safe, because it is a plain inequality.

**A finished period is an equality, not a date range.** `in_previous_fy` is
`fiscal_year == today_fiscal_year - 1` — already the whole closed year, no end
date. Only the three in-flight windows carry a `<= @today` edge.

**`case()` has no else branch.** With the grain filter cleared, `period_label`
returns null and the chart is visibly empty rather than quietly wrong. Keep the
filter's `default`.

## What AQL cannot do here — measured, not assumed

- **Manufacture rows.** Hence `seed_fy_poc_date_spine`.
- **Build a boundary date.** `date_trunc` takes a dimension but rejects the
  `@today` literal, and there is no `date_add`. So the AQL tab cannot print
  per-card start/end dates the way the SQL tab does; it reads the selected
  window back through the `window_start` / `window_end` metrics instead.
- **Reach `CURRENT_DATE`.** AQL has no such keyword, so the AQL path uses
  `@today`. That is not the `@now` the sibling folders ban: `@today` resolves to
  a date, so the generated SQL is stable for the day and the query cache hits.

## Workflow

- Probe an AQL expression with `holistics mcp validate_aql` against the dataset
  rather than patching a model file to see whether it compiles.
- After any edit: `holistics aml validate clients/seed_company/`.
- Before calling a change done, re-run the same window and grain on **both**
  datasets and diff the numbers. `holistics mcp execute_aql` on
  `seed_fy_poc_windows_sql` and `seed_fy_poc_windows_aql` is the check that
  matters; AML validation passing says nothing about the two tabs agreeing.
