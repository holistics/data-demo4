# Looker Liquid coverage in Holistics

Access date: 11 September 2026. This note is capability research only. It does not implement a migration, connect Flip data to Holistics, edit tenant AI context, or validate results against Looker or BigQuery.

## Short answer

Holistics can cover many business outcomes that teams use Looker Liquid for, especially parameter-driven metric switching, dimension switching, date grain controls, dashboard filters, dynamic query-model filters, user-attribute permissions, dynamic data-source/schema routing, and data-driven dashboard content.

Holistics does **not** provide syntax equivalence for Looker Liquid. LookML Liquid definitions are not automatically converted by the Holistics Looker Migration Assistant, and several Looker behaviors require manual redesign in AML/AQL or dashboards. Some Looker Liquid use cases are confirmed unsupported as automatic migration only, not necessarily unsupported as product behavior.

The safest prospect-facing answer is:

> Holistics does not migrate Liquid mechanically. For each Liquid field, we classify the intent and rebuild the behavior with Holistics-native controls, parameter fields, AQL, query parameters, user attributes, permissions, or dynamic content blocks. Flip's count-versus-euro selector is a good minimal demo because Holistics has documented dynamic metric selection, but parity still needs runtime tests against Flip's data.

## What Looker Liquid changes

Looker documents Liquid as a templating language for dynamic LookML. Liquid can run in both query-generation surfaces and presentation surfaces:

- SQL generation: `sql`, `sql_on`, `sql_table_name`, derived table SQL, and `sql_preamble`.
- User inputs: templated filters and Liquid parameters insert dashboard or Explore filter input into SQL.
- Query context: `_in_query`, `_is_selected`, and `_is_filtered` can change SQL or labels based on selected or filtered fields.
- Presentation: `html`, `link`, `action`, field labels, field descriptions, dashboard filter defaults, and dashboard element filters.

Important Looker limitations that matter for migration:

- Templated filters return logical SQL expressions. Liquid parameters insert values directly.
- Persistent derived tables are not supported when the derived table uses templated filters or Liquid parameters.
- Liquid references to another field's `_value` can add that field to `SELECT` and `GROUP BY`, which can change aggregate results.

