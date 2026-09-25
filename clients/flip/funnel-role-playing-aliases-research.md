# Flip funnel role-playing aliases research

Date: 2026-09-11. Scope: research and demo scoping only; no Flip data connection, AML migration, deployment, or change to the preserved LookML source bundles.

## Answer first

Chinh's recollection is directionally right but the wording needs care. I did **not** find Darius saying “role-play aliases” in the discovery transcript. The phrase appears in the onboarding booking payload as one of the “Specific Questions & Use-cases”: “dynamic measure switching, role-play aliases, sum_distinct on fan-out measures, ratio-of-sums, measure-of-measures, period-over-period, median” (Slack thread `C95QEV4JF`, `1789048479.492739`, cached in `.amp/in/artifacts/flip-slack-thread-1789048479.json`). Chinh then asked in Slack, “Not sure what does he mean role-play aliases?” (`1789101202.285939`).

The primary prospect statement that maps to this topic is Darius's written question 2b, not the call transcript: “We have one sales pipeline explore that joins the same view eleven times, once per funnel stage, each join carrying seven parameters - 77 parameter instances in one explore. Does AQL support a repeated, parameterised view join like that?” The source LookML confirms the concrete case: current Explore `marketing_funnel_allocation` joins `hubspot_deals_all_ext` 11 times under different aliases, including SAL, SAO, Closed Won, Close Date, and Expected SD Date.

The business problem is therefore: **Flip needs trustworthy sales-funnel metrics where each funnel stage has its own date grain, population rules, and allocation/target alignment, while still being explorable together for self-service.** The mechanism is role-playing aliases of the deals view. The smallest faithful demo should show SAL, SAO, and Closed Won over the allocation date spine, because a single global deal date or global filter will visibly give wrong stage counts.

## Evidence

