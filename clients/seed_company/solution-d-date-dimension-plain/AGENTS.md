# Solution D — fiscal year on the date dimension, plain version

The original walkthrough (Dong Le, Aug 2026; commits `cc4d2682` and `9efce124`) and the ancestor of Solution C. Same architecture, deliberately minimal: one date model, one date relationship, four metrics.

**This is the one to open first on a call.** It shows the concept with nothing else on screen. Solution C is the same idea taken further.

## Files

| File | What it is |
|---|---|
| `seed_d_dates.model.aml` | `dim_dates` extended with the fiscal columns |
| `seed_d.dataset.aml` | `Dataset seed_d` — orders, order items, products, one date role |
| `seed_d.page.aml` | `Dashboard seed_fiscal_year_demo` |

## Self-contained

Nothing here is used by Solutions A, B or C, and nothing here comes from them. Solution C has its own, fuller copy of the date model. The only shared objects are the core-demo base models (`dim_dates`, `ecommerce_*`), extended and **never edited**; `dim_dates` carries `@tag('Endorsed')`.

Namespace everything in this folder `seed_d_`.

## Kept minimal on purpose

This folder does **not** carry the second date role, the signup metrics, or the users/geography models. All of that is Solution C's job. If you add them here, D stops being the plain version and there is no longer a first-look demo.

The date model still carries `fiscal_period_label` and `fiscal_period_number` even though this page does not chart them — they cost three lines and the dataset description advertises them.

## Gotchas

**Do not use `date_diff` on `date_key`.** Off by a whole month — see the parent `AGENTS.md`. Read `month_number` and `year` instead.

**`fiscal_year_offset` is row-level**, an `@sql` comparison against `CURRENT_DATE`. The page's two right-hand KPIs are pinned to offset 0 and -1 with `of_all(seed_d_dates)`, so they hold the real current and prior fiscal year even while the dropdown is set elsewhere. This is an upgrade over the version originally committed here, which used the aggregate `fiscal_year - max(fiscal_year)` and re-based under a filter. The page prose has been corrected to match.

**`of_all` order matters and fails silently.** `where(...) | of_all(...)` is correct; reversed returns the grand total across every fiscal year. Both validate.

**No `@now`** anywhere in the Seed folders — it defeats the query cache and Seed is cost-sensitive. `CURRENT_DATE` is a keyword and caches fine.

## Verified

Fiscal year boundaries confirmed Oct 01 – Sep 30. The dev MCP has been down since the four-folder split, so nothing in this folder has been re-queried after the rename.

Validate: `holistics aml validate clients/seed_company/solution-d-date-dimension-plain/`
