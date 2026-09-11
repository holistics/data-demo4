# Multiple date fields — one fiscal calendar, switchable join

Answers a question Seed asked that the other folders here do not cover:

> Many of our MSTR datasets have more than one date field — e.g. pledge date and
> close/transaction date. Does this model and solution work with multiple date fields, or
> do you always have to select a single join key?

**You select one at a time, not one forever.** Both date fields are joined to the *same*
fiscal date dimension, exactly one join is active, and a parameter switches which one via
`with_relationships`. Close date is the default.

This is an **add-on to Solution C, not a fourth rival solution.** Same fiscal calendar,
different answer to the multi-date question.

## Scope

- **Data source:** `demodb`.
- **Prefix:** everything is `seed_md_` (md = multiple dates).
- **Self-contained:** shares no AML object with `solution-a-shifted-date/`,
  `solution-b-fiscal-labels/`, `solution-c-date-dimension/` or `fiscal-year-poc/`.
- **Reads two things from outside this folder, edits neither:** `dim_dates` (shared
  core-demo model, `@tag('Endorsed')`) and `PageTheme seed_company` from
  `clients/branded-themes/seed_company/themes/seed_company.theme.aml`. AML names are
  project-global, so both resolve with no import.
- Never touch `01 demo ecommerce/`, `library/`, `Datasets Library/`, or another client's
  folder.

## Files

| File | What it is |
|---|---|
| `seed_md_donations.model.aml` | The two-date fact, plus the `date_basis` param |
| `seed_md_dates.model.aml` | `dim_dates.extend()` with the Oct–Sep fiscal columns |
| `seed_md.dataset.aml` | Both date paths (one active), and the basis-aware metrics |
| `seed_md_fiscal_dashboard.page.aml` | `Dashboard seed_md_fiscal_dashboard`, brand-themed |
| `seed_md.dbml` | Source for the dbdiagram.io embed on "The setup" tab. Not AML — keep in step with the dataset by hand |

## The data is illustrative

Seed's own data is not in this tenant. `seed_md_donations` is a query model over the shared
ecommerce tables re-presented as donations — one row per gift, `close_date` =
`created_at::date`, `amount` = summed line items. **Shapes are real, amounts are not Seed
figures.**

`pledge_date` is **30–119 days** before close (`30 + id % 90`), deliberately varying. A
fixed lag would slide every gift by the same amount and the fiscal re-bucketing would look
like one uniform shift; a varying lag means some gifts cross the 30 Sep / 1 Oct line and
some don't, which is what a real pledge-to-close pipeline does.

## Gotchas

**Point every block at `giving_by_basis` / `donations_by_basis`.** `date_basis` is a param:
it carries the dropdown's value into AQL and filters nothing on its own, so a block on
plain `total_giving` / `total_donations` silently ignores the dropdown. Same trap as
Solution C's `gmv_period`. `giving_on_close` / `giving_on_pledge` are the deliberate
exceptions — hardcoded one basis each, for showing both at once.

**The month axis must stay on the date dimension.** `v_jkpa` plots
`seed_md_dates.calendar_month`, not a fact date column. A param cannot switch a dimension,
so an axis on `seed_md_donations.close_date` would keep reading close date while the KPI
beside it read pledge date. Verified live: same month label, different value per basis.

**`case()` has no else branch.** Both `allowed_values` need an explicit `when`, and the
filter block needs its `default` (`'Close date'`), or a cleared filter returns null.

**Use the long form of `with_relationships`** — both paths named, one `false` and one
`true`. The shorthand also validates, but the docs on path priority warn an override can
lose to a competing active path unless that path is explicitly disabled in the override.

**`relationship()` inside `with_relationships()` requires all three arguments.** Drop the
filter direction there and you get `E200: Invalid number of arguments. Expected 3
arguments for function relationship, got 2`. The dataset's `relationships:` array is the
opposite — the third argument is optional there and defaults to `two_way`.

That is the only reason a direction is written in the overrides at all. They say `two_way`,
matching the array's default, and were measured identical to `one_way` on every check
below. Holistics recommends `one_way` for star-schema dimension-to-fact joins to stop
invalid metric/dimension combinations and unintended join paths; with two models and one
dimension there is nothing here for it to protect. **Revisit that when porting to Seed's
tenant** — several facts sharing one date dimension is exactly where `two_way` produces
fan-out.

**`v_fy_filter` is a hand-built dropdown with brittle couplings.** Its CSS and `{{ }}`
bindings are keyed to the block name (`[data-uname="v_fy_filter"]`), to the field labels
`Fiscal Year Label` / `Fiscal Quarter`, and to row order (0 `fiscal_year_label`,
1 `fiscal_year_quarter`, 2 `is_current_fiscal_quarter`, 3 `is_current_fiscal_year`,
4 `is_last_fiscal_quarter`, 5 `is_last_fiscal_year`). Its `uname` and the `sorts.key` must
stay in step. Rename, relabel or reorder and it breaks with no error.

**No `block_ha_card()` backdrops, unlike `seed_c_v2`.** The theme already gives every block
a white card with a Stone border and 20px padding, so hand-built cards double up. That
padding is also why the KPIs are 280×160 and not v2's 180×80 — at v2's size the value clips
inside the themed card. The dropdown's CSS was recolored to the brand palette (Stone
borders, Natural hover, Forest selection) since the theme's `const`s aren't in scope inside
a markdown blob.

**Don't add `date_diff` on `date_key`** and **don't use `@now`** — see
`../solution-c-date-dimension/AGENTS.md`; both traps apply here unchanged.

## Adding a third date field

One inactive `relationship(...)` line in the dataset, one more `allowed_values` entry on
the param, and one more `when:` branch per basis-aware metric. That last item is the honest
cost of this approach: it scales with metrics × dates, where a date-role model per field
would scale with dates alone. The trade is one `Fiscal Year` field in the picker instead of
one per date, which is what Seed asked for.

## Verified live

Measured 11 Sep 2026 via `holistics mcp --dev execute_aql` on `seed_md`:

| Fiscal year | Close basis | Pledge basis |
|---|---|---|
| FY 2023 | 33,444 | 78,799 |
| FY 2024 | 921,096 | 1,453,618 |
| FY 2025 | 3,123,366 | 3,624,665 |
| FY 2026 | 7,503,636 | 6,424,460 |
| **Total** | **11,581,542** | **11,581,542** |

Close-basis figures match Solution C's `seed_c` exactly (same underlying rows). Grand totals
match across bases — same gifts, re-bucketed. FY 2023 more than doubling is the cheapest
check that the override fires: orders start Aug 2023, so close-basis FY 2023 catches only
Aug–Sep, and shifting back 30–119 days pulls Oct–Dec 2023 closes into it. Donation counts on
pledge basis total 33,010, i.e. every row. Also confirmed: the month axis re-buckets per
basis, and a `fiscal_year == 2024` filter composes with the override rather than fighting it.

Validate: `holistics aml validate clients/seed_company/multiple-date-fields/`
