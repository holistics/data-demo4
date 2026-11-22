connection: "fl-bi-p-looker-sa"

# Flat Tables
include: "/extended_views/Reports/marketing_filters_ext.view"
include: "/extended_views/Reports/marketing_filters_allocation_ext.view"
include: "/extended_views/Reports/gtm_targets_by_department_ext.view"

# Ads
include: "/extended_views/Datamarts/linkedin_ad_performance_pivots_ext.view"

# Account Dashboard
include: "/extended_views/Reports/marketing_account_scoring_accounts_ext.view"
include: "/extended_views/Reports/marketing_account_scoring_all_touchpoints_ext.view"

# SalesLoft
include: "/extended_views/Datamarts/salesloft_meetings_held_ext.view"

# Awareness
include: "/extended_views/Reports/marketing_awareness_flat_table_ext.view"
include: "/extended_views/Datamarts/ga4_events_ext.view"
include: "/extended_views/Datamarts/marketing_touchpoints_ext.view"
include: "/extended_views/Datamarts/search_console_site_searches_ext.view"
include: "/extended_views/Datamarts/search_console_url_searches_ext.view"

# HubSpot
include: "/extended_views/Datamarts/hubspot_deals_all_ext.view"
include: "/extended_views/Datamarts/hubspot_deals_all_historized_ext.view"
include: "/extended_views/Datamarts/hubspot_contacts_all_ext.view"
include: "/extended_views/Datamarts/hubspot_engagement_calls_sales_ext.view"
include: "/extended_views/Datamarts/hubspot_engagement_emails_sales_ext.view"
include: "/extended_views/Datamarts/hubspot_engagement_meetings_sales_ext.view"
include: "/extended_views/Reports/gtm_sales_pipeline_over_time_ext.view"
include: "/extended_views/Reports/gtm_partner_pipeline_over_time_ext.view"
include: "/extended_views/Datamarts/hubspot_deal_marketing_influence_touchpoint_ext.view"

#GoogleSheets
include: "/extended_views/Google_Sheets/marketing_costs_and_targets_ext.view"

# Derived tables

# Seismic:

# LookML Dashboards:

#************************
#***  Caching         ***
#************************
datagroup: model_refresh_morning {
  sql_trigger: SELECT FLOOR(((TIMESTAMP_DIFF(CURRENT_TIMESTAMP(),'1970-01-01 00:00:00',SECOND)) - 60*60*6)/(60*60*24)) ;;
  max_cache_age: "6 hours"
}

### ------- CAMPAIGN MANAGEMENT MARKETING FUNNEL ------------------------------------------ ###

### ------- GTM FUNNEL (ALLOCATION) -------------------------------------------------------------- ###

