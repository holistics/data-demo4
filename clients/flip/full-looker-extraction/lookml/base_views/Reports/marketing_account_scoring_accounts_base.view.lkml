view: marketing_account_scoring_accounts_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.marketing_account_scoring_accounts` ;;

  dimension: account_allocation {
    type: string
    sql: ${TABLE}.account_allocation ;;
  }
  dimension: account_bdr {
    type: string
    sql: ${TABLE}.account_bdr ;;
  }
  dimension: account_bombora_intent_score {
    type: string
    sql: ${TABLE}.account_bombora_intent_score ;;
  }
  dimension: account_bombora_research_stage {
    type: string
    sql: ${TABLE}.account_bombora_research_stage ;;
  }
  dimension: account_classification {
    type: string
    sql: ${TABLE}.account_classification ;;
  }
  dimension: account_contact_foreign_key {
    type: string
    sql: ${TABLE}.account_contact_foreign_key ;;
  }
  dimension: account_deal_foreign_key {
    type: string
    sql: ${TABLE}.account_deal_foreign_key ;;
  }
  dimension: account_domain {
    type: string
    sql: ${TABLE}.account_domain ;;
  }
  dimension: account_g2_buyer_intent_buying_stage {
    type: string
    sql: ${TABLE}.account_g2_buyer_intent_buying_stage ;;
  }
  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }
  dimension: account_industry {
    type: string
    sql: ${TABLE}.account_industry ;;
  }
  dimension: account_intent_score {
    type: number
    sql: ${TABLE}.account_intent_score ;;
  }
  dimension: account_last_activity_date {
    type: string
    sql: ${TABLE}.account_last_activity_date ;;
  }
  dimension: account_last_contacted_date {
    type: string
    sql: ${TABLE}.account_last_contacted_date ;;
  }
  dimension: account_last_engagement_date {
    type: string
    sql: ${TABLE}.account_last_engagement_date ;;
  }
  dimension: account_linkedin_page {
    type: string
    sql: ${TABLE}.account_linkedin_page ;;
  }
  dimension: account_marketing_campaigns_memberships {
    type: string
    sql: ${TABLE}.account_marketing_campaigns_memberships ;;
  }
  dimension: account_name {
    type: string
    sql: ${TABLE}.account_name ;;
  }
  dimension: account_other_technologies {
    type: string
    sql: ${TABLE}.account_other_technologies ;;
  }
  dimension: account_owner {
    type: string
    sql: ${TABLE}.account_owner ;;
  }
  dimension: account_region {
    type: string
    sql: ${TABLE}.account_region ;;
  }
  dimension: account_sales_nav_category_interest {
    type: string
    sql: ${TABLE}.account_sales_nav_category_interest ;;
  }
  dimension: account_segment {
    type: string
    sql: ${TABLE}.account_segment ;;
  }
  dimension: account_territory {
    type: string
    sql: ${TABLE}.account_territory ;;
  }
  dimension: contact_bombora_intent_score {
    type: string
    sql: ${TABLE}.contact_bombora_intent_score ;;
  }
  dimension: contact_bombora_research_stage {
    type: string
    sql: ${TABLE}.contact_bombora_research_stage ;;
  }
  dimension: contact_department_categorised {
    type: string
    sql: ${TABLE}.contact_department_categorised ;;
  }
  dimension: contact_department_raw {
    type: string
    sql: ${TABLE}.contact_department_raw ;;
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
  dimension_group: contact_dmt_opportunity {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contact_dmt_opportunity ;;
  }
  dimension_group: contact_dmt_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contact_dmt_sao ;;
  }
  dimension_group: contact_dmt_sql {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contact_dmt_sql ;;
  }
  dimension: contact_email {
    type: string
    sql: ${TABLE}.contact_email ;;
  }
  dimension: contact_id {
    type: string
    sql: ${TABLE}.contact_id ;;
  }
  dimension: contact_job_title_raw {
    type: string
    sql: ${TABLE}.contact_job_title_raw ;;
  }
  dimension_group: contact_last_activity {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contact_last_activity_date ;;
  }
  dimension_group: contact_last_contacted {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contact_last_contacted_date ;;
  }
  dimension_group: contact_last_engagement {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contact_last_engagement_date ;;
  }
  dimension: contact_lifecycle_stage {
    type: string
    sql: ${TABLE}.contact_lifecycle_stage ;;
  }
  dimension: contact_marketing_campaigns_memberships {
    type: string
    sql: ${TABLE}.contact_marketing_campaigns_memberships ;;
  }
  dimension: contact_name {
    type: string
    sql: ${TABLE}.contact_name ;;
  }
  dimension: contact_project_status {
    type: string
    sql: ${TABLE}.contact_project_status ;;
  }
  dimension: contact_seniority_categorised {
    type: string
    sql: ${TABLE}.contact_seniority_categorised ;;
  }
  dimension: contact_source_channel_hubspot {
    type: string
    sql: ${TABLE}.contact_source_channel_hubspot ;;
  }
  dimension: contact_source_channel_cluster_hubspot {
    type: string
    sql: ${TABLE}.contact_source_channel_cluster_hubspot ;;
  }
  dimension: contact_source_channel_department_hubspot {
    type: string
    sql: ${TABLE}.contact_source_channel_department_hubspot ;;
  }
  dimension: contact_source_channel_drilldown_hubspot {
    type: string
    sql: ${TABLE}.contact_source_channel_drilldown_hubspot ;;
  }
  dimension: contact_trade_show_owner {
    type: string
    sql: ${TABLE}.contact_trade_show_owner ;;
  }
  dimension_group: deal_created_at {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.deal_created_at_date ;;
  }
  dimension: deal_current_amount_euros {
    type: number
    sql: ${TABLE}.deal_current_amount_euros ;;
  }
  dimension: deal_current_amount_in_record_currency {
    type: number
    sql: ${TABLE}.deal_current_amount_in_record_currency ;;
  }
  dimension_group: deal_dmt_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.deal_dmt_sao ;;
  }
  dimension: deal_id {
    type: string
    sql: ${TABLE}.deal_id ;;
  }
  dimension: deal_initial_sao_amount_euros {
    type: number
    sql: ${TABLE}.deal_initial_sao_amount_euros ;;
  }
  dimension: deal_initial_sao_amount_in_record_currency {
    type: number
    sql: ${TABLE}.deal_initial_sao_amount_in_record_currency ;;
  }
  dimension: deal_name {
    type: string
    sql: ${TABLE}.deal_name ;;
  }
  dimension: deal_owner_name {
    type: string
    sql: ${TABLE}.deal_owner_name ;;
  }
  dimension: deal_source_channel_cluster_hubspot {
    type: string
    sql: ${TABLE}.deal_source_channel_cluster_hubspot ;;
  }
  dimension: deal_source_channel_department_hubspot {
    type: string
    sql: ${TABLE}.deal_source_channel_department_hubspot ;;
  }
  dimension: deal_source_channel_drilldown_hubspot {
    type: string
    sql: ${TABLE}.deal_source_channel_drilldown_hubspot ;;
  }
  dimension: has_account_sales_nav_buyer_intent {
    type: yesno
    sql: ${TABLE}.has_account_sales_nav_buyer_intent ;;
  }
  dimension: is_account_in_crm {
    type: yesno
    sql: ${TABLE}.is_account_in_crm ;;
  }
  dimension: is_account_tam {
    type: yesno
    sql: ${TABLE}.is_account_tam ;;
  }
  dimension: is_contact_in_crm {
    type: yesno
    sql: ${TABLE}.is_contact_in_crm ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  dimension: ranking {
    type: number
    sql: ${TABLE}.ranking ;;
  }
  dimension: stage_label {
    type: string
    sql: ${TABLE}.stage_label ;;
  }
  measure: count {
    type: count
    drill_fields: [deal_owner_name, account_name, contact_name, deal_name]
  }
}