Sources: [Looker Liquid variable reference](https://docs.cloud.google.com/looker/docs/liquid-variable-reference) and [Looker templated filters and Liquid parameters](https://docs.cloud.google.com/looker/docs/templated-filters).

## Holistics mechanisms used in this assessment

- AML models can be table models or query models, with dimensions and measures defined in `@sql` or `@aql`: [AML Model](https://docs.holistics.io/reference/aml/model), [AML Table Model](https://docs.holistics.io/reference/aml/table-model), [AML Query Model](https://docs.holistics.io/reference/aml/query-model), [AML Model Fields](https://docs.holistics.io/reference/aml/field).
- Parameter fields carry dashboard or visualization input into model query or field definitions and are documented for dynamic dimensions, dynamic metrics, dynamic query models, and dynamic explore conditions: [Parameter Fields](https://docs.holistics.io/docs/modeling/param-fields), [Dynamic Metrics Selection](https://docs.holistics.io/docs/modeling/dynamic-measures), [Dynamic Dimensions Selection](https://docs.holistics.io/docs/modeling/dynamic-dimensions), [Dynamic Query Model](https://docs.holistics.io/docs/query-parameters).
- Dashboard controls use `FilterBlock`, `DateDrillBlock`, `PopBlock`, and interactions: [AML Dashboard](https://docs.holistics.io/reference/aml/dashboard), [AML FilterBlock](https://docs.holistics.io/reference/aml/filter-block), [AML DateDrillBlock](https://docs.holistics.io/reference/aml/date-drill-block), [AML Dashboard Interactions](https://docs.holistics.io/reference/aml/dashboard-interactions).
- Dynamic presentation uses TextBlock and MarkdownViz / Dynamic Content Blocks, with HTML/CSS templates, raw/formatted values, links, cross-filtering, and no JavaScript execution: [Text Block](https://docs.holistics.io/docs/canvas-dashboard/text-block), [Dynamic Content Blocks](https://docs.holistics.io/docs/charts/dynamic-content-block), [Template Syntax Reference](https://docs.holistics.io/docs/charts/dynamic-content-blocks/syntax-reference).
- User-aware behavior uses `H.current_user.<attribute>` and built-in variables such as `H.current_user.h_email`, `H.current_user.h_role`, and `H.git.is_production`: [AML user attributes and variables](https://docs.holistics.io/reference/aml/user-attributes-and-variables).
- Security uses row-level permission and column-level permission patterns, not hidden fields: [Row-level permission](https://docs.holistics.io/docs/access-control/row-level-permission), [Column-level permission](https://docs.holistics.io/docs/access-control/column-level-permission), [AML Model Fields hidden warning](https://docs.holistics.io/reference/aml/field).
- AML has compile-time programming constructs such as constants, functions, if-else, modules, and string interpolation: [AML Overview](https://docs.holistics.io/as-code/aml), [AML Function](https://docs.holistics.io/reference/aml/func), [AML If-else](https://docs.holistics.io/reference/aml/if-else), [AML String Interpolation](https://docs.holistics.io/reference/aml/string-interpolation).
- The Looker Migration Assistant supports automatic conversion of views, dimensions, and measures with limitations. It does not yet support Explores, dashboards, native derived tables, or Looker definitions using Liquid variable references: [Looker Migration Assistant Tool](https://docs.holistics.io/docs/from-others/looker/migration-tool).

## Capability matrix

Classification legend:

- **Native**: Holistics has a documented product mechanism for the same business outcome.
- **Alternative**: Holistics can plausibly deliver the same outcome through a different product pattern, with material design changes.
- **Manual**: supported only by rebuilding the logic explicitly; no automatic migration.
- **Unsupported**: documented evidence says the capability is not supported.
- **Unknown / unverified**: evidence is insufficient; validate with Holistics product or runtime test.

| Looker Liquid use case | Concrete Looker example | Business objective | Holistics mechanism | Classification | Semantic limitations | Automatic migration status |
|---|---|---|---|---|---|---|
| Parameter-driven dynamic measure | `parameter: category_to_count`; `sql: CASE WHEN ${category} = '{% parameter category_to_count %}' THEN 1 END ;;` | Let one chart switch metric without creating many charts. | Parameter fields plus AQL `case` in a model or dataset metric; documented as Dynamic Metrics Selection. | **Native for outcome; manual for syntax** | Labels and formatting must be rebuilt separately. If branches have different units, the shared Holistics metric needs clear naming and number formatting decisions. | **Not automatic** when LookML definition uses Liquid. |
| Parameter-driven dynamic dimension | `label_from_parameter: dynamic_channel_parameter`; `sql: {% if ... %} ${cluster} {% else %} ${department} {% endif %} ;;` | Let the viewer choose a breakdown such as channel department vs channel cluster. | Parameter fields plus AQL `case` for Dynamic Dimensions Selection; dashboard `FilterBlock` binds to the parameter. | **Native for outcome; manual for syntax** | Dynamic dimension result usually needs one compatible type. Field-picker label behavior is not syntax-equivalent to Looker's `label_from_parameter`. | **Not automatic** for Liquid field definitions. |
| Date granularity switching | `parameter: date_granularity`; dynamic date dimension chooses day/week/month/quarter/year. | Let one chart switch time grain. | `DateDrillBlock` plus `DateDrillInteraction` maps a selected grain to chart date fields. Parameter-field dynamic dimensions can cover custom grain labels when DateDrill is insufficient. | **Native for standard dashboard grain; manual/alternative for custom SQL labels** | DateDrill controls visualization grain; it is not a literal `CASE` dimension. Custom “overall” or string-concatenated quarter labels require manual AML/AQL or SQL. | **Not automatic** for Liquid; dashboard controls also not automatically migrated. |
| Templated filters inside derived tables or inner SQL | `{% condition order_region %} order.region {% endcondition %}` in a derived table. | Push user filter inside a CTE or derived table before aggregation. | Query Model `param` plus `{% filter(param) %} column {% end %}`; direct value syntax `{{ param }}` for custom calculations. | **Native for outcome; manual for syntax** | Direct value syntax needs dashboard defaults or SQL can break; only the first value is used if multiple values are passed. Persistence behavior must be checked per Holistics model design. | **Not automatic**; Looker Liquid and NDTs are unsupported by the migration assistant. |
| `date_start` / `date_end` in SQL | `date({% date_start period_filter %})` for rolling DAU/WAU/MAU or date-partitioned tables. | Use the selected date range boundaries inside SQL. | Query Parameters can inject a filter expression or direct parameter value into query SQL. For Flip's observed `date_start` pattern, Holistics can alternate by a date parameter and use the first date value. | **Alternative / manual** | Flip's first-date / `date_start`-style use case is coverable. The last date / `date_end` value from the same date parameter or range is not currently proven available; use an explicit end-date parameter if exact end-boundary logic is required. | **Not automatic**. |
| Conditional SQL / dynamic table selection | `sql_table_name: {% if event.created_date._in_query %} event_by_day {% else %} event {% endif %} ;;` | Query an aggregate table or detailed table based on selected fields. | AML supports if-else and string interpolation; user attributes can drive dynamic data sources/schemas. Query models can use parameters. | **Alternative; unknown for field-selection-driven table switching** | I found documented dynamic data source/schema and parameter-driven query SQL, but not a documented Holistics equivalent of Looker's `_in_query` table switching based on selected fields. Prefer explicit aggregate awareness / pre-aggregates or separate models unless Holistics confirms. | **Not automatic**. |
| Query-context behavior: `_in_query`, `_is_selected`, `_is_filtered` | Switch SQL or `sql_preamble` when a field is selected/filtered. | Optimize or alter query logic based on query shape. | Dashboard controls, DateDrill, PopBlock, AQL, and query parameters can make user intent explicit. | **Alternative / unknown** | No documented Holistics variable equivalent found for field selected/filtered query context. Business outcomes may be rebuilt with explicit controls; implicit query-shape-dependent SQL should be treated as a high-risk manual redesign. | **Not automatic**. |
| User attributes for personalization | `_user_attributes['region']` in labels, filters, SQL, dashboard defaults, or URLs. | Personalize default filters, data routing, labels, or content by user/team/role. | `H.current_user.<attribute>`, system attrs like `h_email`/`h_role`, AML if-else, row-level permissions, column-level permission patterns, dynamic data source/schema. | **Native for many outcomes; manual for exact placements** | Do not conflate personalization with security. Use RLP/CLP for security. RLP does not apply to Admins or Analysts with data source access. | **Not automatic** for Liquid definitions. |
| Row-level security via Liquid-like filters | `_user_attributes['region']` in SQL filters or advanced filter syntax. | Ensure each user sees only authorized rows. | Row-level permission maps a dataset field to a user attribute and applies the filter automatically. Dynamic mapping can use `h_email`. | **Native** | RLP is dataset-level and has propagation rules. It does not apply to Admins or Analysts with data source access. Multiple rules are ANDed. | **Manual**; do not convert by hiding fields or dashboard filters. |
| Column-level masking | Liquid in SQL or HTML to hide PII based on user attributes. | Show redacted values to users without permission while preserving row access. | Column-level permission pattern uses AML if-else and string interpolation in a dimension SQL definition based on user attributes. | **Native / manual** | Masking a dimension is different from removing rows. Hidden fields are not a security feature. | **Manual**. |
| Dynamic labels, descriptions, and titles | `label_from_parameter`, Liquid in field `label` or `description`. | Make a selected metric/dimension self-describing in UI and visualizations. | AML labels and dashboard function labels can use string interpolation and if-else; parameter field labels are static. Dynamic metric/dimension fields can have stable labels. | **Alternative / partial** | Looker's field-level dynamic label behavior is not syntax-equivalent. Holistics can make dashboards understandable, but exact field-picker and result-column relabeling per user selection is unverified. | **Not automatic**. |
| HTML / per-value formatting in result cells | `html: {% if value == 1 %}<p style="background:red">{{ close_date }}</p>{% endif %}` or currency prefix via `html`. | Add conditional color, links, images, or custom display. | Dynamic Content Blocks / MarkdownViz render HTML/CSS templates with raw/formatted values and conditional classes. Standard chart/table formatting exists, but arbitrary per-cell HTML in every data table is not confirmed from docs reviewed. | **Alternative; partial** | Do not conflate MarkdownViz with arbitrary per-cell formatting in all Holistics chart/table surfaces. Dynamic Content Blocks do not run JavaScript. | **Manual**. |
| Links, drill URLs, external app URLs | `link: { url: "https://app.hubspot.com/.../{{ deal_id }}" }` | Let users click from BI results to HubSpot, Google, or another operational tool. | Dynamic Content Blocks support links built from `.raw` values. FilterBlock and dynamic content support drill-through/cross-filtering via documented interactions and `<h-drill>`. | **Alternative / partial** | I verified dynamic content links and dashboard drill-through. I did not verify a model-field-level equivalent of Looker's `link` menu on every table cell. | **Manual**. |
| Filter propagation and dashboard interactions | Liquid builds Looker URLs with `filterable_value`; dashboard element filters use Liquid defaults. | Pass context between reports or apply defaults dynamically. | `FilterBlock`, `FilterInteraction`, cross-filtering, drill-through settings, and user-attribute defaults in filters. | **Native for dashboard controls; manual for URL parity** | Holistics interactions are configured as dashboard block mappings, not string-built Looker URLs. External URL propagation needs manual link design. | **Dashboards not automatic**. |
| Dynamic warehouse / SQL preamble | `sql_preamble` selects Snowflake warehouse when a large table is in query. | Optimize cost/performance based on query shape. | Dynamic data source/schema by user/git context is documented. Query models and pre-aggregates can be modeled for performance. | **Unknown / alternative** | I found no documented Holistics equivalent of Looker's `sql_preamble` that runs arbitrary pre-query SQL based on selected fields. Validate with Holistics product if this exists in Flip's LookML. | **Not automatic**. |
| Localization | `_localization['key']` in dashboard defaults or filters. | Localize labels/content by locale. | Not verified in the docs reviewed. | **Unknown / unverified** | Do not promise localization parity without dedicated Holistics localization evidence. | **Not automatic**. |
| Actions / custom actions | Liquid in Looker `action` parameters. | Trigger external workflows from query results. | Not verified in the docs reviewed. | **Unknown / unverified** | Dynamic links are not the same as Looker actions that call an integration. | **Not automatic**. |

## Flip-specific findings

I reviewed the supplied Flip source bundles and the existing minimal dynamic measure demo:

- Inventory note: `demo4/clients/flip/lookml-holistics-mapping.md`.
- Source LookML bundles: `demo4/clients/flip/lookml/internal_all_flipsters/` and `demo4/clients/flip/lookml/internal_marketing/`.
- Minimal selector demo: `demo4/clients/flip/demo-dynamic-measures/`.

### Count-versus-euro dynamic measure switching

The existing demo contains two independent Looker Liquid selectors in `flip_deals.view.lkml`:

- `base_metric_loss_analysis`: `# Lost Opps` vs `€ Lost ARR`.
- `base_metric_sao_loss_analysis`: `# SAOs` vs `€ SAO Volume`.

The original source in `hubspot_deals_all_ext.view.lkml` has the same business pattern:

```lookml
parameter: base_metric_loss_analysis {
  type: unquoted
  allowed_value: { label: "# Lost Opps" value: "opps" }
  allowed_value: { label: "€ Lost ARR" value: "arr" }
}

measure: dynamic_base_metric_loss_analysis {
  type: number
  label_from_parameter: base_metric_loss_analysis
  sql: {% if base_metric_loss_analysis._parameter_value == 'opps' %}
      ifnull(COUNT(${dmt_closed_lost_date}),0)
      {% else %}
      ifnull(SUM(${lost_amount_euros}),0)
      {% endif %};;
  html: {% if base_metric_loss_analysis._parameter_value == 'arr' %} €{{ rendered_value }}
        {% else %} {{ rendered_value }}
        {% endif %} ;;
}
```

Holistics has documented Dynamic Metrics Selection with parameter fields and AQL `case`, so the business outcome is a good minimal demonstration candidate. It still requires manual AML/AQL design because:

- the LookML Liquid is not automatically converted;
- the count branch and money branch have different units;
- the Looker HTML euro prefix must be replaced by Holistics number formatting or a dashboard/dynamic-content design;
- the demo's reduced left join is not equivalent to the original full outer join in `hubspot_deals_and_companies_all`.

### Dynamic date grain

Flip uses `date_granularity` in `hubspot_deals_all_ext` and `hubspot_deals_all_historized_ext` to choose month, quarter, year, day, or “overall”-style date fields. Holistics `DateDrillBlock` is a native fit for standard chart grain switching. Custom string labels such as concatenated year-quarter, or `overall`, should be modeled manually if the reporting surface needs the exact same display.

### Channel selector

Flip uses `dynamic_channel_parameter` and `dynamic_channel` to switch between source channel department and source channel cluster/drilldown. Holistics Dynamic Dimensions Selection is a direct business-outcome fit, but the exact `label_from_parameter` behavior is manual.

### Date range and period comparison selectors in marketing views

`marketing_filters_allocation_ext` has live dynamic date comparison dimensions that produce first and second period flags from a `date_selection` parameter. Holistics offers date filters, `DateDrillBlock`, and `PopBlock` period-over-period controls. If Flip needs the exact named options from Looker, such as “Q3 this Year” or “last 2 months” with custom previous-period definitions, model these explicitly instead of assuming PopBlock matches every branch.

### Legacy BASE / TEAM / META target switching

In the current allocation view, `dynamic_target_parameter` only allows `BASE`, and many dynamic target measures are commented out. In the legacy `marketing_filters_ext` view, `BASE`, `TEAM`, and `META` target switching is live across many measures. Treat this as legacy scope unless Darius confirms those reports are still required. If required, Holistics can likely reproduce the outcome with parameter fields and dynamic metrics, but the implementation is manual and needs parity tests for `sum_distinct` keys and ratio-of-sums logic.

### Templated filters and date boundaries

`flip_users_unique_ext` uses a hidden `period_filter`, `{% condition period_filter %}`, and `{% date_start period_filter %}` for active-user measures. For this Flip-specific pattern, Holistics can alternate by a date parameter and use its first date, so the observed `date_start`-style behavior is coverable manually. I did not verify a current Holistics equivalent for retrieving the last date / `date_end` from that same date parameter or range. Use an explicit end-date parameter if exact end-boundary logic is required.

### Links and HTML

The Flip source has HubSpot links on deals, companies, contacts, calls, emails, and pipeline rows. It also uses HTML for conditional red highlighting and currency display. Holistics Dynamic Content Blocks can build data-driven links and conditional HTML/CSS, but that is not the same as Looker's field-level `link` and `html` behavior in all result tables. For a migration estimate, count these as manual UX decisions, not automatic semantic migration.

## High-impact gaps to validate before a prospect commitment

1. **Runtime dynamic metric parity**: Build one Holistics dynamic metric for the two Flip selectors and compare Looker vs BigQuery vs Holistics for both branches, with at least one company breakdown.
2. **Label and formatting parity**: Confirm whether the chosen Holistics surface can show “# Lost Opps” vs “€ Lost ARR” clearly enough without Looker `label_from_parameter` and `html`.
3. **Full outer join and role-playing semantics**: The minimal dynamic-measures demo uses a left many-to-one join. The original Deals & Companies Explore uses a full outer join, and the marketing allocation Explore uses many role aliases and full outer / many-to-many joins.
4. **`sum_distinct` and fan-out behavior**: The marketing target and spend metrics rely on distinct keys. Holistics fan-out handling and AQL definitions need asymmetric test data or live-result comparison.
5. **Query-context Liquid**: If Flip has production dashboards depending on `_in_query`, `_is_selected`, `_is_filtered`, or `sql_preamble`, get product confirmation or redesign explicitly. I did not find a documented Holistics query-shape variable equivalent.
6. **Field-level links / cell HTML**: Confirm whether the exact user workflow requires per-cell field links in standard data tables, or whether dashboard/dynamic-content links are acceptable.
7. **Security semantics**: If Looker Liquid uses user attributes for access control, migrate to Holistics RLP/CLP patterns. Do not use dashboard filters, hidden fields, or dynamic labels as a security substitute.

## Recommended minimal demonstration

Build the smallest Holistics-native version of the existing `demo-dynamic-measures` example:

1. Convert only Liquid-free table fields and ordinary SAO measures first, or hand-author equivalent AML if the converter rejects the mixed Liquid file.
2. Create a `flip_metric_selector` parameter field with `opps` and `arr` values.
3. Create one dynamic metric for Closed Lost using AQL `case`, with branches equivalent to `COUNT(dmt_closed_lost_date)` and `SUM(lost_amount_euros)`.
4. Add a dashboard `FilterBlock` bound to the parameter and one chart by company industry.
5. Show two states: `# Lost Opps` and `€ Lost ARR`.
6. State explicitly that this proves the selector outcome, not automatic Liquid migration, not full outer join parity, and not the marketing allocation funnel.

This demo directly answers Darius's dynamic measure-switching need while keeping the scope honest.

## Confirmed versus unverified

Confirmed from docs:

- Looker Liquid is available in SQL and presentation parameters.
- Looker templated filters and Liquid parameters can alter SQL beyond outer `WHERE` / `HAVING`.
- Looker PDT persistence is not supported for derived tables using templated filters or Liquid parameters.
- Holistics parameter fields support dynamic metrics, dimensions, query models, and dashboard binding.
- Holistics migration assistant does not automatically convert Liquid definitions, Explores, dashboards, or NDTs.
- Holistics has documented user attributes, RLP, CLP patterns, dynamic data-source/schema expressions, dashboard controls, and dynamic content blocks.

Not runtime-tested in this thread:

- Any Holistics AML implementation against Flip data.
- Exact Looker-to-Holistics result parity for the dynamic selectors.
- Exact field-picker and result-column label behavior for dynamic parameter labels.
- Exact `date_end` / last-date extraction from the same date parameter used for Flip's `date_start`-style behavior.
- Exact standard-table per-cell HTML/link parity.
- A Holistics equivalent for Looker `_in_query`, `_is_selected`, `_is_filtered`, or `sql_preamble`.