explore: marketing_funnel_allocation {

  fields: [ALL_FIELDS*
    ,-hubspot_sal.all_datamart_hubspot_customers_all_related_fields*
    ,-hubspot_sao.all_datamart_hubspot_customers_all_related_fields*
    ,-hubspot_closed_won.all_datamart_hubspot_customers_all_related_fields*
  ]

  #always_filter: { # doesn't work / numbers in other stages are wrong when applying this
  #  filters: [hubspot_sal.is_license_overrun_deal: "No", #hubspot_sal.exclude_flip_flow_sals: "Yes"]
  #}

  from: marketing_filters_allocation_ext
  label: "GTM Funnel (Allocation)"
  description: "To-go explore for analysing anything related to the Sales Funnel (Marketing lifecycle stages, Sales funnel stages, Sales Activities"
  view_label: "*Flat table - central"
  persist_for: "6 hours"

  # New target view
  join: gtm_targets_by_department_ext {
    view_label: "*Targets (Department)"
    type: left_outer
    relationship: many_to_one
    sql_on:
    ${marketing_funnel_allocation.date_date} = ${gtm_targets_by_department_ext.date_date}
    AND ${marketing_funnel_allocation.deal_source_channel_department_hubspot} = ${gtm_targets_by_department_ext.department}
    AND ${marketing_funnel_allocation.deal_allocation} = ${gtm_targets_by_department_ext.deal_allocation}
  ;;
  }

  join: hubspot_sal {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.primary_key} = ${hubspot_sal.foreign_key_sal_marketing_filters_allocation} AND  ${hubspot_sal.is_license_overrun_deal} IS false AND ${hubspot_sal.exclude_flip_flow_sals} IS true ;;
    view_label: "Deal #1 DMT SAL"
  }

  join: hubspot_sao {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.primary_key} = ${hubspot_sao.foreign_key_sao_marketing_filters_allocation} ;;
    view_label: "Deal #2 DMT SAO"
  }

  join: hubspot_solution_design {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.primary_key} = ${hubspot_solution_design.foreign_key_solution_design_marketing_filters_allocation} ;;
    view_label: "Deal #3 DMT Solution Design"
  }

  join: hubspot_evaluation {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.primary_key} = ${hubspot_evaluation.foreign_key_evaluation_marketing_filters_allocation} ;;
    view_label: "Deal #4 DMT Evaluation"
  }

  join: hubspot_proposal {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.primary_key} = ${hubspot_proposal.foreign_key_proposal_marketing_filters_allocation} ;;
    view_label: "Deal #5 DMT Proposal"
  }

  join: hubspot_negotiation {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.primary_key} = ${hubspot_negotiation.foreign_key_negotiations_marketing_filters_allocation} ;;
    view_label: "Deal #6 DMT Negotiation"
  }

  join: hubspot_closing_validation {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.primary_key} = ${hubspot_closing_validation.foreign_key_closing_validation_marketing_filters_allocation} ;;
    view_label: "Deal #7 DMT Closing Validation"
  }

  join: hubspot_closed_won {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.primary_key} = ${hubspot_closed_won.foreign_key_closed_won_marketing_filters_allocation} ;;
    view_label: "Deal #8 DMT Closed Won"
  }

  join: hubspot_closed_lost {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.primary_key} = ${hubspot_closed_lost.foreign_key_closed_lost_marketing_filters_allocation} ;;
    view_label: "Deal #9 DMT Closed Lost"
  }

  join: hubspot_close_date {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.primary_key} = ${hubspot_close_date.foreign_key_close_date_marketing_filters_allocation} ;;
    view_label: "Deal # Close Date"
  }

  join: hubspot_expected_sd_date {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.primary_key} = ${hubspot_expected_sd_date.foreign_key_expected_sd_date_marketing_filters_allocation} ;;
    view_label: "Deal # Expected SD Date"
  }

  join: hubspot_pipeline_volume_shapshots {
    from: gtm_sales_pipeline_over_time_ext
    type: full_outer
    relationship: many_to_many
    sql_on: ${marketing_funnel_allocation.date_date} = ${hubspot_pipeline_volume_shapshots.period_date} AND ${marketing_funnel_allocation.deal_allocation} = ${hubspot_pipeline_volume_shapshots.deal_allocation} ;;
    view_label: "Deal # Pipe Volume Snapshots"
  }

  join: hubspot_partner_pipeline_volume_snapshots {
    from: gtm_partner_pipeline_over_time_ext
    type: full_outer
    relationship: many_to_many
    sql_on: ${marketing_funnel_allocation.date_date} = ${hubspot_partner_pipeline_volume_snapshots.period_week_date} AND ${marketing_funnel_allocation.deal_allocation} = ${hubspot_partner_pipeline_volume_snapshots.deal_allocation} ;;
    view_label: "Deal # Partner Pipe Volume Snapshots"
  }

  join: hubspot_contacts_lead {
    from: hubspot_contacts_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.foreign_key_contacts_table} = ${hubspot_contacts_lead.foreign_key_lead_marketing_filters_allocation} ;;
    view_label: "Contact Lifecycle #1 DMT Lead"
  }

  join: hubspot_contacts_mql {
    from: hubspot_contacts_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.foreign_key_contacts_table} = ${hubspot_contacts_mql.foreign_key_mql_marketing_filters_allocation} ;;
    view_label: "Contact Lifecycle #2 DMT MQL"
  }

  join: hubspot_contacts_sql {
    from: hubspot_contacts_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.foreign_key_contacts_table} = ${hubspot_contacts_sql.foreign_key_sql_marketing_filters_allocation} ;;
    view_label: "Contact Lifecycle #3 DMT SQL"
  }

  join: hubspot_contacts_opportunity {
    from: hubspot_contacts_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.foreign_key_contacts_table} = ${hubspot_contacts_opportunity.foreign_key_opportunity_marketing_filters_allocation} ;;
    view_label: "Contact Lifecycle #4 DMT Opportunity"
  }

  join: hubspot_contacts_all {
    from: hubspot_contacts_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel_allocation.foreign_key_contacts_table} = ${hubspot_contacts_all.foreign_key_created_at_date_marketing_filters_allocation} ;;
    view_label: "Contact Lifecycle #0 Create Date"
  }

  join: hubspot_engagement_calls_sales_ext {
    type: full_outer
    relationship: many_to_many
    sql_on: ${marketing_funnel_allocation.foreign_key_bdr_targets} = ${hubspot_engagement_calls_sales_ext.joining_key_date_owner} ;;
    view_label: "Activities: HS Calls"
  }

  join: hubspot_engagement_emails_sales_ext {
    type: full_outer
    relationship: many_to_many
    sql_on: ${marketing_funnel_allocation.foreign_key_bdr_targets} = ${hubspot_engagement_emails_sales_ext.joining_key_date_owner} ;;
    view_label: "Activities: HS Emails"
  }

  join: hubspot_engagement_meetings_sales_ext {
    type: full_outer
    relationship: many_to_many
    sql_on: ${marketing_funnel_allocation.foreign_key_bdr_targets} = ${hubspot_engagement_meetings_sales_ext.joining_key_date_owner} ;;
    view_label: "Activities: HS Meetings HubSpot (meeting date)"
  }

  join: meetings_on_create_date {
    from: hubspot_engagement_meetings_sales_ext
    type: full_outer
    relationship: many_to_many
    sql_on: ${marketing_funnel_allocation.foreign_key_bdr_targets} = ${meetings_on_create_date.joining_key_create_date_owner} ;;
    view_label: "Activities: HS Meetings HubSpot (create date)"
  }

  join: salesloft_meetings_occured_at_date {
    from: salesloft_meetings_held_ext
    type: full_outer
    relationship: many_to_many
    sql_on: ${marketing_funnel_allocation.foreign_key_bdr_targets} = ${salesloft_meetings_occured_at_date.foreign_key_date_name} ;;
    view_label: "Activities: SL Meetings Held (occured at)"
  }

  join: hubspot_sao_marketing_influenced {
    from: hubspot_deal_marketing_influence_touchpoint_ext
    type: left_outer
    relationship: many_to_many
    sql_on: ${hubspot_sao.deal_id} = ${hubspot_sao_marketing_influenced.deal_id}
      AND ${hubspot_sao.dmt_sao_date} IS NOT NULL
      AND ${hubspot_sao.new_business_vs_upsell} IN ('New Business', 'Upsell')
      AND ${hubspot_sao_marketing_influenced.event_date_date} < ${hubspot_sao_marketing_influenced.dmt_sao_date}
      AND ${hubspot_sao_marketing_influenced.event_date_date} > ${hubspot_sao_marketing_influenced.created_at_date_date};;
    view_label: "Deal #2 DMT SAO - Marketing Influenced"
  }

  join: hubspot_closed_won_marketing_influenced {
    from: hubspot_deal_marketing_influence_touchpoint_ext
    type: left_outer
    relationship: many_to_many
    sql_on: ${hubspot_closed_won.deal_id} = ${hubspot_closed_won_marketing_influenced.deal_id}
      AND ${hubspot_closed_won.dmt_closed_won_date} IS NOT NULL
      AND ${hubspot_closed_won.new_business_vs_upsell} IN ('New Business', 'Upsell')
      AND ${hubspot_closed_won_marketing_influenced.event_date_date} < ${hubspot_closed_won_marketing_influenced.dmt_closed_won_date}
      AND ${hubspot_closed_won_marketing_influenced.event_date_date} > ${hubspot_closed_won_marketing_influenced.created_at_date_date};;
    view_label: "Deal #8 Closed Won - Marketing Influenced"
  }
}

