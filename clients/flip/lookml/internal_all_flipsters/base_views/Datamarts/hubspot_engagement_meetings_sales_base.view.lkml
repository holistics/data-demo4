view: hubspot_engagement_meetings_sales_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.hubspot_engagement_meetings_sales` ;;

  dimension: associated_company_id {
    type: string
    sql: ${TABLE}.associated_company_id ;;
  }
  dimension: associated_company_name {
    type: string
    sql: ${TABLE}.associated_company_name ;;
  }
  dimension: associated_company_segment {
    type: string
    sql: ${TABLE}.associated_company_segment ;;
  }
  dimension: associated_contact_id {
    type: string
    sql: ${TABLE}.associated_contact_id ;;
  }

  dimension_group: associated_deal_dmt_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.associated_deal_dmt_sao ;;
  }
  dimension: associated_deal_id {
    type: string
    sql: ${TABLE}.associated_deal_id ;;
  }
  dimension: associated_deal_name {
    type: string
    sql: ${TABLE}.associated_deal_name ;;
  }

  dimension: contact_source_channel_cluster_hubspot{
    type: string
    sql: ${TABLE}.contact_source_channel_cluster_hubspot ;;
  }
  dimension: contact_source_channel_inbound_vs_outbound_hubspot{
    type: string
    sql: ${TABLE}.contact_source_channel_inbound_vs_outbound_hubspot ;;
  }
  dimension: deal_source_channel {
    type: string
    sql: ${TABLE}.deal_source_channel ;;
  }
  dimension: deal_source_channel_cluster_hubspot{
    type: string
    sql: ${TABLE}.deal_source_channel_cluster_hubspot ;;
  }
  dimension: is_meeting_created_after_associated_deal_in_sao {
    type: yesno
    sql: ${TABLE}.is_meeting_created_after_associated_deal_in_sao ;;
  }
  dimension: joining_key_create_date_owner {
    type: string
    sql: ${TABLE}.joining_key_create_date_owner ;;
  }
  dimension: joining_key_date_owner {
    type: string
    sql: ${TABLE}.joining_key_date_owner ;;
  }
  dimension: meeting_activity_type {
    type: string
    sql: ${TABLE}.meeting_activity_type ;;
  }
  dimension_group: meeting_create {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.meeting_create_date ;;
  }
  dimension: meeting_duration_hours {
    type: number
    sql: ${TABLE}.meeting_duration_hours ;;
  }
  dimension: meeting_id {
    type: string
    sql: ${TABLE}.meeting_id ;;
  }

  dimension: meeting_outcome {
    type: string
    sql: ${TABLE}.meeting_outcome ;;
  }
  dimension: meeting_owner_name {
    type: string
    sql: ${TABLE}.meeting_owner_name ;;
  }
  dimension: meeting_owner_team {
    type: string
    sql: ${TABLE}.meeting_owner_team ;;
  }
  dimension: meeting_primary_key {
    type: string
    sql: ${TABLE}.meeting_primary_key ;;
  }
  dimension_group: meeting {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.meeting_time ;;
  }

  dimension: row_num {
    type: number
    sql: ${TABLE}.row_num ;;
  }
  measure: count {
    type: count
    drill_fields: [associated_deal_name, associated_company_name, meeting_owner_name]
  }
}
