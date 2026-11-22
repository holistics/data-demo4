# Sample AQL for the Maman data apps

These queries show how the Store Scorecard and Ryan's weekly sales report data apps read the two datasets. The examples use week ending Sunday 2026-11-08 (`P11 · W2 · FY2026`) and its prior week, ending 2026-11-01.

Validation status:

- The filter and measure expressions in these queries were type-checked offline with `holistics aml validate`, by wrapping them in temporary `where()` metrics on both datasets.
- The `explore {}` blocks themselves have not been validated. The CLI has no offline AQL validator, and `validate_aql` needs the code synced to Development. Run them through `holistics mcp validate_aql` or `execute_aql` once the data and sync are in place.

General rules for the apps:

- Select whole fiscal weeks with `maman_catalog_fiscal_calendar.week_end_date`. For the prior week, use the selected date minus 7 days, not `fiscal_week_of_year - 1`, which breaks at week 1.
- Always include at least one metric. A query with only Fiscal Calendar and Store fields has several equal join paths through different facts.
- Compute ratios and comparisons, such as comp % and variance %, from summed values or the metrics provided. Never average store ratios.
- Missing data comes back as NULL, not 0. Show NULL as a dash.

## 1. Scorecard: weekly KPI table, selected week vs prior week, by store

```aql
explore {
  dimensions {
    store: maman_catalog_store_crosswalk.store_name,
    week_end: maman_catalog_fiscal_calendar.week_end_date,
    week_label: maman_catalog_fiscal_calendar.fiscal_week_label,
  }
  measures {
    toast_net_sales: toast_net_sales,
    transactions: toast_transactions,
    harri_labor_pct: harri_labor_pct,
    labor_hours: harri_labor_hours,
    marginedge_purchases_pct: marginedge_purchases_pct,
    splh: harri_splh,
    average_check: toast_average_check,
    avg_fulfillment_seconds: toast_avg_fulfillment_seconds,
  }
  filters {
    maman_catalog_fiscal_calendar.week_end_date in [@2026-11-08, @2026-11-01],
    maman_catalog_store_crosswalk.store_name in ['Maman 545 Madison'],
  }
}
```

- Dataset: `maman_store_scorecard`.
- The app pivots `week_end` into the Selected week and Prior week columns.
- Comp sales vs prior week = (selected − prior) / prior Toast Net Sales, over the selected stores.
- Drop `store` to get the all-locations tiles.
- For Average Fulfillment Time, keep only stores with `toast_covered_store_days` in both weeks.

## 2. Scorecard Finance: NetSuite P&L to prime margin

```aql
explore {
  dimensions {
    week_end: maman_catalog_fiscal_calendar.week_end_date,
  }
  measures {
    sales: netsuite_sales,
    cogs: netsuite_cogs,
    cogs_pct: netsuite_cogs_pct,
    salary: netsuite_salary,
    salary_pct: netsuite_salary_pct,
    hourly: netsuite_hourly,
    hourly_pct: netsuite_hourly_pct,
    other_wages: netsuite_other_wages,
    other_wages_pct: netsuite_other_wages_pct,
    benefits_payroll_taxes: netsuite_benefits_payroll_taxes,
    benefits_payroll_taxes_pct: netsuite_benefits_payroll_taxes_pct,
    other_labor: netsuite_other_labor,
    other_labor_pct: netsuite_other_labor_pct,
    total_labor: netsuite_total_labor,
    total_labor_pct: netsuite_total_labor_pct,
    prime_margin: netsuite_prime_margin,
    prime_margin_pct: netsuite_prime_margin_pct,
  }
  filters {
    maman_catalog_fiscal_calendar.week_end_date in [@2026-11-08, @2026-11-01],
    maman_catalog_store_crosswalk.is_finance_scope == true,
  }
}
```

