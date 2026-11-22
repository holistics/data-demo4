# Flip LookML inventory and Holistics mapping

Reviewed: 11 September 2026. Scope: the supplied LookML export, not a complete audit of Flip's live Looker project.

**The export contains 50 view declarations, two model files and 13 Explore declarations across 48 restored `.lkml` files.** A proposed consolidated inventory is 27 logical Holistics models and seven current user-facing datasets. These are planning counts, not implemented assets or a fixed migration estimate.

## Model-folder layout

The restored files are grouped by each model's recursive `include` dependencies. Each folder contains its model file at the root, then `base_views/` and `extended_views/`, preserving the source's `Datamarts/` and `Reports/` divisions.

| Folder | Model file | Base view files | Extended view files | View declarations | Explores declared in model file |
|---|---|---:|---:|---:|---:|
| [All Flipsters](lookml/internal_all_flipsters/) | `internal_all_flipsters.model.lkml` | 23 | 23 | 50, including four nested helpers | 7 |
| [Marketing](lookml/internal_marketing/) | `internal_marketing.model.lkml` | 14 | 14 | 28 | 2 |

All Flipsters uses wildcard includes covering every supplied extended view, even when its explicit Explores do not use that view. Marketing includes 13 extended views directly and reaches `hubspot_customers_all_ext` through the deals view. Its 28 base/extended files therefore also occur in the All Flipsters folder as identical source copies. There are now **76 physical `.lkml` files representing the original 48 unique source files**; the inventory counts below remain deduplicated. The four hidden base-file Explores occur only in the All Flipsters folder.

These folders are source-review bundles, not a single combined deployable Looker project. File contents and original include strings are unchanged; resolve project-root includes relative to each bundle and account for the export's `.view` versus restored `.view.lkml` suffix. Missing semantic references still require resolution. Keep the original JSON wrappers as the authoritative export rather than independently editing duplicate view copies.

## Sources and verification

