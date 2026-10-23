-- Faithful reconstruction of the LookML Explore join shape for review.
-- This is not exact Looker-compiled SQL.
-- Source Explore: marketing_funnel_allocation in internal_marketing.model.lkml.

SELECT
  alloc.date AS funnel_date,
  alloc.deal_allocation,

  COUNT(DISTINCT sal.deal_id) AS sals,
  COUNT(DISTINCT sao.deal_id) AS saos,
  COUNT(DISTINCT solution_design.deal_id) AS solution_designs,
  COUNT(DISTINCT evaluation.deal_id) AS evaluations,
  COUNT(DISTINCT proposal.deal_id) AS proposals,
  COUNT(DISTINCT negotiation.deal_id) AS negotiations,
  COUNT(DISTINCT closing_validation.deal_id) AS closing_validations,
  COUNT(DISTINCT closed_won.deal_id) AS closed_won,
  COUNT(DISTINCT closed_lost.deal_id) AS closed_lost,
  COUNT(DISTINCT close_date.deal_id) AS close_date_deals,
  COUNT(DISTINCT expected_sd_date.deal_id) AS expected_sd_date_deals

FROM `fl-bi-p-poc.reports_poc.marketing_filters_allocation` AS alloc

FULL OUTER JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS sal
  ON alloc.primary_key = sal.foreign_key_sal_marketing_filters_allocation
 AND sal.is_license_overrun_deal IS FALSE
 AND sal.exclude_flip_flow_sals IS TRUE

FULL OUTER JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS sao
  ON alloc.primary_key = sao.foreign_key_sao_marketing_filters_allocation

FULL OUTER JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS solution_design
  ON alloc.primary_key = solution_design.foreign_key_solution_design_marketing_filters_allocation

FULL OUTER JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS evaluation
  ON alloc.primary_key = evaluation.foreign_key_evaluation_marketing_filters_allocation

FULL OUTER JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS proposal
  ON alloc.primary_key = proposal.foreign_key_proposal_marketing_filters_allocation

FULL OUTER JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS negotiation
  ON alloc.primary_key = negotiation.foreign_key_negotiations_marketing_filters_allocation

FULL OUTER JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS closing_validation
  ON alloc.primary_key = closing_validation.foreign_key_closing_validation_marketing_filters_allocation

FULL OUTER JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS closed_won
  ON alloc.primary_key = closed_won.foreign_key_closed_won_marketing_filters_allocation

FULL OUTER JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS closed_lost
  ON alloc.primary_key = closed_lost.foreign_key_closed_lost_marketing_filters_allocation

FULL OUTER JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS close_date
  ON alloc.primary_key = close_date.foreign_key_close_date_marketing_filters_allocation

FULL OUTER JOIN `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` AS expected_sd_date
  ON alloc.primary_key = expected_sd_date.foreign_key_expected_sd_date_marketing_filters_allocation

GROUP BY
  funnel_date,
  alloc.deal_allocation;
