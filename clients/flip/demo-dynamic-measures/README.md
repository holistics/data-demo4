# Flip — minimal dynamic measure switching demo

Three LookML files: one model, two flattened views, one Explore, one join, two parameters and four measures (two ordinary and two dynamic). This is a reduced demo, separate from the unchanged source bundles in `../lookml/`. It uses Flip's real deal and company tables, not synthetic data, and has not been deployed or queried against Looker/BigQuery.

| File | Purpose |
|---|---|
| `flip_dynamic_measures.model.lkml` | Original Looker connection name, relative includes and a deals-to-companies Explore |
| `flip_deals.view.lkml` | Deal dimensions, company join key, two date groups, two amounts, two ordinary SAO measures and two dynamic selectors/measures |
| `flip_companies.view.lkml` | Company ID, name, industry and region for a joined breakdown |

The join is `flip_deals.company_id = flip_companies.company_id`, declared `many_to_one` and `left_outer`. It keeps deals without a matching company. The original Deals & Companies Explore uses the same key/cardinality but a full outer join; this demo deliberately omits company-only rows. Company ID is declared a primary key for the demo based on that relationship, not a verified warehouse constraint. Check uniqueness and non-null keys before presenting joined results. This join should not multiply deal rows; it is not a fan-out demo.

## Migration-tool demonstration

The [migration assistant documentation](https://docs.holistics.io/docs/from-others/looker/migration-tool) supports views, dimensions and measures, but excludes Liquid definitions and Explore-to-dataset conversion. Actual conversion of this bundle has not been run.

| Demo part | Expected migration route |
|---|---|
| Company view and ordinary deal fields | Convert to Holistics models/dimensions; review generated types and keys |
| `sao_count`, `sao_volume_euros` | Ordinary filtered count and sum examples for the converter; inspect translated filter and null behavior |
| Explore and company join | Build the Holistics dataset/relationship manually; do not promise automatic migration |
| Parameters, Liquid measures and dynamic labels/HTML | Recreate the switching interaction manually in Holistics |

Start with the company view to show a small Liquid-free conversion. Then demonstrate ordinary deal fields/measures and show the dynamic definitions as explicit migration exceptions. If mixed Liquid content blocks conversion of the deal file, submit only its ordinary definitions for the tool demonstration; keep the original demo file unchanged. Do not claim the tool automatically migrates the selector.

`sao_count` counts rows with a non-null SAO date, rather than all deals. `sao_volume_euros` sums initial SAO amounts without adding a date filter, matching the money branch's population. These ordinary measures are demo additions; unlike the dynamic SQL, the sum does not explicitly coalesce an all-null result to zero.

## Demo walkthrough

1. Load these three files together in an authorized Looker development project with access to connection `fl-bi-p-looker-sa` and the `hubspot_deals_all` and `hubspot_companies_all` tables in `fl-bi-p-poc.datamarts_poc`. The connection name comes from the export; it is not configured by these files.
2. Open **Flip Deals — Dynamic Measures**. First check ordinary SAO count and volume by company industry; compare grand totals to a deals-only query. Then select company industry and the closed-lost dynamic measure.
3. Add the **Base Metric Loss Analysis - Closed Lost** parameter as a filter and explicitly select **# Lost Opps**. Run a bar chart.
4. Change the parameter to **€ Lost ARR** and run again. Check values, measure label and currency display while keeping the same dimension.
5. Repeat with the SAO dynamic measure and its independent parameter: **# SAOs → € SAO Volume**.
6. Drill into a result to inspect the reduced deal-detail list. Check display behavior in the chosen visualization; HTML formatting support depends on the rendering surface.

## Preserved behavior and deliberate reductions

| Aspect | Demo behavior |
|---|---|
| Closed-lost calculation | `opps` counts non-null closed-lost dates; otherwise sums lost amount; null aggregate becomes zero |
| SAO calculation | `opps` counts non-null SAO dates; otherwise sums initial SAO amount; null aggregate becomes zero |
| Parameter defaults | No explicit default, matching the export; select an option explicitly in the demo |
| Labels/formatting | Source `label_from_parameter`, integer format and conditional HTML euro prefix retained |
| Grain | Source declares `deal_id` as primary key; actual uniqueness has not been checked |
| Dependencies | Base/extended definitions flattened; one company join, no customer view, role-playing aliases or target scenarios |
| Dates/drilling | Date timeframe only and a short deal drill list; broader date grains and source drill fields omitted |
| Lost amount metadata | Source declares `lost_amount_euros` as `string`, with no explicit SQL or base definition. Demo makes the implicit same-named column reference explicit and preserves the type. Confirm the actual column exists and is numeric before running its `sum`; no cast or substitute currency is invented |

The money branches do not add a stage-date filter: this preserves the source SQL. A row with a null stage date but a non-null amount can contribute money without contributing to the count. Do not silently filter it away or change `count(date)` to `count_distinct(deal_id)`.

This demo is intended to illustrate the selector pattern and a simple joined migration. It does not prove fan-out safety, symmetric aggregates, full migration parity or dashboard control wiring. The raw aggregates inside `type: number` rely on the company join not multiplying deal rows. Include unmatched-company deals in checks, and stop if company IDs are duplicated.

Sources: `../lookml/internal_all_flipsters/base_views/Datamarts/hubspot_deals_all_base.view.lkml`, `../lookml/internal_all_flipsters/extended_views/Datamarts/hubspot_deals_all_ext.view.lkml` (loss-analysis section), `../lookml/internal_all_flipsters/base_views/Datamarts/hubspot_companies_all_base.view.lkml` and `../lookml/internal_all_flipsters/internal_all_flipsters.model.lkml` (Deals & Companies join).
