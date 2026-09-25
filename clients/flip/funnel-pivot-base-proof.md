# Flip funnel pivot-base proof

This note tests Chinh's proposed Holistics modelling shortcut:

> Focus on pivot base `(month, allocation, channel super category)`, then define AQL metrics at that exact grain.

Conclusion: this is a good minimal demo shape for Flip's funnel question. It avoids exposing 11 duplicated AML table models while preserving core Looker semantics: each stage uses its own date/key logic, but final result is a stage-column pivot at allocation date grain.

## Evidence from LookML

| Evidence | Source |
|---|---|
| Funnel Explore root is `marketing_filters_allocation_ext`. | `internal_marketing.model.lkml:48-64` |
| Allocation source table is `fl-bi-p-poc.reports_poc.marketing_filters_allocation`. | `marketing_filters_allocation_base.view.lkml:1-2` |
| Deal source table is `fl-bi-p-poc.datamarts_poc.hubspot_deals_all`. | `hubspot_deals_all_base.view.lkml:1-2` |
| Allocation root owns date grain and allocation dimensions. | `marketing_filters_allocation_ext.view.lkml:105-123` |
| Allocation root owns `primary_key`. | `marketing_filters_allocation_ext.view.lkml:231-235` |
| Allocation root has `date_granularity` parameter and dynamic date dimension. | `marketing_filters_allocation_ext.view.lkml:338-380` |
| Allocation root has channel parameter and `dynamic_channel`, choosing source channel department or cluster. | `marketing_filters_allocation_ext.view.lkml:675-710` |
| 11 deal aliases all join from `hubspot_deals_all_ext` to allocation `primary_key`, with stage-specific foreign keys. | `internal_marketing.model.lkml:78-163` |
| SAL join has SAL-local filters; source comment says applying them globally makes other stages wrong. | `internal_marketing.model.lkml:56-58`, `internal_marketing.model.lkml:78-83` |
| Stage measures are mostly `count_distinct(deal_id)` with stage-date and deal-type filters. | `hubspot_deals_all_ext.view.lkml:3192-3350` |

## Why pivot base works

The Looker Explore uses aliases to let the same physical deal table contribute multiple independent stage populations to one allocation-date row.

Holistics does not need to present those 11 populations as 11 separate user-facing models if the demo output is a fixed funnel pivot:

```text
month | allocation | channel_super_category | sals | saos | solution_design | ... | closed_won
```

At this output grain, each funnel metric can be expressed as:

```text
count_distinct(deal_id)
where stage-specific foreign key maps to allocation.primary_key
and stage-specific date is not null
and stage-specific deal-type/filter rules hold
```

That is exactly what the 11 joins do, but it can be hidden behind metrics or a query model instead of surfaced as 11 AML table models.

## Minimal Holistics shape

Use two migrated source models from LookML:

1. `flip_funnel_allocation` from `marketing_filters_allocation_base` + `marketing_filters_allocation_ext`.
2. `flip_deals_all` from `hubspot_deals_all_base` + `hubspot_deals_all_ext`.

Then add one derived pivot layer, either:

- a query model at grain `(month, deal_allocation, deal_source_channel_department_hubspot)`, or
- a dataset with AQL metrics that pin each metric to that same grain.

This is enough for a customer-facing demo because users see one funnel table, not 11 role tables.

## Stage metric mapping