| Source | Purpose |
|---|---|
| [Original ZIP](../../poc_lookml_files.zip) | Contains 48 JSON export envelopes with `original_path`, `target_project` and `content`; the extracted `poc_lookml/` folder is no longer present |
| [Restored LookML](lookml/) | Native `.lkml` files reconstructed from each wrapper's `content` |
| [Logical schema DBML](flip-lookml-schema.dbml) | 27 logical entities; alias roles recorded as relationships/provenance rather than duplicate tables |
| [Holistics conceptual differences](https://docs.holistics.io/docs/from-others/looker/conceptual-differences) | Conceptual mapping of views, models, Explores and relationships |
| [Holistics Looker migration tool](https://docs.holistics.io/docs/from-others/looker/migration-tool) | Automation limits; this inventory does not imply automatic Explore or Liquid conversion |
| [Holistics fan-out resolution](https://docs.holistics.io/docs/joins/fan-out-resolution) | Aggregation behavior to verify during metric migration |

All 48 restored files were byte-checked against decoded JSON `content` and parsed successfully with the Python `lkml` parser. The DBML passed `dbdiagram validate` with no warnings. Neither check validates Looker dependency resolution, warehouse keys, live query results or Holistics metric parity. Some referenced definitions are absent from the export; for example, the DBML marks `hubspot_deals_all_ext.deal_source_channel_first_contact_id_associated_hubspot` as unresolved.

## 1. Source counts versus proposed Holistics counts

| Object | Verified Looker export | Proposed Holistics treatment | Target count |
|---|---:|---|---:|
| Base view declarations | 23 | Combine each base definition with its extended business logic | 23 consolidated models |
| Extended view declarations | 23 | Merge into the corresponding model rather than automatically duplicating its table | Included above |
| Nested/UNNEST helper view declarations | 4 | Represent nested collections separately where needed | Up to four additional models |
| **Total view declarations** | **50** | **27 logical entities before role-playing aliases or scope reduction** | **27-model starting inventory** |
| `.view.lkml` files | 46 | Target file organization need not match source organization | Not fixed |
| `.model.lkml` files | 2 | Carry over connection and exploration configuration | Not two Holistics models |
| Visible, nonlegacy Explores | 7 | Starting boundaries for user-facing datasets | Seven dataset candidates |
| Visible legacy Explore | 1 | Exclude unless its reports or behavior are still required | Zero or one dataset |
| Hidden Explores | 5 | Review technical purpose and dependencies before exposing | Not fixed |
| **Total Explore declarations** | **13** | **Seven current visible, one legacy and five hidden** | **Seven-dataset starting scope** |
| **Total restored files** | **48** | 46 view files and two model files | Not a target AML file count |

The guide maps both Looker models and Explores to datasets at different conceptual levels. For this export, use each Explore as the initial dataset boundary, not one dataset per `.model.lkml` file. Looker uses a fixed root view; Holistics chooses the starting model and join paths dynamically from selected fields. That difference requires query-parity tests, particularly for full outer joins and role-local filters.

## 2. All 23 base/extended pairs

Except for row 12, each source pair follows `<stem>_base` and `<stem>_ext`. Proposed target identifiers use the `flip_` namespace; they are suggestions, not existing AML definitions. Entity descriptions below do not establish verified primary keys.

| # | Looker view stem / pair | What it represents | Proposed Holistics model | Migration consideration |
|---:|---|---|---|---|
| 1 | `flip_channels_unique` | Product channels | `flip_channels_unique` | Keep channel grain separate from posts and nested permissions |
| 2 | `flip_feature_tenant_unique` | Tenant-feature records | `flip_feature_tenant_unique` | Validate tenant/feature uniqueness before defining relationships |
| 3 | `flip_posts_unique` | Product posts | `flip_posts_unique` | Joining posts to channels can multiply channel rows |
| 4 | `flip_reactions_unique` | Product reactions | `flip_reactions_unique` | Preserve reaction grain when joining users and tenants |
| 5 | `flip_tenants_daily_aggregations_historized` | Historical daily tenant aggregates | `flip_tenants_daily_aggregations_historized` | Snapshot metrics must not automatically sum across dates |
| 6 | `flip_tenants_unique` | Tenant attributes | `flip_tenants_unique` | Distinguish current attributes from historical daily facts |
| 7 | `flip_user_groups_unique` | Product user groups | `flip_user_groups_unique` | Validate group-to-customer/tenant relationships |
| 8 | `flip_users_unique` | Product users, including deleted users | `flip_users_unique` | Preserve inclusion rules and nested notification settings |
| 9 | `hubspot_companies_all` | CRM companies | `flip_hubspot_companies_all` | Validate company keys and deal/customer cardinality |
| 10 | `hubspot_contacts_all` | CRM contacts | `flip_hubspot_contacts_all` | Reused under five lifecycle roles in the allocation funnel |
| 11 | `hubspot_customers_all` | CRM customers and customer metrics | `flip_hubspot_customers_all` | Preserve recurring-revenue and retention definitions |
| 12 | `hubspot_deal_marketing_influence_touchpoints_unnested_base` + `hubspot_deal_marketing_influence_touchpoint_ext` | Unnested deal marketing-influence touchpoints | `flip_hubspot_deal_marketing_influence_touchpoints` | Multiple touchpoints can fan out a deal; used under two funnel roles |
| 13 | `hubspot_deals_all` | CRM deals and deal measures | `flip_hubspot_deals_all` | Priority metric model; reused under 11 funnel roles |
| 14 | `hubspot_deals_all_historized` | Historical CRM deal records | `flip_hubspot_deals_all_historized` | Separate historical grain from current-deal grain |
| 15 | `hubspot_engagement_calls_sales` | Sales calls | `flip_hubspot_engagement_calls_sales` | Preserve activity-date and allocation logic |
| 16 | `hubspot_engagement_emails_sales` | Sales emails | `flip_hubspot_engagement_emails_sales` | Preserve activity-date and allocation logic |
| 17 | `hubspot_engagement_meetings_sales` | Sales meetings | `flip_hubspot_engagement_meetings_sales` | Used under two date roles in the funnel |
| 18 | `salesloft_meetings_held` | Salesloft meeting activity | `flip_salesloft_meetings_held` | Preserve the occurred-at date role |
| 19 | `gtm_partner_pipeline_over_time` | Partner pipeline snapshots | `flip_gtm_partner_pipeline_over_time` | Validate snapshot aggregation across periods |
| 20 | `gtm_sales_pipeline_over_time` | Sales pipeline snapshots | `flip_gtm_sales_pipeline_over_time` | Validate snapshot aggregation across periods |
| 21 | `gtm_targets_by_department` | Department-level GTM targets | `flip_gtm_targets_by_department` | Preserve target grain and explicit distinct-key semantics |
| 22 | `marketing_filters_allocation` | Root/filter structure for the current allocation funnel | `flip_marketing_filters_allocation` | Test its role in retaining unmatched rows |
| 23 | `marketing_filters` | Root/filter structure for the legacy segment funnel | `flip_marketing_filters` | Candidate for exclusion if legacy reporting is out of scope |

## 3. Four additional helper views

These are nested collections, not four additional top-level warehouse tables.

| Looker helper view | Parent entity | Purpose | Proposed Holistics treatment |
|---|---|---|---|
| `flip_channels_unique__admin_permissions` | Channels | Channel admin permissions | Separate unnested model if required |
| `flip_channels_unique__member_permissions` | Channels | Channel member permissions | Separate unnested model if required |
| `flip_channels_unique__moderator_permissions` | Channels | Channel moderator permissions | Separate unnested model if required |
| `flip_users_unique__push_noti_resting_days` | Users | Push-notification resting days | Separate unnested model if required |

## 4. All 13 Explores

Join counts are explicit joins in each declaration, not counts of unique warehouse tables or proof of runtime availability. Proposed dataset labels should carry a “Flip” prefix when implemented in Demo4.

| Looker container | Explore | Status | Root view | Joins | Proposed Holistics treatment |
|---|---|---|---|---:|---|
| `internal_all_flipsters` | `hubspot_deals_and_companies_all` | Visible | `hubspot_deals_all_ext` | 4 | Flip Deals & Companies dataset |
| `internal_all_flipsters` | `hubspot_contacts_all` | Visible | `hubspot_contacts_all_ext` | 0 | Flip Contacts dataset |
| `internal_all_flipsters` | `all_flipsters_customers_and_deals` | Visible | `hubspot_customers_all_ext` | 4 | Flip Customers & Deals dataset |
| `internal_all_flipsters` | `flip_users_unique_ext` | Hidden | `flip_users_unique_ext` | 0 | Keep users available to other datasets; standalone dataset only if needed |
| `internal_all_flipsters` | `flip_channels` | Visible | `flip_channels_unique_ext` | 3 | Flip Channels dataset |
| `internal_all_flipsters` | `flip_production_tenants` | Visible | `flip_tenants_daily_aggregations_historized_ext` | 3 | Flip Tenant Adoption dataset |
| `internal_all_flipsters` | `flip_production_reactions` | Visible | `flip_reactions_unique_ext` | 3 | Flip Reactions dataset |
| `internal_marketing` | `marketing_funnel_allocation` | Visible/current | `marketing_filters_allocation_ext` | 26 | Flip GTM Funnel — Allocation dataset; priority parity case |
| `internal_marketing` | `marketing_funnel` | Visible/legacy | `marketing_filters_ext` | 22 | Exclude initially unless still needed |
| Channel base-view file | `flip_channels_unique_base` | Hidden | Same-named base view | 3 | Technical Explore for nested permission joins; review before translating |
| Tenant base-view file | `flip_tenants_unique_base` | Hidden | Same-named base view | 0 | No automatic standalone dataset |
| User-group base-view file | `flip_user_groups_unique_base` | Hidden | Same-named base view | 0 | No automatic standalone dataset |
| User base-view file | `flip_users_unique_base` | Hidden | Same-named base view | 1 | Technical Explore for nested notification settings; review before translating |
| **Total** | **13 declarations** | **Seven current visible + one legacy + five hidden** | | **69** | **Seven initial user-facing dataset candidates** |

## 5. Allocation funnel alias roles

An alias is another role for the same source view, not another source view declaration. It may require a distinct model role in Holistics to preserve independent joins and filters. Do not assign a final target model count until this design is tested.

| Source view | Roles in `marketing_funnel_allocation` | Count | Meaning to preserve |
|---|---|---:|---|
| `hubspot_deals_all_ext` | `hubspot_sal`, `hubspot_sao`, `hubspot_solution_design`, `hubspot_evaluation`, `hubspot_proposal`, `hubspot_negotiation`, `hubspot_closing_validation`, `hubspot_closed_won`, `hubspot_closed_lost`, `hubspot_close_date`, `hubspot_expected_sd_date` | 11 | Different stage/date relationships and role-specific filters |
| `hubspot_contacts_all_ext` | `hubspot_contacts_lead`, `hubspot_contacts_mql`, `hubspot_contacts_sql`, `hubspot_contacts_opportunity`, `hubspot_contacts_all` | 5 | Different lifecycle/date roles |
| `hubspot_engagement_meetings_sales_ext` | Original meeting role + `meetings_on_create_date` | 2 | Different meeting-date interpretations |
| `hubspot_deal_marketing_influence_touchpoint_ext` | `hubspot_sao_marketing_influenced`, `hubspot_closed_won_marketing_influenced` | 2 | Marketing influence at different funnel stages |
| Other joined views | Targets, sales pipeline, partner pipeline, calls, emails, Salesloft meetings | 6 | Separate target, snapshot and activity grains |
| **Total joined roles** | | **26** | **Do not collapse roles merely because they share a table** |

The allocation Explore includes full outer and many-to-many joins and join-local SAL filters. Validate both matched and unmatched populations, not only totals from a single measure.

## 6. Metric behaviors requiring migration proof

| Flip requirement | What must survive migration | What to verify in Holistics |
|---|---|---|
| Dynamic measure switching | A selection changes the metric without changing its business definition | Implement selector behavior explicitly; compare each branch against Looker |
| Role-playing aliases | The same entity participates independently under several stage/date roles | Selecting SAL and SAO together retains each role's joins and filters |
| `sum_distinct` on fan-out measures | Deduplication follows the specified entity key, not distinct numeric values | Test two entities with equal amounts plus duplicated joined rows; preserve non-primary-key distinct keys for targets/spend |
| Ratio-of-sums | Aggregate numerator and denominator separately, then divide | Compare totals and grouped results; do not substitute an average of row ratios |
| Measure-of-measures | Inner and outer aggregations occur at the intended grains | Make grouping levels explicit and compare asymmetric groups |
| Period-over-period | Comparison uses the intended date role, period and filtering rules | Check boundaries, missing periods and current/prior date alignment |
| Median | Median uses the intended entity population, filters and deduplication | Verify `deal_id` grain and the NewBusiness filter under fan-out |

Holistics fan-out support for AQL/UI aggregation does not establish equivalence for arbitrary raw SQL measures. Compare Looker results, independently checked SQL and Holistics results before declaring parity. Suspicious source SQL is a question to investigate, not evidence of a proven Looker bug.

## 7. Open decisions before fixing migration scope

| Decision | Current planning assumption | Evidence needed |
|---|---|---|
| Which Explores to expose | Seven visible nonlegacy candidates | Darius confirms actual report usage and POC priorities |
| Whether to retain legacy funnel | Exclude initially | Confirm no required reports depend on it |
| Whether to retain hidden helpers | Preserve needed relationships, not automatic datasets | Inspect dependency and nested-field usage |
| How to implement role-playing aliases | Preserve independent semantics before consolidating | SAL/SAO/ClosedWon and target parity tests with combined selections |
| Whether 27 logical entities cover dependencies | Inventory baseline only | Resolve missing referenced views/fields and verify keys in the warehouse |
| Initial proof slice | Allocation funnel: SAL, SAO, ClosedWon and targets | Agreed Looker outputs, date ranges, filters and expected totals |

This document records the supplied export and a proposed mapping. It does not authorize connecting prospect data to the shared Demo4 tenant, changing tenant AI context, publishing assets or migrating the full project.
