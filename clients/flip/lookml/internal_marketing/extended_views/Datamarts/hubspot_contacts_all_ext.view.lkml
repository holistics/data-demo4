include: "/base_views/Datamarts/hubspot_contacts_all_base.view"

view: hubspot_contacts_all_ext {
  extends: [hubspot_contacts_all_base]

  drill_fields: [contact_id, company_name, contact_source_channel_cluster_hubspot, contact_source_channel_department_hubspot, life_cycle_stage]

# ----- BASE DIMENSIONS --------------------------------------------------------------------------

  dimension_group: associated_deal_first_dmt_sao {
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

  dimension: campaign_or_event {
    type: string
  }

  dimension: company_id {
    type: string
  }

  dimension: company_industry {
    type: string
  }

  dimension: company_name {
    type: string
  }

  dimension: company_segment {
    type: string
  }

  dimension: company_region {
    type: string
  }

  dimension: company_is_workplace_partner {
    type: yesno
    label: "Company Is Workplace Partner"
  }

  dimension: contact_allocation {
    type: string
  }

  dimension: contact_id {
    type: string
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/contact/{{ contact_id }}"
    }
    primary_key: yes
  }

  dimension: contact_source_channel_cluster_hubspot {
    type: string
  }
  dimension: contact_source_channel_department_hubspot {
    type: string
  }
  dimension: contact_source_channel_drilldown_hubspot {
    type: string
  }
  dimension: contact_source_channel_hubspot {
    type: string
  }
  dimension: contact_source_channel_inbound_vs_outbound_hubspot {
    type: string
  }

  dimension_group: create {
    type: time
    timeframes: [
      raw,
      date,
      week,
      week_of_year,
      month,
      month_name,
      quarter,
      quarter_of_year,
      year
    ]
    convert_tz: no
    datatype: date
    drill_fields: []
    description: "Date on which the contact was created in HubSpot."
  }

  dimension_group: dmt_subscriber {
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
    label: "Date - Lifecycle Subscriber"
  }

  dimension_group: dmt_lead {
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
    label: "Date - Lifecycle Lead"
  }

  dimension_group: dmt_mql {
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
    label: "Date - Lifecycle MQL"
  }

  dimension_group: dmt_sql {
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
    label: "Date - Lifecycle SQL"
  }

  dimension_group: dmt_opportunity {
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
    label: "Date - Lifecycle Opportunity"
  }

  dimension_group: dmt_customer {
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
    label: "Date - Lifecycle Customer"
  }

  dimension: days_in_mql {
    type: number
    label: "Days in MQL"
  }

  dimension: days_in_sql {
    type: number
    label: "Days in SQL"
  }

  dimension: days_from_lead_to_mql {
    type: number
  }

  dimension: days_from_mql_to_sql {
    type: number
  }

  dimension: days_from_sql_to_opportunity {
    type: number
  }

  dimension: days_from_sql_to_sao {
    type: number
  }

  dimension: department {
    type: string
  }

  dimension: foreign_key_created_at_date_marketing_filters {
    type: string
    hidden: yes
  }
  dimension: foreign_key_created_at_date_marketing_filters_allocation {
    type: string
    hidden: yes
  }

  dimension: foreign_key_mql_bdr_dashboard {
    type: string
  }

  dimension: foreign_key_sql_bdr_dashboard {
    type: string
  }

  dimension: foreign_key_lead_campaign_management {
    type: string
    hidden: yes
  }

  dimension: foreign_key_mql_campaign_management {
    type: string
    hidden: yes
  }

  dimension: foreign_key_sql_campaign_management {
    type: string
    hidden: yes
  }

  dimension: foreign_key_opportunity_campaign_management {
    type: string
    hidden: yes
  }

  dimension: foreign_key_lead_marketing_filters {
    type: string
  }

  dimension: foreign_key_lead_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_mql_marketing_filters {
    type: string
  }

  dimension: foreign_key_mql_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_opportunity_marketing_filters {
    type: string
  }

  dimension: foreign_key_opportunity_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_sql_marketing_filters {
    type: string
  }

  dimension: foreign_key_sql_marketing_filters_allocation {
    type: string
  }

  dimension: foreign_key_rd_lead {
    type: string
  }

  dimension: foreign_key_rd_mql {
    type: string
  }

  dimension: grouped_campaign {
    type: string
  }

  dimension: has_contact_converted_from_lead_to_mql {
    type: yesno
  }

  dimension: has_contact_converted_from_mql_to_sql {
    type: yesno
  }

  dimension: has_contact_converted_from_sql_to_opportunity {
    type: yesno
  }

  dimension: has_contact_ever_been_lead {
    type: yesno
  }

  dimension: has_contact_ever_been_mql {
    type: yesno
  }

  dimension: has_contact_ever_been_sql {
    type: yesno
  }

  dimension: has_contact_ever_been_opportunity {
    type: yesno
  }

  dimension: hubspot_score {
    type: number
  }

  dimension_group: last_modified {
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

  dimension: lead_score {
    type: number
  }

  dimension: lead_status {
    type: string
  }

  dimension: life_cycle_stage {
    type: string
    label: "Current Lifecycle Stage"
  }

  dimension: marketing_emails_clicked {
    type: string
  }

  dimension: marketing_emails_delivered {
    type: string
  }

  dimension: marketing_emails_open {
    type: string
  }

  dimension: marketing_emails_replied {
    type: string
  }

  dimension: number_of_form_submissions {
    type: string
  }

  dimension: number_of_page_views {
    type: string
  }

  dimension: number_of_sessions {
    type: string
  }

  dimension: has_partner_marketing_influence {
    type: string
  }

  dimension: source_channel {
    type: string
    label: "Source Channel OLD"
  }

  dimension: workplace_customer {
    type: yesno
    label: "Workplace Customer"
  }

  dimension: workplace_user {
    type: yesno
    label: "Workplace User"
  }

  dimension: source_channel_drilldown {
    type: string
    label: "Source Channel Drilldown OLD"
  }

  dimension: trade_show {
    type: string
  }

  dimension_group: time_last_seen {
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

  dimension_group: time_of_last_session {
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

  # ----- MANUALLY ADDED DIMENSIONS ---------------------------------------------------------

  dimension: lifecyclestage_subscriber_drilldown {
    type: string
    sql: ${dmt_lead_date} ;;
    label: "Subscriber Date"
    hidden: yes
    description: "Date on which the Contact was moved to Life Cycle Stage = Subscriber."
  }

  dimension: lifecyclestage_lead_drilldown {
    type: string
    sql: ${dmt_lead_date} ;;
    label: "Lead Date"
    hidden: yes
    description: "Date on which the Contact was moved to Life Cycle Stage = Lead."
  }

  dimension: lifecyclestage_mql_drilldown {
    type: string
    sql: ${dmt_mql_date} ;;
    label: "MQL Date"
    hidden: yes
    description: "Date on which the Contact was moved to Life Cycle Stage = MQL."
  }

  dimension: lifecyclestage_sql_drilldown {
    type: string
    sql: ${dmt_sql_date} ;;
    label: "SQL Date"
    hidden: yes
    description: "Date on which the Contact was moved to Life Cycle Stage = SQL."
  }

  dimension: lifecyclestage_opportunity_drilldown {
    type: string
    sql: ${dmt_opportunity_date} ;;
    label: "Opportunity Date"
    hidden: yes
    description: "Date on which the Contact was moved to Life Cycle Stage = Opportunity."
  }

  dimension: lifecyclestage_customer_drilldown {
    type: string
    sql: ${dmt_customer_date} ;;
    label: "Lifecycle Stage Opportunity Date"
    hidden: yes
    description: "Date on which the Contact was moved to Life Cycle Stage = Customer."
  }

  dimension: dmt_deal_stage_sao_drilldown {
    type: string
    sql: ${associated_deal_first_dmt_sao_date} ;;
    label: "Deal Stage SAO Date"
    hidden: yes
    description: "Date on which the Deal associated to the Contact was moved to SAO stage"
  }

  # ----- MEASURES --------------------------------------------------------------------------

  measure: count {
    type: count
    hidden: no
    label: "# Contacts"
    drill_fields: [contact_id, company_name, contact_source_channel_cluster_hubspot, contact_source_channel_department_hubspot, life_cycle_stage]
  }

  # ----- FILTERED COUNT OF CONTACTS --------------------------------------------------------

  measure: lead_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_lead_date: "-NULL"]
    drill_fields: [contact_id, company_name, contact_allocation, company_segment, company_region, life_cycle_stage, lead_status, hubspot_score, department, contact_source_channel_cluster_hubspot, contact_source_channel_drilldown_hubspot, campaign_or_event, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, dmt_deal_stage_sao_drilldown]
    label: "1# Leads created"
  }

  measure: mql_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_mql_date: "-NULL"]
    drill_fields: [contact_id, lead_status, hubspot_score, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, dmt_deal_stage_sao_drilldown, days_from_mql_to_sql]
    label: "2# MQLs created"
  }

  measure: sql_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_sql_date: "-NULL"]
    drill_fields: [contact_id, lead_status, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, dmt_deal_stage_sao_drilldown, days_from_sql_to_sao_avg]
    label: "3# SQLs created"
  }

  measure: sql_count_distinct_companies {
    type: count_distinct
    sql: ${company_id} ;;
    filters: [dmt_sql_date: "-NULL"]
    drill_fields: [contact_id, lead_status, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, dmt_deal_stage_sao_drilldown, days_from_sql_to_sao_avg]
    label: "3.1# SQLs created (distinct companies)"
  }

  measure: opportunity_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_opportunity_date: "-NULL"]
    drill_fields: [contact_id, lead_status, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, dmt_deal_stage_sao_drilldown]
    label: "4# Opportunities created"
  }

  measure: sao_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [associated_deal_first_dmt_sao_date: "-NULL"]
    drill_fields: [contact_id, lead_status, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, dmt_deal_stage_sao_drilldown]
    label: "5# SAOs created"
  }

  measure: customer_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_customer_date: "-NULL"]
    drill_fields: [contact_id, lead_status, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, dmt_deal_stage_sao_drilldown, lifecyclestage_customer_drilldown]
    label: "6# Customers created"
  }

  measure: still_lead_stage {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [life_cycle_stage: "lead"]
    drill_fields: [contact_id, lead_status, hubspot_score, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown]
    label: "Still in 1# Lead Lifecycle Stage"
  }

  measure: still_mql_stage {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [life_cycle_stage: "marketingqualifiedlead"]
    drill_fields: [contact_id, lead_status, hubspot_score, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, days_in_mql_sum]
    label: "Still in 2# MQL Lifecycle Stage"
    order_by_field: days_in_mql_sum
  }

  measure: still_sql_stage {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [life_cycle_stage: "salesqualifiedlead"]
    drill_fields: [contact_id, lead_status, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, days_in_sql_sum]
    label: "Still in 3# SQL Lifecycle Stage"
    order_by_field: days_in_sql_sum
  }

  measure: still_opportunity_stage {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [life_cycle_stage: "opportunity"]
    drill_fields: [contact_id, lead_status, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown]
    label: "Still in 4# Opportunity Lifecycle Stage"
  }

  measure: lead_to_mql_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_lead_date: "-NULL", dmt_mql_date: "-NULL"]
    drill_fields: [contact_id, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, contact_source_channel_drilldown_hubspot, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown]
    label: "For CR - Lead to MQL Count"
  }

  measure: mql_to_sql_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_mql_date: "-NULL", dmt_sql_date: "-NULL"]
    drill_fields: [contact_id, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, contact_source_channel_drilldown_hubspot, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown]
    label: "For CR - MQL to SQL Count"
  }

  measure: sql_to_opportunity_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_sql_date: "-NULL", dmt_opportunity_date: "-NULL"]
    drill_fields: [contact_id, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, contact_source_channel_drilldown_hubspot, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown]
    label: "For CR - SQL to Opportunity Count"
  }

  measure: days_in_mql_sum {
    type: sum_distinct
    sql: ${days_in_mql} ;;
    drill_fields: [contact_id, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, contact_source_channel_drilldown_hubspot, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown]
    label: "Days in MQL"
  }

  measure: days_in_sql_sum {
    type: sum_distinct
    sql: ${days_in_sql} ;;
    drill_fields: [contact_id, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, contact_source_channel_drilldown_hubspot, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown]
    label: "Days in SQL"
  }

  measure: mqls_disqualified_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_mql_date: "-NULL", lead_status: "Unqualified", dmt_sql_date: "NULL"]
    drill_fields: [contact_id, lead_status, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, days_in_mql_sum]
    label: "# MQLs Unqualified"
    description: "Count of MQLs which have Lead Status = Unqualified"
  }

  measure: mqls_other_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_mql_date: "-NULL", lead_status: "-Unqualified, -Open", dmt_sql_date: "NULL"]
    drill_fields: [contact_id, lead_status, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, days_in_mql_sum]
    label: "# MQLs Other"
    description: "Count of MQLs which did not convert to SQL and do not have Lead Status = Unqualified or Open"
  }

  measure: still_mql_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_mql_date: "-NULL", life_cycle_stage: "marketingqualifiedlead", lead_status: "Open", dmt_sql_date: "NULL"]
    drill_fields: [contact_id, lead_status, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, days_in_mql_sum]
    label: "# MQLs still Open MQL"
    description: "Count of MQLs which have Lead Status = Open and are still in the MQL stage"
  }

  measure: still_sql_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_sql_date: "-NULL", life_cycle_stage: "salesqualifiedlead", dmt_opportunity_date: "NULL"]
    drill_fields: [contact_id, lead_status, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, days_in_sql_sum]
    label: "# SQLs still Open SQL"
    description: "Count of SQLs which are still in the SQL stage"
  }

  measure: sqls_lost_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_sql_date: "-NULL", life_cycle_stage: "-salesqualifiedlead,-opportunity", dmt_opportunity_date: "NULL"]
    drill_fields: [contact_id, lead_status, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown]
    label: "# SQLs Lost"
    description: "Count ofSMQLs which did not convert to S0 and are not in SQL stage anymore"
  }

  # ----- MEASURES FOR CONTACTS -------------------------------------------------------------

  measure: days_from_lead_to_mql_avg {
    type: average
    sql: ${days_from_lead_to_mql} ;;
    filters: [dmt_lead_date: "-NULL", dmt_mql_date: "-NULL"]
    drill_fields: [contact_id, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, contact_source_channel_drilldown_hubspot, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, days_from_lead_to_mql_avg]
    label: "Days from 1# Lead to 2# MQL"
    value_format: "0.0"
  }

  measure: days_from_mql_to_sql_avg {
    type: average
    sql: ${days_from_mql_to_sql} ;;
    filters: [dmt_mql_date: "-NULL", dmt_sql_date: "-NULL"]
    drill_fields: [contact_id, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, contact_source_channel_drilldown_hubspot, life_cycle_stage, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, days_from_mql_to_sql_avg]
    label: "Days from 2# MQL to #3 SQL"
    value_format: "0.0"
  }

  measure: days_from_mql_to_sql_median {
    type: median
    sql: ${days_from_mql_to_sql} ;;
    filters: [dmt_mql_date: "-NULL", dmt_sql_date: "-NULL"]
    drill_fields: [contact_id, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, contact_source_channel_drilldown_hubspot, life_cycle_stage, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, days_from_mql_to_sql]
    label: "Days from 2# MQL to #3 SQL - Median"
    description: "Represents the middle value in a dataset - 50% of the cases are above this value and the other 50% below it"
    value_format: "0"
  }

  measure: days_from_sql_to_opportunity_avg {
    type: average
    sql: ${days_from_sql_to_opportunity} ;;
    filters: [dmt_sql_date: "-NULL", dmt_opportunity_date: "-NULL"]
    drill_fields: [contact_id, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, contact_source_channel_drilldown_hubspot, life_cycle_stage, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, days_from_sql_to_opportunity_avg]
    label: "Days from 3# SQL to 4# Opportunity"
    value_format: "0.0"
  }

  measure: days_from_sql_to_sql_median {
    type: median
    sql: ${days_from_sql_to_opportunity} ;;
    filters: [dmt_sql_date: "-NULL", dmt_opportunity_date: "-NULL"]
    drill_fields: [contact_id, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, contact_source_channel_drilldown_hubspot, life_cycle_stage, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, days_from_sql_to_opportunity]
    label: "Days from 3# SQL to 4# Opportunity - Median"
    description: "Represents the middle value in a dataset - 50% of the cases are above this value and the other 50% below it"
    value_format: "0"
  }

  measure: days_from_sql_to_sao_avg {
    type: average
    sql: ${days_from_sql_to_sao} ;;
    filters: [associated_deal_first_dmt_sao_date: "-NULL", dmt_sql_date: "-NULL"]
    drill_fields: [contact_id, lead_status, company_name, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, campaign_or_event, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown, dmt_deal_stage_sao_drilldown, days_from_sql_to_sao_avg]
    label: "Days from SQL to SAO"
    value_format: "0"
  }

  #Conversion Rates between Contact Lifecycle Stages

  measure: funnel_lead_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_lead_date: "-NULL"]
    drill_fields: [contact_id, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, lead_score, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown]
    label: "Funnel - 1# Leads created"
    # value_format_name: percent_0
  }

  measure: funnel_mql_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_lead_date: "-NULL", dmt_mql_date: "-NULL"]
    drill_fields: [contact_id, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown]
    label: "Funnel - 2# Leads to MQL"
  }

  measure: funnel_sql_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_lead_date: "-NULL", dmt_mql_date: "-NULL", dmt_sql_date: "-NULL"]
    drill_fields: [contact_id, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown]
    label: "Funnel - 3# MQLs to SQL"
  }

  measure: funnel_opportunity_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [dmt_lead_date: "-NULL", dmt_mql_date: "-NULL", dmt_sql_date: "-NULL", dmt_opportunity_date: "-NULL"]
    drill_fields: [contact_id, contact_allocation, company_segment, company_region, department, contact_source_channel_cluster_hubspot, life_cycle_stage, lifecyclestage_lead_drilldown, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, lifecyclestage_opportunity_drilldown]
    label: "Funnel - 4# SQLs to Opportunity"
  }

  measure: lead_to_mql_conversion_percent {
    type: number
    sql: SUM(CASE WHEN ${dmt_lead_date} IS NOT NULL AND ${dmt_mql_date} IS NOT NULL THEN 1 ELSE NULL END)/SUM(CASE WHEN ${dmt_lead_date} IS NOT NULL THEN 1 ELSE NULL END) ;;
    # drill_fields: [contact_id, company_segment, company_region, department, contact_source_channel_cluster_hubspot, contact_source_channel_drilldown_hubspot, life_cycle_stage, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, days_from_mql_to_sql_avg]
    label: "Conversion - #1 Lead to MQL"
    value_format_name: percent_0
  }

  measure: mql_to_sql_conversion_percent {
    type: number
    sql: SUM(CASE WHEN ${dmt_lead_date} IS NOT NULL AND${dmt_mql_date} IS NOT NULL AND ${dmt_sql_date} IS NOT NULL THEN 1 ELSE NULL END)/SUM(CASE WHEN ${dmt_lead_date} IS NOT NULL AND ${dmt_mql_date} IS NOT NULL THEN 1 ELSE NULL END) ;;
    # drill_fields: [contact_id, company_segment, company_region, department, contact_source_channel_cluster_hubspot, contact_source_channel_drilldown_hubspot, life_cycle_stage, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, days_from_mql_to_sql_avg]
    label: "Conversion - #2 MQL to SQL"
    value_format_name: percent_0
  }

  measure: sql_to_opp_conversion_percent {
    type: number
    sql: SUM(CASE WHEN ${dmt_lead_date} IS NOT NULL AND ${dmt_mql_date} IS NOT NULL AND ${dmt_sql_date} IS NOT NULL AND ${dmt_opportunity_date} IS NOT NULL THEN 1 ELSE NULL END)/SUM(CASE WHEN ${dmt_lead_date} IS NOT NULL AND ${dmt_mql_date} IS NOT NULL AND ${dmt_sql_date} IS NOT NULL THEN 1 ELSE NULL END) ;;
    # drill_fields: [contact_id, company_segment, company_region, department, contact_source_channel_cluster_hubspot, contact_source_channel_drilldown_hubspot, life_cycle_stage, lifecyclestage_mql_drilldown, lifecyclestage_sql_drilldown, days_from_mql_to_sql_avg]
    label: "Conversion - #3 SQL to Opp"
    value_format_name: percent_0
  }

## ----- TEAM SPECIFIC SETS (for Explores) -----------------------------------------------------------------------------------

## ----- // END OF TEAM SPECIFIC SETS (for Explores) -----------------------------------------------------------------------------------

}
