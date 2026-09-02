# Seed Company

Seed Company is a US non-profit (tsco.org) in onboarding, running a PoC on Holistics. Warehouse is **unconfirmed**: Lori said Snowflake on the onboarding call, Chukwudi saw Redshift on the instance. The fiscal year work below is warehouse-agnostic on purpose, but confirm before building anything that depends on SQL dialect.

## Data source

Seed's own data is **not** in this tenant. Everything here runs on the shared ecommerce demo data (`demodb`) as a stand-in, so these are proofs of concept for mechanics and design, not real Seed numbers. Nothing under `01 demo ecommerce/` is modified; `dim_dates` and `ecommerce_orders` are extended, not edited.

## Layout: four independent solutions

Four ways to give Seed an Oct-Sep fiscal year, each in its own folder. **The folders share no AML object with each other.** Every model, dataset and dashboard is prefixed by its letter, so any one folder can be opened, deployed and demoed on its own without the other three.

| Folder | Objects | Idea |
|---|---|---|
| `solution-a-shifted-date/` | `seed_a_orders`, `seed_a`, page `seed_fy_solution_a` | Marcus's: close date **+ 3 months**, kept a date field |
| `solution-b-fiscal-labels/` | `seed_b_orders`, `seed_b`, page `seed_fy_solution_b` | Huy's: same shift, exposed only as text labels |
| `solution-c-date-dimension/` | `seed_c_dates`, `seed_c_dates_signup`, `seed_c`, page `seed_fy_solution_c` | Fiscal columns on the **date dimension**, full version |
| `solution-d-date-dimension-plain/` | `seed_d_dates`, `seed_d`, page `seed_fiscal_year_demo` | Same as C, minimal. The original walkthrough (Dong Le, Aug 2026) |

Each folder has its own `AGENTS.md` with that solution's gotchas. Read the folder you are working in; do not assume the others apply.

**The only shared objects are the core-demo base models** — `dim_dates`, `ecommerce_orders`, `ecommerce_order_items`, `ecommerce_products`. Every solution extends them and none of them edits them. That sharing is required by repo rule, not an oversight: `dim_dates` carries `@tag('Endorsed')`.

**Recommended order on a call:** D (the concept, minimal) → C (how far it goes) → A and B only if the room wants to see why the fact-table route was dropped.

### Duplication is deliberate

A and B each carry their own copy of the eleven inherited-field re-declarations that `extend()` on a fact table forces. C and D each carry their own copy of the date dimension. That duplication is the price of "one folder, one demo, no cross-wiring" and it is worth paying here. Do **not** re-introduce a shared model to remove it — the whole point of the layout is that a customer can be shown one folder and nothing else.

## Fiscal year

Seed's fiscal year runs **1 Oct to 30 Sep, named by the ending calendar year**: 2026 = 1 Oct 2025 to 30 Sep 2026. On the onboarding call Lori asked for a reusable "current fiscal year" that cards resolve automatically, because they do not want visualizations that name specific years.

**The recommendation is C/D: fiscal year as a column on the date dimension.** Filter it, group by it, put it on an axis, let the AI use it. No parameter, no `case()` mapping table, no per-metric date arithmetic, and nothing on the fact tables.

### The one real trap: do not use date_diff on `date_key`

Applies to C and D, which build on `dim_dates`. The obvious derivation counts months from an anchor Oct 1 with `date_diff`. **It is off by a whole month.** `date_key` is a DATE; Holistics casts it to timestamptz and applies the tenant timezone (America/Los_Angeles), which rolls every month-start back into the previous month, while the anchor literal carries its own offset and does not shift. This was verified live: it produced fiscal years running 1 Nov to 31 Oct, and it looked correct on the orders table only because that data had no rows on the first few days of October.

Use `year` and `month_number` instead. They come from `to_char()` evaluated in the warehouse on the raw date, so they carry no timezone distortion. Verified boundaries: every fiscal year runs exactly Oct 01 to Sep 30.

Does **not** apply in A and B, which shift `created_at` — a real timestamp — rather than reading `date_key`.