| Funnel metric | Stage key from deals table | Stage filter from LookML | Extra local rule |
|---|---|---|---|
| SALs | `foreign_key_sal_marketing_filters_allocation` | `dmt_sal_date IS NOT NULL`, `new_business_vs_upsell = 'New Business'` | `is_license_overrun_deal IS FALSE`; `exclude_flip_flow_sals IS TRUE` unless exposed as parameter |
| SAOs | `foreign_key_sao_marketing_filters_allocation` | `dmt_sao_date IS NOT NULL`, `new_business_vs_upsell IN ('New Business', 'Upsell')` | none found |
| Solution Design | `foreign_key_solution_design_marketing_filters_allocation` | `dmt_solution_design_date IS NOT NULL`, `new_business_vs_upsell = 'New Business'` | none found |
| Evaluation | `foreign_key_evaluation_marketing_filters_allocation` | `dmt_evaluation_date IS NOT NULL`, `new_business_vs_upsell = 'New Business'` | none found |
| Proposal | `foreign_key_proposal_marketing_filters_allocation` | `dmt_proposal_date IS NOT NULL`, `new_business_vs_upsell = 'New Business'` | none found |
| Negotiation | `foreign_key_negotiations_marketing_filters_allocation` | `dmt_negotiations_date IS NOT NULL`, `new_business_vs_upsell = 'New Business'` | none found |
| Closing Validation | `foreign_key_closing_validation_marketing_filters_allocation` | `dmt_closed_won_validation_date IS NOT NULL`, `new_business_vs_upsell = 'New Business'` | none found |
| Closed Won | `foreign_key_closed_won_marketing_filters_allocation` | `dmt_closed_won_date IS NOT NULL`, `new_business_vs_upsell IN ('New Business', 'Upsell')` | none found |
| Closed Lost | `foreign_key_closed_lost_marketing_filters_allocation` | `dmt_closed_lost_date IS NOT NULL`, `new_business_vs_upsell = 'New Business'` | none found |
| Close Date Deals | `foreign_key_close_date_marketing_filters_allocation` | use close-date population from source alias | exact measure still needs selected Looker tile confirmation |
| Expected SD Date Deals | `foreign_key_expected_sd_date_marketing_filters_allocation` | use expected-SD-date population from source alias | exact measure still needs selected Looker tile confirmation |

## SQL proof of shape

For a fixed monthly funnel by allocation and channel super category, one derived pivot query can express the same result without 11 table models:

```sql
SELECT
  DATE_TRUNC(alloc.date, MONTH) AS month,
  alloc.deal_allocation AS allocation,
  alloc.deal_source_channel_department_hubspot AS channel_super_category,

  COUNT(DISTINCT IF(
    sal.deal_id IS NOT NULL,
    sal.deal_id,
    NULL
  )) AS sals,

  COUNT(DISTINCT IF(
    sao.deal_id IS NOT NULL,
    sao.deal_id,
    NULL
  )) AS saos,

  COUNT(DISTINCT IF(solution_design.deal_id IS NOT NULL, solution_design.deal_id, NULL)) AS solution_design,
  COUNT(DISTINCT IF(evaluation.deal_id IS NOT NULL, evaluation.deal_id, NULL)) AS evaluation,
  COUNT(DISTINCT IF(proposal.deal_id IS NOT NULL, proposal.deal_id, NULL)) AS proposal,
  COUNT(DISTINCT IF(negotiation.deal_id IS NOT NULL, negotiation.deal_id, NULL)) AS negotiation,
  COUNT(DISTINCT IF(closing_validation.deal_id IS NOT NULL, closing_validation.deal_id, NULL)) AS closing_validation,
  COUNT(DISTINCT IF(closed_won.deal_id IS NOT NULL, closed_won.deal_id, NULL)) AS closed_won,
  COUNT(DISTINCT IF(closed_lost.deal_id IS NOT NULL, closed_lost.deal_id, NULL)) AS closed_lost

FROM `fl-bi-p-poc.reports_poc.marketing_filters_allocation` AS alloc

LEFT JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS sal
  ON alloc.primary_key = sal.foreign_key_sal_marketing_filters_allocation
 AND sal.dmt_sal_date IS NOT NULL
 AND sal.new_business_vs_upsell = 'New Business'
 AND sal.is_license_overrun_deal IS FALSE
 AND sal.exclude_flip_flow_sals IS TRUE

LEFT JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS sao
  ON alloc.primary_key = sao.foreign_key_sao_marketing_filters_allocation
 AND sao.dmt_sao_date IS NOT NULL
 AND sao.new_business_vs_upsell IN ('New Business', 'Upsell')

LEFT JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS solution_design
  ON alloc.primary_key = solution_design.foreign_key_solution_design_marketing_filters_allocation
 AND solution_design.dmt_solution_design_date IS NOT NULL
 AND solution_design.new_business_vs_upsell = 'New Business'

LEFT JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS evaluation
  ON alloc.primary_key = evaluation.foreign_key_evaluation_marketing_filters_allocation
 AND evaluation.dmt_evaluation_date IS NOT NULL
 AND evaluation.new_business_vs_upsell = 'New Business'

LEFT JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS proposal
  ON alloc.primary_key = proposal.foreign_key_proposal_marketing_filters_allocation
 AND proposal.dmt_proposal_date IS NOT NULL
 AND proposal.new_business_vs_upsell = 'New Business'

LEFT JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS negotiation
  ON alloc.primary_key = negotiation.foreign_key_negotiations_marketing_filters_allocation
 AND negotiation.dmt_negotiations_date IS NOT NULL
 AND negotiation.new_business_vs_upsell = 'New Business'

LEFT JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS closing_validation
  ON alloc.primary_key = closing_validation.foreign_key_closing_validation_marketing_filters_allocation
 AND closing_validation.dmt_closed_won_validation_date IS NOT NULL
 AND closing_validation.new_business_vs_upsell = 'New Business'

LEFT JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS closed_won
  ON alloc.primary_key = closed_won.foreign_key_closed_won_marketing_filters_allocation
 AND closed_won.dmt_closed_won_date IS NOT NULL
 AND closed_won.new_business_vs_upsell IN ('New Business', 'Upsell')

LEFT JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS closed_lost
  ON alloc.primary_key = closed_lost.foreign_key_closed_lost_marketing_filters_allocation
 AND closed_lost.dmt_closed_lost_date IS NOT NULL
 AND closed_lost.new_business_vs_upsell = 'New Business'

GROUP BY 1, 2, 3;
```

