include: "/base_views/Datamarts/hubspot_deals_all_base.view"
include: "/extended_views/Datamarts/hubspot_customers_all_ext.view"

view: hubspot_deals_all_ext {
  extends: [hubspot_deals_all_base]

  drill_fields: [deal_id, deal_name, ae_name,deal_segment, deal_allocation, deal_allocation_mix, sales_region, stage_label, deal_type, current_amount_euros]

# ----- DIMENSIONS --------------------------------------------------------------------------

## ----- BASE DIMENSIONS --------------------------------------------------------------------

  dimension: additional_developments {
    type: string
    label: "#  additional Developments"
  }

  dimension: ae_name {
    type: string
    label: "AE Name"
    description: "Current AE Name associated to the Deal."
  }

  dimension: ae_team {
    type: string
    label: "AE Team"
    description: "HubSpot Team from the AE Name associated to the Deal."
  }

  dimension: bdr_name {
    type: string
    label: "BDR Name"
    description: "Current BDR Name associated to the Deal."
  }

  dimension: bdr_name_sal {
    type: string
    description: "BDR name when Deal was moved to SAL - static, value will never change"
  }

  dimension: bdr_name_sao {
    type: string
    description: "BDR name when Deal was moved to SAO - static, value will never change"
  }

  dimension: bdr_team {
    type: string
    label: "BDR Team"
    description: "HubSpot Team from the BDR Name associated to the Deal."
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
    label: "Date - Churn (DMT)"
  }

  dimension_group: close {
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
    label: "Date - (expected) Close"
    description: "Date which the Deal is supposed to be closed: either Won or Lost."
  }

  dimension: company_id {
    type: string
    label: "Company ID"
    description: "ID of the Company which the Deal is associated to."
  }

  dimension: company_industry {
    type: string
  }

  dimension: company_is_workplace_partner {
    type: yesno
    label: "Company Is Workplace Partner"
  }

  dimension: company_marketing_campaigns_memberships {
    type: string
    label: "Company Marketing Campaigns Memberships"
  }

  dimension: company_name_groups {
    type: string
    label: "Company Name Groups"
  }

  dimension: company_other_technologies {
    type: string
    label: "Company Other Technologies"
  }

  dimension: company_owner {
    type: string
    label: "Company Owner"
  }

  dimension: company_partner_marker {
    type: string
    label: "Company Partner Marker"
  }

  dimension: company_workplace_list_region {
    type: string
    label: "Company Workplace List Region"
  }

  dimension: company_workplace_source {
    type: string
    label: "Company Workplace Source"
  }

  dimension_group: contact_dmt_lead {
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
    label: "Date - Contact DMT Lead"
  }

  dimension_group: contact_dmt_mql {
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
    hidden: yes
  }

  dimension_group: contact_dmt_sql {
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
    hidden: yes
  }

  dimension: contact_id_for_source_channel {
    type: string
    label: "Contact ID for Source Channel"
    description: "ID of the contact which is used for the Marketing Source Attribution."
  }

  dimension: contact_is_workplace_customer {
    type: yesno
    label: "Contact Is Workplace Customer"
  }

  dimension: contact_is_workplace_user {
    type: yesno
    label: "Contact Is Workplace User"
  }

  dimension: contact_seniority {
    type: string
    label: "Contact Seniority"
  }

  dimension: contact_workplace_community_membership {
    type: string
    label: "Contact Workplace Community Membership"
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
    label: "Date - Contract Start (recognized)"
  }

  dimension: contract_term_in_months {
    type: number
    label: "Contract - in months"
    description: "Duration of the contract in months."
  }

  dimension_group: copied_at {
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
    label: "Date - Copied at"
    # hidden: yes
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
      year
    ]
    hidden: yes
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
    label: "Date - Created at"
    description: "The date the Deal was created at."
  }

  dimension: cs_name {
    type: string
    label: "CS Name"
    description: "Current CS Name associated to the Deal."
  }

  dimension: cs_team {
    type: string
    label: "CS Team"
    description: "HubSpot Team from the CS Name associated to the Deal."
  }

  dimension: current_amount_euros {
    type: number
    label: "Deal Amount - Current Value"
    description: "Current Value of the Deal Annual Recurring Revenue in euros."
  }

  dimension_group: churned_date_group {
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
    label: "Date - DMT Churned Customer Group Date"
    }

  dimension_group: churned_date_customer {
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
    label: "Date - DMT Churned Customer Date"
  }

  dimension: customer_has_ae_hc {
    type: yesno
  }

  dimension: customer_has_pov {
    type: yesno
  }

  dimension: customer_is_pov_conversion {
    type: yesno
  }

  dimension: customer_is_pov_conversion_no_expansion { # use this flag for NRR ext PoV Conversion
    type: yesno
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

  dimension: days_from_sal_to_sao {
    type: number
    hidden: yes
  }

  dimension: days_from_sal_to_closed_won {
    type: number
    hidden: yes
  }

  dimension: days_from_sal_to_closed_lost {
    type: number
    hidden: yes
  }

  dimension: days_from_sao_to_solution_design {
    type: number
    hidden: yes
  }

  dimension: days_from_sao_to_closed_won {
    type: number
    hidden: yes
  }

  dimension: days_from_sao_to_closed_lost {
    type: number
    hidden: yes
  }

  dimension: days_from_solution_design_to_evaluation {
    type: number
    hidden: yes
  }

  dimension: days_from_solution_design_to_closed_won {
    type: number
    hidden: yes
  }

  dimension: days_from_solution_design_to_closed_lost {
    type: number
    hidden: yes
  }

  dimension: days_from_solution_design_to_negotiation {
    type: number
    hidden: yes
  }

  dimension: days_from_evaluation_to_proposal {
    type: number
    hidden: yes
  }

  dimension: days_from_evaluation_to_closed_won {
    type: number
    hidden: yes
  }

  dimension: days_from_evaluation_to_closed_lost {
    type: number
    hidden: yes
  }

  dimension: days_from_proposal_to_negotiation {
    type: number
    hidden: yes
  }

  dimension: days_from_proposal_to_closed_won {
    type: number
    hidden: yes
  }

  dimension: days_from_negotiation_to_closed_won {
    type: number
    hidden: yes
  }

  dimension: days_from_deal_creation_to_closed_won {
    type: number
    hidden: yes
  }

  dimension: days_from_proposal_to_closed_lost {
    type: number
    hidden: yes
  }

  dimension: days_from_negotiation_to_closed_lost {
    type: number
    hidden: yes
  }

  dimension: days_from_deal_creation_to_closed_lost {
    type: number
    hidden: yes
  }

  dimension: days_in_current_stage {
    type: number
    label: "# Days in Current Stage - unformatted"
    hidden: yes
  }

  dimension: days_in_sal_stage {
    type: number
    label: "# Days in SAL"
    hidden: yes
  }

  dimension: days_in_evaluation_stage {
    type: number
    label: "# Days in Evaluation"
    hidden: yes
  }

  dimension: days_in_negotiation_stage {
    type: number
    label: "# Days in Negotiation"
    hidden: yes
  }

  dimension: days_in_proposal_stage {
    type: number
    label: "# Days in Proposal"
    hidden: yes
  }

  dimension: days_in_sao_stage {
    type: number
    label: "# Days in SAO"
    hidden: yes
  }

  dimension: days_in_solution_design_stage {
    type: number
    label: "# Days in Solution Design"
    hidden: yes
  }

  dimension: days_since_last_activity {
    type: number
    label: "# Days since CRM Last Activity"
  }

  dimension: days_to_next_activity {
    type: number
    label: "# Days to CRM Next Activity"
  }

  dimension: deal_creator_name {
    type: string
    label: "Deal Creator Name"
    description: "HubSpot User Name from the Deal Creator."
  }

  dimension: deal_creator_team {
    type: string
    label: "Deal Creator Team"
    description: "HubSpot Team from the Deal Creator."
  }

  dimension: deal_currency_code {
    type: string
    label: "Currency Code"
    description: "Deal Original Currency Code."
  }

  dimension: deal_id {
    type: string
    label: "Deal ID"
    primary_key: yes
  }

  dimension: deal_marketing_influence_touchpoints {
    type: string
    hidden: yes
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
    label: "Deal Next Step - unformatted"
    description: "Next action which will be taken by the AE or BDR on the specific Deal."
  }

  dimension: deal_owner_name {
    type: string
    label: "Deal Owner Name"
  }

  dimension: deal_partner_marketing_campaign {
    type: string
  }
  dimension: has_deal_partner_marketing_influence {
    type: string
  }

  dimension: deal_source_channel_campaign_name {
    type: string
    label: "Source Channel Campaign Name"
    description: "Campaign Name of the Channel which triggered the Deal: first contact between Lead and Flip."
  }
  dimension: deal_source_channel_cluster_hubspot {
    type: string
  }
  dimension: deal_source_channel_department_hubspot {
    type: string
  }
  dimension: deal_source_channel_drilldown {
    type: string
    label: "Source Channel Drilldown OLD"
  }
  dimension: deal_source_channel_drilldown_hubspot {
    type: string
  }
  dimension: deal_source_channel_first_contact_id_associated_hubspot {
    type: string
  }

  dimension: deal_source_channel {
    type: string
    label: "Deal Source Channel OLD"
    description: "Demand capturing Source - first engagement between the Prospect and Flip."
  }

  dimension: deal_source_channel_inbound_vs_outbound_hubspot {
    type: string
  }

  dimension: deal_stage_probability {
    type: number
  }

  dimension: deal_paid_search_channel {
    type: string
    label: "Paid Search Channel"
  }

  dimension: deal_grouped_campaign {
    type: string
    label: "Deal Grouped Campaign"
  }

  dimension: deal_campaign_or_event {
    type: string
    label: "Deal Campaign/Event"
  }

  dimension: deal_type {
    type: string
    label: "Deal Type"
    description: "For filtering: New Business, Upsells, Renewals, POV and Edeka Deals."
  }

  dimension: new_business_vs_upsell {
    type: string
    label: "New Business vs Upsell"
    description: "For filtering: New Business vs Upsells - no distiction Edeka of Deals. Upsells include Renewals if their amount is >0 (larger than original new logo)."
  }

  dimension_group: closed {
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
    label: "(Expected) Close Date"
    description: "Expected Close Date."
  }

  dimension_group: dmt_closed_lost {
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
    label: "Date - DMT Closed Lost"
    description: "Date which the Deal was moved to the Closed Lost Stage."
  }

  dimension_group: dmt_closed_won {
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
    label: "Date - DMT Closed Won"
    description: "Date which the Deal was moved to the Closed Won Stage."
  }

  dimension_group: dmt_closed_won_customer {
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
    label: "Date - DMT Closed Won (Customer)"
    description: "Date of first Happy Call of the (single) Customer"
  }

  dimension_group: dmt_closed_won_group {
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
    label: "Date - DMT Closed Won (Customer Group)"
    description: "Date of first Happy Call of the Customer Group"
  }

  dimension_group: dmt_closed_won_validation {
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
    label: "Date - DMT Closing Validation"
    description: "Date which the Deal was moved to the Closing Validation Stage."
  }

  dimension_group: dmt_evaluation {
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
    label: "Date - DMT Evaluation"
    description: "Date which the Deal was moved to the Evaluation Stage."
  }

  dimension_group: dmt_negotiations {
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
    label: "Date - DMT Negotiations"
    description: "Date which the Deal was moved to the Negotiations Stage."
  }

  dimension_group: dmt_proposal {
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
    label: "Date - DMT Proposal"
    description: "Date which the Deal was moved to the Proposal Stage."
  }

  dimension_group: dmt_sal {
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
    label: "Date - DMT SAL"
    description: "Date which the Deal was moved to the SAL Stage."
  }

  dimension_group: dmt_sao {
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
    label: "Date - DMT SAO"
    description: "Date which the Deal was moved to the SAO Stage."
  }

  dimension_group: dmt_solution_design {
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
    label: "Date - DMT Solution Design"
    description: "Date which the Deal was moved to the Solution Design Stage."
  }

  dimension: edeka_region {
    type: string
    label: "Edeka Region"
  }

  dimension_group: expected_sd {
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
    label: "Date - Expected SD"
    description: "Expected Date to have the Deal moved to Solution Design stage"
  }

  dimension: final_meddic_deal_health_score_computation {
    type: number
    link: {
      label: "Deal MEDDIC section in CRM"
      url: "https://app.hubspot.com/contacts/7401529/deal/{{ deal_id }}/properties?search=__"
    }
    label: "Deal Health Score - unformatted (Hubspot)"
    description: "Probability of successfully closing a deal based on it's metrics and hygiene. Green for >=85%, Yellow for >=60% and Red for <60%"
  }

  dimension: exclude_flip_flow_sals {
    type: yesno
  }

  dimension: expansion_deal {
    type: yesno
    label: "Is Expansion Deal"
  }

  dimension: flip_additional_features {
    type: string
    label: "Flip Additional Features"
  }

  dimension: flip_basic_features {
    type: string
    label: "Flip Basic Features"
  }

  dimension: forecast_category {
    type: string
    label: "Forecast Category"
    description: "Category selected for the Deal Forecast in HubSpot: Commit, Best Case, Pipeline or Not Forecasted."
  }

  dimension: foreign_key_campaigns_sao {
    type: string
    label: "Foreign Key Campaigns - SAO"
    hidden: yes
  }

  dimension: foreign_key_campaigns_closed_won {
    type: string
    label: "Foreign Key Campaigns - Closed Won"
    hidden: yes
  }

  dimension: foreign_key_close_date_marketing_filters {
    type: string
    label: "Foreign Key - Marketing Filters Close Date"
    hidden: yes
  }

  dimension: foreign_key_expected_sd_date_marketing_filters {
    type: string
    label: "Foreign Key - Marketing Filters Expected SD Date"
    hidden: yes
  }

  dimension: foreign_key_closed_lost_marketing_filters {
    type: string
    label: "Foreign Key - Marketing Filters Closed Lost"
    hidden: yes
  }

  dimension: foreign_key_closing_validation_marketing_filters {
    type: string
    label: "Foreign Key - Marketing Filters Closing Validation"
    hidden: yes
  }

  dimension: foreign_key_closed_won_marketing_filters {
    type: string
    label: "Foreign Key - Marketing Filters Closed Won"
    hidden: yes
  }

  dimension: foreign_key_closed_won_marketing_filters_allocation {
    type: string
    label: "FK Cl. Won Mkt Filters Alloc."
  }

  dimension: foreign_key_closed_won_upsell_marketing_filters_allocation {
    type: string
    label: "FK Cl. Won Upsell Mkt Filters Alloc."
  }

  dimension: foreign_key_closed_won_ae_filters {
    type: string
    label: "Foreign Key - AE Filters Closed Won"
    hidden: yes
  }

  dimension: foreign_key_evaluation_marketing_filters {
    type: string
    label: "Foreign Key - Marketing Filters Evaluation"
    hidden: yes
  }

  dimension: foreign_key_negotiations_marketing_filters {
    type: string
    label: "Foreign Key - Marketing Filters Negotiations"
    hidden: yes
  }

  dimension: foreign_key_proposal_marketing_filters {
    type: string
    label: "Foreign Key - Marketing Filters Proposal"
    hidden: yes
  }

  dimension: foreign_key_sal_marketing_filters {
    type: string
    label: "Foreign Key - Marketing Filters SAL"
    hidden: yes
  }

  dimension: foreign_key_sao_marketing_filters {
    type: string
    label: "Foreign Key - Marketing Filters SAO"
    hidden: yes
  }

  dimension: foreign_key_sao_marketing_filters_allocation {
    type: string
    label: "FK SAO Mkt Filters Alloc."
  }

  dimension: foreign_key_sao_upsell_marketing_filters_allocation {
    type: string
    label: "FK SAO Upsell Mkt Filters Alloc."
  }

  # needed to understand missing SAOs in BDR dashboard:
  dimension: foreign_key_sao_bdr_filters {
    type: string
    hidden: no
  }

  dimension: foreign_key_sao_bdr {
    type: string
    hidden: yes
  }

  dimension: foreign_key_sal_bdr_filters {
    type: string
    hidden: yes
  }

  dimension: foreign_key_snapshotdate_ae {
    type: string
    label: "Foreign Key - Sales Ops Snapshot Date AE"
    hidden: yes
  }

  dimension: foreign_key_trunc_month_close_date_ae_name {
    type: string
    label: "Foreign Key - Sales TRUNC-Close Date AE"
    hidden: no
  }

  dimension: foreign_key_trunc_month_dmt_sal_ae_name {
    type: string
    label: "Foreign Key - Sales TRUNC-DMT SAL AE"
    hidden: yes
  }

  dimension: foreign_key_trunc_month_dmt_sao_ae_name {
    type: string
    label: "Foreign Key - Sales TRUNC-DMT SAO AE"
    hidden: yes
  }

  dimension: foreign_key_trunc_month_dmt_closed_won_ae_name {
    type: string
    label: "Foreign Key - Sales TRUNC-DMT Closed Won AE"
    hidden: no
  }

  dimension: foreign_key_solution_design_marketing_filters {
    type: string
    label: "Foreign Key - Marketing Filters Solution Design"
    hidden: yes
  }

  dimension: foreign_key_rd_sao {
    type: string
    hidden: yes
  }

  dimension: foreign_key_rd_closed_won {
    type: string
    hidden: yes
  }

  dimension: foreign_key_revenue_rd_copied_at {
    type: string
    hidden: yes
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
    label: "Date - Go Live"
    description: "Date in which the customer will launch the Flip system."
  }

  dimension: has_integration {
    type: yesno
    label: "Has Integration"
  }

  dimension: has_transformation_meddic_co_competition_score {
    type: yesno
    hidden: yes
  }
  dimension: has_transformation_meddic_dc_decision_criteria_score {
    type: yesno
    hidden: yes
  }
  dimension: has_transformation_meddic_deal_champion_score {
    type: yesno
    hidden: yes
  }
  dimension: has_transformation_meddic_dp_decision_path_score {
    type: yesno
    hidden: yes
  }
  dimension: has_transformation_meddic_e_economic_buyers_score {
    type: yesno
    hidden: yes
  }
  dimension: has_transformation_meddic_i_implicated_pain_score {
    type: yesno
    hidden: yes
  }
  dimension: has_transformation_meddic_m_metrics_score {
    type: yesno
    hidden: yes
  }
  dimension: has_transformation_meddic_p_paper_process_score {
    type: yesno
    hidden: yes
  }

  dimension: inbound_outbound {
    type: string
    label: "Is Inbound Outbound OLD"
    hidden: no
  }

  dimension: industry_flip {
    type: string
    label: "Industry (of the Deal)"
  }

  dimension: initial_closing_validation_amount_euros {
    type: number
    label: "€ Initial Deal Amount - Closing Validation"
    description: "ARR entered when the Deal was moved to Closing Validation."
    hidden: yes
  }

  dimension: initial_evaluation_amount_euros {
    type: number
    label: "€ Initial Deal Amount - Evaluation"
    description: "ARR entered when the Deal was moved to Evaluation."
    hidden: yes
  }

  dimension: initial_negotiations_amount_euros {
    type: number
    label: "€ Initial Deal Amount - Negotiations"
    description: "ARR entered when the Deal was moved to Negotiations."
    hidden: yes
  }

  dimension: initial_proposal_amount_euros {
    type: number
    label: "€ Initial Deal Amount - Proposal"
    description: "ARR entered when the Deal was moved to Proposal."
    hidden: yes
  }

  dimension: initial_sao_amount_euros {
    type: number
    label: "€ Initial Deal Amount - SAO"
    description: "ARR entered when the Deal was moved to SAO."
    hidden: yes
  }

  dimension: initial_solution_design_amount_euros {
    type: number
    label: "€ Initial Deal Amount - Solution Design"
    description: "ARR entered when the Deal was moved to Solution Design."
    hidden: yes
  }

  dimension: integration {
    type: string
    label: "# Add-Ons"
    description: "Integrations"
  }

  dimension: is_a_meta_deal {
    type: yesno
  }

  dimension: is_cs_referral {
    type: string
    label: "Is CS Referral"
    description: "Equal to Yes if the first contact between Lead and Flip was triggered by a CS Referral."
  }

  dimension: is_deal_lost_to_staffbase {
    type: yesno
  }

  dimension: is_deal_lost_to_beekeeper {
    type: yesno
  }

  dimension: is_edeka {
    type: yesno
    label: "Is Edeka"
  }

  dimension: is_flip_flow_upsell_deal {
    type: yesno
  }
  dimension: is_key_deal {
    type: yesno
  }
  dimension: is_license_overrun_deal {
    type: yesno
  }
  dimension: is_partner_influenced {
    type: string
    label: "Is Partner Influenced"
    description: "Equal to Yes if a partner was involved after the deal was already sourced"
  }

  dimension: is_partnerships_involved {
    type: yesno
    label: "Is Partner involved"
  }

  dimension: is_partner_referral {
    type: string
    label: "Is Partner Referral"
    description: "Equal to Yes if the first contact between Lead and Flip was triggered by a Partner Referral."
  }

  dimension: is_top_man_referral {
    type: string
    label: "Is Top Man Referral"
    description: "Equal to Yes if the first contact between Lead and Flip was triggered by a Top Man Referral."
  }

  dimension: is_lost_deal {
    type: number
    label: "Is Lost Deal"
  }

  dimension: job_title_from_source_channel_contact {
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
    label: "Date - Last Activity"
    description: "Date from the Deal last activity in HubSpot."
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
    label: "Date - Last Contacted"
    description: "Date in which the Lead associated to the Deal was last contacted by a HubSpot user."
  }

  dimension: last_deal_stage {
    type: string
    label: "Deal Stage: previous"
  }

  dimension: legal_information {
    type: string
  }

  dimension: licences_count {
    type: number
    label: "Licenses Count"
    description: "Number of licenses entered to the Deal."
  }

  dimension: lost_amount_euros {
    type: string
    label: "Lost Amount"
  }

  dimension: lost_comment {
    type: string
    label: "Lost Comment"
    description: "Further insights on why the Deal was moved to Closed Lost."
  }

  dimension: lost_reason {
    type: string
    label: "Lost Reason"
    description: "The reason why the Deal was moved to Closed Lost."
  }

  dimension: lost_to_competitor {
    type: string
    label: "Lost to Competitor"
    description: "The competitor won the Deal that was lost by Flip."
  }

 # old meddic dims with logic in bigquery (replaced with HS):
  # dimension: meddic_deal_health_score { \ old version, use final_meddic_deal_health_score_computation instead
  #   type: number
  #   hidden: no
  #   link: {
  #     label: "Deal MEDDIC section in CRM"
  #     url: "https://app.hubspot.com/contacts/7401529/deal/{{ deal_id }}/properties?search=__"
  #     }
  #   label: "Deal Health Score - unformatted (Code)"
  #   description: "Probability of successfully closing a deal based on it's metrics and hygiene. Green for >=85%, Yellow for >=60% and Red for <60%"
  #   # hidden: yes
  # }

  # dimension: meddic_recommendations {
  #   type: string
  #   label: "MEDDPICC Recommendation"
  #   description: "Actions to be taken in order to bring the Health Score to the expected value (equal to 1 regardless the stage)."
  # }

  # dimension: meddic_metrics_recommendations {
  #   type: string
  # }

  # dimension: meddic_economic_buyer_recommendations {
  #   type: string
  # }

  # dimension: meddic_decision_criteria_recommendations {
  #   type: string
  # }

  # dimension: meddic_decision_path_recommendations {
  #   type: string
  # }

  # dimension: meddic_implicated_pain_recommendations {
  #   type: string
  # }

  # dimension: meddic_deal_champion_recommendations {
  #   type: string
  # }

  # dimension: meddic_competition_recommendations {
  #   type: string
  # }

  # dimension: meddic_paper_process_recommendations {
  #   type: string
  # }

  dimension: name_from_source_channel_contact {
    type: string
  }

  dimension_group: next_activity {
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
    label: "Date - CRM Next Activity"
    description: "The date in which the next activity is planned for the deal in the CRM"
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
    label: "Date - Next Step - unformatted"
    description: "The date in which the next action on the Deal will be taken by a Sales colleague."
  }

  dimension: no_sao_reason {
    type: string
    label: "No SAO reason"
  }

  dimension: number_of_employees {
    type: number
    label: "Number of Employees"
  }

  dimension: number_of_transformation_meddic_scores {
    type: number
    hidden: yes
  }

  dimension: one_off_cost {
    type: number
  }

  dimension: one_off_deal_amount {
    type: number
    label: "Deal Amount - One Off"
  }

  dimension: one_off_total_amount {
    type: number
    label: "Deal Amount - One Off Total"
  }

  dimension: open_pipe_volume_euros {
    type: number
    hidden: yes
  }

  dimension: original_source {
    type: string
    label: "Original Source"
    hidden: yes
  }

  dimension: original_source_1 {
    type: string
    label: "Original Source 1"
    hidden: yes
  }

  dimension: original_source_2 {
    type: string
    label: "Original Source 2"
    hidden: yes
  }
  dimension: partner_contribution {
    type: string
    description: "Indicates whether a deal is resell (partner-led) or co-sell (rep supported)."
  }
  dimension: partner_name {
    type: string
    label: "Partner Name"
    description: "Name of the Partner which referred the Lead of the Deal."
  }

  dimension: partner_involvement_type {
    type: string
    label: "Partner Involvement Type"
    description: "Type of involvement from Partner in the Deal, used for source channel allocation (who discovered the lead first?)."
  }

  dimension: pipeline_label {
    type: string
    label: "Pipeline"
    description: "Name of the pipeline which the Deal belong to in HubSpot."
  }

  dimension: presales_name {
    type: string
    label: "Presales Name"
    description: "Current Presales Name associated to the Deal."
  }

  dimension: presales_1__pre_project_pitched {
    type: string
  }
  dimension_group: presales_1__pre_project_pitched {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: presales_1__pre_project_won {
    type: string
    hidden: yes
  }
  dimension_group: presales_1__pre_project_won {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  dimension: presales_1_pre_project_comment {
    type: string
  }

  dimension_group: presales_1_pre_project_delivery {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: datetime
  }

  dimension: presales_1_pre_project_status { # old property, replaced with is_pitched and is_won 8/'24
    type: string
  }

  dimension: presales_2_discovery_comment {
    type: string
  }

  dimension_group: presales_2_discovery_delivery {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: datetime
  }

  dimension: presales_2_discovery_status {
    type: string
  }

  dimension: presales_3_demo_comment {
    type: string
  }

  dimension_group: presales_3_demo_delivery {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: datetime
  }

  dimension: presales_3_demo_status {
    type: string
  }
  dimension: presales_3_integrations {
    type: string
  }
  dimension: presales_3_with_integrations {
    type: yesno
  }
  dimension_group: presales_4_pov_delivery {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: datetime
  }

  dimension: project_team {
    type: string
    label: "Project Team"
  }

  dimension_group: renewal {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: datetime
  }

  dimension: sales_country {
    type: string
    label: "Sales Country"
  }

  dimension: sales_region {
    type: string
    label: "Sales Region"
  }

  dimension: setup_amount {
    type: number
    label: "Deal Amount - Setup"
  }

  dimension: source_channel_hubspot {
    type: string
    label: "Source Channel Hubspot OLD"
  }

  dimension: stage_label {
    type: string
    label: "Deal Stage: current"
    description: "Name of the current pipeline stage which the Deal belong to in HubSpot."
  }

  dimension: stage_after_sao {
    type: string
    label: "Stage after SAO"
  }

  dimension: stage_after_solution_design {
    type: string
    label: "Stage after Solution Design"
  }

  dimension: stage_after_evaluation {
    type: string
    label: "Stage after Evaluation"
  }

  dimension: stage_after_proposal {
    type: string
    label: "Stage after Proposal"
  }

  dimension: stage_after_negotiation {
    type: string
    label: "Stage after Negotiation"
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
    label: "Status Quo"
  }

  dimension: technical_setup {
    type: string
  }

  dimension: territory_id {
    type: string
    label: "Territory ID"
    description: "ID of the Territory which the Company associated to the Deal belong to."
  }

  dimension: total_contract_value_euros {
    type: number
    label: "€ Total Contract Value"
    hidden: yes
  }

  dimension: trade_show {
    type: string
    label: "Trade Show"
    description: "Name of the Trade Show in case the Lead of the Deal was a Trade Show sourced Lead."
  }

  dimension: transformation_meddic_co_competition_score {
    type: number
    hidden: yes
  }
  dimension: transformation_meddic_dc_decision_criteria_score {
    type: number
    hidden: yes
  }
  dimension: transformation_meddic_deal_champion_score {
    type: number
    hidden: yes
  }
  dimension: transformation_meddic_dp_decision_path_score {
    type: number
    hidden: yes
  }
  dimension: transformation_meddic_e_economic_buyers_score {
    type: number
    hidden: yes
  }
  dimension: transformation_meddic_i_implicated_pain_score {
    type: number
    hidden: yes
  }
  dimension: transformation_meddic_m_metrics_score {
    type: number
    hidden: yes
  }
  dimension: transformation_meddic_p_paper_process_score {
    type: number
    hidden: yes
  }

  dimension: upsell_vs_expansion {
    type: string
    description: "Differentiates deals with Deal type (Upsell, Upsell EDEKA) between (licence) expansion and (feature) upsell."
  }

  dimension: weeks_in_current_stage {
    type: number
    label: "Weeks in current stage"
  }

## ------ // END OF BASE DIMENSIONS ----------------------------------------------------------------------------

## ------ MANUALLY ADDED DIMENSIONS ----------------------------------------------------------------------------

    dimension: revenue_signed_date { #logic
      type: string
      sql: CASE WHEN ${is_lost_revenue} is TRUE THEN COALESCE (${churn_date}, ${dmt_closed_won_date})
        ELSE ${dmt_closed_won_date} END;;
      description: "This date indicates the latest significant signed date (either Closed Won or when Churn Date)"
      hidden: no
    }

    dimension: is_mtd {
      type: yesno
      sql: EXTRACT(MONTH from DATE(${revenue_signed_date})) = EXTRACT(MONTH from CURRENT_DATE()) ;;
      #sql: (EXTRACT(Day from ${revenue_signed_date}) < EXTRACT(Day from CURRENT_DATE()));;
      label: "is MTD (signed)"
    }

    dimension: is_ytd {
      type: yesno
      sql: EXTRACT(YEAR from DATE(${revenue_signed_date})) = EXTRACT(YEAR from CURRENT_DATE()) ;;
      #sql: EXTRACT(Day from ${revenue_signed_date}) < EXTRACT(Day from CURRENT_DATE());;
      label: "is YTD (signed)"
    }

# creating parameter for enabling glanularity in the timeseries charts
  parameter: date_granularity {
    type: unquoted
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
        label: "Break down by Year"
        value: "year"
      }
  }

  parameter: base_date_for_funnel {
    type: unquoted
      allowed_value: {
        label: "Deal moved to MQL Date"
        value: "mqldate"
      }
      allowed_value: {
        label: "Deal Close Date"
        value: "closedate"
      }
  }

  dimension: dynamic_date_sao {
    type: string
    label_from_parameter: date_granularity
    sql:
          {% if date_granularity._parameter_value == 'month' %}
            ${dmt_sao_month}
          {% elsif date_granularity._parameter_value == 'quarter' %}
            CONCAT(${dmt_sao_year},"-",${dmt_sao_quarter_of_year})
          {% elsif date_granularity._parameter_value == 'year' %}
            LEFT(CAST(DATE_TRUNC(${dmt_sao_date},YEAR) AS STRING),4)
          {% else %}
            ${dmt_sao_date}
          {% endif %};;
  }

  dimension: dynamic_close_date {
    type: string
    label_from_parameter: date_granularity
    sql:
          {% if date_granularity._parameter_value == 'month' %}
            ${close_month}
          {% elsif date_granularity._parameter_value == 'quarter' %}
            CONCAT(${close_year},"-",${close_quarter_of_year})
          {% elsif date_granularity._parameter_value == 'year' %}
            LEFT(CAST(DATE_TRUNC(${close_date},YEAR) AS STRING),4)
          {% else %}
            ${close_date}
          {% endif %};;
  }

# dynamic dates for lost deals
  # dimension: dynamic_date_discovery {
  #   type: string
  #   label_from_parameter: date_granularity
  #   sql:
  #         {% if date_granularity._parameter_value == 'month' %}
  #           ${dmt_discovery_month}
  #         {% elsif date_granularity._parameter_value == 'quarter' %}
  #           CONCAT(${dmt_discovery_year},"-",${dmt_discovery_quarter_of_year})
  #         {% elsif date_granularity._parameter_value == 'year' %}
  #           LEFT(CAST(DATE_TRUNC(${dmt_discovery_date},YEAR) AS STRING),4)
  #         {% else %}
  #           ${dmt_discovery_date}
  #         {% endif %};;
  # }

# dynamic dates for happy calls
    dimension: dynamic_date_closed_won {
      type: string
      label_from_parameter: date_granularity
      sql:
          {% if date_granularity._parameter_value == 'month' %}
            ${dmt_closed_won_month}
          {% elsif date_granularity._parameter_value == 'quarter' %}
            CONCAT(${dmt_closed_won_year},"-",${dmt_closed_won_quarter_of_year})
          {% elsif date_granularity._parameter_value == 'year' %}
            LEFT(CAST(DATE_TRUNC(${dmt_closed_won_date},YEAR) AS STRING),4)
          {% else %}
            ${dmt_closed_won_date}
          {% endif %};;
    }

# dynamic dates for lost deals
    dimension: dynamic_date_closed_lost {
      type: string
      label_from_parameter: date_granularity
      sql:
          {% if date_granularity._parameter_value == 'month' %}
            ${dmt_closed_lost_month}
          {% elsif date_granularity._parameter_value == 'quarter' %}
            CONCAT(${dmt_closed_lost_year},"-",${dmt_closed_lost_quarter_of_year})
          {% elsif date_granularity._parameter_value == 'year' %}
            LEFT(CAST(DATE_TRUNC(${dmt_closed_lost_date},YEAR) AS STRING),4)
          {% else %}
            ${dmt_closed_lost_date}
          {% endif %};;
    }

# dynamic dates for happy calls
  dimension: dynamic_date_customer_signed_hc {
    type: string
    label_from_parameter: date_granularity
    sql:
          {% if date_granularity._parameter_value == 'month' %}
            ${dmt_closed_won_group_month}
          {% elsif date_granularity._parameter_value == 'quarter' %}
            CONCAT(${dmt_closed_won_group_year},"-",${dmt_closed_won_group_quarter_of_year})
          {% elsif date_granularity._parameter_value == 'year' %}
            LEFT(CAST(DATE_TRUNC(${dmt_closed_won_group_date},YEAR) AS STRING),4)
          {% else %}
            ${dmt_closed_won_group_year}
          {% endif %};;
  }

# dynamic filter for parametrized NRR:
  parameter: base_cohort { # filter the user can adapt in the UI
    label: "Base Cohort"
    type: date
    description: "Choose the latest customer signed month (happy call) you'd to include in the base cohort."
  }

  filter: cohort_filter { # make mandatory in explore
    hidden: yes
    sql:
      {% if base_cohort._parameter_value != null %}
        date_trunc(${dmt_closed_won_group_date}, month) <= date_trunc(date({% parameter base_cohort %}), month)
        and coalesce(date_trunc(${churned_date_group_date}, month), date_trunc(current_date(), month)) > date_trunc(date({% parameter base_cohort %}), month)
      {% else %}
        true
      {% endif %};;
  }

  # dimension: last_14d_dimension_nrr { ## not working for NRR / need to write history after computing NRR
  #   type: string
  #   sql: CASE
  #           WHEN DATE_DIFF(current_date(), ${dmt_closed_won_date}, DAY) <= 13 THEN "last 14d"
  #           WHEN DATE_DIFF(current_date(), ${dmt_closed_won_date}, DAY) <= 27 THEN "last 15-28d"
  #           END ;;
  # }

  parameter: exclude_flip_flow_sals_param {
    type: string
    allowed_value: {
      label: "All Deals"
      value: "all"
    }
    allowed_value: {
      label: "All deals except Flip Flow SALs"
      value: "no"
    }
    allowed_value: {
      label: "Only Flip Flow SALs"
      value: "yes"
    }
  }

  dimension: dynamic_join_condition {
    hidden: yes
    type: string
    # This SQL block contains all the logic.
    # Because it's inside the same view as the parameter, you do NOT need a scope/prefix.
    sql: {% if exclude_flip_flow_sals_param._parameter_value == 'all' %}
            (1=1)
         {% elsif exclude_flip_flow_sals_param._parameter_value == 'yes' %}
            (${TABLE}.exclude_flip_flow_sals)
         {% elsif exclude_flip_flow_sals_param._parameter_value == 'no' %}
            (NOT ${TABLE}.exclude_flip_flow_sals)
         {% else %}
            (1=1)
         {% endif %} ;;
  }

### ----- DEAL FLAG DIMENSIONS --------------------------------------------------------------------------------

  dimension: is_recurring {
    type: yesno
    sql: ${current_amount_euros} IS NOT NULL ;;
  }

  dimension: is_churned {
    type: yesno
    sql: ${churn_raw} IS NOT NULL ;;
    label: "Is churned (signed)"
    description: "Signed Perspective: indicates if the deal was cancelled by the customer (but mustn't be expired yet)."
  }

  dimension: is_churned_today {
    type: yesno
    sql: ${churn_raw} <= current_date() ;;
    label: "Is churned (today)"
    description: "Recognized Perspective: indicates if the deal (was cancelled and) is already expired as of today."
  }

  # Identifying downsells and deals corrections (important for NRR)
  dimension: negative_positive_amounts {
    type: string
    sql: CASE
          WHEN ${current_amount_euros} < 0 THEN "negative"
          WHEN ${current_amount_euros} > 0 THEN "positive"
          WHEN ${current_amount_euros} = 0 THEN "zero"
          ELSE NULL
          END   ;;
    # hidden: yes
  }

  dimension: is_lost_revenue {
    type: yesno
    description: "Indicates if the deal counts as lost revenue, i.e. is churned or is a downsell (negative TCV)"
  }

  dimension: deals_relevant_for_cs {
    type: yesno
    sql: (${deal_type} IN ("New Business","New Business EDEKA","Upsell","Upsell EDEKA", "Renewal") AND ${stage_label} = "Closed Won")
          OR (${deal_type} = "POV") ;;
  }

  dimension: deals_relevant_for_cs_nrr { # do we need to add "expansion flag" here?
    type: yesno
    sql:
        (${deal_type} IN ("New Business EDEKA","Upsell","Upsell EDEKA","POV", "Renewal") AND ${stage_label} = "Closed Won");;
  }

  dimension: is_sao {
    type: string
    sql: CASE WHEN ${dmt_sao_date} IS NOT NULL THEN "yes" ELSE "no" END ;;
    label: "Opp progressed to SAO"
  }

### ------ // END OF DEAL FLAG DIMENSIONS ------------------------------------------------------

### ----- ORDERING FOR SORTING DIMENSIONS ------------------------------------------------------------------
    #drilldowns should be sorted by measure not date that's why we need the date to be a string

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
          ELSE NULL END ;;
    label: "Deal Stages: current, numerated"
  }

  dimension: last_deal_stage_corrected {
    type: string
    sql: CASE
    WHEN ${last_deal_stage} = "Pre-Opportunity" THEN "3. Solution Design"
    WHEN ${last_deal_stage} = "Solution Design" THEN "3. Solution Design"
    WHEN ${last_deal_stage} = "SQL" THEN "2. SAO"
    WHEN ${last_deal_stage} = "SAO" THEN "2. SAO"
    WHEN ${last_deal_stage} = "Opportunity" THEN "4. Evaluation"
    WHEN ${last_deal_stage} = "Evaluation" THEN "4. Evaluation"
    WHEN ${last_deal_stage} = "Offer" THEN "5. Proposal"
    WHEN ${last_deal_stage} = "Discovery" THEN "0. Discovery"
    WHEN ${last_deal_stage} = "SAL" THEN "1. SAL"
    WHEN ${last_deal_stage} = "Proposal" THEN "5. Proposal"
    WHEN ${last_deal_stage} = "Negotiation" THEN "6. Negotiations"
    WHEN ${stage_label} = "Closed Lost" AND ${last_deal_stage} IS NULL AND ${dmt_closed_won_validation_date} IS NOT NULL THEN "7. Closed Won Validation"
    WHEN ${stage_label} = "Closed Lost" AND ${last_deal_stage} IS NULL AND ${dmt_negotiations_date} IS NOT NULL THEN "6. Negotiations"
    WHEN ${stage_label} = "Closed Lost" AND ${last_deal_stage} IS NULL AND ${dmt_proposal_date} IS NOT NULL THEN "5. Proposal"
    WHEN ${stage_label} = "Closed Lost" AND ${last_deal_stage} IS NULL AND ${dmt_evaluation_date} IS NOT NULL THEN "4. Evaluation"
    WHEN ${stage_label} = "Closed Lost" AND ${last_deal_stage} IS NULL AND ${dmt_solution_design_date} IS NOT NULL THEN "3. Solution Design"
    WHEN ${stage_label} = "Closed Lost" AND ${last_deal_stage} IS NULL AND ${dmt_sao_date} IS NOT NULL THEN "2. SAO"
    WHEN ${stage_label} = "Closed Lost" AND ${last_deal_stage} IS NULL AND ${dmt_sal_date} IS NOT NULL THEN "1. SAL"
    ELSE "Other" END ;;
    label: "Deal Stage: previous (corrected)"
  }

  dimension: company_name {
    type: string
    sql: ${company_name_groups} ;;
    label: "Company Name"
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/company/{{ company_id }}"
    }
  }

  dimension: created_at_date_drilldown {
    type: string
    sql: ${created_at_date} ;;
    label: "Created At Date"
    hidden: yes
  }

  dimension: close_date_drilldown {
    type: string
    sql: ${close_date} ;;
    label: "Close Date"
    # hidden: yes
  }

  dimension: contact_dmt_lead_drilldown {
    type: string
    sql: ${contact_dmt_lead_date} ;;
    label: "Contact DMT Lead"
    # hidden: yes
  }

  dimension: contact_dmt_mql_drilldown {
    type: string
    sql: ${contact_dmt_mql_date} ;;
    label: "Contact DMT MQL"
    # hidden: yes
  }

  dimension: contact_dmt_sql_drilldown {
    type: string
    sql: ${contact_dmt_sql_date} ;;
    label: "Contact DMT SQL"
    # hidden: yes
  }

  dimension: presales_1_pre_project_delivery_date_drilldown {
    type: string
    sql: ${presales_1_pre_project_delivery_date} ;;
    label: "PreSales 1. Pre-Project Delivery Date"
  }

  dimension: presales_2_discovery_delivery_date_drilldown {
    type: string
    sql: ${presales_2_discovery_delivery_date} ;;
    label: "PreSales 2. Discovery Delivery Date"
  }

  dimension: presales_3_demo_delivery_date_drilldown {
    type: string
    sql: ${presales_3_demo_delivery_date} ;;
    label: "PreSales 3. Demo Delivery Date"
  }

  dimension: presales_4_pov_delivery_date_drilldown {
    type: string
    sql: ${presales_4_pov_delivery_date} ;;
    label: "PreSales 4. POV Delivery Date"
  }

  dimension: presales_1__pre_project_won_yn {
    type: yesno
    sql: CASE WHEN ${presales_1__pre_project_won} = "true" THEN true ELSE false END  ;;
    label: "PreSales 1. Pre-Project is Won"

    }

  dimension: approx_number_of_employees {
    type: number
    sql: CASE WHEN ${number_of_employees} IS NOT NULL THEN ${number_of_employees}
              WHEN ${licences_count} IS NOT NULL THEN ${licences_count}
              WHEN left(${sub_segment}, 1) = 'b' THEN 1
              WHEN left(${sub_segment}, 1) = 'c' THEN 501
              WHEN left(${sub_segment}, 1) = 'd' THEN 1001
              WHEN left(${sub_segment}, 1) = 'e' THEN 3001
              WHEN left(${sub_segment}, 1) = 'f' THEN 10001
              ELSE 0 END ;;
    label: "Approximate Number of Employees"
    hidden:  yes
  }

  # -------------------------------------------------------------------------------------
  # start of conditional formating for AE hygiene factors

  dimension: next_step_date_corrected {
    type: string
    sql: IFNULL(CAST(${next_step_date} AS string),"-") ;;
    hidden: yes
  }

  dimension: next_step_date_formatted {
    type: string
    sql: CASE WHEN ${next_step_date} < CURRENT_DATE() THEN 2
              WHEN ${next_step_date} IS NULL THEN 1
              ELSE 0 END ;;
    label: "Next Step Date - formatted"
    html:
      {% if value  == 0 %}
      <p style="color: black">{{ next_step_date_corrected }}</p>
      {% elsif value == 1 %}
      <p style="color: white; background-color: #dc2650;">{{ next_step_date_corrected }}</p>
      {% else %}
      <p style="color: white; background-color: #dc2650;">{{ next_step_date_corrected }}</p>
      {% endif %}
      ;;
  }

  dimension: days_in_current_stage_formatted {
    type: string
    sql: CASE WHEN ${days_in_current_stage} > 15 AND ${deal_segment} = "1. Smart" AND ${stage_label} = "SAL" THEN 1
              WHEN ${days_in_current_stage} > 30 AND ${deal_segment} = "2. Enterprise" AND ${stage_label} = "SAL" THEN 1
              WHEN ${days_in_current_stage} > 30 AND ${deal_segment} = "4. Strategic" AND ${stage_label} = "SAL" THEN 1
              WHEN ${days_in_current_stage} > 15 AND ${deal_segment} = "1. Smart" AND ${stage_label} = "SAO" THEN 1
              WHEN ${days_in_current_stage} > 30 AND ${deal_segment} = "2. Enterprise" AND ${stage_label} = "SAO" THEN 1
              WHEN ${days_in_current_stage} > 45 AND ${deal_segment} = "4. Strategic" AND ${stage_label} = "SAO" THEN 1
              WHEN ${days_in_current_stage} > 15 AND ${deal_segment} = "1. Smart" AND ${stage_label} = "Solution Design" THEN 1
              WHEN ${days_in_current_stage} > 45 AND ${deal_segment} = "2. Enterprise" AND ${stage_label} = "Solution Design" THEN 1
              WHEN ${days_in_current_stage} > 75 AND ${deal_segment} = "4. Strategic" AND ${stage_label} = "Solution Design" THEN 1
              WHEN ${days_in_current_stage} > 10 AND ${deal_segment} = "1. Smart" AND ${stage_label} = "Evaluation" THEN 1
              WHEN ${days_in_current_stage} > 45 AND ${deal_segment} = "2. Enterprise" AND ${stage_label} = "Evaluation" THEN 1
              WHEN ${days_in_current_stage} > 60 AND ${deal_segment} = "4. Strategic" AND ${stage_label} = "Evaluation" THEN 1
              WHEN ${days_in_current_stage} > 2 AND ${deal_segment} = "1. Smart" AND ${stage_label} = "Proposal" THEN 1
              WHEN ${days_in_current_stage} > 7 AND ${deal_segment} = "2. Enterprise" AND ${stage_label} = "Proposal" THEN 1
              WHEN ${days_in_current_stage} > 10 AND ${deal_segment} = "4. Strategic" AND ${stage_label} = "Proposal" THEN 1
              WHEN ${days_in_current_stage} > 2 AND ${deal_segment} = "1. Smart" AND ${stage_label} = "Negotiation" THEN 1
              WHEN ${days_in_current_stage} > 30 AND ${deal_segment} = "2. Enterprise" AND ${stage_label} = "Negotiation" THEN 1
              WHEN ${days_in_current_stage} > 30 AND ${deal_segment} = "4. Strategic" AND ${stage_label} = "Negotiation" THEN 1
              ELSE 0 END ;;
    label: "Days in current stage - formatted"
    description: "If the Days in current Stage are above the benchmark, the field is highlighted in red. Benchmarks owned by Qazi "
    html:
      {% if value  == 0 %}
      <p style="color: black">{{ days_in_current_stage }}</p>
      {% elsif value == 1 %}
      <p style="color: white; background-color: #dc2650;">{{ days_in_current_stage }}</p>
      {% else %}
      <p style="color: black">{{ days_in_current_stage }}</p>
      {% endif %}
      ;;
  }

  dimension: next_step_corrected {
    type: string
    sql: IFNULL(CAST(${deal_next_step} AS string),"-") ;;
    hidden: yes
  }

  dimension: next_step_formatted {
    type: string
    sql: CASE WHEN ${deal_next_step} IS NOT NULL THEN 0
              WHEN ${deal_next_step} IS NULL THEN 1
              ELSE 1 END ;;
    label: "Next Step - formatted"
    html:
      {% if value  == 0 %}
      <p style="color: black">{{ next_step_corrected }}</p>
      {% elsif value == 1 %}
      <p style="color: white; background-color: #dc2650;">{{ next_step_corrected }}</p>
      {% else %}
      <p style="color: white; background-color: #dc2650;">{{ next_step_corrected }}</p>
      {% endif %}
      ;;
  }

  dimension: closed_date_formatted {
    type: string
    sql: CASE WHEN ${close_date} < CURRENT_DATE() THEN 2
              WHEN ${close_date} IS NULL THEN 1
              ELSE 0 END ;;
    label: "Close Date - formatted"
    html:
      {% if value  == 0 %}
      <p style="color: black">{{ close_date }}</p>
      {% elsif value == 1 %}
      <p style="color: white; background-color: #dc2650;">{{ close_date }}</p>
      {% else %}
      <p style="color: white; background-color: #dc2650;">{{ close_date }}</p>
      {% endif %}
      ;;
  }

  # end of conditional formating for AE hygiene factors
  # --------------------------------------------------------------------------------------

  dimension: dmt_sal_drilldown {
    type: string
    sql: ${dmt_sal_date} ;;
    label: "DMT SAL"
    hidden: yes
  }

  dimension: dmt_sao_drilldown {
    type: string
    sql: ${dmt_sao_date} ;;
    label: "DMT SAO"
    hidden: yes
  }

  dimension: dmt_solution_design_drilldown {
    type: string
    sql: ${dmt_solution_design_date} ;;
    label: "DMT Solution Design"
    hidden: yes
  }

  dimension: dmt_evaluation_drilldown {
    type: string
    sql: ${dmt_evaluation_date} ;;
    label: "DMT Evaluation"
    hidden: yes
  }

  dimension: dmt_proposal_drilldown {
    type: string
    sql: ${dmt_proposal_date} ;;
    label: "DMT Proposal"
    hidden: yes
  }

  dimension: dmt_negotiation_drilldown {
    type: string
    sql: ${dmt_negotiations_date} ;;
    label: "DMT Negotiation"
    hidden: yes
  }

  dimension: dmt_closing_validation_drilldown {
    type: string
    sql: ${dmt_closed_won_validation_date} ;;
    label: "DMT Closing Validation"
    hidden: yes
  }

  dimension: dmt_closed_won_drilldown {
    type: string
    sql: ${dmt_closed_won_date} ;;
    label: "DMT Closed Won"
    hidden: yes
  }

  dimension: dmt_closed_lost_drilldown {
    type: string
    sql: ${dmt_closed_lost_date} ;;
    label: "DMT Closed Lost"
    hidden: yes
  }

  dimension: expected_sd_date_drilldown {
    type: string
    sql: ${expected_sd_date} ;;
    label: "Expected SD Date"
    hidden: yes
  }

  dimension: date_left_sao_drilldown {
    type: string
    sql: ${date_left_sao_date} ;;
    label: "Date left SAO"
    hidden: yes
  }

  dimension: date_left_solution_design_drilldown {
    type: string
    sql: ${date_left_solution_design_date} ;;
    label: "Date left Solution Design"
    hidden: yes
  }

  dimension: date_left_evaluation_drilldown {
    type: string
    sql: ${date_left_evaluation_date} ;;
    label: "Date left Evaluation"
    hidden: yes
  }

  dimension: date_left_proposal_drilldown {
    type: string
    sql: ${date_left_proposal_date} ;;
    label: "Date left Proposal"
    hidden: yes
  }

  dimension: date_left_negotiation_drilldown {
    type: string
    sql: ${date_left_negotiation_date} ;;
    label: "Date left Negotiation"
    hidden: yes
  }

  dimension: deal_allocation {
    type: string
    description: "Combination of Segment, Sales Region and Business Stream to allocate deals. Used by Management since 01/2025."
  }

  dimension: deal_allocation_mix {
    type: string
    description: "Distinguishes between single and mixed allocation, currently `direct` vs `co-sell`. "
  }

  dimension: deal_segment { # HS property
    type: string
    label: "Segment"
  }

  dimension: contract_start_date_drilldown {
    type: string
    sql: ${contract_start_date} ;;
    label: "Customer Start Date"
    hidden: yes
  }

  dimension: next_step_date_drilldown {
    type: string
    sql: ${next_step_date} ;;
    label: "Next Step Date"
    # hidden: yes
  }

  dimension_group: current_date {
    type: time
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: CURRENT_DATE() ;;
    label: "Current Date"
  }

  dimension: lost_to_competitor_array {
    type: string
    sql:UNNEST(ARRAY_DISTINCT(SPLIT(REGEXP_REPLACE(${lost_to_competitor}, ';', ','), ','))) ;;
    label: "Lost to Competitor Array"
    # hidden: yes
  }