- Dataset: `maman_store_scorecard`.
- `is_finance_scope` keeps US Cafe, Catering and Retail & E-Commerce, so management contracts, commissaries and Canada are out.
- Payroll for the latest week books on the following Wednesday. Until then, Total Labor and Prime Margin are NULL; show a dash.
- Show Other labor only when it is not NULL.
- For the NetSuite-sales-by-location table, add `store: maman_catalog_store_crosswalk.store_name` and keep only `sales`.
- For the coverage table, use these measures by week:
  - `toast_trading_stores`
  - `netsuite_locations_with_sales`
  - `netsuite_locations_with_cogs`
  - `netsuite_locations_with_labor`

## 3. Ryan: actual vs forecast vs last year by market, one week

```aql
explore {
  dimensions {
    market: maman_catalog_store_crosswalk.market,
    store_format: maman_catalog_store_crosswalk.store_format,
  }
  measures {
    actual: erp_actual_sales,
    forecast: forecast_sales,
    last_year: erp_sales_ly,
    var_forecast: erp_var_forecast,
    var_forecast_pct: erp_var_forecast_pct,
    var_last_year: erp_var_ly,
    var_last_year_pct: erp_var_ly_pct,
  }
  filters {
    maman_catalog_fiscal_calendar.week_end_date == @2026-11-08,
    maman_catalog_store_crosswalk.is_finance_scope == true,
  }
}
```

- Dataset: `maman_weekly_sales`.
- `erp_sales_ly` returns the same fiscal week last year, WE 2025-11-09. Each fact date joins the calendar's `ly_date` (date − 364) through an inactive relationship, which the metric switches on with `with_relationships()`.
- The same metrics work for period to date and year to date. Swap the week filter for one of these:
  - Period to date: `fiscal_year == 2026, fiscal_period == 11, week_end_date <= @2026-11-08`
  - Year to date: `fiscal_year == 2026, week_end_date <= @2026-11-08`

### 3b. L4L cafes only (same-store sales)

Add these filters to query 3. The week starts on 2026-11-02, so a cafe is comparable if it opened on or before 2025-11-02 (365 days earlier):

```aql
  filters {
    maman_catalog_fiscal_calendar.week_end_date == @2026-11-08,
    maman_catalog_store_crosswalk.is_finance_scope == true,
    maman_catalog_store_crosswalk.store_format == 'Cafe',
    maman_catalog_store_crosswalk.opening_date <= @2025-11-02,
  }
```

The app then holds out Transition cafes, meaning those with a closure in either compared week. Read the closures with this query and check them against both weeks:

```aql
explore {
  dimensions {
    store: maman_catalog_store_crosswalk.short_name,
    closed_from: maman_catalog_store_closures.closed_from,
    closed_to: maman_catalog_store_closures.closed_to,
    reason: maman_catalog_store_closures.reason,
  }
}
```

Filter closures by `closed_from` and `closed_to` only, never by Fiscal Calendar fields: the calendar has no direct join to closures. The app also applies Ryan's other cohort rules: the `minPY` floor, partial opening weeks, and the bridge buckets.

## 4. Ryan: weekly Toast traffic vs same week last year

```aql
explore {
  dimensions {
    market: maman_catalog_store_crosswalk.market,
    store: maman_catalog_store_crosswalk.short_name,
  }
  measures {
    orders: toast_orders,
    orders_ly: toast_orders_ly,
    average_ticket: toast_average_ticket_ex_events,
    average_ticket_ly: toast_average_ticket_ex_events_ly,
    net_sales: toast_net_sales,
    net_sales_ly: toast_net_sales_ly,
  }
  filters {
    maman_catalog_fiscal_calendar.week_end_date == @2026-11-08,
    maman_catalog_store_crosswalk.store_format == 'Cafe',
    maman_catalog_store_crosswalk.opening_date <= @2025-11-02,
  }
}
```

- Ryan matches only stores trading in both weeks, so the app drops rows where `orders` or `orders_ly` is NULL before summing to market.
- Average ticket = (Toast net sales − Events $) / orders, from summed values. Use the metric at market level; never average store tickets.