This SQL still uses role aliases internally, because SQL needs table aliases. Holistics model surface does not need 11 separate AML table models if a derived query or AQL metric layer owns the stage logic.

## AQL framing

In Holistics terms, proof is:

```text
Dataset grain:
  flip_funnel_allocation.month
  flip_funnel_allocation.deal_allocation
  flip_funnel_allocation.deal_source_channel_department_hubspot

Metric pattern:
  count_distinct(flip_deals_all.deal_id)
    filtered by one stage foreign key matching allocation.primary_key
    filtered by stage date not null
    filtered by stage deal-type rule
```

If AQL cannot express a metric-local custom join predicate against one source model cleanly, use one query model for the pivot base. That still proves Chinh's point: no need for 11 customer-visible AML models.

## Acceptance test

Use a deal that reaches stages in different months:

| Deal | Channel super category | Allocation | SAL month | SAO month | Closed Won month |
|---|---|---|---|---|---|
| A | Marketing | Marketing | Jan | Feb | Mar |

Expected pivot:

| Month | Allocation | Channel super category | SALs | SAOs | Closed Won |
|---|---|---|---:|---:|---:|
| Jan | Marketing | Marketing | 1 | 0 | 0 |
| Feb | Marketing | Marketing | 0 | 1 | 0 |
| Mar | Marketing | Marketing | 0 | 0 | 1 |

Wrong implementations fail visibly:

- one global deal date puts deal A into only one month;
- one global SAL filter can incorrectly remove the same deal from SAO or Closed Won;
- one global channel/date join can mix stage populations into wrong allocation rows.

## What this does not prove

- It does not prove parity for every field in the Looker Explore.
- It does not preserve arbitrary ad hoc exploration across all aliased fields.
- It does not replace Looker's full outer join behavior for unmatched deal-only rows unless the pivot base explicitly needs them.
- It does not automatically migrate Liquid syntax. Parameter behaviour still needs AML/AQL translation.

For a bounded onboarding demo, those trade-offs are acceptable if target deliverable is a funnel table/dashboard, not a full Explore clone.
