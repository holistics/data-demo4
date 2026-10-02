# Flip bounded funnel migration

Started: 22 September 2026 (Asia/Saigon).
Task: `28e20df3-0859-406c-9335-c475fa491181`.
Thread: https://ampcode.com/threads/T-01a0c877-4a2f-70bf-b5b3-cd7bb4712337

## Scope and authorization

Chinh requested data profiling and extension of the existing funnel POC, followed by adversarial oracle review and a Markdown report. Target the Flip development project on `eu.holistics.io`, authenticated as `darius.bruer@getflip.com`. Do not commit, push, publish, alter permissions, write warehouse data, or change tenant AI context. Keep source exports and evidence outside the synchronized customer repository.

The customer repository has existing uncommitted changes. Preserve them. The CLI initially targets Demo4 as Chinh, so no Flip queries or synchronization may run until the requested identity is verified.

## Agent work

| Step | Action | Completion evidence | Status |
|---|---|---|---|
| 1 | Verify EU CLI authentication as Darius and the intended Flip development project. | EU OAuth user `darius.bruer@getflip.com`, project `2199023299265`, source `flip_poc`, GitLab Flip semantic-layer repository. | Done |
| 2 | Inspect dummy-table coverage for allocation, deals, contacts, departmental targets and marketing touchpoints. | All five schemas inspected and aggregate row counts executed. | Done |
| 3 | Profile primary keys, nulls, duplicate business keys, conflicting values per spend/target key and unmatched stage keys. | Results saved under `.amp/flip-funnel-migration-20260922/` in the presales workspace. | Done for bounded checks |
| 4 | Extend the existing stage-relationship pattern and implement distinct-key spend/targets, remaining supported deal stages, one dynamic selector and one median. | Nine stage count metrics, eleven date-role relationships, seven allocation BASE targets, keyed spend, median and selector execute. Unique allocation-key bridge replaces invalid raw-table cardinality. | Done in development; not certified for rollout |
| 5 | Validate AML/AQL and execute discriminating checks against independent source-semantic expectations. | AML passes. Combined Q1 2026 month/department query returns 24 complete buckets; reference contains 504 rows. | Bounded runtime checks complete; broader cases below remain unverified |
| 6 | Ask oracle for an adversarial review; investigate findings, fix supported defects, and return evidence for follow-up review. | Two successful review rounds. Median blocker fixed and confirmed; disagreements reconciled below. | Done |
| 7 | Deliver Markdown report and update this plan. | Report, evidence and limitations recorded below. | Done |

## Planned validation cases (not all completed)

- Two distinct deals with equal amounts, plus repeated marketing touchpoints.
- Repeated spend/target keys with identical versus conflicting values.
- SAL exclusions that must not exclude SAO-valid deals.
- Different stage dates for the same deal, including a SAL-to-SAO cohort boundary.
- Allocation-only and unmatched deal-stage populations.
- Zero denominators, null values and even/odd median populations.
- Both dynamic-selector branches and combined metric queries.

## Customer inputs still needed for parity

Chinh and Darius should provide Looker tile definitions and outputs with fields, filters, parameter values, timezone, ordering and limits, ideally against the same dummy dataset. Confirm any intentionally changed business semantics and report scope. These inputs do not block independent local implementation or source-semantic testing.

## Findings and implementation decisions