### ------- END OF GTM FUNNEL (ALLOCATION ------------------------------------------------------------- ###

### ------- GTM FUNNEL (SEGMENT) -------------------------------------------------------------- ###

explore: marketing_funnel {

  fields: [ALL_FIELDS*
          ,-hubspot_sal.all_datamart_hubspot_customers_all_related_fields*
          ,-hubspot_sao.all_datamart_hubspot_customers_all_related_fields*
          ,-hubspot_closed_won.all_datamart_hubspot_customers_all_related_fields*
          ]

  from: marketing_filters_ext
  label: "OLD - GTM Funnel (Segment) - OLD"
  description: "NOT USED SINCE 2025. To-go explore for analysing anything related to the Sales Funnel (Marketing lifecycle stages, Sales funnel stages, Sales Activities"
  view_label: "*Flat table - central"
  persist_for: "6 hours"

  join: hubspot_sal {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.primary_key} = ${hubspot_sal.foreign_key_sal_marketing_filters} ;;
    view_label: "Deal #1 DMT SAL"
  }

  join: hubspot_sao {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.primary_key} = ${hubspot_sao.foreign_key_sao_marketing_filters} ;;
    view_label: "Deal #2 DMT SAO"
  }

  join: hubspot_solution_design {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.primary_key} = ${hubspot_solution_design.foreign_key_solution_design_marketing_filters} ;;
    view_label: "Deal #3 DMT Solution Design"
  }

  join: hubspot_evaluation {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.primary_key} = ${hubspot_evaluation.foreign_key_evaluation_marketing_filters} ;;
    view_label: "Deal #4 DMT Evaluation"
  }

  join: hubspot_proposal {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.primary_key} = ${hubspot_proposal.foreign_key_proposal_marketing_filters} ;;
    view_label: "Deal #5 DMT Proposal"
  }

  join: hubspot_negotiation {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.primary_key} = ${hubspot_negotiation.foreign_key_negotiations_marketing_filters} ;;
    view_label: "Deal #6 DMT Negotiation"
  }

  join: hubspot_closing_validation {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.primary_key} = ${hubspot_closing_validation.foreign_key_closing_validation_marketing_filters} ;;
    view_label: "Deal #7 DMT Closing Validation"
  }

  join: hubspot_closed_won {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.primary_key} = ${hubspot_closed_won.foreign_key_closed_won_marketing_filters} ;;
    view_label: "Deal #8 DMT Closed Won"
  }

  join: hubspot_closed_lost {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.primary_key} = ${hubspot_closed_lost.foreign_key_closed_lost_marketing_filters} ;;
    view_label: "Deal #9 DMT Closed Lost"
  }

  join: hubspot_close_date {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.primary_key} = ${hubspot_close_date.foreign_key_close_date_marketing_filters} ;;
    view_label: "Deal # Close Date"
  }

  join: hubspot_expected_sd_date {
    from: hubspot_deals_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.primary_key} = ${hubspot_expected_sd_date.foreign_key_expected_sd_date_marketing_filters} ;;
    view_label: "Deal # Expected SD Date"
  }

  join: hubspot_pipeline_volume_shapshots {
    from: gtm_sales_pipeline_over_time_ext
    type: full_outer
    relationship: many_to_many
    sql_on: ${marketing_funnel.date_date} = ${hubspot_pipeline_volume_shapshots.period_date} AND ${marketing_funnel.segment} = ${hubspot_pipeline_volume_shapshots.deal_segment} ;;
    view_label: "Deal # Pipe Volume Snapshots"
  }

  join: hubspot_contacts_lead {
    from: hubspot_contacts_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.foreign_key_contacts_table} = ${hubspot_contacts_lead.foreign_key_lead_marketing_filters} ;;
    view_label: "Contact Lifecycle #1 DMT Lead"
  }

  join: hubspot_contacts_mql {
    from: hubspot_contacts_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.foreign_key_contacts_table} = ${hubspot_contacts_mql.foreign_key_mql_marketing_filters} ;;
    view_label: "Contact Lifecycle #2 DMT MQL"
  }

  join: hubspot_contacts_sql {
    from: hubspot_contacts_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.foreign_key_contacts_table} = ${hubspot_contacts_sql.foreign_key_sql_marketing_filters} ;;
    view_label: "Contact Lifecycle #3 DMT SQL"
  }

  join: hubspot_contacts_opportunity {
    from: hubspot_contacts_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.foreign_key_contacts_table} = ${hubspot_contacts_opportunity.foreign_key_opportunity_marketing_filters} ;;
    view_label: "Contact Lifecycle #4 DMT Opportunity"
  }

  join: hubspot_contacts_all {
    from: hubspot_contacts_all_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_funnel.foreign_key_contacts_table} = ${hubspot_contacts_all.foreign_key_created_at_date_marketing_filters} ;;
    view_label: "Contact Lifecycle #0 Create Date"
  }

  join: hubspot_engagement_calls_sales_ext {
    type: full_outer
    relationship: many_to_many
    sql_on: ${marketing_funnel.foreign_key_bdr_targets} = ${hubspot_engagement_calls_sales_ext.joining_key_date_owner} ;;
    view_label: "Activities: HS Calls"
  }

  join: hubspot_engagement_emails_sales_ext {
    type: full_outer
    relationship: many_to_many
    sql_on: ${marketing_funnel.foreign_key_bdr_targets} = ${hubspot_engagement_emails_sales_ext.joining_key_date_owner} ;;
    view_label: "Activities: HS Emails"
  }

  join: hubspot_engagement_meetings_sales_ext {
    type: full_outer
    relationship: many_to_many
    sql_on: ${marketing_funnel.foreign_key_bdr_targets} = ${hubspot_engagement_meetings_sales_ext.joining_key_date_owner} ;;
    view_label: "Activities: HS Meetings HubSpot (meeting date)"
  }
  #test

  join: meetings_on_create_date {
    from: hubspot_engagement_meetings_sales_ext
    type: full_outer
    relationship: many_to_many
    sql_on: ${marketing_funnel.foreign_key_bdr_targets} = ${meetings_on_create_date.joining_key_create_date_owner} ;;
    view_label: "Activities: HS Meetings HubSpot (create date)"
  }

  join: salesloft_meetings_occured_at_date {
    from: salesloft_meetings_held_ext
    type: full_outer
    relationship: many_to_many
    sql_on: ${marketing_funnel.foreign_key_bdr_targets} = ${salesloft_meetings_occured_at_date.foreign_key_date_name} ;;
    view_label: "Activities: SL Meetings Held (occured at)"
  }

}

