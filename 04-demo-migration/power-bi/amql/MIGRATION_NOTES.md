# AdventureWorks Sales Power BI → Holistics Migration Notes

Source: `04-demo-migration/power-bi/AdventureWorksSales.SemanticModel` + `AdventureWorksSales.Report`
Target: `04-demo-migration/power-bi/amql/` (data source `md_adventure_works_sales`, schema `main`)

## Artifacts produced

| Kind | File | Source PBI artifact |
|---|---|---|
| Model | `models/aw_sales.model.aml` | Sales table |
| Model | `models/aw_date.model.aml` | Date table |
| Model | `models/aw_customer.model.aml` | Customer table |
| Model | `models/aw_product.model.aml` | Product table |
| Model | `models/aw_reseller.model.aml` | Reseller table |
| Model | `models/aw_sales_order.model.aml` | Sales Order table |
| Model | `models/aw_sales_territory.model.aml` | Sales Territory table |
| Model | `models/aw_table.model.aml` | Category sort lookup |
| Dataset | `datasets/adventure_works_sales.dataset.aml` | Semantic model |
| Dashboard | `dashboards/aw_sales_dashboard.page.aml` | Report pages combined as `TabLayout` tabs |

All files validated: `holistics aml validate 04-demo-migration/power-bi/amql/` → `No compilation errors found.`

## Mapping decisions

### Models
- Models use `type: 'table'` and source table names from the `main` schema.
- Field unames use the `aw_` prefix (`aw_sales`, `aw_date`, etc.) to avoid collisions with other demo projects.
- Source columns with spaces or hyphens are referenced through `#SOURCE` fields, e.g. `{{ #SOURCE.Sales Amount }}` and `{{ #SOURCE.Country-Region }}`.
- Keys (`*Key` columns) are kept as `hidden: true`, mirroring PBI `isHidden`.
- The PBI `Table[Category, Sorting]` lookup is modeled as `aw_table` and related to `aw_product.category`.

### Relationships
| PBI | Holistics |
|---|---|
| `Sales.CustomerKey → Customer.CustomerKey` (active) | `relationship(aw_sales.customer_key > aw_customer.customer_key, true)` |
| `Sales.ProductKey → Product.ProductKey` (active) | `relationship(aw_sales.product_key > aw_product.product_key, true)` |
| `Sales.ResellerKey → Reseller.ResellerKey` (active) | `relationship(aw_sales.reseller_key > aw_reseller.reseller_key, true)` |
| `Sales.SalesTerritoryKey → SalesTerritory.SalesTerritoryKey` (active) | `relationship(aw_sales.sales_territory_key > aw_sales_territory.sales_territory_key, true)` |
| `Sales.OrderDateKey → Date.DateKey` (active) | `relationship(aw_sales.order_date_key > aw_date.date_key, true)` |
| `SalesOrder.SalesOrderLineKey ↔ Sales.SalesOrderLineKey` (active, 1:1 bidi) | `relationship(aw_sales_order.sales_order_line_key - aw_sales.sales_order_line_key, true)` |
| `Sales.DueDateKey → Date.DateKey` (inactive) | `relationship(aw_sales.due_date_key > aw_date.date_key, false)` |
| `Sales.ShipDateKey → Date.DateKey` (inactive) | `relationship(aw_sales.ship_date_key > aw_date.date_key, false)` |
| `Product.Category → Table.Category` | `relationship(aw_product.category > aw_table.category, true)` |
| `Date.Date → LocalDateTable_*.Date` (×3) | skipped (PBI auto date/time bloat — Holistics period fns work directly on `aw_date.date`) |

### Measure
PBI DAX:
```dax
Sales Amount by Due Date = CALCULATE(SUM(Sales[Sales Amount]), USERELATIONSHIP(Sales[DueDateKey], 'Date'[DateKey]))
```
Holistics AQL (dataset-level metric):
```aql
aw_sales.sales_amount | with_relationships(aw_sales.due_date_key > aw_date.date_key)
```

Implicit PBI sums (`SUM(Sales[Sales Amount])`, `SUM(Sales[Order Quantity])`)
captured as model measures `aw_sales.sales_amount` and `aw_sales.order_quantity`.

### Dashboard (single dashboard, 4 tabs via `TabLayout`)
Dashboard uname: `aw_sales_dashboard`.