### ------ // END OF ORDERING FOR SORTING DIMENSIONS ----------------------------------------------------------------------

## ----- COHORT DIMENSIONS

  dimension: days_since_go_live_date {
    type: number
    #filter for newlogos?
    #oneoff alles raus
    hidden: yes
    sql: DATE_DIFF(${go_live_date}, current_date(), DAY) ;;
    #sql: DATE_DIFF(${go_live_date_date}, ${cs_customers_ext.go_live_raw}, DAY) ;;
  }

  dimension: months_since_go_live_floor {
    type: number
    sql: FLOOR(${days_since_go_live_date}/(30)) ;;
    label: "Months since GoLive"
    description: "Number of months since the Customer went live"
  }

## ----- // END OF COHORT DIMENSIONS

# ------ // END OF DIMENSIONS ---------------------------------------------------------------

# ------ MEASURES -------------------------------------------------------------------------------------------
    # unless stated differently, all deal volumes and revenue measures are EURO

## ------ COMPANY-WIDE DEAL MEASURES -------------------------------------------------------------------------------

### --- RAW COUNTS ------------------------------------------------------------------------------------------

  measure: count {
    type: count_distinct
    sql: ${deal_id} ;;
    label: "# Deals"
    drill_fields: [deal_name, deal_id, deal_id, deal_type,deal_segment, deal_allocation, deal_allocation_mix, funnel_stages_ordered, bdr_name, presales_name, ae_name, cs_name, current_amount_sum_euros, licences_sum]
  }

  # All Licences sum
  measure: licences_sum {
    type: sum
    sql: ${licences_count} ;;
    label: "# Licences Sold (Deal)"
    drill_fields: [deal_name, deal_id, deal_id, deal_type,deal_segment, deal_allocation, deal_allocation_mix, funnel_stages_ordered, bdr_name, ae_name, cs_name, current_amount_sum_euros, licences_sum]
    value_format: "[>=1000000]#0.000,,\" M\";[>=1000]#0.00,\" K\";0"
  }