- Allocation: 91,476,448 rows; 122,976 null primary keys; 1,792 duplicate non-null rows across 1,232 keys. No conflicting date/channel/department/allocation variants across non-null keys in the audited projection. Do not claim the raw key is unique.
- Deals: 9,219 rows, unique non-null primary keys and deal IDs. Contacts: 235,163 rows with unique non-null contact IDs. Departmental targets: 6,525 unique non-null primary keys. Touchpoints: 192 rows, 191 deal IDs, no unmatched deal IDs.
- Naive spend: EUR 505,968,457.12. Once per source date/channel key: EUR 3,272,535.13. No conflicting non-null spend values or null spend keys with a non-null spend value found.
- Allocation BASE targets have no detected min/max conflicts; the Closed Won volume target returned null. This does not establish that departmental target measures are migrated.
- The source SAL join requires `is_license_overrun_deal is false`; the POC previously allowed null via `is not true`. Both SAL count and cohort numerator now use the source predicate.
- Source has unmatched stage foreign keys and matching duplicate allocation keys. Preserve raw allocation rows and use a unique non-null key bridge rather than dropping records or inventing warehouse constraints.
- Close Date and Expected SD Date are additional date roles, not invented business stage-count definitions. Nine stage count metrics are implemented; eleven relationships are available.
- Development sync only. Initial sync reported 51 identical common files and pushed four pre-existing local-only files. A complete pre-sync repository backup is retained outside the customer repository. No Git commit, push or Holistics publish.

## Execution report: bounded POC works, parity remains unverified

| Check | Observed result | Evidence in `.amp/flip-funnel-migration-20260922/` |
|---|---|---|
| AML validation | No errors across the funnel, bridge, reference and quality assets | `holistics aml validate` run after median repair |
| Combined Q1 query | 24 of 24 month/department buckets; no execution errors | `combined-final-result.yaml` |
| Independent source-semantic reference | 504 of 504 rows retrieved using artifact paging; 21 metrics × 24 buckets | `reference-full.yaml`, `reference-result.yaml` |
| Parent comparison | 744 displayed-value checks across combined query and three selector edge runs: 678 exact, 66 within display rounding, zero outside rounding | Combined, reference and selector YAMLs; this is not raw-precision parity |
| Exact median | Generated SQL uses `PERCENTILE_CONT` after deal-ID grouping; all 24 buckets match reference, including 12 null medians | `median-repair-result.yaml`, `combined-final-result.yaml` |
| Selector count/euro | Both branches execute; euro values checked against reference | `combined-final-result.yaml`, `selector-euro-result.yaml` |
| Selector edge cases | No selection returns null; both allowed values choose count | `selector-unset-result.yaml`, `selector-multi-result.yaml` |
| Allocation-only buckets | All 24 retained with `allocation_spine_rows`; stage-only query retains only 20 | `stages-result.yaml`, `combined-final-result.yaml` |
| Existing work | Backup comparison found only the funnel dataset changed and four new AML files; no existing source file deleted | `customer-repo-before.tar.gz`; ignore tar-generated AppleDouble metadata entries |

### Oracle reconciliation

| Challenge | Resolution |
|---|---|
| Nested median passed AML but failed runtime | Replaced nesting with filtered deal relation → group by deal ID → max amount → exact median → SAO relationship. Combined runtime query passes. Oracle confirmed blocker resolved. |
| Selector needs a dashboard default | No dashboard changed and existing funnel page does not expose the new selector. Keep dataset-only scope; require exactly one value when wiring a tile. Unset/null and multi/count differ from Looker behavior and are not accepted parity. |
| Looker raw selector aggregates inflate on duplicate joins | Plausible from source `type: number` SQL, but not observed in Looker. Oracle downgraded its categorical claim. Do not quantify divergence without Looker-generated SQL/results. |
| Fractional targets appear rounded | Source presentation uses integer formatting. SQL does not round; preserve presentation and report formatted-value checks separately from raw numeric parity. |
| Bridge alone proves correct row retention | Rejected. Retention is verified only for tested allocation dimensions with the spine metric included. |
| All measures are migrated Looker measures | Rejected. Existing SAL-to-SAO cohort and conversion rate are custom POC logic, not certified Looker conversions. |

### Limits and owner actions

