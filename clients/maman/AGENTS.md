# Maman PoC

Maman is a US and Canada bakery-café group with about 70 stores, evaluating Holistics. This folder is the semantic layer for 2 data apps: the Store Scorecard (Operating and Finance tabs) and Ryan's weekly sales report. Read `README.md` before editing.

## Scope and naming

- Keep changes inside `clients/maman/**`. Do not touch `01 demo ecommerce/`, shared `library/`, `Datasets Library/` or another client's folder.
- Prefix every object with `maman_`: models, metric partials, datasets and any future dashboards or skills.
- Data source: `demo_bigquery`. BigQuery dataset: `maman_demo`. The source's default project is `data-demo-502609`, so table names are `maman_demo.<table>` with no project prefix.
- All data is generated mock data. Never copy real figures from Maman's reports into files.

## Contract first

- The schema contract is `~/Documents/Dev/holistics/demo-maman/mock-data/schema-contract.md` (repo `demo-maman`, outside demo4). It is the single source of truth for table and column names and types. To change a column, change the contract first, then the model.
- Keep one model per contract table. Name each pass-through dimension exactly like its column and keep its type. Derived dimensions get new names.
- The 2 Toast aggregates (`maman_toast_agg_store_daypart_daily`, `maman_toast_agg_item_daily`) follow `~/Documents/Dev/holistics/demo-maman/mock-data/toast-aggregates-spec.md`. The shared Toast metrics must read them, never the Toast detail models. Apps must group or filter Toast metrics by aggregate or Store/Calendar fields: a detail field such as `maman_toast_fact_order_selections.item_name` reaches the aggregates only through tied store or date paths.
- Every dimension and metric needs a plain-language description: what it means, its grain or units, and caveats such as missing-not-zero, date basis and source.

## Join rules

- Every fact joins `maman_catalog_store_crosswalk` through its own source ID: Toast `restaurant_guid`, Harri `harri_location_id`, MarginEdge `unit_id`, NetSuite `netsuite_location_id`, Datarails `datarails_store_id`, GBP `gbp_listing_id`.
- Every fact joins `maman_catalog_fiscal_calendar` on its own date column. Weekly tables join on `week_end_date`.
- Source dimension tables join the crosswalk one-to-one, never a fact.
- The only fact-to-fact joins are many-to-one:
  - checks > orders
  - clocks > employees
  - line items > documents
- Last-year metrics use inactive `date > calendar.ly_date` relationships, activated with `with_relationships()`. Do not make them active.

## Definitions that differ by design

Keep these as separate, labelled metrics. Never merge them into one formula:

- Toast Net Sales, NetSuite Sales and Datarails Net Sales
- Harri labor and NetSuite labor
- MarginEdge Purchases and NetSuite COGS
- Average Check and Ryan's Average Ticket ex-Events

The labor presentation is undecided at Maman, so expose both Harri and NetSuite labor.

## Metrics are shared

- Define metrics once in `metrics/*.aml` as `PartialDataset`s.
- Datasets start from an anonymous `Dataset { models, relationships }` and `.extend()` the partials, because a `PartialDataset` has no `.extend()`.
- Keep each `.extend()` chain on one line. A line break before `.extend` fails to parse.
- Add a metric to a partial only if every dataset that extends that partial has the models it needs.

## Completion gate

Run from the repository root after every AML edit:

```sh
holistics aml validate clients/maman
git diff --check
```

- AML validation checks syntax and AQL types only, not runtime behavior.
- It does not report join-path ambiguity. Reason about paths with the rules above.
- Before calling a change done, run a real query against the data.
- Do not start `holistics sync` or run cloud queries unless the operator asks.

## Tenant AI context

Holistics AI learns Maman's definitions from two places that must stay in step with this folder:

- **Route:** `settings/ai/context.aml` has a *Maman* routing-table row and the `maman_context_routing` section. Both bind to the `maman_*` models on `demo_bigquery` and the datasets `maman_store_scorecard` and `maman_weekly_sales`. The section repeats the non-negotiables inline: name the source, never average store percentages, missing is not zero, keep labor open, 4-4-5 calendar and last year = date − 364.
- **Skill:** `ai/maman_kpi_definitions.skill.aml` (`Skill maman_kpi_definitions`, auto-invoked) holds the definitions table: which metric holds each source's definition, which dataset has it, and what the demo cannot show.

Update them when this folder changes:

- When you add, rename or redefine a metric named in the skill, or a model or dataset named in the route, update the skill or route in the same change. The route matches on model and dataset names, so a rename can silently break it.
- Per `clients/AGENTS.md`, propose `context.aml` edits to the operator and wait for approval. Never edit it as a side effect of work in this folder.
- After editing either file, run `holistics aml validate settings/ai/context.aml clients/maman` from the repository root.
