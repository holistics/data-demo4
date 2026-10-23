# Temple & Webster: Holistics AI demo guide

- **Dataset:** `demo_ecommerce_bigquery` (label *Ecommerce Dataset (BigQuery)*), on data source `demo_bigquery`.
- **Code:** `team-folders/Marcus/ecommerce_bigquery/`.
- **Upstream dbt:** [`bigquery_ecommerce`](https://github.com/holistics/dbt-demo/tree/master/bigquery_ecommerce), which builds BigQuery dataset `ecommerce_cleaned`.

## The margin being demoed

```
margin = (revenue_1 + revenue_2 − cost_1 − cost_2) / (revenue_1 + revenue_2)
```

---

## Step 1: Build a small semantic layer for margin

### Prompt (Holistics AI, Development)

```
Add a Margin metric defined as (revenue_home_living + revenue_electronics - cost_home_living - cost_electronics) / (revenue_home_living + revenue_electronics).
```

```
Also add a Gross Margin % metric for all categories: gross_profit / revenue.
```

```
Put both margin metrics in a new Margin group in the dataset view.
```

**Expected result:** a new `metric` block in `demo_ecommerce_bigquery.dataset.aml`, built from the existing group metrics.

```aml
metric margin_home_living_electronics {
  label: 'Margin (Home & Living + Electronics)'
  type: 'number'
  definition: @aql
    (revenue_home_living + revenue_electronics - cost_home_living - cost_electronics)
    / (revenue_home_living + revenue_electronics) ;;
  format: '#,###0.0%'
}
```

### 1a. Where the semantic layer lives and how it's used

| Layer | Where | Owns |
|---|---|---|
| Warehouse | BigQuery `data-demo-502609.ecommerce_cleaned` | Clean, typed tables |
| dbt (D&A team) | `bigquery_ecommerce/models/cleaned/` | Row-level logic: the revenue and cost formulas, category groups (`category_groups` var), field docs |
| Holistics models | `ecommerce_bigquery/models/*.model.aml` | One model per dbt table, plus field labels and descriptions |
| Holistics dataset | `demo_ecommerce_bigquery.dataset.aml` | Joins (relationships), metrics (AQL), the dataset view |
| Consumption | Dashboards, AI chat, Explore | Everything reads the same metric definitions |

### 1b. Governance: "we want the D&A team to own metrics, ideally in dbt"

- **Ratios belong in the semantic layer.** Margin has to be calculated after aggregation, as `sum(revenue − cost) / sum(revenue)` at the grain of each query, so it can't be a dbt column.
- **Same workflow as dbt.** AML lives in git and changes go through pull requests before they're published, so the D&A team owns the repo.
- **dbt docs flow in.** `holistics dbt upload` syncs the dbt descriptions and lineage.
- **Trust and access.** Datasets can carry `@tag('Endorsed')` and row-level `permission` blocks, and AI answers use the same published metrics.

---

## Step 2: Simple margin dashboard

### Prompts

```
Create a dashboard with a Margin KPI, margin by month, and margin by continent.
```

```
Add a table below the charts showing revenue, cost and margin by category group.
```

```
Change the region chart to break down by country instead of continent, top 10 by revenue.
```

### 2a. The conversational part

```
Why did margin change last month?
```

```
Which continent has the highest margin, and is the difference meaningful?
```

```
Break this chart down by category group.
```

---

## Step 3: Chat about margin

| # | Prompt | What it shows | Expected |
|---|---|---|---|
| 1 | `What is our total revenue, cost and gross profit?` | Basic metric lookup | $7.12M / $2.45M / $4.67M |
| 2 | `What is the margin for Home & Living and Electronics combined?` | Uses the new metric | ≈ 65.7% |
| 3 | `Show margin by month for the last 12 months` | Time series and relative dates | Flat line near 65–66% |
| 4 | `Which region has the highest margin?` | Joins through orders → users → cities | Continents within about 0.2 pts of each other |
| 5 | `Compare revenue and cost across the five category groups` | The 10 categorical metrics | Electronics is largest ($2.53M revenue) |
| 6 | `Which category group contributes most to gross profit, as % of total?` | Percent of total | Electronics ≈ 35.6% |
| 7 | `How does margin this year compare with last year?` | Period comparison | Roughly flat |
| 8 | `How is margin calculated?` | Explains the metric definition, which is governance in action | Quotes the formula |
| 9 | `What is our net profit after marketing costs?` | **Boundary:** the AI should say the data isn't available | Declines: no operating costs in the dataset |

For each answer, open the AQL/SQL generated query to show **how** the AI got it. It picks
metrics and dimensions from the semantic layer; it doesn't write SQL from scratch.

---
