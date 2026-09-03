# Solution A — shifted Fiscal Date

Marcus's answer from the Slack thread. `fiscal_date` = close date **+ 3 months**, so the shifted date's calendar year *is* the fiscal year, and it stays a real date field.

## Files

| File | What it is |
|---|---|
| `seed_a_orders.model.aml` | `ecommerce_orders` extended with `Fiscal Date` and `Fiscal Month Start` |
| `seed_a.dataset.aml` | `Dataset seed_a` — the orders extension plus order items and products |
| `seed_a.page.aml` | `Dashboard seed_fy_solution_a` — answer on top, catch underneath |

## Self-contained

Nothing here is used by Solutions B, C or D, and nothing here comes from them. The only shared objects are the core-demo base models (`ecommerce_orders`, `ecommerce_order_items`, `ecommerce_products`), which are read, extended, and **never edited** — `ecommerce_orders` is a demo-critical model. Do not point core-demo datasets at `seed_a_orders`.

Namespace everything in this folder `seed_a_`.

## What this solution is for

It works, and the page shows it working: a `this year` filter on `Fiscal Month Start` resolves to 1 Oct 2025 – 30 Sep 2026 today and to FY2027 on 1 October, with nothing to edit. That is exactly what Lori asked for.

The bottom half of the page shows the price: **every date the user sees is three months late.** 15 Nov 2025 renders as 15 Feb 2026. Any absolute date typed into a filter is shifted too. Walk the page top to bottom on the call.

## Gotchas

**`extend()` copies definitions verbatim.** Every inherited field that spelled out `ecommerce_orders.<field>` still says `ecommerce_orders`, which is not in scope in a dataset that only includes `seed_a_orders`. Seventeen `E102` errors on the first attempt; eleven fields had to be re-declared at the bottom of the model. `extend()` cannot delete a field either — the most you can do is override and hide it. That cost is per fact table and it is permanent. It is not a footnote, it is the argument for Solutions C and D.

**No relative-FY metrics here.** A's dataset deliberately has only `gmv` and `total_orders`. The `fiscal_year_offset` construct lives in Solution B, where the page actually demos its limits.

**Functions do not parse inside `explore { dimensions { ... } }`** — use `measures {}` with an aggregate. And `now()` does not exist in AQL; it is `@now`, which is banned here anyway (see the parent `AGENTS.md`).

## Verified

33,010 orders, 2023-07-25 to 2026-09-01, month boundaries checked. Numbers were last measured before the four-folder split; the dev MCP has been down since, so nothing in this folder has been re-queried after the rename.

Validate: `holistics aml validate clients/seed_company/solution-a-shifted-date/`
