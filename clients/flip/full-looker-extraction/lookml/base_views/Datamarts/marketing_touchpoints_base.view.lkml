view: marketing_touchpoints_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.marketing_touchpoints` ;;

  dimension: awareness_dash_foreign_key {
    type: string
    sql: ${TABLE}.awareness_dash_foreign_key ;;
  }
  dimension: company_id {
    type: string
    sql: ${TABLE}.company_id ;;
  }
  dimension: company_region {
    type: string
    sql: ${TABLE}.company_region ;;
  }
  dimension: company_segment {
    type: string
    sql: ${TABLE}.company_segment ;;
  }
  dimension: contact_email {
    type: string
    sql: ${TABLE}.contact_email ;;
  }
  dimension: contact_id {
    type: string
    sql: ${TABLE}.contact_id ;;
  }
  dimension: contact_source_channel {
    type: string
    sql: ${TABLE}.contact_source_channel ;;
  }
  dimension: contact_source_channel_cluster_hubspot {
    type: string
    sql: ${TABLE}.contact_source_channel_cluster_hubspot ;;
  }
  dimension: dmt_lead {
    type: string
    sql: ${TABLE}.dmt_lead ;;
  }
  dimension: dmt_mql {
    type: string
    sql: ${TABLE}.dmt_mql ;;
  }
  dimension: dmt_sql {
    type: string
    sql: ${TABLE}.dmt_sql ;;
  }
  dimension: dmt_opportunity {
    type: string
    sql: ${TABLE}.dmt_opportunity ;;
  }
  dimension: form_name {
    type: string
    sql: ${TABLE}.form_name ;;
  }
  dimension: page_url {
    type: string
    sql: ${TABLE}.page_url ;;
  }
  dimension: touchpoint_id {
    type: string
    sql: ${TABLE}.touchpoint_id ;;
  }
  dimension_group: touchpoint_inserted_at_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.touchpoint_inserted_at_timestamp ;;
  }
  dimension_group: touchpoint_occured_at_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.touchpoint_occured_at_timestamp ;;
  }
  dimension: touchpoint_source {
    type: string
    sql: ${TABLE}.touchpoint_source ;;
  }
  dimension: touchpoint_title {
    type: string
    sql: ${TABLE}.touchpoint_title ;;
  }
  dimension: touchpoint_type {
    type: string
    sql: ${TABLE}.touchpoint_type ;;
  }
  measure: count {
    type: count
    drill_fields: [form_name]
  }
}
