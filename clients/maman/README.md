# Maman PoC: semantic layer

These are the models, shared metrics and datasets behind 2 Holistics data apps for Maman:

- the Store Scorecard, with Operating and Finance tabs
- Ryan's weekly sales report

The data apps are single-file HTML apps that query the datasets with AQL. They are not in this folder.

## Data

| Item | Value |
|---|---|
| Data source | `demo_bigquery` |
| BigQuery dataset | `data-demo-502609.maman_demo`, referenced as `maman_demo.<table>` |
| Schema contract | `~/Documents/Dev/holistics/demo-maman/mock-data/schema-contract.md` |
| KPI definitions | `~/Documents/Dev/holistics/demo-maman/context/email/re-discovery-call-and-tailored-demo.txt`, sections 2 and 3 |
| History | 2024-12-30 (FY2025 week 1) to 2026-11-15 (FY2026 P11 week 3) |

All rows are generated. Maman shared table names and grain only, so the columns are inferred from their KPI definitions.

## Layout

- `models/`: one model per contract table (27), plus 2 Toast daily aggregates from `~/Documents/Dev/holistics/demo-maman/mock-data/toast-aggregates-spec.md`.
  - The shared Toast metrics read `maman_toast_agg_store_daypart_daily` and `maman_toast_agg_item_daily`, not the detail tables, so app queries scan megabytes instead of gigabytes. The Toast detail models stay in the datasets for ad hoc questions.
  - All are table models except `maman_datarails_fact_monthly_sales`. That is a query model, because it adds the fiscal period end date from the calendar so monthly rows can join it.
- `metrics/`: shared metric partials, one per source.
  - `maman_toast_metrics`: Toast sales and traffic.
  - `maman_toast_operations_metrics`: items and kitchen.
  - `maman_harri_metrics`, `maman_marginedge_metrics`, `maman_netsuite_metrics`, `maman_gbp_metrics`.
  - `maman_weekly_sales_metrics`: ERP actual, forecast, last year, and Toast traffic for last year.
- `datasets/`: the two datasets, which share the models and the Toast and NetSuite metrics.
  - `maman_store_scorecard`: 23 models, 51 metrics.
  - `maman_weekly_sales`: 13 models, 42 metrics.
- `docs/sample-queries.md`: AQL the data apps need.
- `ai/maman_kpi_definitions.skill.aml`: the Holistics AI skill with the definitions that differ by source (sales, labor, COGS, comp vs same-store, average check vs ticket, transaction date vs posting period) and the answer rules. The *Maman* route in `settings/ai/context.aml` loads it for queries on the two datasets.

## Key modelling decisions

- **Store.** `maman_catalog_store_crosswalk` is the only store dimension. Facts reach it through their own source ID. A NULL source ID means the source is unmatched for that store, so its figures show as missing, not zero.
- **Fiscal calendar.** Every fact joins `maman_catalog_fiscal_calendar` on its own date, so fiscal year, period and week filters apply to every source the same way.
- **Last year.** The calendar's `ly_date` is date − 364, the same fiscal day one 52-week year earlier.
  - Inactive relationships join `fact date > ly_date`. The `*_ly` metrics switch them on with `with_relationships()`.
  - Any calendar filter (week, period, year, YTD) therefore returns last year's matching days under this year's labels.
  - `relative_period()` was not used, because it shifts only filters on the one time field it names.
- **Finance scope.** `is_finance_scope` is a Store filter, not part of the metric definitions. The apps apply it. Ryan's population is the same: US cafes, catering and Retail & E-Commerce, without management contracts.
- **Cohorts.**
  - `opening_cohort` gives the static opening year.
  - Week-level L4L is a filter, `opening_date <= week_start_date − 365 days`, computed by the app.
  - Closures, the `minPY` floor and the bridge buckets stay in app code, as at Maman today.

## Validate

From the demo4 repository root:

```sh
holistics aml validate clients/maman
git diff --check
```

AML validation works offline. It does not check join-path ambiguity or run queries.