### ------- END OF GTM FUNNEL (SEGMENT) ------------------------------------------------------------- ###
### ------- MARKETING COSTS & EVENT SPECIFIC TARGETS (GROWTH MARKETING)

explore: marketing_costs_and_targets_ext {
  label: "Growth Marketing Costs & Targets"
}

### ------- ACCOUNT SCORING  -------------------------------------------------------------- ###

explore: account_scoring_v2 {
  from: marketing_account_scoring_accounts_ext
  label: "Account Dash - all touchpoints"
  view_label: "Account Scoring: Accounts & Contacts"
  persist_for: "6 hours"

  join: linkedin_impressions_per_account_per_day {
    from: linkedin_ad_performance_pivots_ext
    type: left_outer
    relationship: one_to_many
    sql_on: ${account_scoring_v2.account_id} = ${linkedin_impressions_per_account_per_day.hubspot_company_id} ;;
    view_label: "LinkedIn Impressions/Clicks"
  }

  join: account_scoring_all_touchpoints {
    from: marketing_account_scoring_all_touchpoints_ext
    type: full_outer
    relationship: one_to_many
    # Linkedin impression and clicks do not match with an account
    sql_on: ${account_scoring_v2.account_contact_foreign_key} = ${account_scoring_all_touchpoints.account_contact_foreign_key};;
    view_label: "Account Scoring: Touchpoints"
  }

  join: marketing_costs_and_targets_ext {
    type:  inner
    sql_on: ${account_scoring_all_touchpoints.touchpoint_details} = ${marketing_costs_and_targets_ext.source_channel_drilldown} ;;
    relationship: many_to_one
  }

  # join: accounts_on_dmt_lead   {
  #   from: marketing_account_scoring_accounts_ext
  #   type: left_outer
  #   relationship: one_to_many
  #   sql_on: ${account_scoring_all_touchpoints.account_contact_foreign_key} = ${account_scoring_v2.account_contact_foreign_key}
  #           AND ${account_scoring_all_touchpoints.touchpoint_timestamp_date} = ${account_scoring_v2.contact_dmt_lead_date};;
  #   view_label: "Accounts & Contacts (dmt Lead on Event Date)"

  # }
}

