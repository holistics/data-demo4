# Solution B — fiscal periods as labels

Huy's answer from the Slack thread. Same +3 month shift as Solution A, but the shifted date is **hidden**. The user only ever sees `FY2026`, `FY2026-Q1 (Oct-Dec)`, `Oct FY2026`.

## Files

| File | What it is |
|---|---|
| `seed_b_orders.model.aml` | `ecommerce_orders` extended with fiscal labels, sort keys and the offset |
| `seed_b.dataset.aml` | `Dataset seed_b` — the orders extension plus order items and products |
| `seed_b.page.aml` | `Dashboard seed_fy_solution_b` — three cascading dropdowns |

## Self-contained

Nothing here is used by Solutions A, C or D, and nothing here comes from them. The only shared objects are the core-demo base models (`ecommerce_orders`, `ecommerce_order_items`, `ecommerce_products`), which are read, extended, and **never edited**. Do not point core-demo datasets at `seed_b_orders`.

Namespace everything in this folder `seed_b_`.

## Post-deploy step, required

**Parent-child filter narrowing has no AML syntax.** Fiscal Year narrowing the Fiscal Quarter dropdown is a Studio UI setting. After deploying: edit the Fiscal Year filter → Child Filters → enable Fiscal Quarter. Without it the dashboard still works, the child dropdowns are just longer. The labels are unambiguous, so nothing is wrong, only noisier.

## Gotchas

**`extend()` copies definitions verbatim** — the same eleven inherited re-declarations Solution A pays, paid again here. See that folder's note; the duplication is deliberate.

**Sorting text labels is positional.** Holistics chart sorting addresses fields by their index in the viz (`type:` / `field_index:` / `direction:`), so a sort cannot point at a field that is not on the chart. `'FY2026'` and `'FY2026-Q1'` happen to sort correctly on their own — alphabetical order and chronological order agree. `'Oct FY2026'` does not: alphabetically Apr comes before Oct. That is why `Fiscal Year Number` and `Fiscal Month Number` are visible dimensions — to sort by fiscal month you put the number in the table and sort on that column. Solution C solves this properly by carrying the sort key inside the label (`'01 Oct'` … `'12 Sep'`).

**`fiscal_year_offset` here is scope-bound.** It is `fiscal_year_num - max(fiscal_year_num)`, and `max()` is evaluated inside the query's filter scope — the dashboard filter lands in the first CTE and every later CTE selects from it. So narrowing the fiscal filter to a single year re-bases offset 0 onto that year and leaves offset -1 empty. Leave the fiscal filter open on any dashboard that pins these.

`of_all()` does **not** rescue this. It gives `max()` its scope back, so the card fills in, but it re-bases onto the newest fiscal year present in the data rather than the one containing today — silently wrong instead of blank. The fix is Solution C's: compare against `CURRENT_DATE` row by row. This weaker version is kept here on purpose so the contrast is demoable.

**Functions do not parse inside `explore { dimensions { ... } }`** — use `measures {}` with an aggregate.

## Verified

33,010 orders, 2023-07-25 to 2026-09-01, month boundaries checked. Numbers were last measured before the four-folder split; the dev MCP has been down since, so nothing in this folder has been re-queried after the rename.

Validate: `holistics aml validate clients/seed_company/solution-b-fiscal-labels/`