### `fiscal_year_offset`: row-level, not aggregate

C and D define the offset as a row-level `@sql` comparison against `CURRENT_DATE`, so 0 always means the fiscal year containing today. A and B still define it as `fiscal_year_num - max(fiscal_year_num)`, which is **scope-bound**: narrowing a fiscal filter re-bases offset 0 onto the filtered year. That difference is one of the reasons C/D won, and A/B keep the weaker version on purpose so the contrast is demoable.

`of_all(<date model>)` drops a dashboard filter off a metric, so a pinned "current FY" card works in pure AML. **Order matters and failing is silent:** `where(...) | of_all(...)` is correct; the reverse returns the grand total across every fiscal year. Measured under a FY2024 filter: correct form 7,365,785, reversed 11,581,542.

`of_all` does **not** rescue an aggregate offset. It gives `max()` its scope back, so the card fills in — but it re-bases onto the newest fiscal year present in the data, not the one containing today. Silently wrong rather than blank.

### No `@now`

`@now` inlines as a full timestamp, so the generated SQL changes on every execution and the query cache never hits. Seed is cost-sensitive about warehouse queries. Use `CURRENT_DATE` in `@sql` instead — it is a keyword, so the SQL text is stable and the cache hits. The one `@now` in A and B is an inherited base-model measure, re-declared only because `extend()` forces it, and hidden.

### Multiple date fields

Lori noted the relevant date differs per dataset (forecast uses close date). Only ONE relationship to the date dimension can be active **per model pair** — two different date models can each have an active relationship to the same fact. For a second date role, extend the date dimension again into a role model with its own active relationship. Solution C demos this (`seed_c_dates_signup`, three lines, zero re-declared fields). The documented alternative, `with_relationships()` in each metric, scales with metrics × roles rather than roles alone.

### Approaches already tried and rejected

Do not re-litigate these without new information:

| Approach | Why it went |
|---|---|
| `case()` mapping each FY to a literal date range | clunky, and filter-only |
| Year-number param resolved into date bounds in each metric | clunky, repetitive, filter-only |
| Fiscal dimensions on the fact table (A and B) | works, but is per-model work forever — eleven re-declarations per fact table |

The parameter versions were all **filter-only**: with no field to group by, you could not put fiscal year on a chart axis or let the AI use it. A column on the date dimension gives that for free, and matches what Chukwudi told the customer on the call: "we're just going to route it through the date dimension model, which means it can adapt to any field it needs to adapt".

One unrelated bug found along the way, still worth reporting: a `number` param with numeric `allowed_values` makes a dataset return HTTP 500 on every query, including unrelated base metrics, while `holistics aml validate` passes locally.

## Porting to Seed's tenant

For C or D: point the date model at their date dimension (or ship this one, it is warehouse-agnostic), and repoint the single relationship line in the dataset from `ecommerce_orders.created_date` to their close date. Their `closedate` is a timestamp, so the cast to DATE must happen **warehouse-side**, not as a Holistics date truncation, or the tenant-timezone conversion moves deals across the 30 Sep / 1 Oct line. Test those two days explicitly.

SQL used in the `@sql` blocks (`CAST(... AS INT)`, `CASE`, `||`, `LPAD`, `EXTRACT`, `CURRENT_DATE`) is valid on Postgres, Snowflake and Redshift. On BigQuery, `INT` becomes `INT64`.

Open questions for Seed: whether their Snowflake `dim_date` already carries fiscal columns, and the `America/Los_Angeles` vs `Asia/Singapore` tenant-timezone discrepancy that governs the 30 Sep / 1 Oct boundary.

## Rules

Keep changes inside this folder, namespace with `seed_`, and never edit `01 demo ecommerce/`, `library/` or `Datasets Library/`. Per `clients/AGENTS.md`, ask the operator before putting anything about Seed into `settings/ai/context.aml` — it is tenant-wide.

Keep the four solution folders independent. A change that makes two of them share an object is a regression.

Validate: `holistics aml validate clients/seed_company/`