### ------- END OF ACCOUNT SCORING -------------------------------------------------------- ###

### ------- ACCOUNT SCORING ROLLING DATE RANGES ------------------------------------------- ###

### ------- SAOs per AE per Channel over time  ----------------------------------- ###

### ------- AWARENESS ------------------------------------------------------------ ###

explore: marketing_awareness {
  from: marketing_awareness_flat_table_ext
  label: "Awareness"
  view_label: "Flat Table"
  persist_for: "6 hours"

  join: ga4_data {
    from: ga4_events_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_awareness.primary_key} = ${ga4_data.foreign_key} ;;
    view_label: "GA4 data"
  }

  join: form_submissions_data {
    from: marketing_touchpoints_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_awareness.primary_key} = ${form_submissions_data.awareness_dash_foreign_key} ;;
    view_label: "Form Submissions data"
  }

  join: search_console_data {
    from: search_console_site_searches_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_awareness.primary_key} = ${search_console_data.foreign_key} ;;
    view_label: "Search Console data - site"
  }

  join: search_console_data_url_level {
    from: search_console_url_searches_ext
    type: full_outer
    relationship: one_to_many
    sql_on: ${marketing_awareness.primary_key} = ${search_console_data_url_level.foreign_key} ;;
    view_label: "Search Console data - url"
  }

}

### ------- AWARENESS SEISMIC ------------------------------------------------------ ###