# All Licences sum
  measure: licences_average {
    type: average
    sql: ${licences_count} ;;
    label: "# Licences Sold (Deal) avg"
    value_format: "[>1000000]#0.000,,\" M\";[>=1000]#0.00,\" K\";0"
    hidden: yes
  }

# All Licences sum
  measure: licences_upsell_sum {
    type: sum
    filters: [pipeline_label: "Upsell Pipeline"]
    sql: ${licences_count} ;;
    label: "# Licences (Upsell)"
    value_format: "[>=1000000]#0.000,,\" M\";[>=1000]#0.00,\" K\";0"
  }

### ----- // END OF RAW COUNTS ---------------------------------------------------------------------------------------

### --- FILTERED COUNTS ------------------------------------------------------------------------------------------

  measure: new_added_customers_count {
    type: count
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "New Business", negative_positive_amounts: "positive, zero"]
    label: "# Happy Calls New Business"
    drill_fields: [deal_name, deal_id, deal_id, ae_name, current_amount_sum_euros]
    description: "Including only New Logos"
  }

  # measure: customers_count {
  #   type: count_distinct
  #   sql: ${company_id} ;;
  #   filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "New Business", negative_positive_amounts: "positive, zero"]
  #   label: "AE # Customers"
  # }

  # Added Closed Won Upsells - It includes only the Upsell Pipeline
  measure: new_added_upsells_count {
    type: count
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "Upsell", negative_positive_amounts: "positive, zero"]
    label: "# Upsells - all time"
    drill_fields: [dmt_closed_won_drilldown, deal_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, current_amount_sum_euros]
    description: "Including only Closed Won Upsells"
  }

  measure: new_added_closed_won_count {
    type: count
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "New Business, Upsell", negative_positive_amounts: "positive, zero"]
    label: "# Closed Won Deals (all)"
    drill_fields: [dmt_closed_won_drilldown, deal_name, deal_type, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, deal_source_channel_cluster_hubspot, current_amount_sum_euros]
    description: "Including all Closed Won: New Logos + Upsells"
  }

  # Churned Deals
  measure: churned_deals_count {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "New Business", churn_date: "-NULL"]
    label: "# Churned Deals New Business"
    description: "Count of Churned Deals (including New Business (with Edeka) only)."
  }

  ### used in PreSales dashboard
  measure: deals_with_pre_sales_pre_project_count {
    type: count_distinct
    sql: ${deal_id} ;;
    label: "PreSales # Deals with 1. Pre-Project"
    filters: [presales_1_pre_project_delivery_date: "-NULL", presales_name: "-NULL"]
    drill_fields: [deal_name, deal_id, deal_type,deal_segment, deal_allocation, deal_allocation_mix, funnel_stages_ordered, bdr_name, presales_name, ae_name, presales_1_pre_project_status, presales_1_pre_project_delivery_date_drilldown, presales_1_pre_project_comment, close_date_drilldown, current_amount_sum_euros, licences_sum]
  }

  ### used in PreSales dashboard
  measure: deals_with_pre_sales_discovery_count {
    type: count_distinct
    sql: ${deal_id} ;;
    label: "PreSales # Deals with 2. Discovery"
    filters: [presales_2_discovery_delivery_date: "-NULL", presales_name: "-NULL"]
    drill_fields: [deal_name, deal_id, deal_type,deal_segment, deal_allocation, deal_allocation_mix, funnel_stages_ordered, bdr_name, presales_name, ae_name, presales_2_discovery_status, presales_2_discovery_delivery_date_drilldown, presales_2_discovery_comment, close_date_drilldown, current_amount_sum_euros, licences_sum]
  }

  ### used in PreSales dashboard
  measure: deals_with_pre_sales_demo_count {
    type: count_distinct
    sql: ${deal_id} ;;
    label: "PreSales # Deals with 3. Demo"
    filters: [presales_3_demo_delivery_date: "-NULL", presales_name: "-NULL"]
    drill_fields: [deal_name, deal_id, deal_type,deal_segment, deal_allocation, deal_allocation_mix, funnel_stages_ordered, bdr_name, presales_name, ae_name, presales_3_demo_status, presales_3_demo_delivery_date_drilldown, presales_3_demo_comment, close_date_drilldown, current_amount_sum_euros, licences_sum]
  }

  ### used in PreSales dashboard
  measure: deals_with_pre_sales_pov_count {
    type: count_distinct
    sql: ${deal_id} ;;
    label: "PreSales # Deals with 4. POV"
    filters: [presales_4_pov_delivery_date: "-NULL", presales_name: "-NULL"]
    drill_fields: [deal_name, deal_id, deal_type,deal_segment, deal_allocation, deal_allocation_mix, funnel_stages_ordered, bdr_name, presales_name, ae_name, presales_4_pov_delivery_date_drilldown, close_date_drilldown, current_amount_sum_euros, licences_sum]
  }

  measure: days_from_preproject_pitch_to_won_avg {
    sql: DATE_DIFF(${presales_1__pre_project_won_date},${presales_1__pre_project_pitched_date},DAY) ;;
    type: average
    value_format_name: decimal_1
    label: "Presales avg. days PP pitch to won"
  }

  measure: preproject_duration_avg {
    sql: DATE_DIFF(${dmt_solution_design_date},${presales_1__pre_project_won_date},DAY) ;;
    type: average
    value_format_name: decimal_1
    label: "Presales avg. PP duration"
    description: "Days from PP won date to dmt_solution_design"
  }