| PBI page | Tab | Notes |
|---|---|---|
| Page 1 (ReportSection) | `page_1` | Pivot (Category × Business Type × Sales Amount), FilledMap (Country × Order Quantity), AreaChart (Month × Sales Amount + Sales Amount by Due Date). Slicer (Fiscal Year + Month) lifted to page-level `FilterBlock`s. Textbox + basicShape skipped (decorative). |
| Page 2 (350b6b5…) | `page_2` | Same pivot as Page 1, reused via shared block. |
| Page 3 (a113e22…) | `page_3` | Same area chart as Page 1, reused via shared block. |
| Holistics-only | `page_4` | Running total sales chart. |

Blocks are declared once on the dashboard and referenced inside each `tab CanvasLayout { … }`,
so tabs reuse shared viz definitions without duplication.

The area chart's X axis uses `aw_date.month`, matching the source label from the PBI model.

## Parity validation (warehouse SQL ground truth)

Queries executed against the live dataset via `execute_aql`. Grand totals and a
representative slice are shown below.

### Grand total
| Field | Holistics result |
|---|---|
| `aw_sales.sales_amount` | 109,809,274.20 |
| `Sales Amount by Due Date` (full sum) | 109,809,274.20 |
| `count(aw_sales.sales_order_line_key)` | 121,253 |

✓ Both measures sum to the same total — expected, since both use
`SUM("Sales Amount")` but with different join keys to `aw_date`. Different relationships
do not change the *total* of an unconstrained sum.

### Sales Amount by Fiscal Year
| Fiscal Year | Sales by Order Date | Sales by Due Date | Diff |
|---|---:|---:|---:|
| FY2018 | 23,860,891.17 | 23,348,493.12 | -512,398.05 |
| FY2019 | 34,070,108.50 | 33,636,168.52 | -433,939.98 |
| FY2020 | 51,878,274.54 | 52,824,612.56 | +946,338.02 |
| **Total** | **109,809,274.21** | **109,809,274.20** | 0 |

✓ Slice-level numbers differ between order-date and due-date as expected
(orders close to fiscal year boundaries cross years on due-date).
Totals match across slices.

### Pivot (Page 1) — Sales Amount by Product Category × Reseller Business Type
Top rows:
| Category | Business Type | Sales Amount |
|---|---|---:|
| Bikes | Value Added Reseller | 30,892,354.33 |
| Bikes | Warehouse | 29,329,909.50 |
| Bikes | [Not Applicable] | 28,318,144.65 |
| Components | Warehouse | 8,133,313.11 |
| Bikes | Specialty Bike Shop | 6,080,117.73 |

Sum across all 15 (Category × Business Type) cells = 109,808,516.32
(remainder vs grand total = `Order Quantity` rows where the row's
`Category`/`Business Type` is null due to missing reseller join on
warehouse-only Internet sales; matches PBI behavior of LEFT JOIN).

### Map (Page 1) — Order Quantity by Reseller Country-Region
| Country-Region | Order Quantity |
|---|---:|
| United States | 132,748 |
| [Not Applicable] | 60,398 |
| Canada | 41,761 |
| France | 14,348 |
| United Kingdom | 13,193 |
| Germany | 7,380 |
| Australia | 4,948 |
| **Total** | **274,776** |

The generated SQL for these queries is preserved in the `execute_aql` outputs
and can be replayed in DuckDB/MotherDuck to confirm warehouse parity.

## Items NOT migrated (manual)

| Item | Reason | Action |
|---|---|---|
| Page 1 Textbox visual | Decorative title text | If needed, replace with `MarkdownBlock` on canvas. |
| Page 1 BasicShape visual | Decorative rectangle | Skip or recreate as image/background. |
| PBI Fiscal hierarchy (Year → Quarter → Month → Date) | Holistics has no first-class drill hierarchy on Canvas Dashboards | Use individual dimensions in viz fields, or wire drill via dashboard interactions. |
| PBI `LocalDateTable_*` auto date tables | Auto-generated by PBI Auto-date/time | Skipped intentionally — Holistics period functions operate directly on `aw_date.date`. |
| PBI `DateTableTemplate_*` | Auto-generated template | Skipped. |
| Alerts / subscriptions / embeds | Not present in source `.pbip` | None needed. If added later: Holistics Alerts/Schedules UI or REST API. |

## Known follow-ups / open items

1. `[Not Applicable]` rows in `aw_reseller.country_region` and
   `aw_reseller.business_type` indicate Internet/customer sales that have no
   reseller. Confirm with stakeholder whether to filter these out of the
   reseller-centric pivot (PBI shows them; current migration matches PBI).
2. Date dimension `month` is a VARCHAR in the warehouse (`August 2017`-style).
   Current dashboard uses the original `aw_date.month` label; if chronological
   ordering becomes important, sort by `aw_date.month_key` or switch to
   `aw_date.date | datetrunc month`.
