# Solution C — fiscal year on the date dimension

The recommended answer. Fiscal columns live on the date dimension; fact tables carry nothing.

## Files

| File | What it is |
|---|---|
| `seed_c_dates.model.aml` | `dim_dates` extended with the fiscal columns. The only file that knows what a fiscal year is |
| `seed_c_dates_signup.model.aml` | The same dimension in a second role, joined on signup date. Three lines |
| `seed_c_period.model.aml` | Parameter model behind the Period dropdown. Joined to nothing |
| `seed_c.dataset.aml` | `Dataset seed_c` — both date roles plus orders, order items, products, users |
| `seed_c.page.aml` | `Dashboard seed_fy_solution_c` |

**Seven models, and that is on purpose.** `ecommerce_cities` and `ecommerce_countries` were dropped on 2 Sep 2026 — they were declared and joined to each other but no metric, dimension or block referenced them. `ecommerce_users` stays only because `sign_up_date` is the one second date field this warehouse has; without it there is nothing to demo the signup role on.

## Self-contained

Nothing here is used by Solutions A or B, and nothing here comes from them. The only shared objects are the core-demo base models (`dim_dates`, `ecommerce_*`), extended and **never edited**; `dim_dates` carries `@tag('Endorsed')`.

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

**The model diagram is an embedded iframe.** Block `t_erd` on the page is a `TextBlock` whose `@md` body contains raw HTML — Holistics passes HTML through, so no dedicated embed block type is needed. It points at dbdiagram.io. The DBML source lives *outside this repo*, in the mgmt repo at `presales/seed-company-solution-c.dbml`; the two can drift, so update the DBML and re-publish to the same URL when the model changes. The block goes blank rather than degrading if dbdiagram.io is unreachable or the diagram is unpublished — check before showing this page in a customer-facing embed context with a restrictive CSP.

## The signup metric and this warehouse's synthetic data

`users_signed_up_current_fy` counts users by their own signup fiscal year — FY23 321, FY24 1,188, FY25 2,336, FY26 6,419, a sane ramp. Read it as shape, not counts.

There was also an `orders_from_users_signed_up_this_fy`, removed on 2 Sep 2026. The definition was right, but this warehouse's synthetic `sign_up_date` values are not chronologically consistent with order dates, so it collided with `total_orders` (FY23 120/120, FY24 2,776/2,776, FY25 9,172/9,172 identical) and read as a broken card. It would separate cleanly on Seed's real data — recover it from git history if the second-role point ever needs an orders-grain example.

## Verification status

**Nothing in this folder has been verified by live query since the four-folder split.** Every number quoted above was measured before it. The dev MCP has been down since — `execute_aql` on `seed_c` returns "Dataset `seed_c` not found" while `aml validate` passes, so it is MCP scope, not AML. Restart `holistics mcp --dev` and re-check the FY labels, the quarter axis and the YTD/QTD windows before demoing.

`holistics sync-code` runs as a live watcher against Project 7, so edits here reach the Holistics `tsco` dev branch as they hit disk — including deletions. They still need a separate commit and merge in the Holistics UI to reach master.

Validate: `holistics aml validate clients/seed_company/solution-c-date-dimension/`

## The Period dropdown is a param, not a field filter

Fiscal YTD and Fiscal QTD overlap — every QTD date is also a YTD date — so they cannot be two values of one field filter. The dropdown is sourced from `seed_c_period.window`, a parameter model with no join, and `gmv_period` reads it with a `case()`.

Params do not filter the query on their own. **Every block must use `gmv_period`, not `gmv`** — a chart written against plain `gmv` silently ignores the dropdown, which looks like a broken filter rather than a modelling mistake.

`where()` on a `truefalse` dimension needs the explicit comparison: `where(seed_c_dates.is_fiscal_ytd == true)`. The bare form raises `E246: No primary key found for model seed_c_dates`, which does not describe the actual problem.

Fiscal QTD needs no fiscal arithmetic: the fiscal year is shifted by exactly one quarter, so fiscal and calendar quarter boundaries are the same dates and `DATE_TRUNC('quarter', CURRENT_DATE)` is already the current fiscal quarter start. This breaks if Seed ever moves to a year end that is not a quarter boundary.
