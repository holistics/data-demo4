include: "/base_views/Datamarts/hubspot_deals_all_historized_base.view"

view: hubspot_deals_all_historized_ext {
  extends: [hubspot_deals_all_historized_base]

# ----- DIMENSIONS --------------------------------------------------------------------------

## ----- BASE DIMENSIONS --------------------------------------------------------------------

  dimension: account_classification {
    type: string
  }
  dimension: additional_developments {
    type: string
  }
  dimension: ae_name {
    type: string
    label: "AE Name"
  }

  dimension: ae_name_closed_won {
    type: string
  }

  dimension: ae_name_proposal {
    type: string
  }

  dimension: ae_name_sao {
    type: string
  }

  dimension: ae_team {
    type: string
  }

  dimension: bdr_name {
    type: string
  }

  dimension: bdr_team {
    type: string
  }

  dimension: change_in_amount_vs_previous_day {
    type: number
  }

  dimension_group: churn {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: close {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension: company_id {
    type: string
  }

  dimension: company_owner {
    type: string
  }

  dimension: contact_id_for_source_channel {
    type: string
  }

  dimension: contract_term_in_months {
    type: number
  }

  dimension_group: copied_at {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      quarter_of_year,
      year
    ]
    convert_tz: no
    datatype: date
    allow_fill: no
  }

  dimension_group: copied_at_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      quarter_of_year,
      year
    ]
  }

  dimension_group: created_at {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension: cs_name {
    type: string
  }

  dimension: cs_team {
    type: string
  }

  dimension: current_amount_euros {
    type: number
  }

  dimension: contract_type {
    type: string
    description: "Indicates whether a deal is a PoV or Pilot (regular deals: empty)."
  }

  dimension_group: contract_start {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: date_entered_sal {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: date_entered_evaluation {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: date_entered_negotiation {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: date_entered_proposal {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: date_entered_sao {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: date_entered_solution_design {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: date_left_sal {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: date_left_evaluation {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: date_left_negotiation {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: date_left_proposal {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: date_left_sao {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: date_left_solution_design {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension: days_from_sal_to_sao {
    type: number
  }

  dimension: days_from_sao_to_closed_won {
    type: number
  }

  dimension: days_in_current_stage {
    type: number
    label: "Days in Current Stage"
  }

  dimension: deal_currency_code {
    type: string
  }

  dimension: deal_id {
    type: string
  }

  dimension: deal_name {
    type: string
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/deal/{{ deal_id }}"
    }
    label: "Deal Name"
  }

  dimension: deal_next_step {
    type: string
  }

  dimension: deal_segment {
    type: string
    label: "Segment"
  }

  dimension: deal_source_channel {
    type: string
  }

  dimension: deal_source_channel_campaign_name {
    type: string
  }

  dimension: deal_source_channel_cluster_hubspot {
    type: string
  }
  dimension: deal_source_channel_department_hubspot {
    type: string
  }

  dimension: deal_source_channel_drilldown {
    type: string
  }

  dimension: deal_source_channel_drilldown_hubspot {
    type: string
  }
  dimension: deal_source_channel_first_contact_associated_hubspot {
    type: string
  }
  dimension: deal_source_channel_hubspot {
    type: string
  }
  dimension: deal_source_channel_inbound_vs_outbound_hubspot {
    type: string
  }

  dimension: deal_stage_probability {
    type: number
  }

  dimension: deal_type {
    type: string
  }

  dimension_group: dmt_closed_lost {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: dmt_closed_won {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: dmt_closed_won_validation {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: dmt_evaluation {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: dmt_negotiations {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: dmt_proposal {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: dmt_sal {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: dmt_sao {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: dmt_solution_design {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension: edeka_region {
    type: string
  }

  dimension: executive_sponsor_name {
    type: string
  }
  dimension: expansion_deal {
    type: yesno
  }
  dimension_group: expected_sd {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: final_meddic_deal_health_score_computation {
    type: number
    hidden:  yes
  }

  dimension: flip_additional_features {
    type: string
  }

  dimension: flip_basic_features {
    type: string
  }

  dimension: forecast_category {
    type: string
  }

  dimension: foreign_key_campaigns_closed_won {
    type: string
  }

  dimension: foreign_key_campaigns_sao {
    type: string
  }

  dimension: foreign_key_close_date_marketing_filters {
    type: string
  }
  dimension: foreign_key_close_date_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_close_date_quarterly_basis {
    type: string
  }

  dimension: foreign_key_closed_lost_marketing_filters {
    type: string
  }

  dimension: foreign_key_closed_lost_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_closed_won_ae_filters {
    type: string
  }

  dimension: foreign_key_closed_won_marketing_filters {
    type: string
  }

  dimension: foreign_key_closed_won_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_closed_won_upsell_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_closing_validation_marketing_filters {
    type: string
  }

  dimension: foreign_key_closing_validation_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_dates {
    type: string
  }

  dimension: foreign_key_evaluation_marketing_filters {
    type: string
  }

  dimension: foreign_key_evaluation_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_expected_sd_date_marketing_filters {
    type: string
  }

  dimension: foreign_key_expected_sd_date_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_negotiations_marketing_filters {
    type: string
  }

  dimension: foreign_key_negotiations_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_proposal_marketing_filters {
    type: string
  }

  dimension: foreign_key_proposal_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_rd_closed_won {
    type: string
  }

  dimension: foreign_key_rd_sao {
    type: string
  }

  dimension: foreign_key_revenue_rd_copied_at {
    type: string
  }

  dimension: foreign_key_sal_marketing_filters {
    type: string
  }

  dimension: foreign_key_sal_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_sao_bdr_filters {
    type: string
  }

  dimension: foreign_key_sao_marketing_filters {
    type: string
  }

  dimension: foreign_key_sao_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_sao_upsell_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_snapshotdate_ae {
    type: string
  }

  dimension: foreign_key_solution_design_marketing_filters {
    type: string
  }

  dimension: foreign_key_solution_design_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_trunc_month_close_date_ae_name {
    type: string
  }

  dimension: foreign_key_trunc_month_dmt_closed_won_ae_name {
    type: string
  }

  dimension_group: go_live {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension: has_integration {
    type: yesno
  }

  dimension: has_transformation_meddic_co_competition_score {
    type: yesno
  }
  dimension: has_transformation_meddic_dc_decision_criteria_score {
    type: yesno
  }
  dimension: has_transformation_meddic_deal_champion_score {
    type: yesno
  }
  dimension: has_transformation_meddic_dp_decision_path_score {
    type: yesno
  }
  dimension: has_transformation_meddic_e_economic_buyers_score {
    type: yesno
  }
  dimension: has_transformation_meddic_i_implicated_pain_score {
    type: yesno
  }
  dimension: has_transformation_meddic_m_metrics_score {
    type: yesno
  }
  dimension: has_transformation_meddic_p_paper_process_score {
    type: yesno
  }

  dimension: industry_flip {
    type: string
  }

  dimension: initial_evaluation_amount {
    type: number
  }

  dimension: initial_negotiations_amount {
    type: number
  }

  dimension: initial_proposal_amount {
    type: number
  }

  dimension: initial_sal_amount {
    type: number
  }

  dimension: initial_sao_amount {
    type: number
  }

  dimension: initial_solution_design_amount {
  }

  dimension: integration {
    type: string
  }

  dimension: is_a_meta_deal {
    type: yesno
  }

  dimension: is_cs_referral {
    type: string
  }

  dimension: is_edeka {
    type: yesno
  }

  dimension: is_key_deal {
    type: yesno
    label: "Is Key Deal"
  }

  dimension: is_lost_deal {
    type: number
  }
  dimension: is_lost_revenue {
    type: yesno
  }

  dimension: is_partner_influenced {
    type: string
  }

  dimension: is_partnerships_involved {
    type: yesno
  }

  dimension: is_partner_referral {
    type: string
  }

  dimension: is_top_man_referral {
    type: string
  }

  dimension_group: last_activity {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: last_contacted {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension: last_deal_stage {
    type: string
  }
    dimension: legal_information {
      type: string
    }

  dimension: licences_count {
    type: number
  }

  dimension: lost_comment {
    type: string
  }

  dimension: lost_reason {
    type: string
  }

  dimension: lost_to_competitor {
    type: string
  }

  dimension: meddic_deal_health_score {
    type: number
    value_format: "0.00%"
  }

  dimension: new_business_vs_upsell {
    type: string
    label: "Deal Type simplified: New Business vs Upsell"
    description: "For filtering: New Business vs Upsells - no distiction Edeka of Deals."
  }

  dimension_group: next_step {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

    dimension: no_sao_reason {
      type: string
    }
    dimension: number_of_employees {
      type: number
      hidden: yes
    }
    dimension: number_of_transformation_meddic_scores {
      type: number
      hidden: yes
    }

  dimension: one_off_deal_amount {
    type: number
  }

  dimension: one_off_total_amount {
    type: number
  }

  dimension: original_source {
    type: string
  }

  dimension: original_source_1 {
    type: string
  }

  dimension: original_source_2 {
    type: string
  }

  dimension: partner_name {
    type: string
  }

  dimension: pipeline_label {
    type: string
  }

  dimension: presales_name {
    type: string
  }

  dimension: previous_amount {
    type: number
  }

  dimension: previous_stage {
    type: string
  }

  dimension: primary_key {
    type: string
    primary_key: yes
  }

  dimension: sales_country {
    type: string
  }

  dimension: sales_region {
    type: string
    label: "Region"
  }

  dimension: setup_amount {
    type: number
  }

  dimension: stage_after_previous_stage {
    type: string
  }

  dimension: stage_label {
    type: string
    label: "Stage"
  }
  dimension: standardised_deal_value_euros {
    type: number
    hidden: yes
  }
  dimension: standardised_deal_value_in_record_currency {
    type: number
    hidden: yes
  }
  dimension: status_quo {
    type: string
  }
  dimension: sub_segment {
    type: string
  }
  dimension: technical_setup {
    type: string
  }

  dimension: territory_id {
    type: string
  }

  dimension: total_contract_value {
    type: number
  }

  dimension: trade_show {
    type: string
  }

  dimension: transformation_meddic_co_competition_score {
    type: number
    hidden:  yes
  }
  dimension: transformation_meddic_dc_decision_criteria_score {
    type: number
    hidden:  yes
  }
  dimension: transformation_meddic_deal_champion_score {
    type: number
   hidden:  yes
  }
  dimension: transformation_meddic_dp_decision_path_score {
    type: number
    hidden:  yes
  }
  dimension: transformation_meddic_e_economic_buyers_score {
    type: number
    hidden:  yes
  }
  dimension: transformation_meddic_i_implicated_pain_score {
    type: number
    hidden:  yes
  }
  dimension: transformation_meddic_m_metrics_score {
    type: number
    hidden:  yes
  }
  dimension: transformation_meddic_p_paper_process_score {
    type: number
    hidden:  yes
  }
  dimension: upsell_vs_expansion {
    type: string
  }

  dimension: funnel_stages_ordered {
    type: string
    sql: CASE
          WHEN ${stage_label} = "SAL" THEN "1. SAL"
          WHEN ${stage_label} = "SAO" THEN "2. SAO"
          WHEN ${stage_label} = "Solution Design" THEN "3. Solution Design"
          WHEN ${stage_label} = "Evaluation" THEN "4. Evaluation"
          WHEN ${stage_label} = "Proposal" THEN "5. Proposal"
          WHEN ${stage_label} = "Negotiation" THEN "6. Negotiations"
          WHEN ${stage_label} = "Closing Validation" THEN "7. Closing Validation"
          WHEN ${stage_label} = "Closed Won" THEN "8. Closed Won"
          WHEN ${stage_label} = "Closed Lost" THEN "9. Closed Lost"
          ELSE ${stage_label} END ;;
    label: "Stages Ordered"
  }

  dimension: close_date_drilldown {
    type: string
    sql: ${close_date} ;;
    label: "Close Date"
    hidden: yes
  }

  dimension: next_step_date_drilldown {
    type: string
    sql: ${next_step_date} ;;
    label: "Next Step Date"
    hidden: yes
  }

  dimension: dmt_sao_date_drilldown {
    type: string
    sql: ${dmt_sao_date} ;;
    hidden: yes
  }

  dimension: copied_at_date_drilldown {
    type: string
    sql: ${copied_at_date} ;;
    label: "Snapshot Date"
    hidden: yes
  }

  measure: max_date_1 {
    type: date
    sql: add_days(max(diff_days(to_date(“1900-01-01”),${copied_at_date})),to_date(“1900-01-01”)) ;;
    convert_tz: no
    label: "Max Date 1"
  }

  measure: max_date_2 {
    type: string
    sql: add_days(max(diff_days(to_date(“1900-01-01”),${copied_at_date})),to_date(“1900-01-01”)) ;;
    label: "Max Date 2"
  }

  dimension: max_date_3 {
    type: string
    sql: add_days(max(diff_days(to_date(“1900-01-01”),${copied_at_date})),to_date(“1900-01-01”)) ;;
    label: "Max Date 3"
  }

  dimension: max_date_4 {
    type: date
    sql: add_days(max(diff_days(to_date(“1900-01-01”),${copied_at_date})),to_date(“1900-01-01”)) ;;
    label: "Max Date 4"
  }

# creating parameter for enabling glanularity in the timeseries charts
  parameter: date_granularity {
    type: unquoted
    allowed_value: {
      label: "Break down by Day"
      value: "day"
    }
    allowed_value: {
      label: "Break down by Week"
      value: "week"
    }
    allowed_value: {
      label: "Break down by Month"
      value: "month"
    }
    allowed_value: {
      label: "Break down by Quarter"
      value: "quarter"
    }
    allowed_value: {
      label: "Break down by Overall"
      value: "overall"
    }
  }

  dimension: dynamic_date {
    type: string
    label_from_parameter: date_granularity
    sql:
          {% if date_granularity._parameter_value == 'day' %}
            ${copied_at_date}
          {% elsif date_granularity._parameter_value == 'week' %}
            ${copied_at_week}
          {% elsif date_granularity._parameter_value == 'month' %}
            ${copied_at_month}
          {% elsif date_granularity._parameter_value == 'quarter' %}
            CONCAT(${copied_at_year},"-",${copied_at_quarter_of_year})
          {% elsif date_granularity._parameter_value == 'overall' %}
            "Overall"
          {% else %}
            ${copied_at_date}
          {% endif %};;
  }

  # ----- MEASURES --------------------------------------------------------------------------

  measure: count {
    type: count
    label: "# Deals"
    drill_fields: [close_date_drilldown, deal_name, forecast_category, stage_label, deal_next_step, next_step_date_drilldown, dmt_sao_date_drilldown, ae_name, sales_region,deal_segment, current_amount_sum_euros]
  }

  measure: companies_associated_count {
    type: count_distinct
    sql: ${company_id} ;;
    label: "# Companies"
  }

  # measure: deals_count {
  #   type: count
  #   label: "# Deals"
  #   drill_fields: [close_date_drilldown, deal_name, forecast_category, stage_label, deal_next_step, next_step_date_drilldown, dmt_sao_date_drilldown, ae_name, sales_region,deal_segment, current_amount_sum_euros]
  # }

  measure: meddic_deal_health_score_avg {
    type:  average
    sql: ${meddic_deal_health_score} ;;
    label: "Health Score (avg)"
    drill_fields: [copied_at_date, deal_name, deal_id, stage_label, ae_name, sales_region,deal_segment, current_amount_euros]
    }

  # ----------------

  measure: sal_count {
    type: count
    filters: [dmt_sal_date:"-NULL"]
    # drill_fields: [deal_name, bdr_name, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown, sales_region,deal_segment, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros]
    label: "Count #1 SAL"
  }

  measure: sao_count {
    type: count
    filters: [dmt_sao_date:"-NULL"]
    # drill_fields: [deal_name, bdr_name, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown, sales_region,deal_segment, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros]
    label: "Count #2 SAO"
  }

  measure: solution_design_count {
    type: count
    filters: [dmt_solution_design_date:"-NULL"]
    # drill_fields: [deal_name, bdr_name, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown, sales_region,deal_segment, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros]
    label: "Count #3 Solution Design"
  }

  measure: evaluation_count {
    type: count
    filters: [dmt_evaluation_date:"-NULL"]
    # drill_fields: [deal_name, bdr_name, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown, sales_region,deal_segment, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros]
    label: "Count #4 Evaluation"
  }

  measure: proposal_count {
    type: count
    filters: [dmt_proposal_date:"-NULL"]
    # drill_fields: [deal_name, bdr_name, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown, sales_region,deal_segment, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros]
    label: "Count #5 Proposal"
  }

  measure: negotiation_count {
    type: count
    filters: [dmt_negotiations_date:"-NULL"]
    # drill_fields: [deal_name, bdr_name, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown, sales_region,deal_segment, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros]
    label: "Count #6 Negotiation"
  }

  # measure: closing_validation_count {
  #   type: count
  #   filters: [dmt_closing_validation_date:"-NULL"]
  #   # drill_fields: [deal_name, bdr_name, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown, sales_region,deal_segment, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros]
  #   label: "Count #7 Closing Validation"
  # }

  measure: closed_won_count {
    type: count
    filters: [dmt_closed_won_date:"-NULL"]
    # drill_fields: [deal_name, bdr_name, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown, sales_region,deal_segment, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros]
    label: "Count #8 Closed Won"
  }

  measure: closed_lost_count {
    type: count
    filters: [dmt_closed_lost_date:"-NULL"]
    # drill_fields: [deal_name, bdr_name, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown, sales_region,deal_segment, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros]
    label: "Count #9 Closed Lost"
  }

# ----- GENERAL MEASURES VOLUMES ----------------------------------------------------------

  measure: current_amount_sum_euros {
    type: sum
    sql: ${current_amount_euros} ;;
    filters: [new_business_vs_upsell: "New Business, Upsell"]
    label: "Deal Amount € - current value"
    drill_fields: [close_date_drilldown, deal_name, forecast_category, stage_label, deal_next_step, next_step_date_drilldown, dmt_sao_date_drilldown, ae_name, sales_region,deal_segment, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

# ----- FORECAST VOLUMES ------------------------------------------------------------------

  measure: closing_arr_sum_euros {
    type: sum
    sql: ${current_amount_euros} ;;
    filters: [close_date: "-NULL", forecast_category: "best case, commit", new_business_vs_upsell: "New Business, Upsell"]
    label: "Closing Commit & Best Case ARR €"
    drill_fields: [close_date_drilldown, deal_name, forecast_category, stage_label, deal_next_step, next_step_date_drilldown, ae_name, sales_region,deal_segment, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: closing_arr_all_sum_euros {
    type: sum
    sql: ${current_amount_euros} ;;
    filters: [close_date: "-NULL", stage_label: "SAO, Solution Design, Evaluation, Proposal, Negotiation, Closing Validation, Closed Won", new_business_vs_upsell: "New Business, Upsell"]
    label: "Closing ARR €"
    drill_fields: [copied_at_date_drilldown, close_date_drilldown, deal_name, forecast_category, sales_region,deal_segment, ae_name, stage_label, deal_next_step, next_step_date_drilldown, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

# ----- VOLUME PER STAGE ------------------------------------------------------------------

  measure: sao_current_amount_sum_euros {
    type: sum
    sql:  ${current_amount_euros} ;;
    filters: [stage_label: "SAO", new_business_vs_upsell: "New Business, Upsell"]
    label: "Volume in 2. SAO - €"
    drill_fields: [copied_at_date_drilldown, close_date_drilldown, deal_name, deal_type, sales_region,deal_segment, ae_name, stage_label, forecast_category, next_step_date_drilldown, deal_next_step, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: solution_design_current_amount_sum_euros {
    type: sum
    sql:  ${current_amount_euros} ;;
    filters: [stage_label: "Solution Design", new_business_vs_upsell: "New Business, Upsell"]
    label: "Volume in 3. Solution Design - €"
    drill_fields: [copied_at_date_drilldown, close_date_drilldown, deal_name, deal_type, sales_region,deal_segment, ae_name, stage_label, forecast_category, next_step_date_drilldown, deal_next_step, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: evaluation_current_amount_sum_euros {
    type: sum
    sql:  ${current_amount_euros} ;;
    filters: [stage_label: "Evaluation", new_business_vs_upsell: "New Business, Upsell"]
    label: "Volume in 4. Evaluation - €"
    drill_fields: [copied_at_date_drilldown, close_date_drilldown, deal_name, deal_type, sales_region,deal_segment, ae_name, stage_label, forecast_category, next_step_date_drilldown, deal_next_step, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: proposal_current_amount_sum_euros {
    type: sum
    sql:  ${current_amount_euros} ;;
    filters: [stage_label: "Proposal", new_business_vs_upsell: "New Business, Upsell"]
    label: "Volume in 5. Proposal - €"
    drill_fields: [copied_at_date_drilldown, close_date_drilldown, deal_name, deal_type, sales_region,deal_segment, ae_name, stage_label, forecast_category, next_step_date_drilldown, deal_next_step, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: negotiation_current_amount_sum_euros {
    type: sum
    sql:  ${current_amount_euros} ;;
    filters: [stage_label: "Negotiation", new_business_vs_upsell: "New Business, Upsell"]
    label: "Volume in 6. Negotiation - €"
    drill_fields: [copied_at_date_drilldown, close_date_drilldown, deal_name, deal_type, sales_region,deal_segment, ae_name, stage_label, forecast_category, next_step_date_drilldown, deal_next_step, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: closing_validation_current_amount_sum_euros {
    type: sum
    sql:  ${current_amount_euros} ;;
    filters: [stage_label: "Closing Validation", new_business_vs_upsell: "New Business, Upsell"]
    label: "Volume in 7. Closing Validation - €"
    drill_fields: [copied_at_date_drilldown, close_date_drilldown, deal_name, deal_type, sales_region,deal_segment, ae_name, stage_label, forecast_category, next_step_date_drilldown, deal_next_step, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: closed_won_current_amount_sum_euros {
    type: sum
    sql:  ${current_amount_euros} ;;
    filters: [stage_label: "Closed Won", new_business_vs_upsell: "New Business, Upsell"]
    label: "Volume in 8. Closed Won - €"
    drill_fields: [copied_at_date_drilldown, close_date_drilldown, deal_name, deal_type, sales_region,deal_segment, ae_name, stage_label, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: forecast_total_amount_sum_euros {
    type: sum
    sql:  ${current_amount_euros} ;;
    filters: [forecast_category: "pipeline, best case, commit, closed won", new_business_vs_upsell: "New Business, Upsell", stage_label: "-SAL,-Closed Lost"]
    label: "€ Amount - forecast total"
    drill_fields: [copied_at_date_drilldown, close_date_drilldown, deal_name, deal_type, forecast_category, sales_region,deal_segment, ae_name, stage_label, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: closed_won_amount_sum_euros {
    type: sum
    sql:  ${current_amount_euros} ;;
    filters: [forecast_category: "closed won", new_business_vs_upsell: "New Business, Upsell", stage_label: "Closed Won"]
    label: "€ Amount - forecast closed won"
    drill_fields: [copied_at_date_drilldown, close_date_drilldown, deal_name, deal_type, forecast_category, sales_region,deal_segment, ae_name, stage_label, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: commit_amount_sum_euros {
    type: sum
    sql:  ${current_amount_euros} ;;
    filters: [forecast_category: "commit", new_business_vs_upsell: "New Business, Upsell", stage_label: "-SAL,-Closed Lost"]
    label: "€ Amount - forecast commit"
    drill_fields: [copied_at_date_drilldown, close_date_drilldown, deal_name, deal_type, forecast_category, sales_region,deal_segment, ae_name, stage_label, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: best_case_amount_sum_euros {
    type: sum
    sql:  ${current_amount_euros} ;;
    filters: [forecast_category: "best case", new_business_vs_upsell: "New Business, Upsell", stage_label: "-SAL,-Closed Lost"]
    label: "€ Amount - forecast best case "
    drill_fields: [copied_at_date_drilldown, close_date_drilldown, deal_name, deal_type, forecast_category, sales_region,deal_segment, ae_name, stage_label, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: pipeline_amount_sum_euros {
    type: sum
    sql:  ${current_amount_euros} ;;
    filters: [forecast_category: "pipeline", new_business_vs_upsell: "New Business, Upsell", stage_label: "-SAL,-Closed Lost"]
    label: "€ Amount - forecast pipeline"
    drill_fields: [copied_at_date_drilldown, close_date_drilldown, deal_name, deal_type, forecast_category, sales_region,deal_segment, ae_name, stage_label, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

# ----- VOLUME CHANGES --------------------------------------------------------------------

  # measure: previous_amount_sum_euros {
  #   type: sum
  #   sql: ${previous_amount} ;;
  #   filters: [new_business_vs_upsell: "New Business, Upsell"]
  #   label: "Deal Amount € - previous day value"
  #   # drill_fields: [copied_at_date_drilldown, deal_name, previous_stage, stage_after_previous_stage, ae_name, current_amount_sum_euros, previous_amount, change_in_amount_vs_previous_day_sum_euros]
  #   value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  #   hidden: yes
  # }

  # measure: change_in_amount_vs_previous_day_sum_euros {
  #   type: sum
  #   sql: ${change_in_amount_vs_previous_day} ;;
  #   filters: [new_business_vs_upsell: "New Business, Upsell"]
  #   label: "Deal Amount € - net value (current vs previous day)"
  #   drill_fields: [copied_at_date_drilldown, deal_name, previous_stage, stage_label, ae_name, change_in_amount_vs_previous_day_sum_euros, previous_amount_sum_euros, current_amount_sum_euros]
  #   value_format: "\"€\"#,##0"
  # }

}
