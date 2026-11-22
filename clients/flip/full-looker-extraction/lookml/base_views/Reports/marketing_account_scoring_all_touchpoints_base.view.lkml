view: marketing_account_scoring_all_touchpoints_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.marketing_account_scoring_all_touchpoints` ;;

  dimension: account_contact_foreign_key {
    type: string
    sql: ${TABLE}.account_contact_foreign_key ;;
  }
  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }
  dimension: cost_euros {
    type: number
    sql: ${TABLE}.cost_euros ;;
  }
  dimension: hubspot_object_id {
    type: string
    sql: ${TABLE}.hubspot_object_id ;;
  }
  dimension: hubspot_object_source_channel {
    type: string
    sql: ${TABLE}.hubspot_object_source_channel ;;
  }
  dimension: hubspot_object_source_channel_cluster_hubspot {
    type: string
    sql: ${TABLE}.hubspot_object_source_channel_cluster_hubspot ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  dimension: touchpoint_details {
    type: string
    sql: ${TABLE}.touchpoint_details ;;
  }
  dimension_group: touchpoint_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.touchpoint_timestamp ;;
  }
  dimension_group: touchpoint_timestamp_end {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.touchpoint_timestamp_end ;;
  }
  dimension_group: touchpoint_timestamp_start {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.touchpoint_timestamp_start ;;
  }
  dimension: touchpoint_type {
    type: string
    sql: ${TABLE}.touchpoint_type ;;
  }
  dimension: touchpoint_url {
    type: string
    sql: ${TABLE}.touchpoint_url ;;
  }
  measure: count {
    type: count
  }
}