| Claim | Evidence |
|---|---|
| Darius's broad business goal is one AI-native semantic layer for internal and external reporting. | Discovery transcript: “we want to have like one semantic layer that we can leverage… for our internal usage, but also for our external usage for our customers, and which is more AI native” at `[00:39]` ([transcript lines 7-11](../../../dealops/logs/call-transcripts/2026-08-14_getflip_call_discovery_transcript.clean.md#L7-L11)). |
| Self-service and trust matter because business questions still go back to Darius/data team. | Darius: “if the users can do more self-service… that also benefits the data team” at `[03:29]`, and “a lot of questions get redirected to me” at `[04:29]` ([transcript lines 13-19](../../../dealops/logs/call-transcripts/2026-08-14_getflip_call_discovery_transcript.clean.md#L13-L19)). |
| Migration assistant should not be over-promised for this Explore. | Current [Holistics migration assistant docs](https://docs.holistics.io/docs/from-others/looker/migration-tool) say views/dimensions/measures convert, but “Looker Explores → Holistics Datasets” are “Not yet supported” and Liquid definitions are not supported by the standard assistant. Fetched 2026-09-11. |
| The current funnel Explore is `marketing_funnel_allocation`, not legacy `marketing_funnel`. | `marketing_funnel_allocation` is labelled “GTM Funnel (Allocation)” ([model lines 48-63](lookml/internal_marketing/internal_marketing.model.lkml#L48-L63)). The older `marketing_funnel` is labelled “OLD - GTM Funnel (Segment) - OLD” and described as “NOT USED SINCE 2025” ([model lines 286-299](lookml/internal_marketing/internal_marketing.model.lkml#L286-L299)). |
| The Explore uses a date/allocation/filter root. | Root is `from: marketing_filters_allocation_ext` ([model line 60](lookml/internal_marketing/internal_marketing.model.lkml#L60)); the base table is `fl-bi-p-poc.reports_poc.marketing_filters_allocation` with `date`, `deal_allocation`, `primary_key`, and target fields ([filter base lines 1-3](lookml/internal_marketing/base_views/Reports/marketing_filters_allocation_base.view.lkml#L1-L3), [89-99](lookml/internal_marketing/base_views/Reports/marketing_filters_allocation_base.view.lkml#L89-L99), [172-187](lookml/internal_marketing/base_views/Reports/marketing_filters_allocation_base.view.lkml#L172-L187)). |
| The Explore repeatedly joins the same deals view under stage aliases. | `hubspot_sal`, `hubspot_sao`, `hubspot_closed_won`, `hubspot_close_date`, and `hubspot_expected_sd_date` all use `from: hubspot_deals_all_ext`, each on a different foreign key ([model lines 78-164](lookml/internal_marketing/internal_marketing.model.lkml#L78-L164)). The inventory records 11 `hubspot_deals_all_ext` aliases and 26 joins overall ([mapping section 5](lookml-holistics-mapping.md#L113-L126)). |
| SAL has join-local exclusions that should not become a global funnel filter. | The `hubspot_sal` join includes `is_license_overrun_deal IS false` and `exclude_flip_flow_sals IS true` in `sql_on` ([model lines 78-83](lookml/internal_marketing/internal_marketing.model.lkml#L78-L83)). The commented `always_filter` says it “doesn't work / numbers in other stages are wrong when applying this” ([model lines 56-58](lookml/internal_marketing/internal_marketing.model.lkml#L56-L58)). |
| Stage measures also carry stage-local population filters. | SAL count filters on `dmt_sal_date` and recurring deal type ([deals ext lines 3201-3208](lookml/internal_marketing/extended_views/Datamarts/hubspot_deals_all_ext.view.lkml#L3201-L3208)); SAO filters on `dmt_sao_date` ([lines 3219-3226](lookml/internal_marketing/extended_views/Datamarts/hubspot_deals_all_ext.view.lkml#L3219-L3226)); Closed Won filters on `dmt_closed_won_date` ([lines 3309-3316](lookml/internal_marketing/extended_views/Datamarts/hubspot_deals_all_ext.view.lkml#L3309-L3316)). |
| The stage date keys are real source columns, not just labels. | Deal base view defines `dmt_sal`, `dmt_sao`, `dmt_closed_won`, `expected_sd`, and stage-specific allocation foreign keys ([base lines 439-532](lookml/internal_marketing/base_views/Datamarts/hubspot_deals_all_base.view.lkml#L439-L532), [554-580](lookml/internal_marketing/base_views/Datamarts/hubspot_deals_all_base.view.lkml#L554-L580), [638-672](lookml/internal_marketing/base_views/Datamarts/hubspot_deals_all_base.view.lkml#L638-L672)). |

## Proposed smallest faithful demo

Do **not** migrate the full 50-view project or the full 26-join Explore for the first onboarding demo. Show one narrow “Flip GTM Funnel — Allocation” slice with:

1. A date/allocation root: `marketing_filters_allocation_ext` / `marketing_filters_allocation_base`.
2. Three role-specific aliases of the same deals source: SAL, SAO, Closed Won.
3. Optional target fields from the root and/or `gtm_targets_by_department_ext` only if there is time, because the main proof is stage-date independence.
4. Three simple metrics: SAL count, SAO count, Closed Won count, plus one conversion or lag metric if needed.

### Stage mapping

| Demo stage | Source alias | Source view | Join key in `marketing_funnel_allocation` | Stage date / measure filter | Role-specific caveat |
|---|---|---|---|---|---|
| SAL | `hubspot_sal` | `hubspot_deals_all_ext` | `marketing_funnel_allocation.primary_key = hubspot_sal.foreign_key_sal_marketing_filters_allocation` | `dmt_sal_date: -NULL`; count metric allows New Business and Upsell | Join-local exclusions: `is_license_overrun_deal IS false` and `exclude_flip_flow_sals IS true`; must not be applied globally. |
| SAO | `hubspot_sao` | `hubspot_deals_all_ext` | `marketing_funnel_allocation.primary_key = hubspot_sao.foreign_key_sao_marketing_filters_allocation` | `dmt_sao_date: -NULL`; count metric allows New Business and Upsell | Same physical deals table, different allocation key and date. |
| Closed Won | `hubspot_closed_won` | `hubspot_deals_all_ext` | `marketing_funnel_allocation.primary_key = hubspot_closed_won.foreign_key_closed_won_marketing_filters_allocation` | `dmt_closed_won_date: -NULL`; count metric allows New Business and Upsell | Same deal may appear in a different period than its SAL/SAO periods. |

### Minimal source and target counts

| Layer | Small demo count | Notes |
|---|---:|---|
| Source Looker model file | 1 | `internal_marketing.model.lkml`. |
| Source Explore | 1 narrow slice | `marketing_funnel_allocation`; do not include legacy `marketing_funnel`. |
| Source physical tables | 2 minimum | `reports_poc.marketing_filters_allocation` and the HubSpot deals datamart behind `hubspot_deals_all_ext`; add targets as a third table only if needed. |
| Source LookML view files | 4 minimum | Base + extended files for the root and deals. |
| Holistics model roles | 4 minimum | One root model + three deal role models. These can be created from one base model via AML Extend if implemented. |
| Holistics dataset | 1 | `Flip GTM Funnel — Allocation`, containing the root plus stage roles. |

## Proposed Holistics representation and documented gaps

Use Holistics docs conservatively:

- [Holistics Looker conceptual differences](https://docs.holistics.io/docs/from-others/looker/conceptual-differences) map a Looker view to a Holistics model and a Looker Explore to a Holistics dataset. They also note that Holistics datasets do not require a fixed root; join paths are dynamic.
- [Holistics relationships](https://docs.holistics.io/docs/relationships) are defined in datasets or reusable relationship files. Relationship types are `many_to_one` and `one_to_one`; short form uses `>` for many-to-one and `-` for one-to-one.
- The same relationships docs say many-to-many cannot be specified directly; use a junction model/query model so it is interpreted as `1 - n - 1`.
- [AML Extend](https://docs.holistics.io/reference/aml/extend) is documented as producing a new object from an existing object without duplicating all code, e.g. `Model users_anonymized = users.extend({...})`.

Therefore the safe design for the demo is:

1. Build a base `flip_hubspot_deals_all` model from the deals table.
2. Create three role models with `extend`: `flip_hubspot_sal`, `flip_hubspot_sao`, `flip_hubspot_closed_won`. Override labels and expose only the role-specific date/key/metrics needed for the demo.
3. Build `flip_marketing_filters_allocation` from the allocation spine.
4. Create relationships from each stage role's stage-specific allocation key to the allocation spine key. Keep `nullable: true` unless warehouse checks prove all keys match.
5. If exact full-outer preservation is required, do **not** promise it from relationship syntax alone. Holistics relationships default to left joins for supported relationship types; the source Looker uses full outer joins in this Explore. Exact unmatched-row behavior may need a query-model spine or parity-specific dataset design.

Manual migration required:

- Explore-to-dataset translation, because the migration assistant docs say this is not yet automatic.
- Role aliases and stage-local filters, because automatic view conversion does not know which aliases must stay independent.
- Full outer / many-to-many joins, because Holistics relationships do not directly specify many-to-many and do not express Looker's full outer join exactly.
- Liquid definitions, if any appear in the selected slice, because the standard assistant does not support Liquid definitions.
- Query parity tests against Looker outputs and warehouse SQL before claiming metric equivalence.

## Failure-mode demo scenario

Use a tiny seeded example or a live Looker/Holistics comparison where the same deal moves through stages on different dates:

| Deal | Type | Allocation | SAL date | SAO date | Closed Won date | SAL exclusions | Correct Jan SAL | Correct Feb SAO | Correct Mar Closed Won |
|---|---|---|---|---|---|---|---:|---:|---:|
| A | New Business | Inbound | 2026-01-10 | 2026-02-05 | 2026-03-20 | passes | 1 | 1 | 1 |
| B | New Business | Inbound | 2026-01-15 | null | null | excluded by SAL join | 0 | 0 | 0 |
| C | Upsell | Partner | null | 2026-02-18 | 2026-03-10 | n/a | 0 | 1 | 1 |

Expected visible failure if implemented wrongly:

- If one global deal date is used, Deal A can only land in one month, so Jan SAL, Feb SAO, and Mar Closed Won cannot all be correct.
- If the SAL exclusion is promoted to a global dataset filter, it can suppress deals from SAO/Closed Won populations where SAL-specific exclusions were never intended. This matches the source author's warning that global filtering makes other stages wrong.
- If the three aliases collapse into one deals model with one active date relationship, selecting SAL and Closed Won together may force one join path/date key and misalign target comparisons.

This is the strongest small demo because it demonstrates the real reason for role-playing aliases: **independent stage populations over a shared allocation/date reporting spine**.

## What I could not verify

- I did not get fresh ReadAI access; the discovery evidence above uses the cached clean transcript in `dealops/logs/call-transcripts/`.
- I did not verify live Flip warehouse data, Looker outputs, or support impersonation. The note is based on supplied LookML and cached deal artifacts.
- I did not find official Holistics docs that state “role-playing alias” as a named feature. The supported building blocks I verified are datasets/relationships and AML Extend; exact alias semantics still need implementation and parity testing.