| Limit | Consequence / owner action |
|---|---|
| No Looker-produced baseline | Darius: provide a Q1 month/department tile export and generated SQL with filters, parameter value, timezone and source snapshot. Agent SQL is a hypothesis, not a baseline. |
| Raw allocation keys contain duplicates/nulls | Bridge is an agent-authored redesign, not an approved semantic equivalence. Darius: confirm intended handling of duplicated and unmatched keys. |
| Fixed Looker root versus dynamic Holistics root | Include `allocation_spine_rows` in allocation reports. Unfiltered grand totals, unmatched/null buckets and alternative grouping/filter paths remain uncertified. |
| Selector bound to SAO alias | Assumed report intent; Darius must confirm the source tile alias. No-selection behavior differs from source Liquid fallback. |
| Median reference relies on profiled unique deal IDs | It does not independently inject duplicate IDs or test constructed even/odd populations. Distinct-key behavior is supported by generated SQL, not a synthetic fixture. |
| Display rounding | Exact underlying numeric comparison remains outstanding. The 66 rounding-compatible checks are not exact matches and do not establish a customer-approved tolerance. |
| Query cost | Large allocation table is repeated in generated SQL. No cold-cache benchmark or persisted bridge. Do not infer acceptable dashboard performance. |
| Unexecuted planned cases | No synthetic equal-amount/deal-duplication/touchpoint-fanout suite, alternate grouping or full no-dimension reconciliation. Live profiling and grouped checks do not replace these. |
| Development-only audit assets | `flip_funnel_reference`, `flip_funnel_key_audit` and `flip_funnel_data_quality` are diagnostic assets. Review/remove before any future publish; no publish authorized. |
| Migration breadth | Contacts, departmental targets and touchpoints were profiled, not fully migrated. This is a bounded funnel extension, not completion of the full LookML project. |

### Bounded metric mapping ledger

All rows use the supplied full LookML extraction (zip snapshot; upstream revision unknown), route `agent implementation`, provenance `agent-authored`, status `unverified` for Looker parity. Runtime evidence is the complete Q1 comparison above. Dependencies are raw allocation, raw deals and the new unique-key bridge; selector also uses the existing parameter model. Darius owns source-equivalence decisions. No whole-project inventory completion is claimed.

Source paths: `A` = `lookml/extended_views/Reports/marketing_filters_allocation_ext.view.lkml`; `D` = `lookml/extended_views/Datamarts/hubspot_deals_all_ext.view.lkml`. Targets are metrics in `flip_funnel_relationship_poc`.

| Source field | Target | Mapping / validation concern |
|---|---|---|
| A:spend_sum_euros | spend_euros | Sum one value per date/channel key; conflicting values audited |
| A:target_lead_count | target_lead_count | BASE target key, not naive sum |
| A:target_mql_count | target_mql_count | BASE target key |
| A:target_sql_count | target_sql_count | BASE target key |
| A:target_sal_count | target_sal_count | BASE target key |
| A:target_sao_count | target_sao_count | BASE target key |
| A:target_sao_volume_sum | target_sao_volume_euros | BASE target key; fractional value formatting |
| A:target_closed_won_arr_sum | target_closed_won_volume_euros | BASE target key; dummy values null |
| D:sals_count | sal_count | SAL date role; New Business; join-local exclusions applied in metric |
| D:saos_count | sao_count | SAO role; New Business and Upsell |
| D:solution_design_count | solution_design_count | SD role; New Business |
| D:evaluation_count | evaluation_count | Evaluation role; New Business |
| D:proposal_count | proposal_count | Proposal role; New Business |
| D:negotiations_count | negotiations_count | Negotiations role; New Business |
| D:closing_validation_count | closing_validation_count | Closing Validation role; New Business |
| D:closed_won_count | closed_won_count | Won role; New Business and Upsell |
| D:closed_lost_count | closed_lost_count | Lost role; New Business |
| D:sao_volume_median_euros | sao_median_initial_amount_euros | Distinct deal ID, exact median; New Business with SAO date |
| D:dynamic_base_metric_sao | dynamic_sao | Two helper branches; SAO role assumption; unset/multi-select gaps |

This ledger enumerates 19 scoped source measures and 19 corresponding target measures. Eleven date-role relationships are available; Close Date and Expected SD add no invented stage-count measures. Existing cohort/spine helpers and two selector helper branches are implementation support, not additional migrated source measures.
