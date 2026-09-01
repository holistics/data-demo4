# Solution C — fiscal year on the date dimension, full version

The recommended answer, taken as far as it goes. Fiscal columns live on the date dimension; fact tables carry nothing.

## Files

| File | What it is |
|---|---|
| `seed_c_dates.model.aml` | `dim_dates` extended with the fiscal columns. The only file that knows what a fiscal year is |
| `seed_c_dates_signup.model.aml` | The same dimension in a second role, joined on signup date. Three lines |
| `seed_c.dataset.aml` | `Dataset seed_c` — both date roles, orders, users, geography |
| `seed_c.page.aml` | `Dashboard seed_fy_solution_c` |

## Self-contained

Nothing here is used by Solutions A, B or D, and nothing here comes from them. Solution D has its own, plainer copy of the date model — the two are independent on purpose so either can be demoed alone. The only shared objects are the core-demo base models (`dim_dates`, `ecommerce_*`), extended and **never edited**; `dim_dates` carries `@tag('Endorsed')`.

Namespace everything in this folder `seed_c_`.

## Everything is `@sql`, and that is the whole trick

An earlier version wrote these columns in AQL as `case(when: cast(seed_c_dates.month_number, 'number') >= 10, ...)`. **A dimension defined in AQL with a model prefix does not re-point when extended** — the copied definition still names the parent model, which is out of scope, so every role model built on top produces `E102: Model, metric, or field ... is not defined`. Nine of them, from an empty-bodied `extend({})`.

A dimension defined in `@sql` against `{{ #SOURCE.col }}` extends for free, and `@sql` can reference a sibling dimension bare as `{{ fiscal_year }}`. That is why `seed_c_dates_signup` re-declares **nothing** while Solutions A and B re-declare eleven fields each. Keep this file all-`@sql`.

## Gotchas

**Do not use `date_diff` on `date_key`.** It is off by a whole month — see the parent `AGENTS.md`. Read `month_number` and `year` instead; they are warehouse-side `to_char()` output and carry no timezone distortion.

**`of_all` order matters and fails silently.** `gmv | where(offset == 0) | of_all(seed_c_dates)` → 7,365,785 under a FY2024 filter (correct). Reversed → 11,581,542 (grand total, wrong). Both validate.

**`fiscal_year_offset` is row-level here**, an `@sql` comparison against `CURRENT_DATE`, not `fiscal_year - max(fiscal_year)`. So 0 is the fiscal year containing today regardless of what the dashboard is filtered to. `CURRENT_DATE` is a keyword, so the SQL text is stable and the query cache hits — unlike `@now`, which is banned in the Seed folders.

**Post-deploy step:** Fiscal Year filter → Child Filters → enable Fiscal Quarter. No AML syntax exists for parent-child narrowing.

**Two active date relationships is legal.** The one-active rule is per model *pair*, and `seed_c_dates` and `seed_c_dates_signup` are two different models.

## The signup metrics and this warehouse's synthetic data

`orders_from_users_signed_up_this_fy` is defined but deliberately **not on the dashboard**. This demo warehouse's `sign_up_date` values are not chronologically consistent with order dates, so it collides with `Total Orders`: FY23 120/120, FY24 2,776/2,776, FY25 9,172/9,172 identical; only FY26 (20,942 vs 18,736) and unfiltered (33,010 vs 30,804) differ. It reads as a broken card rather than a second calendar. The definition is right and will separate on Seed's real data.

`users_signed_up_current_fy` is the demo-safe one — FY23 321, FY24 1,188, FY25 2,336, FY26 6,419, a sane ramp. Read the signup chart as shape, not counts.

## Verified

Numbers above were measured before the four-folder split. The dev MCP has been down since, so nothing in this folder has been re-queried after the rename.

Validate: `holistics aml validate clients/seed_company/solution-c-date-dimension/`