### ----- // END OF FILTERED COUNTS ---------------------------------------------------------------------------------------

### ----- DEAL VALUE & REVENUE MEASURES ------------------------------------------------------------------------------

#### --- RAW: deal volume, contract values

  # measure: initial_amount_sao_euros {
  #   type: sum
  #   sql:  ${initial_sao_amount_euros};;
  #   value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  #   label: "€ Deal Volume - at SAO (standardized)"
  #   description: "Standardized Deal value. Computation: sum"
  # }

  # measure: initial_amount_solution_design_euros {
  #   type: sum
  #   sql:  ${initial_solution_design_amount_euros};;
  #   value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  #   label: "€ Deal Volume - at Solution Design"
  #   description: "Takes the actual value if provided - else using standardized deal size."
  # }

  # measure: initial_amount_evaluation_euros {
  #   type: sum
  #   sql:  ${initial_evaluation_amount_euros};;
  #   value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  #   label: "€ Deal Volume - at Evaluation"
  #   description: "Takes the actual value if provided - else using standardized deal size."
  # }

  # measure: initial_amount_proposal_euros {
  #   type: sum
  #   sql:  ${initial_proposal_amount_euros};;
  #   value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  #   label: "€ Deal Volume - at Proposal"
  #   description: "Takes the actual value (must be provided). No standardized deal sizes in Proposal and later stages."
  # }

  # measure: initial_amount_negotiation_euros {
  #   type: sum
  #   sql:  ${initial_negotiations_amount_euros};;
  #   value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  #   label: "€ Deal Volume - at Negotiation"
  #   description: "Takes the actual value (must be provided). No standardized deal sizes in Proposal and later stages."
  # }

  # measure: initial_amount_closing_validation_euros {
  #   type: sum
  #   sql:  ${initial_closing_validation_amount_euros};;
  #   value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  #   label: "€ Deal Volume - at Closing Validation"
  #   description: "Takes the actual value (must be provided). No standardized deal sizes in Proposal and later stages."
  # }

  measure: current_amount_sum_euros {
    type: sum
    sql:  ${current_amount_euros};;
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    drill_fields: [deal_name, deal_id, deal_source_channel_cluster_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, number_of_employees, stage_label, bdr_name, presales_name, deal_owner_name, ae_name, dmt_sao_drilldown, expected_sd_date_drilldown, close_date_drilldown, current_amount_sum_euros]
    label: "€ Deal Volume: Current Value (sum)"
  }

  measure: current_amount_sum_distinct_euros {
    type: sum_distinct
    sql_distinct_key: ${deal_id} ;;
    sql:  ${current_amount_euros};;
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    drill_fields: [deal_name, deal_id, deal_source_channel_cluster_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, number_of_employees, stage_label, bdr_name, presales_name, deal_owner_name, ae_name, dmt_sao_drilldown, expected_sd_date_drilldown, close_date_drilldown, current_amount_sum_euros]
    label: "€ Deal Volume: Current Value (sum dist.)"
  }

  measure: current_amount_avg_euros {
    type: average
    sql:  ${current_amount_euros};;
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    drill_fields: [deal_name, deal_id, deal_source_channel_cluster_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, number_of_employees, stage_label, bdr_name, presales_name, deal_owner_name, dmt_sao_drilldown, close_date_drilldown, current_amount_sum_euros]
    label: "€ Avg ARR - *Current Value"
  }

  # Total OTR
  measure: one_off_total_amount_sum_euros {
    type: sum
    sql:  ${one_off_total_amount};;
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ Total one-time Amount"
    description: "Total one-off Revenue Deal Amount (one-off + setup cost), no filters applied."
  }

  # Setup Cost
  measure: setup_amount_sum_euros {
    type: sum
    sql:  ${setup_amount};;
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ Setup Cost"
    description: "Setup Cost Deal Amount, no filters applied."
  }

  # One-Off Revenue
  measure: one_off_deal_amount_sum_euros {
    type: sum
    sql:  ${one_off_deal_amount};;
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ One-time Amount"
    description: "One-Off Deal Amount, no filters applied."
  }

  # Total Contract Value TCV
  measure: total_contract_value_sum_euros {
    type: sum
    sql: ${total_contract_value_euros} ;;
    label: "€ TCV"
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    description: "Total Contract Value: Total revenue that the deal will generate over it's lifetime [ARR * contract-length (y) + one-off-cost + setup-cost]"
  }

  measure: total_contract_value_avg_euros{
    type: average
    sql: ${total_contract_value_euros} ;;
    label: "€ ACV"
    drill_fields: [deal_name, deal_id,deal_segment, deal_allocation, deal_allocation_mix, deal_owner_name, dmt_sao_drilldown, dmt_closed_won_drilldown, contract_term_in_months, total_contract_value_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    description: "Average TCV (total contract value during lifetime)."
  }

  # Total Recurring Contract Value TRCV
  measure: total_recurring_contract_value_sum_euros {
    type: sum
    sql: ${current_amount_euros} * ${contract_term_in_months}/12;;
    label: "Recurring Contract Value RCV € (raw)"
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    description: "Total recurring revenue that the deal will generate over it's lifetime [ARR * contract-length (y)]"
  }

  measure: standardized_deal_size_value_euros_sum {
    type: sum
    sql: ${standardised_deal_value_euros} ;;
    label: "€ Standardized Deal Size"
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    description: "Standardized Deal Sizes for SAOs: 50k ENT, 222k STR."
  }

#### ----- // END OF RAW: deal amounts, contract values --------------------------------------------------------------------------------------

#### ----- FILTERED: revenue KPIs
      # all filters must be indicated in the description

##### ----- FILTERED: One-Time Revenue ------------------------------------------------------------------------

  # Net OTR
  measure: net_one_time_revenue_sum_euros {
    type: sum
    sql:  ${one_off_total_amount};;
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "New Business, Upsell"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ Net OTR (signed)"
    description: "Net OTR (one-off + setup cost) for all won deals (happy calls of AE, Edeka & Upsell Pipeline). POVS not included. Negative amounts may stem from downsell deals."
  } #add povs here?

  # Total Added OTR
  measure: added_one_time_revenue_sum_euros {
    type: sum
    sql:  ${one_off_total_amount};;
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "New Business, Upsell", negative_positive_amounts: "posivite, zero"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ Added OTR (signed)"
    description: "Added OTR (one-off + setup cost) for all won deals (happy calls of AE, Edeka & Upsell Pipeline) with positive amounts (excluding downsells)."
  }

  # Total Lost OTR
  measure: lost_one_time_revenue_sum_euros {
    type: sum
    sql:  ${one_off_total_amount};;
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "New Business, Upsell", negative_positive_amounts: "negative"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ Lost OTR (signed)"
    description: "Lost OTR (one-off + setup cost) for all won deals (happy calls of AE, Edeka & Upsell Pipeline) with negative amounts (downsells)."
  }

  ##### ----- // END OF FILTERED: One-Time Revenue ----------------------------------------------------------------------

  ##### ----- FILTERED: Recurring Revenue ------------------------------------------------------------------------------------

  measure: open_pipe_volume_euros_sum { ## logic in datamart code
    type: sum
    sql: ${open_pipe_volume_euros} ;;
    label: "€ Open Pipe Volume"
    description: "Open Pipeline Volume depending on deal stage (SAL: 0, SAO: standarised amount, >SAO: current deal amount)."
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  # Net ARR
  measure: net_arr_sum_euros {
    type: number
    #sql:  ${current_amount};;
    sql: ${signed_arr_sum_euros} + ${lost_arr_sum_euros} ;;
    #no filters needed as both added and lost arr are filtered already
    label: "€ Net ARR (signed)"
    description: "Net ARR including all won deals (happy calls of AE, Edeka & Upsell Pipeline) with positive amount (new logo, upsell) and negative amount (churn, downsell)."
    drill_fields: [company_name_groups, company_owner, net_arr_sum_euros, signed_arr_upsells_sum_euros, new_added_upsells_count]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: signed_arr_sum_euros {
    type: sum
    sql:  IFNULL(${current_amount_euros},0);;
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "New Business, Upsell", negative_positive_amounts: "positive, zero", deal_id: "-2457706877"]
    label: "€ Signed ARR"
    description: "Total Signed ARR including all closed won New Business & Upsell deals."
    drill_fields: [dmt_closed_won_drilldown, deal_name, deal_type, bdr_name, ae_name, cs_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, deal_source_channel_cluster_hubspot, signed_arr_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    #value_format_name: eur_0
  }

  measure: signed_arr_avg_euros {
    type: average
    sql:  IFNULL(${current_amount_euros},0);;
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "New Business, Upsell", negative_positive_amounts: "positive, zero"]
    label: "€ Signed ARR (avg)"
    description: "Total Signed ARR including all closed won New Business & Upsell deals."
    drill_fields: [dmt_closed_won_drilldown, deal_name, deal_type, deal_owner_name, cs_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, dmt_sao_drilldown, signed_arr_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: signed_arr_upsells_sum_euros {
    type: sum
    sql:  IFNULL(${current_amount_euros},0);;
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "Upsell", negative_positive_amounts: "positive"]
    label: "€ Signed ARR Upsell"
    description: "Upsell Signed ARR including all closed won Upsell deals (licence expansion + feature upsells)."
    drill_fields: [dmt_closed_won_drilldown, deal_name, deal_type, deal_owner_name, cs_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, signed_arr_upsells_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: signed_arr_new_logos_sum_euros {
    type: sum
    sql:  ${current_amount_euros};;
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "New Business", negative_positive_amounts: "positive, zero"]
    label: "€ Signed ARR New Business"
    description: "New Business Signed ARR including all closed won New Business deals."
    drill_fields: [dmt_closed_won_drilldown, deal_name, deal_type, deal_owner_name, cs_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, signed_arr_new_logos_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  # Expansion ARR €
  measure: expansion_arr_sum_euros {
    type: sum
    sql:  ${current_amount_euros};;
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "Upsell", negative_positive_amounts: "positive, zero", licences_count: "-0, NOT NULL"]
    label: "€ Signed ARR Lic. Expansion"
    description: "License Expansion ARR including all closed won expansion deals with positive amount (one part of total upsell ARR)."
    drill_fields: [dmt_closed_won_drilldown, deal_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  # Feature Upsell ARR €
  measure: upsell_arr_sum_euros {
    type: sum
    sql:  ${current_amount_euros};;
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "Upsell", negative_positive_amounts: "positive, zero", licences_count: "0,NULL"]
    label: "€ Signed ARR Feature Upsell"
    description: "Feature Upsell ARR including all closed won feature upsell deals with positive amount."
    drill_fields: [dmt_closed_won_drilldown, deal_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  measure: lost_arr_sum_euros {
    type: sum
    #sql:  ${current_amount};;
    sql: CASE WHEN ${current_amount_euros} < 0 THEN ${current_amount_euros} ELSE ${current_amount_euros}*(-1) END ;;
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "New Business, Upsell", is_lost_revenue: "Yes"]
    label: "€ Signed ARR Lost"
    description: "Lost ARR including all won deals (happy calls of AE, Edeka & Upsell Pipeline) with negative amount (downsell) and churned deals (churn date known) with positive amount (new logo, upsell). Only works without date dimension as downsells and churn have different dates (dmt closed won vs dmt churned)."
    drill_fields: [dmt_closed_won_drilldown, deal_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, current_amount_sum_euros]
    #value_format: "[>-1000]€#0.00;[<=-1000]€#0.00,\" K\";[<=-1000000]€#0.000,,\" M\;"
    value_format_name: eur_0
  }

  # Downsell ARR €
  measure: downsell_arr_sum_euros {
    type: sum
    sql:  ${current_amount_euros};;
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "Upsell", negative_positive_amounts: "negative"]
    label: "€ Signed ARR Downsell"
    description: "Downsell ARR including all (happy calls Upsell Pipeline) deals with negative amount (downsell)."
    #drill_fields: [dmt_happy_call_date_drilldown, deal_name, ae_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, current_amount_sum, days_from_sql_to_happy_call_avg]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format_name: eur_0
  }

  # Churned ARR €
  measure: churned_arr_sum_euros {
    type: sum
    sql:  ${current_amount_euros}*(-1);;
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "New Business, Upsell", churn_date: "-NULL"]
    label: "€ Signed ARR Churned"
    description: "Churned ARR including all churned (churn date known) deals (happy calls of AE, Edeka & Upsell Pipeline)."
    value_format_name: eur_0
  }

# Added ARR Potential in Commit
  measure: commit_arr_sum_euros {
    type: sum
    sql:  ${current_amount_euros};;
    filters: [close_date: "-NULL", forecast_category: "commit", new_business_vs_upsell: "New Business, Upsell"]
    label: "€ Committed ARR"
    drill_fields: [close_date_drilldown, deal_name, forecast_category, deal_next_step, next_step_date_drilldown, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

# Added ARR Potential in Best Case
  measure: best_case_arr_sum_euros {
    type: sum
    sql:  ${current_amount_euros};;
    filters: [close_date: "-NULL", forecast_category: "best case", new_business_vs_upsell: "New Business, Upsell"]
    label: "€ Best Case ARR"
    drill_fields: [close_date_drilldown, deal_name, forecast_category, deal_next_step, next_step_date_drilldown, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, current_amount_sum_euros]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

# Added ARR Potential in all forecast categories
  measure: closing_arr_sum_euros {
    type: sum
    sql:  ${current_amount_euros};;
    filters: [close_date: "-NULL", dmt_sao_date: "-NULL", stage_label: "-Closed Lost, -SAL, -LTO", forecast_category: "best case, commit, pipeline", new_business_vs_upsell: "New Business, Upsell"]
    label: "€ Forecasted Opp. Volume (unweighted)"
    drill_fields: [close_date_drilldown, deal_name, deal_type, deal_allocation, forecast_category, stage_label, deal_stage_probability, deal_next_step, next_step_date_drilldown, deal_owner_name, current_amount_sum_euros]
    # value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format: "€#,##0"
    description: "Simple sum of the € Deal Volume of the Opportunities (New Business & Upsells) that are forecasted as Pipeline, Best Case or Commit and reported to close within the selected date range"
  }

# Added ARR Potential in all forecast categories
  measure: closing_arr_weighted_sum_euros {
    type: sum
    sql:  ${current_amount_euros}*${deal_stage_probability};;
    filters: [close_date: "-NULL", dmt_sao_date: "-NULL", stage_label: "-Closed Lost, -SAL, -LTO", forecast_category: "best case, commit, pipeline", new_business_vs_upsell: "New Business, Upsell"]
    label: "€ Forecasted Opp. Volume (weighted)"
    drill_fields: [close_date_drilldown, deal_name, deal_type, forecast_category, stage_label, deal_stage_probability, deal_next_step, next_step_date_drilldown, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, current_amount_sum_euros]
    # value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format: "€#,##0"
    description: "Weighted sum of the € Deal Volume of the Opportunities (New Business & Upsells) that are forecasted as Pipeline, Best Case or Commit and reported to close within the selected date range - weight is varying from stage to stage in the Sales Pipeline and can be found in the HubSpot UI"
  }

# Count of Opportunities in all forecast categories
  measure: closing_opportunities_count {
    type: count
    filters: [close_date: "-NULL", dmt_sao_date: "-NULL", stage_label: "-Closed Lost, -SAL, -LTO", forecast_category: "best case, commit, pipeline, not forecasted", new_business_vs_upsell: "New Business, Upsell"]
    label: "# Closing Opportunities"
    drill_fields: [close_date_drilldown, deal_name, deal_type, forecast_category, stage_label, deal_next_step, next_step_date_drilldown, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, current_amount_sum_euros]
  }

  measure: price_per_user_avg_euros {
    type: average
    sql:  IFNULL(${current_amount_euros},0)/${licences_count}/12;;
    filters: [dmt_closed_won_date: "-NULL", new_business_vs_upsell: "New Business, Upsell", negative_positive_amounts: "positive, zero", deal_id: "-2457706877"]
    label: "€ APU / month"
    description: "€ Avg Price per User for all closed won New Business & Upsell deals."
    drill_fields: [dmt_closed_won_drilldown, deal_name, deal_type, deal_owner_name, cs_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, deal_source_channel_cluster_hubspot, signed_arr_sum_euros, price_per_user_avg_euros, licences_count]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

##### ----- // END OF FILTERED: Recurring Revenue ------------------------------------------------------------------------------------

#### ----- // END OF FILTERED: revenue KPIs -------------------------------------------------------------------------------------------

#### ----- FILTERED: Net Retention ----------------------------------------------------------------------------------------------------
# --> parametrized on a monthly basis

# NRR parametrized (monthly): BASE revenue
  measure: nrr_params_base_euros {
    type: sum
    sql:
        CASE

        -- only closed won deals:
        WHEN stage_label = "Closed Won"

        -- include all regular-ARR deals:
        AND ${new_business_vs_upsell} IN ("New Business", "Upsell")

        -- Customer Group is part of Cohort:
        AND date_trunc(${dmt_closed_won_group_date}, month) <= date_trunc(date({% parameter base_cohort %}), month)

        -- Customer is not churned before Cohort:
        AND coalesce(date_trunc(${churned_date_customer_date}, month), date_trunc(current_date(), month)) > date_trunc(date({% parameter base_cohort %}), month)

        -- Deal is not churned before Cohort:
        AND coalesce(date_trunc(${churn_date}, month), date_trunc(current_date(), month)) > date_trunc(date({% parameter base_cohort %}), month)

        -- All Deals Closed Won before Cohort:
        AND date_trunc(${dmt_closed_won_date}, month) <= coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01')

        THEN ${current_amount_euros} END ;;

    #value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format_name: eur_0
    label: "€ NR Base ARR"
    drill_fields: [deal_id, deal_name, deal_type, company_id, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
    description: "ARR made with all customers signed before [Base Cohort month]. Includes all Deals closed won before [Base Cohort month]) in EUR. This is the base value (100%) to compute the NRR."
  }

  # NRR parametrized (monthly): all ARR deals of Cohort customers churned in current period
  measure: nrr_params_churned_revenue_euros {
    type: sum
    sql:
      CASE

        -- only closed won deals:
        WHEN stage_label = "Closed Won"

        -- all regular-ARR deals:
        AND  ${deal_type} IN ("New Business", "New Business EDEKA", "Upsell", "Upsell EDEKA")

        -- Customer Group is part of Cohort:
        AND date_trunc(${dmt_closed_won_group_date}, month) <= date_trunc(date({% parameter base_cohort %}), month)

        -- Customer is not churned before Cohort:
        AND (date_trunc(${churned_date_customer_date}, month) IS NULL
          OR coalesce(date_trunc(${churned_date_customer_date}, month), date_trunc(current_date(), month)) > date_trunc(date({% parameter base_cohort %}), month))

        -- Deal churns in current period:
        AND date_trunc(${churn_date}, month) BETWEEN coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') + (EXTRACT(day FROM LAST_DAY(date(timestamp_trunc({% parameter base_cohort %}, month)))))
          AND (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365)

        THEN ${current_amount_euros} END ;;

    #value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format_name: eur_0
    label: "€ NR Churned ARR"
    description: "Churned ARR from customers signed before [Base Cohort month]. Includes all Deals with Churn Date in the 12 months after [Base Cohort month]."
    drill_fields: [deal_id, deal_name, deal_type, company_id, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
  }

  # NRR parametrized (monthly): Net Revenue of current period (upsells & downsells)
  measure: nrr_params_expansion_downsell_euros {
    type: sum
    sql:
      CASE
        -- #1 Upsell Deals for non-Edeka:
          -- Deal must be closed won:
        WHEN stage_label = "Closed Won"
          -- only regular Upsell Deals (non-Edeka):
        AND ${deal_type} IN ("Upsell")
          -- Customer Group part of Cohort:
        AND date_trunc(${dmt_closed_won_group_date}, month) <= date_trunc(date({% parameter base_cohort %}), month)
          -- Deal not churned in 12m after cohort:
        AND (date_trunc(${churn_date}, month) IS NULL
              OR date_trunc(${churn_date}, month) > (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365))
          -- Deal closed in 12m after Cohort:
        AND date_trunc(${dmt_closed_won_date}, month)
          BETWEEN coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') + (EXTRACT(day FROM LAST_DAY(date(timestamp_trunc({% parameter base_cohort %}, month)))))
          AND (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365)
          THEN ${current_amount_euros}

        --
          -- Deal must be closed won:
        WHEN stage_label = "Closed Won"
          -- Edeka Upsell Deals only:
        AND ${deal_type} IN ("Upsell EDEKA")
          -- Edeka Store must be part of Base Cohort to be part of regular Upsell revenue:
        AND date_trunc(${dmt_closed_won_customer_date}, month) <= date_trunc(date({% parameter base_cohort %}), month)
        AND (date_trunc(${churned_date_customer_date}, month) IS NULL
          OR coalesce(date_trunc(${churned_date_customer_date}, month), date_trunc(current_date(), month)) > date_trunc(date({% parameter base_cohort %}), month))
          -- Deal not churned in 12m after cohort:
        AND (date_trunc(${churn_date}, month) IS NULL
              OR date_trunc(${churn_date}, month) > (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365))
          -- Deal closed in 12m after Cohort:
        AND date_trunc(${dmt_closed_won_date}, month)
        BETWEEN coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') + (EXTRACT(day FROM LAST_DAY(date(timestamp_trunc({% parameter base_cohort %}, month)))))
        AND (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365)

          THEN ${current_amount_euros}

        --
          -- Deal must be closed won:
        WHEN stage_label = "Closed Won"
          -- only flagged expansion deals (new logo (non-Edeka) only):
        AND ${deal_type} = "New Business"
        AND ${expansion_deal} IS true

          -- Deal not churned in 12m after cohort:
        AND (date_trunc(${churn_date}, month) IS NULL
              OR date_trunc(${churn_date}, month) > (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365))

          -- Deal closed in curent period:
        AND date_trunc(${dmt_closed_won_date}, month)
        BETWEEN coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') + (EXTRACT(day FROM LAST_DAY(date(timestamp_trunc({% parameter base_cohort %}, month)))))
        AND (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365)

          THEN ${current_amount_euros}

        END ;;
    #value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format_name: eur_0
    label: "€ NR Net Expansion ARR"
    description: "Expansion/Upsell/Downsell ARR from customers signed before [Base Cohort month]. Includes all Upsell Pipeline Deals closed won in the 12 months after [Base Cohort month]."
    drill_fields: [deal_id, deal_name, deal_type, company_id, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
  }

 # new logo Edekas are considered Upsell revenue:
  measure: nrr_params_expansion_edeka_euros {
    type: sum
    sql:
      CASE
        -- Deal must be closed won:
        WHEN stage_label = "Closed Won"
        -- Edeka New Logo Deals only:
        AND ${deal_type} = "New Business EDEKA"

        -- Edeka Group is part of Cohort:
        AND date_trunc(${dmt_closed_won_group_date}, month) <= date_trunc(date({% parameter base_cohort %}), month)
        -- not needed:
        -- and coalesce(date_trunc(${churned_date_group_date}, month), date_trunc(current_date(), month)) > date_trunc(date({% parameter base_cohort %}), month))
        -- Deal not churned in 12m after cohort:
        AND (date_trunc(${churn_date}, month) IS NULL
              OR date_trunc(${churn_date}, month) > (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365))
        -- Deal closed in 12m after cohort:
        and date_trunc(${dmt_closed_won_date}, month)
        BETWEEN coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') + (EXTRACT(day FROM LAST_DAY(date(timestamp_trunc({% parameter base_cohort %}, month)))))
        AND (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365)
          THEN ${current_amount_euros} END ;;
    label: "€ NR Edeka New Logo ARR"
    #value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format_name: eur_0
    description: "ARR generated through adding new Edeka Stores is considered Upsell Revenue (NRR is computed on customer group level). Includes all Edeka Pipeline Deals closed won in the 12 months after [Base Cohort month]."
    drill_fields: [deal_id, deal_name, company_id, deal_type, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
  }

# GRR parametrized (monthly): Net Revenue of current period (downsells only)
  measure: grr_params_downsell_euros {
    type: sum
    sql:
      case
        WHEN (date_trunc(${dmt_closed_won_group_date}, month) <= date_trunc(date({% parameter base_cohort %}), month)
        and coalesce(date_trunc(${churned_date_group_date}, month), date_trunc(current_date(), month)) > date_trunc(date({% parameter base_cohort %}), month))
        and date_trunc(${dmt_closed_won_date}, month)
        BETWEEN coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') + (EXTRACT(day FROM LAST_DAY(date(timestamp_trunc({% parameter base_cohort %}, month)))))
        AND (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365)
        AND ${stage_label} = "Closed Won"
        AND ${negative_positive_amounts} = "negative"
        AND ${deal_type} IN ("Upsell", "Upsell EDEKA")
        then ${current_amount_euros}
      end ;;
    #value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format_name: eur_0
    label: "€ GR Downsell ARR"
    description: "Downsell ARR from customers signed before [Base Cohort month]. Includes all Upsell Pipeline Deals with negative value closed won in the 12 months after [Base Cohort month]."
    drill_fields: [deal_id, deal_name, deal_type, company_id, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
  }

  measure: grr_params_euro {
    type: number
    sql: ${nrr_params_base_euros}-${nrr_params_churned_revenue_euros} - ${grr_params_downsell_euros} ;;
    label: "€ GRR"
    description: "Gross Retention in EUR: indicates how much of the base revenue for the Customer cohort joined before [Base Cohort month] we manage to retain in the following 12 months.
    Computation: Base ARR - Downsell ARR - churned ARR"
    #value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format_name: eur_0
    drill_fields: [deal_id, deal_name, deal_type, company_id, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
  }

  measure: grr_params_percent {
    type: number
    sql: ${grr_params_euro}/NULLIF(${nrr_params_base_euros},0) ;;
    value_format_name: percent_2
    drill_fields: [deal_id, deal_name, deal_type, company_id, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
    label: "% GRR"
    description: "Gross Retention Rate %: Percentage of Net Revenue retained with all customers joined before [Base Cohort month] in the 12 months after [Base Cohort month]
    compared to the Base Revenue (ARR made with the same customers before [Base Cohort month]). Computation: (Base ARR - Downsell ARR - churned ARR) / Base ARR"
  }

  measure: nrr_params_euro {
    type: number
    sql: ${nrr_params_base_euros}+${nrr_params_expansion_downsell_euros}-${nrr_params_churned_revenue_euros}+${nrr_params_expansion_edeka_euros} ;;
    label: "€ NRR"
    description: "Net Retention in EUR: Net Revenue made with all customers joined before [Base Cohort month] in the 12 months after [Base Cohort month].
    Computation: Base ARR + Expansion/Downsell ARR - churned ARR + Edeka Expansion ARR."
    #value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format_name: eur_0
    drill_fields: [deal_id, deal_name, deal_type, company_id, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
  }

  measure: nrr_params_percent {
    type:  number
    sql: ${nrr_params_euro}/NULLIF(${nrr_params_base_euros},0);;
    value_format_name: percent_2
    drill_fields: [deal_id, deal_name, deal_type, company_id, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
    label: "% NRR"
    description: "Net Retention Rate %: Percentage of Net Revenue made with all customers joined before [Base Cohort month] in the 12 months after [Base Cohort month]
    compared to the Base Revenue (ARR made with the same customers before [Base Cohort month]). Computation: (Base ARR + Expansion/Downsell ARR - churned ARR + Edeka Expansion ARR) / Base ARR."
  }

### ----- CS-SPECIFIC NRR MEASURES ------------------------------------------------------------

#-------------
  # NRR ext: includes Upsells from Customers in the 12 months after the base cohort
  # measure: nrr_ext_params_expansion_downsell_euros {
  #   type: sum
  #   sql:
  #       CASE

  #       -- Upsell Deals for non-Edeka:
  #       WHEN ${deal_type} IN ("Upsell")

  #       -- Customer Group part of Cohort:
  #       --- closed won before Cohort:
  #       AND date_trunc(${dmt_closed_won_group_date}, month) <= date_trunc(date({% parameter base_cohort %}), month)
  #       --- not churned before Cohort:
  #       AND coalesce(date_trunc(${churned_date_group_date}, month), date_trunc(current_date(), month)) > date_trunc(date({% parameter base_cohort %}), month)

  #       -- Deal closed in 12m after Cohort:
  #       AND date_trunc(${dmt_closed_won_date}, month)
  #       BETWEEN coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') + (EXTRACT(day FROM LAST_DAY(date(timestamp_trunc({% parameter base_cohort %}, month)))))
  #       AND (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365)

  #       -- Deal must be closed won:
  #       AND stage_label = "Closed Won"

  #       AND ${deal_id} NOT IN ("11316066631", "11316007797", "10684559926", "8410408752")
  #         THEN ${current_amount_euros}

  #       --  expansion deal logic:
  #       WHEN ${expansion_deal} IS true
  #       AND ${deal_type} = "New Business"
  #       AND stage_label = "Closed Won"
  #       AND date_trunc(${dmt_closed_won_date}, month)
  #       BETWEEN coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') + (EXTRACT(day FROM LAST_DAY(date(timestamp_trunc({% parameter base_cohort %}, month)))))
  #       AND (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365)
  #       THEN ${current_amount_euros} END ;;

  #   #value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  #   value_format_name: eur_0
  #   label: "NR ext OLD! Expansion/Downsell incl. New Logo Upsells €"
  #   description: "Expansion/Upsell/Downsell ARR from new logos signed in the 12 months after [Base Cohort month].
  #   Includes all Upsell Pipeline Deals closed won in the 12 months after [Base Cohort month]. Used for extented Net Retention only."
  #   drill_fields: [deal_id, deal_name, company_id, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
  # }
#----------
# -- All Upsells of Customers who joined after the cohort but happened in current period:
  measure: nrr_ext_params_upsell_new_logo_euros {
    type: sum
    sql:
      CASE
        -- Deal must be closed won:
        WHEN stage_label = "Closed Won"
        -- Upsell deals that are not expansion only:
        AND ${deal_type} IN ("Upsell", "Upsell EDEKA")
        AND ${expansion_deal} IS NOT true

        -- Customer was closed within current period:
        AND date_trunc(${dmt_closed_won_customer_date}, month) BETWEEN coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01')
        + (EXTRACT(day FROM LAST_DAY(date(timestamp_trunc({% parameter base_cohort %}, month)))))
        AND (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365)
        -- Deal hasn't churned in current period:
        AND (date_trunc(${churn_date}, month) IS NULL
              OR date_trunc(${churn_date}, month) > (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365))
        -- Deal closed in current period:
        AND date_trunc(${dmt_closed_won_date}, month)
        BETWEEN coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') + (EXTRACT(day FROM LAST_DAY(date(timestamp_trunc({% parameter base_cohort %}, month)))))
        AND (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365)
          THEN ${current_amount_euros} END ;;

    #value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format_name: eur_0
    label: "€ NR ext New Logo Upsell ARR"
    description: "Expansion/Upsell/Downsell ARR from new logos signed in the 12 months after [Base Cohort month].
    Includes all Upsell Pipeline Deals closed won in the 12 months after [Base Cohort month]. Used for extented Net Retention only."
    drill_fields: [deal_id, deal_name, company_id, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
  }

  # Amount of won pilot/POV deals
  measure: nrr_ext_params_pilot_values_euros {
    type: sum
    sql:
    CASE
      -- only closed won deals:
      WHEN stage_label = "Closed Won"
      -- only POV Deals:
      AND ${deal_type} IN ("POV", "Pilot") -- both (Kristina 9.11.23)
      -- no expansions (avoid double counting):
      AND ${customer_is_pov_conversion_no_expansion} IS true

      -- Customer was closed within current period:
      AND (date_trunc(${dmt_closed_won_customer_date}, month) BETWEEN coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01')
      + (EXTRACT(day FROM LAST_DAY(date(timestamp_trunc({% parameter base_cohort %}, month)))))
       AND (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365))
      -- deal closed date - not relevant bc happens before new logo anyways
      THEN ${one_off_total_amount} END ;; # povs don't have recurring amount
    #filters: [deal_id: "6895693685, 5466458162, 8000715882"]
    label: "NR ext won Pilots"
    description: "Auxiliary measure to compute the Pilot Conversions for NRR extended: Value of won POV deals. Used for extented Net Retention only."
    drill_fields: [deal_id, deal_name, company_id, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
    #value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format_name: eur_0
    }

  # new logos that resulted from a PoV Conversion and are not Expansion (Expansion > PoV Conversion)
  measure: nrr_ext_params_pilot_newlogo_euros {
    type: sum
    sql:
      CASE
      -- only closed won deals:
      WHEN stage_label = "Closed Won"

      -- only new logo deals (non-Edeka):
      AND ${deal_type} = "New Business"
      -- deal cannot be an expansion (then would be counted as expansion instead of POV Conversion):
      AND ${expansion_deal} IS NOT true -- for some reason 'IS false' didn't work
      -- deal must be pov conversion
      AND ${customer_is_pov_conversion} IS true

      -- deal must be closed within current period:
      AND date_trunc(${dmt_closed_won_date}, month)
          BETWEEN coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') + (EXTRACT(day FROM LAST_DAY(date(timestamp_trunc({% parameter base_cohort %}, month)))))
          AND (coalesce(date(timestamp_trunc({% parameter base_cohort %}, month)), '1970-01-01') +365)

      -- Customer hasn't churned in current period:
      AND (date_trunc(${churned_date_customer_date}, month) IS NULL
        OR coalesce(date_trunc(${churned_date_customer_date}, month), date_trunc(current_date(), month)) > date_trunc(date({% parameter base_cohort %}), month))

        THEN ${current_amount_euros} END ;;
    #filters: [deal_id: "4051893230, 3298914764, 6927018013"]
    label: "NR ext New Logos from Pilots"
    description: "Auxiliary measure to compute the Pilot Conversions for NRR extended: ARR of new logo deals which resulted from a Pilot conversion. Used for extented Net Retention only. Conversion must happen in the 12 months after the base period."
    #value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format_name: eur_0
    drill_fields: [deal_id, deal_name, company_id, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
  }

  measure: nrr_ext_params_euros {
    type: number
    sql: ${nrr_params_base_euros}
    + ${nrr_params_expansion_downsell_euros}
    + ${nrr_ext_params_upsell_new_logo_euros}
    - ${nrr_params_churned_revenue_euros}
    + ${nrr_params_expansion_edeka_euros}
    -- + GREATEST((${nrr_ext_params_pilot_newlogo_euros} - ${nrr_ext_params_pilot_values_euros}),0)
    + (${nrr_ext_params_pilot_newlogo_euros} - ${nrr_ext_params_pilot_values_euros});;
    #value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format_name: eur_0
    drill_fields: [deal_id, deal_name, company_id, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
    label: "€ NRR ext"
    description: "Net Retention extended in € (CS targets): Net ARR made with all customers joined before [Base Cohort month] in the 12 months after [Base Cohort month]
    + EXT (Expansion & Upsell ARR made in the 12 months after [Base Cohort month] with new logos of that period
    + (New Logo ARR - POV Value) if result of a POV conversion made in the 12 months after [Base Cohort month]). Excluding built-in expansions (three named strategic accounts).
    Computation: (Base ARR + Expansion/Downsell ARR - churned ARR + Edeka Expansion ARR) + New Customer Upsell ARR + (New Logo ARR - POV Value)."
  }

  measure: nrr_ext_params_percent {
    type: number
    sql: ${nrr_ext_params_euros}/nullif(${nrr_params_base_euros},0) ;;
    value_format_name: percent_2
    drill_fields: [deal_id, deal_name, company_id, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
    label: "% NRR ext"
    description: "Net Retention Rate extended % (CS targets): Percentage of Net ARR made with all customers joined before [Base Cohort month] in the 12 months after [Base Cohort month]
    + EXT (Expansion & Upsell ARR made in the 12 months after [Base Cohort month] with new logos of that period
    + (New Logo ARR - POV Value) if result of a POV conversion made in the 12 months after [Base Cohort month])
    compared to the Base Revenue (ARR made with the same customers before [Base Cohort month]). Excluding built-in expansions (three named strategic accounts).
    Computation: ((Base ARR + Expansion/Downsell ARR - churned ARR + Edeka Expansion ARR) + New Customer Upsell ARR + (New Logo ARR - POV Value)) / Base ARR."
  }

    # measure: nrr_ext_params_wo_base_percent {   # only shows the nrr revenues added in the consideration period, excluding the base
    #   type: number
    #   sql: (${nrr_ext_params_expansion_downsell_euros} - ${nrr_params_churned_revenue_euros} + ${nrr_params_expansion_edeka_euros} + GREATEST((${nrr_ext_params_pilot_newlogo_euros} - ${nrr_ext_params_pilot_values_euros}),0))/nullif(${nrr_params_base_euros},0) ;;
    #   value_format_name: percent_0
    #   drill_fields: [deal_id, deal_name, company_id, pipeline_label, funnel_stages_ordered, dmt_closed_won_date, current_amount_sum_euros]
    #   label: "NRR ext w/o Base %"
    #   description: "NRR ext % excluding the base (only the change value since the beginning of the consideration period)."
    # }

#### ----- // END OF FILTERED: Net Retention -------------------------------------------------------------------------------------------

### ----- // END OF DEAL VALUE & REVENUE MEASURES -------------------------------------------------------------------------------------

## ----- // END OF COMPANY-WIDE MEASURES  ----------------------------------------------------------------------------------

## ----- USE-CASE SPECIFIC MEASURES

# ### ----- // GROWTH MARKETING MEASURES -----------------------------------------------------------------------

  # measure: saos_marketing_influenced_count {
  #   type: count_distinct
  #   sql: CASE
  #         WHEN ${deal_source_channel_drilldown_hubspot} IN UNNEST(${deal_marketing_influence_touchpoints})
  #         THEN ${deal_id}
  #       END ;;
  #   filters: [dmt_sao_date: "-NULL", new_business_vs_upsell: "New Business, Upsell"]
  #   drill_fields: [deal_id, deal_name, deal_type, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, deal_source_channel_campaign_name, bdr_name, ae_name, deal_owner_name, sales_region, deal_segment, deal_allocation, deal_allocation_mix, stage_label, contact_dmt_lead_drilldown, contact_dmt_mql_drilldown, contact_dmt_sql_drilldown, dmt_sal_drilldown, dmt_sao_drilldown, dmt_solution_design_drilldown, dmt_evaluation_drilldown, dmt_proposal_drilldown, dmt_negotiation_drilldown, dmt_closed_won_drilldown, close_date_drilldown, forecast_category, sao_volume_sum_euros, current_amount_sum_euros]
  #   label: "#2 SAOs Marketing Influenced"
  #   description: "Deals with dmt SAO and recurring Deal Type (New Business, Upsell) that are influenced by the specific marketing event."
  # }

  # measure: closed_won_marketing_influenced_count {
  #   type: count_distinct
  #   sql: CASE
  #         WHEN ${deal_source_channel_drilldown_hubspot} IN UNNEST(${deal_marketing_influence_touchpoints})
  #         THEN ${deal_id}
  #       END ;;
  #   filters: [dmt_closed_won_date:"-NULL", new_business_vs_upsell: "New Business, Upsell"]
  #   drill_fields: [deal_id, deal_name, deal_type, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, deal_source_channel_campaign_name, bdr_name, ae_name, deal_owner_name, sales_region, deal_segment, deal_allocation, deal_allocation_mix, stage_label, contact_dmt_lead_drilldown, contact_dmt_mql_drilldown, contact_dmt_sql_drilldown, dmt_sal_drilldown, dmt_sao_drilldown, dmt_solution_design_drilldown, dmt_evaluation_drilldown, dmt_proposal_drilldown, dmt_negotiation_drilldown, dmt_closed_won_drilldown, close_date_drilldown, forecast_category, sao_volume_sum_euros, current_amount_sum_euros]
  #   label: "#8 Closed Won Marketing Influenced"
  #   description: "Deals with dmt Closed Won and recurring Deal Type (New Business, Upsell) that are influenced by the specific marketing event."
  # }

# # ---- MARKETING CAMPAIGNS DASHBOARD ---------------------------------------------------------------------------

# In the Marketing model, there's a one to many relationship. Count distinct is perform to sum sql_volume of each deal only one time
  measure: sao_marketing_sourced_distinct_count {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_sao_date: "-NULL", deal_source_channel: "paid social, paid search, trade show, marketing inbound other, direct traffic, organic search, pr & media", new_business_vs_upsell: "New Business"]
    label: "# SAOs Marketing Sourced (New Business)"
  }

### ---- SALES FUNNEL SPECIFIC MEASURES ----------------------------------------------------------------------

  measure: number_of_employees_avg {
    type: average
    sql:  ${number_of_employees};;
    value_format: "#,###"
    drill_fields: [deal_name, deal_id, dmt_sao_drilldown, number_of_employees_avg]
    label: "# Employees (avg)"
  }

  measure: number_of_employees_median {
    type: median
    sql:  ${number_of_employees};;
    value_format: "#,###"
    drill_fields: [deal_name, deal_id, dmt_sao_drilldown, number_of_employees_avg]
    label: "# Employees (median)"
  }

  measure: number_of_employees_sum {
    type: sum
    sql:  ${number_of_employees};;
    value_format: "#,###"
    drill_fields: [deal_name, deal_id, dmt_sao_drilldown, number_of_employees]
    label: "# Employees"
  }

  measure: number_of_licenses_sum {
    type: sum
    sql:  ${licences_count};;
    value_format: "#,###"
    drill_fields: [deal_name, deal_id, dmt_sao_drilldown, number_of_employees]
    label: "# Licenses"
  }

  measure: approx_number_of_employees_sum {
    type: sum
    sql:  ${approx_number_of_employees};;
    value_format: "#,###"
    drill_fields: [deal_name, deal_id, dmt_sao_drilldown, number_of_employees]
    label: "# Employees (approximation)"
    hidden: yes
  }

  dimension: number_of_employees_tiers {
    type: tier
    style: integer
    tiers: [0,251,501,1001,2501,5001,10001,25001]
    sql: ${number_of_employees} ;;
    label: "Tier # Employees (250-500-1k-2.5k-5k-10k-25k)"
  }

  dimension: number_of_employees_tiers_2 { # georg
    type: tier
    style: integer
    tiers: [0,101,301,501,751,1501,3001]
    sql: ${number_of_employees} ;;
    label: "Tier # Employees (100-300-500-750-1.5k-3k)"
  }

  dimension: number_of_employees_tiers_maxi {
    type: tier
    style: integer
    tiers: [0,501,2501,5001,25001]
    sql: ${number_of_employees} ;;
    label: "Tier # Employees (500-2.5k-5k-25k)"
  }

  dimension: number_of_employees_tiers_coenraad {
    type: tier
    style: integer
    tiers: [501,1001,3001,10001]
    sql: ${number_of_employees} ;;
    label: "Tier # Employees (500-1k-3k-10k)"
  }

  measure: sales_cycle_length_sao_to_closed_avg {
    type: average
    filters: [stage_label: "Closed Won",dmt_sao_date: "-NULL"]
    sql:  CASE WHEN ${stage_label} = "Closed Won" THEN DATE_DIFF(${dmt_closed_won_date},${dmt_sao_date},day)
          ELSE NULL END;;
    value_format: "#,###"
    drill_fields: [deal_name, deal_id,deal_segment, deal_allocation, deal_allocation_mix, number_of_employees, number_of_employees_tiers, deal_owner_name, flip_basic_features, flip_additional_features, dmt_sao_drilldown, dmt_closed_won_drilldown, current_amount_sum_euros, price_per_user_avg_euros, sales_cycle_length_sao_to_closed_avg]
    label: "Sales Cycle Lenght (avg d)"
    description: "Difference (in days) between Closed Won Date and SAO Date"
  }

  measure: tcv_avg_euros {
    type: average
    filters: [stage_label: "Closed Won", dmt_sao_date: "-NULL", new_business_vs_upsell: "New Business"]
    sql:  ${contract_term_in_months}/12*${current_amount_euros};;
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    drill_fields: [deal_name, deal_id,deal_segment, deal_allocation, deal_allocation_mix, number_of_employees, number_of_employees_tiers, deal_owner_name, flip_basic_features, flip_additional_features, dmt_sao_drilldown, dmt_closed_won_drilldown, current_amount_sum_euros, price_per_user_avg_euros, sales_cycle_length_sao_to_closed_avg, tcv_avg_euros]
    label: "€ TCV (avg, New Business)"
    description: "Total Contract Value: Total value from recurring revenue that the deal will generate over it's lifetime [ARR * contract-length in years]"
  }

  measure: conversion_sal_to_sao { # not working yet
    type: number
    # filters: [stage_label: "Closed Won, Closed Lost",dmt_sao_date: "-NULL"]
    sql:  SUM(CASE WHEN ${dmt_sal_date} IS NOT NULL AND ${stage_label} IN ("SAO") THEN 1 ELSE 0 END)/COUNT(${dmt_sal_date});;
    value_format: "0%"
    drill_fields: [deal_id, deal_name, stage_label,deal_segment, deal_allocation, deal_allocation_mix, number_of_employees, number_of_employees_tiers, deal_owner_name, flip_basic_features, flip_additional_features, dmt_sao_drilldown, dmt_closed_won_drilldown, current_amount_sum_euros, price_per_user_avg_euros]
    label: "% CR (SAL -> SAO) (all)"
    hidden: yes
  }

  measure: conversion_sao_to_closed_won_lost {
    type: number
    # filters: [stage_label: "Closed Won, Closed Lost",dmt_sao_date: "-NULL"]
    sql:  SUM(CASE WHEN ${dmt_sao_date} IS NOT NULL AND ${stage_label} IN ("Closed Won") THEN 1 ELSE 0 END)/COUNT(${dmt_sao_date});;
    value_format: "0%"
    drill_fields: [deal_id, deal_name, stage_label,deal_segment, deal_allocation, deal_allocation_mix, number_of_employees, number_of_employees_tiers, deal_owner_name, flip_basic_features, flip_additional_features, dmt_sao_drilldown, dmt_closed_won_drilldown, current_amount_sum_euros, price_per_user_avg_euros]
    label: "% Win Rate SAO (all)"
    description: "% of closed won SAOs"
  }

  measure: sals_count {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_sal_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_id,deal_name, deal_type, bdr_name, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, contact_dmt_lead_drilldown, contact_dmt_mql_drilldown, contact_dmt_sql_drilldown, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros]
    label: "#1 SALs (New Business)"
    description: "All Deals with dmt SAL and Deal Type New Business (incl. Edeka). "
  }

  measure: sals_count_all {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_sal_date:"-NULL", new_business_vs_upsell: "New Business, Upsell"]
    drill_fields: [deal_id,deal_name, deal_type, bdr_name, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, contact_dmt_lead_drilldown, contact_dmt_mql_drilldown, contact_dmt_sql_drilldown, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros]
    label: "#1 SALs (all)"
    description: "All Deals with dmt SAL and recurring Deal Type (New business, Upsell - NOT renewal)."
  }

  measure: sals_count_one_off {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_sal_date:"-NULL", deal_type: "One-Time"]
    drill_fields: [deal_id,deal_name, deal_type, bdr_name, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, contact_dmt_lead_drilldown, contact_dmt_mql_drilldown, contact_dmt_sql_drilldown, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros]
    label: "#1 SALs (one-time)"
    description: "All Deals with dmt SAL and one-time (!) Deal Type."
  }

  measure: saos_count {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_sao_date:"-NULL", new_business_vs_upsell: "New Business, Upsell"]
    drill_fields: [deal_id, deal_name,  deal_type, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, deal_source_channel_campaign_name, bdr_name, ae_name, deal_owner_name, sales_region, deal_segment, deal_allocation, deal_allocation_mix, stage_label, contact_dmt_lead_drilldown, contact_dmt_mql_drilldown, contact_dmt_sql_drilldown, dmt_sal_drilldown, dmt_sao_drilldown, dmt_solution_design_drilldown, dmt_evaluation_drilldown, dmt_proposal_drilldown, dmt_negotiation_drilldown, dmt_closed_won_drilldown, close_date_drilldown,  forecast_category, sao_volume_sum_euros, current_amount_sum_euros]
    label: "#2 SAOs (all)"
    description: "All Deals with dmt SAO and recurring Deal Type (New business, Upsell (incl. upsell Renewal)."
  }

  measure: saos_count_new_business {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_sao_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_id, deal_name,  deal_type, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, deal_source_channel_campaign_name, bdr_name, ae_name, deal_owner_name, sales_region, deal_segment, deal_allocation, deal_allocation_mix, stage_label, contact_dmt_lead_drilldown, contact_dmt_mql_drilldown, contact_dmt_sql_drilldown, dmt_sal_drilldown, dmt_sao_drilldown, dmt_solution_design_drilldown, dmt_evaluation_drilldown, dmt_proposal_drilldown, dmt_negotiation_drilldown, dmt_closed_won_drilldown, close_date_drilldown,  forecast_category, sao_volume_sum_euros, current_amount_sum_euros]
    label: "#2 SAOs New Business"
    description: "All Deals with dmt SAO and Deal Type New Business (incl. Edeka). "
  }

  measure: saos_count_one_off {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_sao_date:"-NULL", deal_type: "One-Time"]
    drill_fields: [deal_id,deal_name, deal_type, bdr_name, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, contact_dmt_lead_drilldown, contact_dmt_mql_drilldown, contact_dmt_sql_drilldown, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros]
    label: "#2 SAOs (one-time)"
    description: "All Deals with dmt SAO and one-time (!) Deal Type."
  }

  measure: saos_count_upsell {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_sao_date:"-NULL", new_business_vs_upsell: "Upsell"]
    drill_fields: [deal_id, deal_name,  deal_type, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, deal_source_channel_campaign_name, bdr_name, ae_name, deal_owner_name, sales_region, deal_segment, deal_allocation, deal_allocation_mix, stage_label, contact_dmt_lead_drilldown, contact_dmt_mql_drilldown, contact_dmt_sql_drilldown, dmt_sal_drilldown, dmt_sao_drilldown, dmt_solution_design_drilldown, dmt_evaluation_drilldown, dmt_proposal_drilldown, dmt_negotiation_drilldown, dmt_closed_won_drilldown, close_date_drilldown,  forecast_category, sao_volume_sum_euros, current_amount_sum_euros]
    label: "#2 SAOs Upsell"
    description: "All Deals with dmt SAO and Deal Type Upsell (incl. Edeka). "
  }

  measure: saos_still_open_count {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_sao_date:"-NULL", new_business_vs_upsell: "New Business, Upsell", stage_label: "-Closed Lost, -Closed Won, -LTO"]
    drill_fields: [deal_id, deal_name,  deal_type, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, deal_source_channel_campaign_name, bdr_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, contact_dmt_lead_drilldown, contact_dmt_mql_drilldown, contact_dmt_sql_drilldown, dmt_sal_drilldown, dmt_sao_drilldown, dmt_solution_design_drilldown, dmt_evaluation_drilldown, dmt_proposal_drilldown, dmt_negotiation_drilldown, dmt_closed_won_drilldown, close_date_drilldown,  forecast_category, sao_volume_sum_euros, current_amount_sum_euros]
    label: "# SAOs still open (all)"
  }

  measure: solution_design_count {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_solution_design_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_id, deal_name, deal_type, deal_source_channel_cluster_hubspot, bdr_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_solution_design_drilldown, dmt_evaluation_drilldown, close_date_drilldown, forecast_category, solution_design_volume_sum_euros, current_amount_sum_euros]
    label: "#3 Solution Design (New Business)"
    description: "All Deals with dmt SD and Deal Type New Business (incl. Edeka). "

  }

  measure: evaluation_count {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_evaluation_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_id, deal_name, deal_type, deal_source_channel_cluster_hubspot, bdr_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_evaluation_drilldown, dmt_proposal_drilldown, close_date_drilldown, forecast_category, evaluation_volume_sum_euros, current_amount_sum_euros]
    label: "#4 Evaluation (New Business)"
    description: "All Deals with dmt Evaluation and Deal Type New Business (incl. Edeka). "

  }

  measure: proposal_count {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_proposal_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_id, deal_name, deal_type, deal_source_channel_cluster_hubspot, bdr_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_proposal_drilldown, dmt_negotiation_drilldown, close_date_drilldown, forecast_category, proposal_volume_sum_euros, current_amount_sum_euros]
    label: "#5 Proposal (New Business)"
    description: "All Deals with dmt Proposal and Deal Type New Business (incl. Edeka). "
  }

  measure: negotiations_count {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_negotiations_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_id, deal_name, deal_type, deal_source_channel_cluster_hubspot, bdr_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_negotiation_drilldown, dmt_closed_won_drilldown, close_date_drilldown, forecast_category, negotiation_volume_sum_euros, current_amount_sum_euros]
    label: "#6 Negotiation New Business"
    description: "All Deals with dmt Negotiation and Deal Type New Business (incl. Edeka)."
  }

  measure: closing_validation_count {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_closed_won_validation_date: "-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_id, deal_name,  deal_type, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_closing_validation_drilldown, current_amount_sum_euros]
    label: "#7 Closing Validation New Business"
  }

  measure: closed_won_count {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_closed_won_date:"-NULL", new_business_vs_upsell: "New Business, Upsell"]
    drill_fields: [deal_id, deal_name,  deal_type, deal_owner_name, industry_flip, name_from_source_channel_contact, job_title_from_source_channel_contact, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, contact_dmt_lead_drilldown, contact_dmt_mql_drilldown, contact_dmt_sql_drilldown, dmt_sal_drilldown, dmt_sao_drilldown, dmt_closed_won_drilldown, signed_arr_sum_euros, sales_cycle_length_sao_to_closed_avg]
    label: "#8 Closed Won"
    description: "All Deals with dmt Closed Won and recurring Deal Type (New business, Upsell - NOT renewal)."
  }

  measure: closed_won_count_new_business {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_closed_won_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_id, deal_name,  deal_type, deal_owner_name, industry_flip, name_from_source_channel_contact, job_title_from_source_channel_contact, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, contact_dmt_lead_drilldown, contact_dmt_mql_drilldown, contact_dmt_sql_drilldown, dmt_sal_drilldown, dmt_sao_drilldown, dmt_closed_won_drilldown, signed_arr_sum_euros, sales_cycle_length_sao_to_closed_avg]
    label: "#8 Closed Won New Business"
    description: "All Deals with dmt Closed Won and Deal Type New Business (incl. Edeka). "
  }

  measure: closed_won_count_upsell {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_closed_won_date:"-NULL", new_business_vs_upsell: "Upsell"]
    drill_fields: [deal_id, deal_name,  deal_type, deal_owner_name, industry_flip, name_from_source_channel_contact, job_title_from_source_channel_contact, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, contact_dmt_lead_drilldown, contact_dmt_mql_drilldown, contact_dmt_sql_drilldown, dmt_sal_drilldown, dmt_sao_drilldown, dmt_closed_won_drilldown, signed_arr_sum_euros, sales_cycle_length_sao_to_closed_avg]
    label: "#8 Closed Won Upsell"
    description: "All Deals with dmt Closed Won and Deal Type Upsell (incl. Edeka). "
  }

  measure: closed_won_count_one_off {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_closed_won_date:"-NULL", deal_type: "One-Time"]
    drill_fields: [deal_id,deal_name, deal_type, bdr_name, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, contact_dmt_lead_drilldown, contact_dmt_mql_drilldown, contact_dmt_sql_drilldown, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros]
    label: "#8 Closed Wons (one-time)"
    description: "All Deals with dmt Closed Won and one-time (!) Deal Type."
  }

  measure: closed_lost_count {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_closed_lost_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [dmt_closed_lost_drilldown, deal_id, deal_name,  deal_type, lost_reason, lost_to_competitor, lost_comment, deal_owner_name,deal_segment, deal_allocation, deal_allocation_mix, industry_flip, sales_region, stage_label, last_deal_stage_corrected, current_amount_sum_euros]
    label: "#9 Closed Lost New Business"
    description: "All Deals with dmt Closed Lost and Deal Type New Business (incl. Edeka). "
  }

  measure: closed_lost_arr_sum {
    type: sum_distinct
    sql_distinct_key: ${deal_id} ;;
    sql:  ${current_amount_euros};;
    filters: [dmt_closed_lost_date:"-NULL", new_business_vs_upsell: "New Business"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";0"
    drill_fields: [dmt_closed_lost_drilldown, deal_id, deal_name, deal_type, lost_reason, lost_to_competitor, lost_comment, deal_owner_name,deal_segment, deal_allocation, deal_allocation_mix, industry_flip, sales_region, stage_label, last_deal_stage_corrected, current_amount_sum_euros]
    label: "€ Closed Lost Volume New Business"
  }

  measure: sao_volume_sum_euros {
    type: sum_distinct
    sql_distinct_key: ${deal_id} ;;
    sql:  ${initial_sao_amount_euros};;
    filters: [dmt_sao_date:"-NULL", new_business_vs_upsell: "New Business, Upsell"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";0"
    drill_fields: [deal_id, deal_name, deal_source_channel_cluster_hubspot, deal_type, deal_source_channel_campaign_name, deal_source_channel_drilldown_hubspot, bdr_name, ae_name,  deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, number_of_employees, stage_label, forecast_category, dmt_sao_drilldown, close_date_drilldown, sao_volume_sum_euros, current_amount_sum_distinct_euros]
    label: "€ SAO Volume (total)"
    description: "includes all deal types"
  }

  measure: sao_volume_avg_euros_all {
    type: average_distinct
    sql_distinct_key: ${deal_id} ;;
    sql:  ${initial_sao_amount_euros};;
    filters: [dmt_sao_date:"-NULL", new_business_vs_upsell: "New Business, Upsell"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";0"
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, deal_source_channel_campaign_name, bdr_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sao_drilldown, sao_volume_sum_euros]
    label: "€ SAO Volume avg (all deals)"
    description: "Avg SAO Volume € per SAO generated"
  }

  measure: sao_volume_sum_euros_newbiz {
    type: sum_distinct
    sql_distinct_key: ${deal_id} ;;
    sql:  ${initial_sao_amount_euros};;
    filters: [dmt_sao_date:"-NULL", new_business_vs_upsell: "New Business"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";0"
    drill_fields: [deal_id, deal_name, deal_source_channel_cluster_hubspot, deal_source_channel_campaign_name, deal_source_channel_drilldown_hubspot, bdr_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, number_of_employees, stage_label, forecast_category, dmt_sao_drilldown, close_date_drilldown, sao_volume_sum_euros, current_amount_sum_euros]
    label: "€ SAO Volume New Business"
    description: "includes New Business & New Business EDEKA"
  }

  measure: sao_volume_avg_euros {
    type: average_distinct
    sql_distinct_key: ${deal_id} ;;
    sql:  ${initial_sao_amount_euros};;
    filters: [dmt_sao_date:"-NULL", new_business_vs_upsell: "New Business"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";0"
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, deal_source_channel_campaign_name, bdr_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sao_drilldown, sao_volume_sum_euros]
    label: "€ SAO Volume New Business (avg)"
    description: "Avg SAO Volume € per SAO generated"
  }

  measure: sao_volume_median_euros {
    type: median_distinct
    sql_distinct_key: ${deal_id} ;;
    sql:  ${initial_sao_amount_euros};;
    filters: [dmt_sao_date:"-NULL", new_business_vs_upsell: "New Business"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";0"
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, deal_source_channel_campaign_name, bdr_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sao_drilldown, sao_volume_sum_euros]
    label: "€ SAO Volume New Business (median)"
    description: "The medium SAO Volume value in a sorted list of SAOs generated"
  }

  measure: solution_design_volume_sum_euros {
    type: sum_distinct
    sql_distinct_key: ${deal_id} ;;
    sql:  ${initial_solution_design_amount_euros};;
    filters: [dmt_solution_design_date:"-NULL", new_business_vs_upsell: "New Business"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";0"
    drill_fields: [deal_name, deal_id, deal_id, deal_type, deal_source_channel_cluster_hubspot, bdr_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_solution_design_drilldown, close_date_drilldown, forecast_category, solution_design_volume_sum_euros]
    label: "€ SD Volume New Business"
  }

  measure: evaluation_volume_sum_euros {
    type: sum_distinct
    sql_distinct_key: ${deal_id} ;;
    sql:  ${initial_evaluation_amount_euros};;
    filters: [dmt_evaluation_date:"-NULL", new_business_vs_upsell: "New Business"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";0"
    drill_fields: [deal_name, deal_id, deal_id, deal_type, deal_source_channel_cluster_hubspot, bdr_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_evaluation_drilldown, close_date_drilldown, forecast_category, evaluation_volume_sum_euros]
    label: "€ Evaluation Volume New Business"
  }

  measure: proposal_volume_sum_euros {
    type: sum_distinct
    sql_distinct_key: ${deal_id} ;;
    sql:  ${initial_proposal_amount_euros};;
    filters: [dmt_proposal_date:"-NULL", new_business_vs_upsell: "New Business"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";0"
    drill_fields: [deal_name, deal_id, deal_id, deal_type, deal_source_channel_cluster_hubspot, bdr_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_proposal_drilldown, close_date_drilldown, forecast_category, proposal_volume_sum_euros]
    label: "€ Proposal Volume New Business"
  }

  measure: negotiation_volume_sum_euros {
    type: sum_distinct
    sql_distinct_key: ${deal_id} ;;
    sql:  ${initial_negotiations_amount_euros};;
    filters: [dmt_negotiations_date:"-NULL", new_business_vs_upsell: "New Business"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";0"
    drill_fields: [deal_name, deal_id, deal_id, deal_type, deal_source_channel_cluster_hubspot, bdr_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_negotiation_drilldown, close_date_drilldown, forecast_category, negotiation_volume_sum_euros]
    label: "€ Negotiation Volume New Business"
  }

  measure: closing_validation_volume_sum_euros {
    type: sum_distinct
    sql_distinct_key: ${deal_id} ;;
    sql:  ${initial_closing_validation_amount_euros};;
    filters: [dmt_closed_won_validation_date:"-NULL", new_business_vs_upsell: "New Business"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";0"
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_campaign_name, deal_source_channel_drilldown_hubspot, bdr_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, number_of_employees, stage_label, dmt_negotiation_drilldown, close_date_drilldown, negotiation_volume_sum_euros]
    label: "€ Closed Validation Volume New Business"
  }

  measure: sals_still_in_sal_count {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_sal_date:"-NULL", stage_label: "SAL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, bdr_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sal_drilldown, days_in_sal_stage, current_amount_sum_euros]
    label: "# Still SAL New Business"
  }

  measure: nonaccepted_sals_in_lost_count {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_sal_date:"-NULL", dmt_sao_date:"NULL", stage_label: "Closed Lost", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, bdr_name, deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sal_drilldown, dmt_closed_lost_drilldown, no_sao_reason, lost_reason, lost_comment, current_amount_sum_euros]
    label: "# Nonaccepted SALs in Lost New Business"
  }

  measure: saos_still_in_sao_count {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_sao_date:"-NULL", stage_label: "SAO", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, ae_name, deal_owner_name, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sao_drilldown, days_in_sao_stage, sao_volume_sum_euros]
    label: "# Still SAO New Business"
  }

  measure: saos_still_in_sao_count_upsell {
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_sao_date:"-NULL", stage_label: "SAO", new_business_vs_upsell: "Upsell"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, ae_name, deal_owner_name, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sao_drilldown, days_in_sao_stage, sao_volume_sum_euros]
    label: "# Still SAO Upsell"
  }

  measure: sal_to_sao_count { # -- should be deleted/cleaned if possible
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_sal_date:"-NULL", dmt_sao_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, sao_volume_sum_euros]
    label: "CR SAL -> SAO Count New Business"
    hidden: yes
  }

  measure: sao_to_closed_won_count { # -- should be deleted/cleaned if possible
    type: count_distinct
    sql: ${deal_id} ;;
    filters: [dmt_sao_date:"-NULL", dmt_closed_won_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sao_drilldown, dmt_closed_won_drilldown, sao_volume_sum_euros, signed_arr_sum_euros]
    label: "For CR - SAO to Closed Won Count New Business"
    hidden: yes
  }

  # -- DAYS BETWEEN STAGES ACROSS THE PIPELINE -- #

  # -- AVERAGES --

  # -- DAYS IN THIS STAGE --

  measure: days_in_current_stage_avg {
    type: average
    label: "# Days in Current Stage (avg)"
    filters: [new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, sao_volume_sum_euros, current_amount_sum_euros, days_in_sal_stage_avg]
    value_format: "0"
    }

  measure: days_in_sal_stage_avg {
    type: average
    sql: ${days_in_sal_stage} ;;
    filters: [dmt_sal_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, sao_volume_sum_euros, current_amount_sum_euros, days_in_sal_stage_avg]
    label: "# Days in SAL (avg)"
    value_format: "0"
  }

  measure: days_in_sao_stage_avg {
    type: average
    sql: ${days_in_sao_stage} ;;
    filters: [dmt_sao_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, dmt_solution_design_drilldown, sao_volume_sum_euros, solution_design_volume_sum_euros, current_amount_sum_euros, days_in_sao_stage_avg]
    label: "# Days in SAO  New Business (avg)"
    value_format: "0"
  }

  measure: days_in_solution_design_stage_avg {
    type: average
    sql: ${days_in_solution_design_stage} ;;
    filters: [dmt_solution_design_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_solution_design_drilldown, dmt_evaluation_drilldown, solution_design_volume_sum_euros, evaluation_volume_sum_euros, days_in_solution_design_stage_avg]
    label: "# Days in SD New Business  (avg)"
    value_format: "0"
  }

  measure: days_in_evaluation_stage_avg {
    type: average
    sql: ${days_in_evaluation_stage} ;;
    filters: [dmt_evaluation_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_evaluation_drilldown, dmt_proposal_drilldown, evaluation_volume_sum_euros, proposal_volume_sum_euros, days_in_evaluation_stage_avg]
    label: "# Days in Evaluation New Business (avg)"
    value_format: "0"
  }

  measure: days_in_proposal_stage_avg {
    type: average
    sql: ${days_in_proposal_stage} ;;
    filters: [dmt_proposal_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_proposal_drilldown, dmt_negotiation_drilldown, proposal_volume_sum_euros, negotiation_volume_sum_euros, days_in_proposal_stage_avg]
    label: "# Days in Proposal New Business (avg)"
    value_format: "0"
  }

  measure: days_in_negotiation_stage_avg {
    type: average
    sql: ${days_in_negotiation_stage} ;;
    filters: [dmt_negotiations_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_negotiation_drilldown, dmt_closed_won_drilldown, negotiation_volume_sum_euros, current_amount_sum_euros, days_in_negotiation_stage]
    label: "# Days in Negotiation New Business (avg)"
    value_format: "0"
  }

  # -- DAYS TO NEXT STAGE --
  measure: days_from_sal_to_sao_avg {
    type: average
    sql: ${days_from_sal_to_sao} ;;
    filters: [dmt_sal_date:"-NULL", dmt_sao_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, sao_volume_sum_euros, current_amount_sum_euros, days_from_sal_to_sao_avg]
    label: "# Days from SAL to SAO  New Business (avg)"
    value_format: "0"
  }

  measure: days_from_sao_to_solution_design_avg {
    type: average
    sql: ${days_from_sao_to_solution_design} ;;
    filters: [dmt_sao_date:"-NULL", dmt_solution_design_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, dmt_solution_design_drilldown, sao_volume_sum_euros, solution_design_volume_sum_euros, current_amount_sum_euros, days_from_sao_to_solution_design_avg]
    label: "# Days from SAO to SD  New Business (avg)"
    value_format: "0"
  }

  measure: days_from_solution_design_to_evaluation_avg {
    type: average
    sql: ${days_from_solution_design_to_evaluation} ;;
    filters: [dmt_solution_design_date:"-NULL", dmt_evaluation_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_solution_design_drilldown, dmt_evaluation_drilldown, solution_design_volume_sum_euros, evaluation_volume_sum_euros, days_from_solution_design_to_evaluation_avg]
    label: "# Days from SD to Evaluation  New Business (avg)"
    value_format: "0"
  }

  measure: days_from_solution_design_to_negotitation_avg { #verena
    type: average
    sql: ${days_from_solution_design_to_negotiation} ;;
    filters: [dmt_solution_design_date:"-NULL", dmt_evaluation_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_solution_design_drilldown, dmt_evaluation_drilldown, solution_design_volume_sum_euros, evaluation_volume_sum_euros, days_from_solution_design_to_evaluation_avg]
    label: "# Days from SD to Negotiation  New Business (avg)"
    value_format: "0"
  }

  measure: days_from_evaluation_to_proposal_avg {
    type: average
    sql: ${days_from_evaluation_to_proposal} ;;
    filters: [dmt_evaluation_date:"-NULL", dmt_proposal_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_evaluation_drilldown, dmt_proposal_drilldown, evaluation_volume_sum_euros, proposal_volume_sum_euros, days_from_evaluation_to_proposal_avg]
    label: "# Days from Evaluation to Proposal  New Business (avg)"
    value_format: "0"
  }

  measure: days_from_proposal_to_negotiation_avg {
    type: average
    sql: ${days_from_proposal_to_negotiation} ;;
    filters: [dmt_proposal_date:"-NULL", dmt_negotiations_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_proposal_drilldown, dmt_negotiation_drilldown, proposal_volume_sum_euros, negotiation_volume_sum_euros, days_from_proposal_to_negotiation_avg]
    label: "# Days from Proposal to Negotiation  New Business (avg)"
    value_format: "0"
  }

  # -- DAYS TO WON --
  measure: days_from_sal_to_closed_won_avg {
    type: average
    sql: ${days_from_sal_to_closed_won} ;;
    filters: [dmt_sal_date:"-NULL", dmt_closed_won_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sao_drilldown, dmt_closed_won_drilldown, sao_volume_sum_euros, current_amount_sum_euros, days_from_sao_to_closed_won_avg]
    label: "# Days from SAL to Won New Business (avg)"
    value_format: "0"
  }

  measure: days_from_sao_to_closed_won_avg {
    type: average
    sql: ${days_from_sao_to_closed_won} ;;
    filters: [dmt_sao_date:"-NULL", dmt_closed_won_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sao_drilldown, dmt_closed_won_drilldown, sao_volume_sum_euros, current_amount_sum_euros, days_from_sao_to_closed_won_avg]
    label: "# Days from SAO to Won New Business (avg)"
    value_format: "0"
  }

  measure: days_from_solution_design_to_closed_won_avg {
    type: average
    sql: ${days_from_solution_design_to_closed_won} ;;
    filters: [dmt_solution_design_date:"-NULL", dmt_closed_won_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_solution_design_drilldown, dmt_closed_won_drilldown, solution_design_volume_sum_euros, current_amount_sum_euros, days_from_solution_design_to_closed_won_avg]
    label: "# Days from SD to Won New Business (avg)"
    value_format: "0"
  }

  measure: days_from_evaluation_to_closed_won_avg {
    type: average
    sql: ${days_from_evaluation_to_closed_won} ;;
    filters: [dmt_evaluation_date:"-NULL", dmt_closed_won_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_evaluation_drilldown, dmt_closed_won_drilldown, evaluation_volume_sum_euros, current_amount_sum_euros, days_from_evaluation_to_closed_won_avg]
    label: "# Days from Evaluation to Won New Business (avg)"
    value_format: "0"
  }

  measure: days_from_proposal_to_closed_won_avg {
    type: average
    sql: ${days_from_proposal_to_closed_won} ;;
    filters: [dmt_proposal_date:"-NULL", dmt_closed_won_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_proposal_drilldown, dmt_closed_won_drilldown, proposal_volume_sum_euros, current_amount_sum_euros, days_from_proposal_to_closed_won_avg]
    label: "# Days from Proposal to Won New Business (avg)"
    value_format: "0"
  }

  measure: days_from_negotiation_to_closed_won_avg {
    type: average
    sql: ${days_from_negotiation_to_closed_won} ;;
    filters: [dmt_negotiations_date:"-NULL", dmt_closed_won_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_negotiation_drilldown, dmt_closed_won_drilldown, negotiation_volume_sum_euros, current_amount_sum_euros, days_from_negotiation_to_closed_won_avg]
    label: "# Days from Negotiation to Won New Business (avg)"
    value_format: "0"
  }

  # -- DAYS TO LOST --
  measure: days_from_sal_to_closed_lost_avg {
    type: average
    sql: ${days_from_sal_to_closed_lost} ;;
    filters: [dmt_sal_date:"-NULL", dmt_closed_lost_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sao_drilldown, dmt_closed_lost_drilldown, sao_volume_sum_euros, current_amount_sum_euros, days_from_sao_to_closed_lost_avg]
    label: "# Days from SAL to Lost New Business (avg)"
    value_format: "0"
  }

  measure: days_from_sao_to_closed_lost_avg {
    type: average
    sql: ${days_from_sao_to_closed_lost} ;;
    filters: [dmt_sao_date:"-NULL", dmt_closed_lost_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sao_drilldown, dmt_closed_lost_drilldown, sao_volume_sum_euros, current_amount_sum_euros, days_from_sao_to_closed_lost_avg]
    label: "# Days from SAO to Lost New Business (avg)"
    value_format: "0"
  }

  measure: days_from_solution_design_to_closed_lost_avg {
    type: average
    sql: ${days_from_solution_design_to_closed_lost} ;;
    filters: [dmt_solution_design_date:"-NULL", dmt_closed_lost_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_solution_design_drilldown, dmt_closed_lost_drilldown, solution_design_volume_sum_euros, current_amount_sum_euros, days_from_solution_design_to_closed_lost_avg]
    label: "# Days from SD to Lost New Business (avg)"
    value_format: "0"
  }

  measure: days_from_evaluation_to_closed_lost_avg {
    type: average
    sql: ${days_from_evaluation_to_closed_lost} ;;
    filters: [dmt_evaluation_date:"-NULL", dmt_closed_lost_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_evaluation_drilldown, dmt_closed_lost_drilldown, evaluation_volume_sum_euros, current_amount_sum_euros, days_from_evaluation_to_closed_lost_avg]
    label: "# Days from Evaluation to Lost New Business (avg)"
    value_format: "0"
  }

  measure: days_from_proposal_to_closed_lost_avg {
    type: average
    sql: ${days_from_proposal_to_closed_lost} ;;
    filters: [dmt_proposal_date:"-NULL", dmt_closed_lost_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_proposal_drilldown, dmt_closed_lost_drilldown, proposal_volume_sum_euros, current_amount_sum_euros, days_from_proposal_to_closed_lost_avg]
    label: "# Days from Proposal to Lost New Business (avg)"
    value_format: "0"
  }

  measure: days_from_negotiation_to_closed_lost_avg {
    type: average
    sql: ${days_from_negotiation_to_closed_lost} ;;
    filters: [dmt_negotiations_date:"-NULL", dmt_closed_lost_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_negotiation_drilldown, dmt_closed_lost_drilldown, negotiation_volume_sum_euros, current_amount_sum_euros, days_from_negotiation_to_closed_lost_avg]
    label: "# Days from Negotiation to Lost New Business (avg)"
    value_format: "0"
  }

    # -- MEDIANS --

  measure: days_from_sal_to_sao_median {
    type: median
    sql: ${days_from_sal_to_sao} ;;
    filters: [dmt_sal_date:"-NULL", dmt_sao_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros, days_from_sal_to_sao_median]
    label: "# Days from SAL to SAO New Business (median)"
    value_format: "0"
  }

  measure: days_from_sao_to_solution_design_median {
    type: median
    sql: ${days_from_sao_to_solution_design} ;;
    filters: [dmt_sao_date:"-NULL", dmt_solution_design_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sal_drilldown, dmt_sao_drilldown, current_amount_sum_euros, days_from_sao_to_solution_design_median]
    label: "# Days from SAO to SD New Business (median)"
    value_format: "0"
  }

  measure: days_from_solution_design_to_evaluation_median {
    type: median
    sql: ${days_from_solution_design_to_evaluation} ;;
    filters: [dmt_solution_design_date:"-NULL", dmt_evaluation_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_solution_design_drilldown, dmt_evaluation_drilldown, current_amount_sum_euros, days_from_solution_design_to_evaluation_median]
    label: "# Days from SD to Evaluation New Business (median)"
    value_format: "0"
  }

  measure: days_from_evaluation_to_proposal_median {
    type: median
    sql: ${days_from_evaluation_to_proposal} ;;
    filters: [dmt_evaluation_date:"-NULL", dmt_proposal_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_evaluation_drilldown, dmt_proposal_drilldown, current_amount_sum_euros, days_from_evaluation_to_proposal_median]
    label: "# Days from Evaluation to Proposal New Business (median)"
    value_format: "0"
  }

  measure: days_from_proposal_to_negotiation_median {
    type: median
    sql: ${days_from_proposal_to_negotiation} ;;
    filters: [dmt_proposal_date:"-NULL", dmt_negotiations_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_proposal_drilldown, dmt_negotiation_drilldown, current_amount_sum_euros, days_from_proposal_to_negotiation_median]
    label: "# Days from Proposal to Negotiation New Business (median)"
    value_format: "0"
  }

  measure: days_from_negotiation_to_closed_won_median {
    type: median
    sql: ${days_from_negotiation_to_closed_won} ;;
    filters: [dmt_negotiations_date:"-NULL", dmt_closed_won_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_negotiation_drilldown, dmt_closed_won_drilldown, current_amount_sum_euros, days_from_negotiation_to_closed_won_median]
    label: "# Days from Negotiation to Won New Business (median)"
    value_format: "0"
  }

  measure: days_from_sao_to_closed_won_median {
    type: median
    sql: ${days_from_sao_to_closed_won} ;;
    filters: [dmt_sao_date:"-NULL", dmt_closed_won_date:"-NULL", new_business_vs_upsell: "New Business"]
    drill_fields: [deal_name, deal_id, deal_id, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, dmt_sao_drilldown, dmt_closed_won_drilldown, current_amount_sum_euros, days_from_sao_to_closed_won_avg]
    label: "# Days from SAO to Won New Business (median)"
    value_format: "0"
  }

  ### MEDDIC metrics for AE Dashboard ###

  measure: meddic_deal_health_score_number {
    type: sum
    sql: ${final_meddic_deal_health_score_computation} ;;
    value_format: "0%"
    link: {
      label: "Deal MEDDIC section in CRM"
      url: "https://app.hubspot.com/contacts/7401529/deal/{{ deal_id }}/properties?search=__"
    }
    label: "Deal Health Score - formatted (Hubspot)"
    description: "Probability of successfully closing a deal based on it's metrics and hygiene. Green for >=85%, Yellow for >=60% and Red for <60%"
  }

### ---- DEMAND GEN DASHBOARD SPECIFIC MEASURES --------------------------------------------------------------------

  # creating parameter for enabling user to report Region/Country more granular
  parameter: dynamic_channel_parameter {
    type: unquoted
    allowed_value: {
      label: "Source Channel Department"
      value: "super_category"
    }
    allowed_value: {
      label: "Source Channel Cluster"
      value: "sub_category"
    }
  }

  dimension: dynamic_channel {
    type: string
    label_from_parameter: dynamic_channel_parameter
    sql: {% if dynamic_channel_parameter._parameter_value == 'sub_category' %}
        (${deal_source_channel_drilldown_hubspot})
        {% else %}
        ${deal_source_channel_department_hubspot}
        -- (CASE WHEN LOWER(${deal_source_channel_drilldown_hubspot}) IN ("management/investor referral") THEN "Mgmt/Inv"
        --       WHEN LOWER(${deal_source_channel_drilldown_hubspot}) IN ("cs referral") THEN "CS"
        --       WHEN LOWER(${deal_source_channel_drilldown_hubspot}) IN ("partner") THEN "Partner"
        --       WHEN LOWER(${deal_source_channel_drilldown_hubspot}) IN ("bdr outbound") THEN "BDR Out"
        --       WHEN LOWER(${deal_source_channel_drilldown_hubspot}) IN ("ae outbound") THEN "AE Out"
        --       WHEN LOWER(${deal_source_channel_drilldown_hubspot}) IS NULL OR LOWER(${deal_source_channel_drilldown_hubspot}) IN ("w/o","-") THEN "w/o"
        --       ELSE "Marketing" END
        -- )
        {% endif %};;
  }

### ---- LOSS ANALYSIS DASHBOARD SPECIFIC MEASURES -----------------------------------------------------------------

  parameter: base_metric_loss_analysis {
    type: unquoted
    allowed_value: {
      label: "# Lost Opps"
      value: "opps"
    }
    allowed_value: {
      label: "€ Lost ARR"
      value: "arr"
    }
    label: "Base Metric Loss Analysis - Closed Lost"
  }

  parameter: base_metric_sao_loss_analysis {
    type: unquoted
    allowed_value: {
      label: "# SAOs"
      value: "opps"
    }
    allowed_value: {
      label: "€ SAO Volume"
      value: "arr"
    }
    label: "Base Metric Loss Analysis - SAO"
  }

  # creating dynamic base metric
  measure: dynamic_base_metric_loss_analysis {
    type: number
    label_from_parameter: base_metric_loss_analysis
    sql: {% if base_metric_loss_analysis._parameter_value == 'opps' %}
        ifnull(COUNT(${dmt_closed_lost_date}),0)
        {% else %}
        ifnull(SUM(${lost_amount_euros}),0)
        {% endif %};;
    # value_format: "[>=1000000]#0.000,,\" M\";[>=1000]#0.00,\" K\";[<1500]#0;0"
    value_format: "#,##0"
    html: {% if base_metric_loss_analysis._parameter_value == 'arr' %} €{{ rendered_value }}
          {% else %} {{ rendered_value }}
          {% endif %} ;;
    drill_fields: [dmt_closed_lost_drilldown, deal_name, lost_reason, lost_to_competitor, lost_comment, deal_owner_name,deal_segment, deal_allocation, deal_allocation_mix, industry_flip, sales_region, stage_label, last_deal_stage_corrected, current_amount_sum_euros]
    label: "Closed Lost - Dynamic Metric Loss Analysis"
  }

  measure: dynamic_base_metric_sao {
    type: number
    label_from_parameter: base_metric_sao_loss_analysis
    sql: {% if base_metric_sao_loss_analysis._parameter_value == 'opps' %}
        ifnull(COUNT(${dmt_sao_date}),0)
        {% else %}
        ifnull(SUM(${initial_sao_amount_euros}),0)
        {% endif %};;
    # value_format: "[>=1000000]#0.000,,\" M\";[>=1000]#0.00,\" K\";[<1500]#0;0"
      value_format: "#,##0"
      html: {% if base_metric_sao_loss_analysis._parameter_value == 'arr' %} €{{ rendered_value }}
          {% else %} {{ rendered_value }}
          {% endif %} ;;
      drill_fields: [dmt_closed_lost_drilldown, deal_name, lost_reason, lost_to_competitor, lost_comment, lost_arr_sum_euros, deal_owner_name,deal_segment, deal_allocation, deal_allocation_mix, industry_flip, sales_region, stage_label, last_deal_stage_corrected]
      label: "SAO - Dynamic Metric Loss Analysis"
    }

## ----- // END OF USE-CASE SPECIFIC MEASURES -----------------------------------------------------------

# ---- SETS ------

  set: all_complete_date_groups {
    fields:
    [
      churn_date, churn_month, churn_quarter, churn_raw, churn_week, churn_year,
      close_date, close_month, close_quarter, close_raw, close_week, close_year,
      copied_at_date,  copied_at_month,  copied_at_quarter,  copied_at_raw,  copied_at_week,  copied_at_year,
      copied_at_timestamp_date, copied_at_timestamp_month, copied_at_timestamp_quarter, copied_at_timestamp_raw, copied_at_timestamp_week, copied_at_timestamp_year,

      created_at_date, created_at_month, created_at_quarter, created_at_raw, created_at_week, created_at_year,
      churned_date_customer_date, churned_date_customer_month, churned_date_customer_quarter, churned_date_customer_raw, churned_date_customer_week, churned_date_customer_year,
      churned_date_group_date, churned_date_group_month, churned_date_group_quarter, churned_date_group_raw, churned_date_group_week, churned_date_group_year,
      dmt_closed_won_customer_date, dmt_closed_won_customer_month, dmt_closed_won_customer_quarter, dmt_closed_won_customer_raw, dmt_closed_won_customer_week, dmt_closed_won_customer_year,
      dmt_closed_won_group_date, dmt_closed_won_group_month, dmt_closed_won_group_quarter, dmt_closed_won_group_raw, dmt_closed_won_group_week, dmt_closed_won_group_year,
      contract_start_date, contract_start_month, contract_start_quarter, contract_start_raw, contract_start_week, contract_start_year,
      dmt_closed_lost_date, dmt_closed_lost_month, dmt_closed_lost_quarter, dmt_closed_lost_raw, dmt_closed_lost_week, dmt_closed_lost_year,
      dmt_closed_won_date, dmt_closed_won_month, dmt_closed_won_quarter, dmt_closed_won_raw, dmt_closed_won_week, dmt_closed_won_year,
      dmt_closed_won_validation_date, dmt_closed_won_validation_month, dmt_closed_won_validation_quarter, dmt_closed_won_validation_raw, dmt_closed_won_validation_week, dmt_closed_won_validation_year,
      dmt_evaluation_date, dmt_evaluation_month, dmt_evaluation_quarter, dmt_evaluation_raw, dmt_evaluation_week, dmt_evaluation_year,
      dmt_negotiations_date, dmt_negotiations_month, dmt_negotiations_quarter, dmt_negotiations_raw, dmt_negotiations_week, dmt_negotiations_year,
      dmt_proposal_date, dmt_proposal_month, dmt_proposal_quarter, dmt_proposal_raw, dmt_proposal_week, dmt_proposal_year,
      dmt_sal_date, dmt_sal_month, dmt_sal_quarter, dmt_sal_raw, dmt_sal_week, dmt_sal_year,
      dmt_sao_date, dmt_sao_month, dmt_sao_quarter, dmt_sao_raw, dmt_sao_week, dmt_sao_year,
      dmt_solution_design_date, dmt_solution_design_month, dmt_solution_design_quarter, dmt_solution_design_raw, dmt_solution_design_week, dmt_solution_design_year,
      go_live_date, go_live_month, go_live_quarter, go_live_raw, go_live_week, go_live_year,
      last_activity_date, last_activity_month, last_activity_quarter, last_activity_raw, last_activity_week, last_activity_year,
      last_contacted_date, last_contacted_month, last_contacted_quarter, last_contacted_raw, last_contacted_week, last_contacted_year,
      next_step_date, next_step_month, next_step_quarter, next_step_raw, next_step_week, next_step_year,
      renewal_date, renewal_month, renewal_quarter, renewal_raw, renewal_time, renewal_week, renewal_year
    ]
  }

  set: all_datamart_hubspot_customers_all_related_fields {
    fields: [nrr_params_base_euros, nrr_params_churned_revenue_euros, nrr_params_expansion_downsell_euros, nrr_params_base_euros, nrr_params_expansion_edeka_euros,
        nrr_ext_params_upsell_new_logo_euros, nrr_ext_params_euros, nrr_ext_params_percent,
      ]
  }

  set: all_net_retention_fields {
    fields: [base_cohort,
      nrr_params_base_euros, nrr_params_expansion_downsell_euros, nrr_params_churned_revenue_euros, nrr_params_expansion_edeka_euros,
      nrr_params_euro, nrr_params_percent,
      nrr_ext_params_upsell_new_logo_euros, nrr_ext_params_pilot_values_euros, nrr_ext_params_pilot_newlogo_euros, nrr_ext_params_euros, nrr_ext_params_percent,
      ]
  }

  set: nrr_all_flipster_additional_fields {
    fields: [
      churn_date, churn_month, churn_quarter, churn_week, churn_year,
      dmt_closed_won_group_date, dmt_closed_won_group_month, dmt_closed_won_group_quarter, dmt_closed_won_group_week, dmt_closed_won_group_year,
      churned_date_group_date, churned_date_group_month, churned_date_group_quarter, churned_date_group_week, churned_date_group_year,
      current_amount_sum_euros, deal_id, deal_name, deal_type, expansion_deal, pipeline_label, stage_label,deal_segment,
      customer_is_pov_conversion, customer_is_pov_conversion_no_expansion

    ]
  }

  set: all_gross_retention_fields {
    fields: [base_cohort, negative_positive_amounts,
      nrr_params_base_euros, nrr_params_churned_revenue_euros, grr_params_downsell_euros, grr_params_euro, grr_params_percent
      ]
  }

## ----- TEAM SPECIFIC SETS (for Explores) -----------------------------------------------------------------------------------

  set: all_cs_relevant_fields {
    fields: [
      contract_term_in_months, cs_name, cs_team, deal_id, deal_name, deal_type, new_business_vs_upsell, upsell_vs_expansion, deals_relevant_for_cs,
      edeka_region, flip_additional_features, flip_basic_features, has_integration, industry_flip, integration,deal_allocation, contract_type,
      is_mtd, is_ytd, is_churned, is_churned_today, is_edeka, is_lost_revenue, is_recurring, is_license_overrun_deal,
      months_since_go_live_floor, negative_positive_amounts, pipeline_label, presales_name, revenue_signed_date, sales_region,deal_segment,
      stage_label, customer_is_pov_conversion, customer_is_pov_conversion_no_expansion, expansion_deal, stage_label, deal_source_channel_cluster_hubspot,
      forecast_category,
      close_date, close_month, close_quarter, close_week, close_year,
      churn_date, churn_month, churn_quarter, churn_week, churn_year,
      dmt_closed_won_customer_date, dmt_closed_won_customer_month, dmt_closed_won_customer_quarter, dmt_closed_won_customer_raw, dmt_closed_won_customer_week, dmt_closed_won_customer_year,
      dmt_closed_won_group_date, dmt_closed_won_group_month, dmt_closed_won_group_quarter, dmt_closed_won_group_week, dmt_closed_won_group_year,
      churned_date_customer_date, churned_date_customer_month, churned_date_customer_quarter, churned_date_customer_raw, churned_date_customer_week, churned_date_customer_year,
      churned_date_group_date, churned_date_group_month, churned_date_group_quarter, churned_date_group_week, churned_date_group_year,
      contract_start_date, contract_start_month, contract_start_quarter, contract_start_week, contract_start_year,
      dmt_closed_won_date, dmt_closed_won_month, dmt_closed_won_quarter, dmt_closed_won_week, dmt_closed_won_year,
      dmt_negotiations_date, dmt_negotiations_month, dmt_negotiations_quarter, dmt_negotiations_week, dmt_negotiations_year,
      dmt_sao_date, dmt_sao_month, dmt_sao_quarter, dmt_sao_raw, dmt_sao_week, dmt_sao_year,
      renewal_date, renewal_month, renewal_quarter, renewal_raw, renewal_time, renewal_week, renewal_year,
      partner_name,
      count, licences_sum, licences_upsell_sum, new_added_upsells_count,
      current_amount_sum_euros, total_contract_value_sum_euros, total_recurring_contract_value_sum_euros,
      one_off_deal_amount_sum_euros, setup_amount,one_off_total_amount_sum_euros,
      signed_arr_sum_euros, signed_arr_avg_euros, churned_arr_sum_euros, downsell_arr_sum_euros, lost_arr_sum_euros, net_arr_sum_euros,
      signed_arr_upsells_sum_euros, signed_arr_new_logos_sum_euros,
      added_one_time_revenue_sum_euros, net_one_time_revenue_sum_euros,
      sales_cycle_length_sao_to_closed_avg,
      all_net_retention_fields*,

      ]
  }
  # -- sao_to_closed and dmt_sao should be removed when separated

  set: all_flipsters_fields {
    fields: [
      contract_term_in_months, ae_name, ae_team, bdr_name, cs_name, cs_team, deal_allocation, deal_allocation_mix, deal_id, deal_name, deal_type, new_business_vs_upsell, upsell_vs_expansion,
      edeka_region, flip_additional_features, flip_basic_features, has_integration, industry_flip, integration,
      is_mtd, is_ytd, is_churned, is_churned_today, is_edeka, is_lost_revenue, is_recurring, is_key_deal, is_a_meta_deal, is_license_overrun_deal,
      months_since_go_live_floor, negative_positive_amounts, partner_name, pipeline_label, presales_name, revenue_signed_date, sales_region, deal_source_channel_cluster_hubspot,
      company_workplace_list_region,deal_segment,deal_allocation, contract_type,
      final_meddic_deal_health_score_computation,
      stage_label, customer_is_pov_conversion, expansion_deal, stage_label,
      presales_1__pre_project_pitched, presales_1__pre_project_won, presales_1__pre_project_won_yn, presales_1_pre_project_comment,
      presales_1_pre_project_delivery_date, presales_1_pre_project_delivery_month, presales_1_pre_project_delivery_quarter, presales_1_pre_project_delivery_week, presales_1_pre_project_delivery_year,
      presales_1__pre_project_pitched_date, presales_1__pre_project_pitched_month, presales_1__pre_project_pitched_quarter, presales_1__pre_project_pitched_week, presales_1__pre_project_pitched_year,
      presales_1__pre_project_won_date, presales_1__pre_project_won_month, presales_1__pre_project_won_quarter, presales_1__pre_project_won_week, presales_1__pre_project_won_year,
      total_contract_value_avg_euros,
      churn_date, churn_month, churn_quarter, churn_week, churn_year, close_date_drilldown,close_date, close_month, close_quarter, close_week, close_year,
      dmt_closed_won_customer_date, dmt_closed_won_customer_month, dmt_closed_won_customer_quarter, dmt_closed_won_customer_raw, dmt_closed_won_customer_week, dmt_closed_won_customer_year,
      dmt_closed_won_group_date, dmt_closed_won_group_month, dmt_closed_won_group_quarter, dmt_closed_won_group_week, dmt_closed_won_group_year,
      churned_date_group_date, churned_date_group_month, churned_date_group_quarter, churned_date_group_week, churned_date_group_year,
      contract_start_date, contract_start_month, contract_start_quarter, contract_start_week, contract_start_year,
      dmt_closed_won_date, dmt_closed_won_month, dmt_closed_won_quarter, dmt_closed_won_week, dmt_closed_won_year,
      renewal_date, renewal_month, renewal_quarter, renewal_raw, renewal_time, renewal_week, renewal_year,
      dmt_sao_date, dmt_sao_month, dmt_sao_quarter, dmt_sao_year,
      created_at_date,
      count, licences_sum, licences_upsell_sum, new_added_upsells_count,
      current_amount_sum_euros, total_contract_value_sum_euros, total_recurring_contract_value_sum_euros,
      one_off_deal_amount_sum_euros, setup_amount,one_off_total_amount_sum_euros, sales_country,
      signed_arr_sum_euros, signed_arr_avg_euros, churned_arr_sum_euros, downsell_arr_sum_euros, lost_arr_sum_euros, net_arr_sum_euros,
      signed_arr_upsells_sum_euros, signed_arr_new_logos_sum_euros,
      added_one_time_revenue_sum_euros, net_one_time_revenue_sum_euros,

    ]

  }

  set: exclude_names {
    fields: [cs_name, ae_name, presales_name, bdr_name]
  }

## ----- // END OF TEAM SPECIFIC SETS (for Explores) -----------------------------------------------------------------------------------

## ----- USE/CASE SPECIFIC SETS (for Explores) -----------------------------------------------------------------------------------

## ----- // END OF USE/CASE SPECIFIC SETS (for Explores) -----------------------------------------------------------------------------------
# ----- // END OF SETS -----------------------------------------------------------------------------------

}
