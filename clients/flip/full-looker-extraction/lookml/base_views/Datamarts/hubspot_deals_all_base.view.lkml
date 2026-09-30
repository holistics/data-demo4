view: hubspot_deals_all_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` ;;

  dimension: account_classification {
    type: string
    sql: ${TABLE}.account_classification ;;
  }
  dimension: additional_developments {
    type: string
    sql: ${TABLE}.additional_developments ;;
  }
  dimension: ae_name {
    type: string
    sql: ${TABLE}.ae_name ;;
  }
  dimension: ae_name_closed_won {
    type: string
    sql: ${TABLE}.ae_name_closed_won ;;
  }
  dimension: ae_name_proposal {
    type: string
    sql: ${TABLE}.ae_name_proposal ;;
  }
  dimension: ae_name_sao {
    type: string
    sql: ${TABLE}.ae_name_sao ;;
  }
  dimension: ae_team {
    type: string
    sql: ${TABLE}.ae_team ;;
  }
  dimension: bdr_name {
    type: string
    sql: ${TABLE}.bdr_name ;;
  }
  dimension: bdr_name_sal {
    type: string
    sql: ${TABLE}.bdr_name_sal ;;
  }
  dimension: bdr_name_sao {
    type: string
    sql: ${TABLE}.bdr_name_sao ;;
  }
  dimension: bdr_team {
    type: string
    sql: ${TABLE}.bdr_team ;;
  }
  dimension: change_in_amount_vs_previous_day {
    type: number
    sql: ${TABLE}.change_in_amount_vs_previous_day ;;
  }
  dimension_group: churn {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.churn_date ;;
  }
  dimension_group: churned_date_customer {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.churned_date_customer ;;
  }
  dimension_group: churned_date_group {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.churned_date_group ;;
  }
  dimension_group: close {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.close_date ;;
  }
  dimension: company_has_expansion {
    type: yesno
    sql: ${TABLE}.company_has_expansion ;;
  }
  dimension: company_id {
    type: string
    sql: ${TABLE}.company_id ;;
  }
  dimension: company_industry {
    type: string
    sql: ${TABLE}.company_industry ;;
  }
  dimension: company_is_workplace_partner {
    type: yesno
    sql: ${TABLE}.company_is_workplace_partner ;;
  }
  dimension: company_marketing_campaigns_memberships {
    type: string
    sql: ${TABLE}.company_marketing_campaigns_memberships ;;
  }
  dimension: company_name_groups {
    type: string
    sql: ${TABLE}.company_name_groups ;;
  }
  dimension: company_other_technologies {
    type: string
    sql: ${TABLE}.company_other_technologies ;;
  }
  dimension: company_owner {
    type: string
    sql: ${TABLE}.company_owner ;;
  }
  dimension: company_partner_marker {
    type: string
    sql: ${TABLE}.company_partner_marker ;;
  }
  dimension: company_workplace_list_region {
    type: string
    sql: ${TABLE}.company_workplace_list_region ;;
  }
  dimension: company_workplace_source {
    type: string
    sql: ${TABLE}.company_workplace_source ;;
  }
  dimension_group: contact_dmt_lead {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contact_dmt_lead ;;
  }
  dimension_group: contact_dmt_mql {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contact_dmt_mql ;;
  }
  dimension_group: contact_dmt_sql {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contact_dmt_sql ;;
  }
  dimension: contact_id_for_source_channel {
    type: string
    sql: ${TABLE}.contact_id_for_source_channel ;;
  }
  dimension: contact_is_workplace_customer {
    type: yesno
    sql: ${TABLE}.contact_is_workplace_customer ;;
  }
  dimension: contact_is_workplace_user {
    type: yesno
    sql: ${TABLE}.contact_is_workplace_user ;;
  }
  dimension: contact_seniority {
    type: string
    sql: ${TABLE}.contact_seniority ;;
  }
  dimension: contact_workplace_community_membership {
    type: string
    sql: ${TABLE}.contact_workplace_community_membership ;;
  }
  dimension_group: contract_start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contract_start_date ;;
  }
  dimension: contract_term_in_months {
    type: number
    sql: ${TABLE}.contract_term_in_months ;;
  }
  dimension: contract_type {
    type: string
    sql: ${TABLE}.contract_type ;;
  }
  dimension_group: copied_at {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.copied_at_date ;;
  }
  dimension_group: copied_at_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.copied_at_timestamp ;;
  }
  dimension_group: created_at {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.created_at_date ;;
  }
  dimension: cs_name {
    type: string
    sql: ${TABLE}.cs_name ;;
  }
  dimension: cs_team {
    type: string
    sql: ${TABLE}.cs_team ;;
  }
  dimension: current_amount_euros {
    type: number
    sql: ${TABLE}.current_amount_euros ;;
  }
  dimension: current_amount_in_record_currency {
    type: number
    sql: ${TABLE}.current_amount_in_record_currency ;;
  }
  dimension: customer_has_ae_hc {
    type: yesno
    sql: ${TABLE}.customer_has_ae_hc ;;
  }
  dimension: customer_has_pov {
    type: yesno
    sql: ${TABLE}.customer_has_pov ;;
  }
  dimension: customer_is_pov_conversion {
    type: yesno
    sql: ${TABLE}.customer_is_pov_conversion ;;
  }
  dimension: customer_is_pov_conversion_no_expansion {
    type: yesno
    sql: ${TABLE}.customer_is_pov_conversion_no_expansion ;;
  }
  dimension_group: date_entered_evaluation {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_entered_evaluation ;;
  }
  dimension_group: date_entered_negotiation {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_entered_negotiation ;;
  }
  dimension_group: date_entered_proposal {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_entered_proposal ;;
  }
  dimension_group: date_entered_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_entered_sao ;;
  }
  dimension_group: date_entered_solution_design {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_entered_solution_design ;;
  }
  dimension_group: date_left_evaluation {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_left_evaluation ;;
  }
  dimension_group: date_left_negotiation {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_left_negotiation ;;
  }
  dimension_group: date_left_proposal {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_left_proposal ;;
  }
  dimension_group: date_left_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_left_sao ;;
  }
  dimension_group: date_left_solution_design {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_left_solution_design ;;
  }
  dimension: days_from_deal_creation_to_closed_lost {
    type: number
    sql: ${TABLE}.days_from_deal_creation_to_closed_lost ;;
  }
  dimension: days_from_deal_creation_to_closed_won {
    type: number
    sql: ${TABLE}.days_from_deal_creation_to_closed_won ;;
  }
  dimension: days_from_evaluation_to_closed_lost {
    type: number
    sql: ${TABLE}.days_from_evaluation_to_closed_lost ;;
  }
  dimension: days_from_evaluation_to_closed_won {
    type: number
    sql: ${TABLE}.days_from_evaluation_to_closed_won ;;
  }
  dimension: days_from_evaluation_to_proposal {
    type: number
    sql: ${TABLE}.days_from_evaluation_to_proposal ;;
  }
  dimension: days_from_negotiation_to_closed_lost {
    type: number
    sql: ${TABLE}.days_from_negotiation_to_closed_lost ;;
  }
  dimension: days_from_negotiation_to_closed_won {
    type: number
    sql: ${TABLE}.days_from_negotiation_to_closed_won ;;
  }
  dimension: days_from_proposal_to_closed_lost {
    type: number
    sql: ${TABLE}.days_from_proposal_to_closed_lost ;;
  }
  dimension: days_from_proposal_to_closed_won {
    type: number
    sql: ${TABLE}.days_from_proposal_to_closed_won ;;
  }
  dimension: days_from_proposal_to_negotiation {
    type: number
    sql: ${TABLE}.days_from_proposal_to_negotiation ;;
  }
  dimension: days_from_sal_to_closed_lost {
    type: number
    sql: ${TABLE}.days_from_sal_to_closed_lost ;;
  }
  dimension: days_from_sal_to_closed_won {
    type: number
    sql: ${TABLE}.days_from_sal_to_closed_won ;;
  }
  dimension: days_from_sal_to_sao {
    type: number
    sql: ${TABLE}.days_from_sal_to_sao ;;
  }
  dimension: days_from_sao_to_closed_lost {
    type: number
    sql: ${TABLE}.days_from_sao_to_closed_lost ;;
  }
  dimension: days_from_sao_to_closed_won {
    type: number
    sql: ${TABLE}.days_from_sao_to_closed_won ;;
  }
  dimension: days_from_sao_to_solution_design {
    type: number
    sql: ${TABLE}.days_from_sao_to_solution_design ;;
  }
  dimension: days_from_solution_design_to_closed_lost {
    type: number
    sql: ${TABLE}.days_from_solution_design_to_closed_lost ;;
  }
  dimension: days_from_solution_design_to_closed_won {
    type: number
    sql: ${TABLE}.days_from_solution_design_to_closed_won ;;
  }
  dimension: days_from_solution_design_to_evaluation {
    type: number
    sql: ${TABLE}.days_from_solution_design_to_evaluation ;;
  }
  dimension: days_from_solution_design_to_negotiation {
    type: number
    sql: ${TABLE}.days_from_solution_design_to_negotiation ;;
  }
  dimension: days_in_current_stage {
    type: number
    sql: ${TABLE}.days_in_current_stage ;;
  }
  dimension: days_in_evaluation_stage {
    type: number
    sql: ${TABLE}.days_in_evaluation_stage ;;
  }
  dimension: days_in_negotiation_stage {
    type: number
    sql: ${TABLE}.days_in_negotiation_stage ;;
  }
  dimension: days_in_proposal_stage {
    type: number
    sql: ${TABLE}.days_in_proposal_stage ;;
  }
  dimension: days_in_sal {
    type: number
    sql: ${TABLE}.days_in_sal ;;
  }
  dimension: days_in_sal_stage {
    type: number
    sql: ${TABLE}.days_in_sal_stage ;;
  }
  dimension: days_in_sao_stage {
    type: number
    sql: ${TABLE}.days_in_sao_stage ;;
  }
  dimension: days_in_solution_design_stage {
    type: number
    sql: ${TABLE}.days_in_solution_design_stage ;;
  }
  dimension: days_since_last_activity {
    type: number
    sql: ${TABLE}.days_since_last_activity ;;
  }
  dimension: days_to_next_activity {
    type: number
    sql: ${TABLE}.days_to_next_activity ;;
  }
  dimension: deal_allocation {
    type: string
    sql: ${TABLE}.deal_allocation ;;
  }
  dimension: deal_allocation_bigquery {
    type: string
    sql: ${TABLE}.deal_allocation_bigquery ;;
  }
  dimension: deal_allocation_mix {
    type: string
    sql: ${TABLE}.deal_allocation_mix ;;
  }
  dimension: deal_allocation_mix_bigquery {
    type: string
    sql: ${TABLE}.deal_allocation_mix_bigquery ;;
  }
  dimension: deal_campaign_or_event {
    type: string
    sql: ${TABLE}.deal_campaign_or_event ;;
  }
  dimension: deal_creator_name {
    type: string
    sql: ${TABLE}.deal_creator_name ;;
  }
  dimension: deal_creator_team {
    type: string
    sql: ${TABLE}.deal_creator_team ;;
  }
  dimension: deal_currency_code {
    type: string
    sql: ${TABLE}.deal_currency_code ;;
  }
  dimension: deal_grouped_campaign {
    type: string
    sql: ${TABLE}.deal_grouped_campaign ;;
  }
  dimension: deal_id {
    type: string
    sql: ${TABLE}.deal_id ;;
  }
  dimension: deal_marketing_influence_touchpoints {
    type: string
    sql: ${TABLE}.deal_marketing_influence_touchpoints ;;
  }
  dimension: deal_name {
    type: string
    sql: ${TABLE}.deal_name ;;
  }
  dimension: deal_next_step {
    type: string
    sql: ${TABLE}.deal_next_step ;;
  }
  dimension: deal_owner_name {
    type: string
    sql: ${TABLE}.deal_owner_name ;;
  }
  dimension: deal_paid_search_channel {
    type: string
    sql: ${TABLE}.deal_paid_search_channel ;;
  }
  dimension: deal_partner_marketing_campaign {
    type: string
    sql: ${TABLE}.deal_partner_marketing_campaign ;;
  }
  dimension: has_deal_partner_marketing_influence {
    type: string
    sql: ${TABLE}.deal_has_partner_marketing_influence ;;
  }
  dimension: deal_segment {
    type: string
    sql: ${TABLE}.deal_segment ;;
  }
  dimension: deal_source_asset {
    type: string
    sql: ${TABLE}.deal_source_asset ;;
  }
  dimension: deal_source_channel {
    type: string
    sql: ${TABLE}.deal_source_channel ;;
  }
  dimension: deal_source_channel_campaign_name {
    type: string
    sql: ${TABLE}.deal_source_channel_campaign_name ;;
  }
  dimension: deal_source_channel_cluster_hubspot {
    type: string
    sql: ${TABLE}.deal_source_channel_cluster_hubspot ;;
  }
  dimension: deal_source_channel_department_hubspot {
    type: string
    sql: ${TABLE}.deal_source_channel_department_hubspot ;;
  }
  dimension: deal_source_channel_drilldown {
    type: string
    sql: ${TABLE}.deal_source_channel_drilldown ;;
  }
  dimension: deal_source_channel_drilldown_hubspot {
    type: string
    sql: ${TABLE}.deal_source_channel_drilldown_hubspot ;;
  }
  dimension: deal_source_channel_first_contact_id_associated_hubspot {
    type: string
    sql: ${TABLE}.deal_source_channel_first_contact_associated_hubspot ;;
  }
  dimension: deal_source_channel_hubspot {
    type: string
    sql: ${TABLE}.deal_source_channel_hubspot ;;
  }
  dimension: deal_source_channel_inbound_vs_outbound_hubspot {
    type: string
    sql: ${TABLE}.deal_source_channel_inbound_vs_outbound_hubspot ;;
  }
  dimension: deal_stage_probability {
    type: number
    sql: ${TABLE}.deal_stage_probability ;;
  }
  dimension: deal_type {
    type: string
    sql: ${TABLE}.deal_type ;;
  }
  dimension_group: dmt_closed_lost {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_closed_lost ;;
  }
  dimension_group: dmt_closed_won {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_closed_won ;;
  }
  dimension_group: dmt_closed_won_customer {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_closed_won_customer ;;
  }
  dimension_group: dmt_closed_won_group {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_closed_won_group ;;
  }
  dimension_group: dmt_closed_won_validation {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_closed_won_validation ;;
  }
  dimension_group: dmt_evaluation {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_evaluation ;;
  }
  dimension_group: dmt_negotiations {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_negotiations ;;
  }
  dimension_group: dmt_proposal {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_proposal ;;
  }
  dimension_group: dmt_sal {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_sal ;;
  }
  dimension_group: dmt_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_sao ;;
  }
  dimension_group: dmt_solution_design {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_solution_design ;;
  }
  dimension: edeka_region {
    type: string
    sql: ${TABLE}.edeka_region ;;
  }
  dimension:  exclude_flip_flow_sals{
    type: yesno
    sql: ${TABLE}.exclude_flip_flow_sals ;;
  }
  dimension: executive_sponsor_name {
    type: string
    sql: ${TABLE}.executive_sponsor_name ;;
  }
  dimension: expansion_deal {
    type: yesno
    sql: ${TABLE}.expansion_deal ;;
  }
  dimension_group: expected_sd {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.expected_sd_date ;;
  }
  dimension: final_meddic_deal_health_score_computation {
    type: number
    sql: ${TABLE}.final_meddic_deal_health_score_computation ;;
  }
  dimension: flip_additional_features {
    type: string
    sql: ${TABLE}.flip_additional_features ;;
  }
  dimension: flip_basic_features {
    type: string
    sql: ${TABLE}.flip_basic_features ;;
  }
  dimension: forecast_category {
    type: string
    sql: ${TABLE}.forecast_category ;;
  }
  dimension: foreign_key_campaigns_closed_won {
    type: string
    sql: ${TABLE}.foreign_key_campaigns_closed_won ;;
  }
  dimension: foreign_key_campaigns_sao {
    type: string
    sql: ${TABLE}.foreign_key_campaigns_sao ;;
  }
  dimension: foreign_key_close_date_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_close_date_marketing_filters ;;
  }
  dimension: foreign_key_close_date_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_close_date_marketing_filters_allocation ;;
  }
  dimension: foreign_key_close_date_quarterly_basis {
    type: string
    sql: ${TABLE}.foreign_key_close_date_quarterly_basis ;;
  }
  dimension: foreign_key_closed_lost_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_closed_lost_marketing_filters ;;
  }
  dimension: foreign_key_closed_lost_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_closed_lost_marketing_filters_allocation ;;
  }
  dimension: foreign_key_closed_won_ae_filters {
    type: string
    sql: ${TABLE}.foreign_key_closed_won_ae_filters ;;
  }
  dimension: foreign_key_closed_won_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_closed_won_marketing_filters ;;
  }
  dimension: foreign_key_closed_won_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_closed_won_marketing_filters_allocation ;;
  }
  dimension: foreign_key_closed_won_upsell_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_closed_won_upsell_marketing_filters_allocation ;;
  }
  dimension: foreign_key_closing_validation_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_closing_validation_marketing_filters ;;
  }
  dimension: foreign_key_closing_validation_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_closing_validation_marketing_filters_allocation ;;
  }
  dimension: foreign_key_dates {
    type: string
    sql: ${TABLE}.foreign_key_dates ;;
  }
  dimension: foreign_key_evaluation_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_evaluation_marketing_filters ;;
  }
  dimension: foreign_key_evaluation_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_evaluation_marketing_filters_allocation ;;
  }
  dimension: foreign_key_expected_sd_date_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_expected_sd_date_marketing_filters ;;
  }
  dimension: foreign_key_expected_sd_date_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_expected_sd_date_marketing_filters_allocation ;;
  }
  dimension: foreign_key_negotiations_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_negotiations_marketing_filters ;;
  }
  dimension: foreign_key_negotiations_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_negotiations_marketing_filters_allocation ;;
  }
  dimension: foreign_key_proposal_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_proposal_marketing_filters ;;
  }
  dimension: foreign_key_proposal_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_proposal_marketing_filters_allocation ;;
  }
  dimension: foreign_key_sal_bdr_filters {
    type: string
    sql: ${TABLE}.foreign_key_sal_bdr_filters ;;
  }
  dimension: foreign_key_sal_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_sal_marketing_filters ;;
  }
  dimension: foreign_key_sal_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_sal_marketing_filters_allocation ;;
  }
  dimension: foreign_key_sao_bdr {
    type: string
    sql: ${TABLE}.foreign_key_sao_bdr ;;
  }
  dimension: foreign_key_sao_bdr_filters {
    type: string
    sql: ${TABLE}.foreign_key_sao_bdr_filters ;;
  }
  dimension: foreign_key_sao_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_sao_marketing_filters ;;
  }
  dimension: foreign_key_sao_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_sao_marketing_filters_allocation ;;
  }
  dimension: foreign_key_sao_upsell_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_sao_upsell_marketing_filters_allocation ;;
  }
  dimension: foreign_key_snapshotdate_ae {
    type: string
    sql: ${TABLE}.foreign_key_snapshotdate_ae ;;
  }
  dimension: foreign_key_solution_design_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_solution_design_marketing_filters ;;
  }
  dimension: foreign_key_solution_design_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_solution_design_marketing_filters_allocation ;;
  }
  dimension: foreign_key_trunc_month_close_date_ae_name {
    type: string
    sql: ${TABLE}.foreign_key_trunc_month_close_date_ae_name ;;
  }
  dimension: foreign_key_trunc_month_dmt_closed_won_ae_name {
    type: string
    sql: ${TABLE}.foreign_key_trunc_month_dmt_closed_won_ae_name ;;
  }
  dimension: foreign_key_trunc_month_dmt_sal_ae_name {
    type: string
    sql: ${TABLE}.foreign_key_trunc_month_dmt_sal_ae_name ;;
  }
  dimension: foreign_key_trunc_month_dmt_sao_ae_name {
    type: string
    sql: ${TABLE}.foreign_key_trunc_month_dmt_sao_ae_name ;;
  }
  dimension_group: go_live {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.go_live_date ;;
  }
  dimension: has_integration {
    type: yesno
    sql: ${TABLE}.has_integration ;;
  }
  dimension: has_transformation_meddic_co_competition_score {
    type: yesno
    sql: ${TABLE}.has_transformation_meddic_co_competition_score ;;
  }
  dimension: has_transformation_meddic_dc_decision_criteria_score {
    type: yesno
    sql: ${TABLE}.has_transformation_meddic_dc_decision_criteria_score ;;
  }
  dimension: has_transformation_meddic_deal_champion_score {
    type: yesno
    sql: ${TABLE}.has_transformation_meddic_deal_champion_score ;;
  }
  dimension: has_transformation_meddic_dp_decision_path_score {
    type: yesno
    sql: ${TABLE}.has_transformation_meddic_dp_decision_path_score ;;
  }
  dimension: has_transformation_meddic_e_economic_buyers_score {
    type: yesno
    sql: ${TABLE}.has_transformation_meddic_e_economic_buyers_score ;;
  }
  dimension: has_transformation_meddic_i_implicated_pain_score {
    type: yesno
    sql: ${TABLE}.has_transformation_meddic_i_implicated_pain_score ;;
  }
  dimension: has_transformation_meddic_m_metrics_score {
    type: yesno
    sql: ${TABLE}.has_transformation_meddic_m_metrics_score ;;
  }
  dimension: has_transformation_meddic_p_paper_process_score {
    type: yesno
    sql: ${TABLE}.has_transformation_meddic_p_paper_process_score ;;
  }
  dimension: inbound_outbound {
    type: string
    sql: ${TABLE}.inbound_outbound ;;
  }
  dimension: industry_flip {
    type: string
    sql: ${TABLE}.industry_flip ;;
  }
  dimension: initial_closing_validation_amount_euros {
    type: number
    sql: ${TABLE}.initial_closing_validation_amount_euros ;;
  }
  dimension: initial_closing_validation_amount_in_record_currency {
    type: number
    sql: ${TABLE}.initial_closing_validation_amount_in_record_currency ;;
  }
  dimension: initial_evaluation_amount_euros {
    type: number
    sql: ${TABLE}.initial_evaluation_amount_euros ;;
  }
  dimension: initial_evaluation_amount_in_record_currency {
    type: number
    sql: ${TABLE}.initial_evaluation_amount_in_record_currency ;;
  }
  dimension: initial_negotiations_amount_euros {
    type: number
    sql: ${TABLE}.initial_negotiations_amount_euros ;;
  }
  dimension: initial_negotiations_amount_in_record_currency {
    type: number
    sql: ${TABLE}.initial_negotiations_amount_in_record_currency ;;
  }
  dimension: initial_proposal_amount_euros {
    type: number
    sql: ${TABLE}.initial_proposal_amount_euros ;;
  }
  dimension: initial_proposal_amount_in_record_currency {
    type: number
    sql: ${TABLE}.initial_proposal_amount_in_record_currency ;;
  }
  dimension: initial_sao_amount_euros {
    type: number
    sql: ${TABLE}.initial_sao_amount_euros ;;
  }
  dimension: initial_sao_amount_in_record_currency {
    type: number
    sql: ${TABLE}.initial_sao_amount_in_record_currency ;;
  }
  dimension: initial_solution_design_amount_euros {
    type: number
    sql: ${TABLE}.initial_solution_design_amount_euros ;;
  }
  dimension: initial_solution_design_amount_in_record_currency {
    type: number
    sql: ${TABLE}.initial_solution_design_amount_in_record_currency ;;
  }
  dimension: integration {
    type: string
    sql: ${TABLE}.integration ;;
  }
  dimension: is_a_meta_deal {
    type: yesno
    sql: ${TABLE}.is_a_meta_deal ;;
  }
  dimension: is_cs_referral {
    type: string
    sql: ${TABLE}.is_cs_referral ;;
  }
  dimension: is_deal_lost_to_beekeeper {
    type: yesno
    sql: ${TABLE}.is_deal_lost_to_beekeeper ;;
  }
  dimension: is_deal_lost_to_competitor_unknown {
    type: yesno
    sql: ${TABLE}.is_deal_lost_to_competitor_unknown ;;
  }
  dimension: is_deal_lost_to_coyo {
    type: yesno
    sql: ${TABLE}.is_deal_lost_to_coyo ;;
  }
  dimension: is_deal_lost_to_inhousesolution {
    type: yesno
    sql: ${TABLE}.is_deal_lost_to_inhousesolution ;;
  }
  dimension: is_deal_lost_to_limeade {
    type: yesno
    sql: ${TABLE}.is_deal_lost_to_limeade ;;
  }
  dimension: is_deal_lost_to_lolyo {
    type: yesno
    sql: ${TABLE}.is_deal_lost_to_lolyo ;;
  }
  dimension: is_deal_lost_to_microsoftviva {
    type: yesno
    sql: ${TABLE}.is_deal_lost_to_microsoftviva ;;
  }
  dimension: is_deal_lost_to_msteams {
    type: yesno
    sql: ${TABLE}.is_deal_lost_to_msteams ;;
  }
  dimension: is_deal_lost_to_speakap {
    type: yesno
    sql: ${TABLE}.is_deal_lost_to_speakap ;;
  }
  dimension: is_deal_lost_to_staffbase {
    type: yesno
    sql: ${TABLE}.is_deal_lost_to_staffbase ;;
  }
  dimension: is_deal_lost_to_statusquo {
    type: yesno
    sql: ${TABLE}.is_deal_lost_to_statusquo ;;
  }
  dimension: is_deal_lost_to_threema {
    type: yesno
    sql: ${TABLE}.is_deal_lost_to_threema ;;
  }
  dimension: is_edeka {
    type: yesno
    sql: ${TABLE}.is_edeka ;;
  }
  dimension: is_flip_flow_upsell_deal {
    type: yesno
    sql: ${TABLE}.is_flip_flow_upsell_deal ;;
  }
  dimension: is_key_deal {
    type: yesno
    sql: ${TABLE}.is_key_deal ;;
  }
  dimension: is_license_overrun_deal {
    type: yesno
    sql: ${TABLE}.is_license_overrun_deal ;;
  }
  dimension: is_lost_deal {
    type: number
    sql: ${TABLE}.is_lost_deal ;;
  }
  dimension: is_lost_revenue {
    type: yesno
    sql: ${TABLE}.is_lost_revenue ;;
  }
  dimension: is_partner_influenced {
    type: string
    sql: ${TABLE}.is_partner_influenced ;;
  }
  dimension: is_partner_referral {
    type: string
    sql: ${TABLE}.is_partner_referral ;;
  }
  dimension: is_top_man_referral {
    type: string
    sql: ${TABLE}.is_top_man_referral ;;
  }
  dimension: job_title_from_source_channel_contact {
    type: string
    sql: ${TABLE}.job_title_from_source_channel_contact ;;
  }
  dimension_group: last_activity {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_activity_date ;;
  }
  dimension_group: last_contacted {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_contacted_date ;;
  }
  dimension: last_deal_stage {
    type: string
    sql: ${TABLE}.last_deal_stage ;;
  }
  dimension: legal_information {
    type: string
    sql: ${TABLE}.legal_information ;;
  }
  dimension: licences_count {
    type: number
    sql: ${TABLE}.licences_count ;;
  }
  dimension: lost_amount_in_record_currency {
    type: number
    sql: ${TABLE}.lost_amount_in_record_currency ;;
  }
  dimension: lost_comment {
    type: string
    sql: ${TABLE}.lost_comment ;;
  }
  dimension: lost_reason {
    type: string
    sql: ${TABLE}.lost_reason ;;
  }
  dimension: lost_to_competitor {
    type: string
    sql: ${TABLE}.lost_to_competitor ;;
  }
  dimension: meddic_cc_deal_champion {
    type: string
    sql: ${TABLE}.meddic_cc_deal_champion ;;
  }
  dimension: meddic_cc_deal_champion_score {
    type: number
    sql: ${TABLE}.meddic_cc_deal_champion_score ;;
  }
  dimension: meddic_co_competition {
    type: string
    sql: ${TABLE}.meddic_co_competition ;;
  }
  dimension: meddic_co_competition_score {
    type: number
    sql: ${TABLE}.meddic_co_competition_score ;;
  }
  dimension: meddic_dc_decision_criteria {
    type: string
    sql: ${TABLE}.meddic_dc_decision_criteria ;;
  }
  dimension: meddic_dc_decision_criteria_score {
    type: number
    sql: ${TABLE}.meddic_dc_decision_criteria_score ;;
  }
  dimension: meddic_dp_decision_path {
    type: string
    sql: ${TABLE}.meddic_dp_decision_path ;;
  }
  dimension: meddic_dp_decision_path_score {
    type: number
    sql: ${TABLE}.meddic_dp_decision_path_score ;;
  }
  dimension: meddic_e_economic_buyer {
    type: string
    sql: ${TABLE}.meddic_e_economic_buyer ;;
  }
  dimension: meddic_e_economic_buyer_score {
    type: number
    sql: ${TABLE}.meddic_e_economic_buyer_score ;;
  }
  dimension: meddic_i_implicated_pain {
    type: string
    sql: ${TABLE}.meddic_i_implicated_pain ;;
  }
  dimension: meddic_i_implicated_pain_score {
    type: number
    sql: ${TABLE}.meddic_i_implicated_pain_score ;;
  }
  dimension: meddic_m_metrics {
    type: string
    sql: ${TABLE}.meddic_m_metrics ;;
  }
  dimension: meddic_m_metrics_score {
    type: number
    sql: ${TABLE}.meddic_m_metrics_score ;;
  }
  dimension: meddic_p_paper_process {
    type: string
    sql: ${TABLE}.meddic_p_paper_process ;;
  }
  dimension: meddic_p_paper_process_score {
    type: number
    sql: ${TABLE}.meddic_p_paper_process_score ;;
  }
  dimension: name_from_source_channel_contact {
    type: string
    sql: ${TABLE}.name_from_source_channel_contact ;;
  }
  dimension: new_business_vs_upsell {
    type: string
    sql: ${TABLE}.new_business_vs_upsell ;;
  }
  dimension_group: next_activity {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.next_activity_date ;;
  }
  dimension_group: next_step {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.next_step_date ;;
  }
  dimension: no_sao_reason {
    type: string
    sql: ${TABLE}.no_sao_reason ;;
  }
  dimension: number_of_employees {
    type: number
    sql: ${TABLE}.number_of_employees ;;
  }
  dimension: number_of_transformation_meddic_scores {
    type: number
    sql: ${TABLE}.number_of_transformation_meddic_scores ;;
  }
  dimension: one_off_deal_amount {
    type: number
    sql: ${TABLE}.one_off_deal_amount ;;
  }
  dimension: one_off_total_amount {
    type: number
    sql: ${TABLE}.one_off_total_amount ;;
  }
  dimension: open_pipe_volume_euros {
    type: number
    sql: ${TABLE}.open_pipe_volume_euros ;;
  }
  dimension: open_pipe_volume_in_record_currency {
    type: number
    sql: ${TABLE}.open_pipe_volume_in_record_currency ;;
  }
  dimension: original_source {
    type: string
    sql: ${TABLE}.original_source ;;
  }
  dimension: original_source_1 {
    type: string
    sql: ${TABLE}.original_source_1 ;;
  }
  dimension: original_source_2 {
    type: string
    sql: ${TABLE}.original_source_2 ;;
  }
  dimension: partner_contribution {
    type: string
    sql: ${TABLE}.partner_contribution ;;
  }
  dimension: is_partnerships_involved {
    type: yesno
    sql: ${TABLE}.is_partnerships_involved ;;
  }
  dimension: partner_involvement_type {
    type: string
    sql: ${TABLE}.partner_involvement_type ;;
  }
  dimension: partner_name {
    type: string
    sql: ${TABLE}.partner_name ;;
  }
  dimension: pipeline_label {
    type: string
    sql: ${TABLE}.pipeline_label ;;
  }
  dimension: presales_1__pre_project_pitched {
    type: string
    sql: ${TABLE}.presales_1__pre_project_pitched ;;
  }
  dimension_group: presales_1__pre_project_pitched {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.presales_1__pre_project_pitched_date ;;
  }
  dimension: presales_1__pre_project_won {
    type: string
    sql: ${TABLE}.presales_1__pre_project_won ;;
  }
  dimension_group: presales_1__pre_project_won {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.presales_1__pre_project_won_date ;;
  }
  dimension: presales_1_pre_project_comment {
    type: string
    sql: ${TABLE}.presales_1_pre_project_comment ;;
  }
  dimension_group: presales_1_pre_project_delivery {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.presales_1_pre_project_delivery_date ;;
  }
  dimension: presales_1_pre_project_status {
    type: string
    sql: ${TABLE}.presales_1_pre_project_status ;;
  }
  dimension: presales_2_discovery_comment {
    type: string
    sql: ${TABLE}.presales_2_discovery_comment ;;
  }
  dimension_group: presales_2_discovery_delivery {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.presales_2_discovery_delivery_date ;;
  }
  dimension: presales_2_discovery_status {
    type: string
    sql: ${TABLE}.presales_2_discovery_status ;;
  }
  dimension: presales_3_demo_comment {
    type: string
    sql: ${TABLE}.presales_3_demo_comment ;;
  }
  dimension_group: presales_3_demo_delivery {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.presales_3_demo_delivery_date ;;
  }
  dimension: presales_3_demo_status {
    type: string
    sql: ${TABLE}.presales_3_demo_status ;;
  }
  dimension: presales_3_integrations {
    type: string
    sql: ${TABLE}.presales_3_integrations ;;
  }
  dimension: presales_3_with_integrations {
    type: yesno
    sql: ${TABLE}.presales_3_with_integrations ;;
  }
  dimension_group: presales_4_pov_delivery {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.presales_4_pov_delivery_date ;;
  }
  dimension: presales_name {
    type: string
    sql: ${TABLE}.presales_name ;;
  }
  dimension: previous_amount_in_record_currency {
    type: number
    sql: ${TABLE}.previous_amount_in_record_currency ;;
  }
  dimension: previous_stage {
    type: string
    sql: ${TABLE}.previous_stage ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  dimension: project_team {
    type: string
    sql: ${TABLE}.project_team ;;
  }
  dimension_group: renewal {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.renewal_date ;;
  }
  dimension: sales_country {
    type: string
    sql: ${TABLE}.sales_country ;;
  }
  dimension: sales_region {
    type: string
    sql: ${TABLE}.sales_region ;;
  }
  dimension: segment_bigquery {
    type: string
    sql: ${TABLE}.segment_bigquery ;;
  }
  dimension: setup_amount {
    type: number
    sql: ${TABLE}.setup_amount ;;
  }
  dimension: source_channel_hubspot {
    type: string
    sql: ${TABLE}.source_channel_hubspot ;;
  }
  dimension: stage_after_previous_stage {
    type: string
    sql: ${TABLE}.stage_after_previous_stage ;;
  }
  dimension: stage_label {
    type: string
    sql: ${TABLE}.stage_label ;;
  }
  dimension: standardised_deal_value_euros {
    type: number
    sql: ${TABLE}.standardised_deal_value_euros ;;
  }
  dimension: standardised_deal_value_in_record_currency {
    type: number
    sql: ${TABLE}.standardised_deal_value_in_record_currency ;;
  }
  dimension: status_quo {
    type: string
    sql: ${TABLE}.status_quo ;;
  }
  dimension: sub_segment {
    type: string
    sql: ${TABLE}.sub_segment ;;
  }
  dimension: technical_setup {
    type: string
    sql: ${TABLE}.technical_setup ;;
  }
  dimension: territory_id {
    type: string
    sql: ${TABLE}.territory_id ;;
  }
  dimension: total_contract_value_euros {
    type: number
    sql: ${TABLE}.total_contract_value_euros ;;
  }
  dimension: trade_show {
    type: string
    sql: ${TABLE}.trade_show ;;
  }
  dimension: transformation_meddic_co_competition_score {
    type: number
    sql: ${TABLE}.transformation_meddic_co_competition_score ;;
  }
  dimension: transformation_meddic_dc_decision_criteria_score {
    type: number
    sql: ${TABLE}.transformation_meddic_dc_decision_criteria_score ;;
  }
  dimension: transformation_meddic_deal_champion_score {
    type: number
    sql: ${TABLE}.transformation_meddic_deal_champion_score ;;
  }
  dimension: transformation_meddic_dp_decision_path_score {
    type: number
    sql: ${TABLE}.transformation_meddic_dp_decision_path_score ;;
  }
  dimension: transformation_meddic_e_economic_buyers_score {
    type: number
    sql: ${TABLE}.transformation_meddic_e_economic_buyers_score ;;
  }
  dimension: transformation_meddic_i_implicated_pain_score {
    type: number
    sql: ${TABLE}.transformation_meddic_i_implicated_pain_score ;;
  }
  dimension: transformation_meddic_m_metrics_score {
    type: number
    sql: ${TABLE}.transformation_meddic_m_metrics_score ;;
  }
  dimension: transformation_meddic_p_paper_process_score {
    type: number
    sql: ${TABLE}.transformation_meddic_p_paper_process_score ;;
  }
  dimension: upsell_vs_expansion {
    type: string
    sql: ${TABLE}.upsell_vs_expansion ;;
  }
  dimension: weeks_in_current_stage {
    type: number
    sql: ${TABLE}.weeks_in_current_stage ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  partner_name,
  cs_name,
  deal_owner_name,
  ae_name,
  deal_creator_name,
  bdr_name,
  foreign_key_trunc_month_dmt_sal_ae_name,
  deal_source_channel_campaign_name,
  foreign_key_trunc_month_dmt_sao_ae_name,
  executive_sponsor_name,
  foreign_key_trunc_month_close_date_ae_name,
  presales_name,
  foreign_key_trunc_month_dmt_closed_won_ae_name,
  deal_name
  ]
  }

}
