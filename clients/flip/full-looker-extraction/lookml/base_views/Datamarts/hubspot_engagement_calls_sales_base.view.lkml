view: hubspot_engagement_calls_sales_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.hubspot_engagement_calls_sales` ;;

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
  dimension: associated_contact_name {
    type: string
    sql: ${TABLE}.associated_contact_name ;;
  }
  dimension: call_activity_type {
    type: string
    sql: ${TABLE}.call_activity_type ;;
  }
  dimension: call_body {
    type: string
    sql: ${TABLE}.call_body ;;
  }
  dimension_group: call_create {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.call_create_date ;;
  }
  dimension: call_direction {
    type: string
    sql: ${TABLE}.call_direction ;;
  }
  dimension: call_duration_hours {
    type: number
    sql: ${TABLE}.call_duration_hours ;;
  }
  dimension: call_from_number {
    type: string
    sql: ${TABLE}.call_from_number ;;
  }
  dimension: call_id {
    type: string
    sql: ${TABLE}.call_id ;;
  }
  dimension: call_outcome {
    type: string
    sql: ${TABLE}.call_outcome ;;
  }
  dimension: call_owner_name {
    type: string
    sql: ${TABLE}.call_owner_name ;;
  }
  dimension: call_owner_team {
    type: string
    sql: ${TABLE}.call_owner_team ;;
  }
  dimension: call_to_number {
    type: string
    sql: ${TABLE}.call_to_number ;;
  }
  dimension: hs_call_callee_object_id {
    type: string
    sql: ${TABLE}.hs_call_callee_object_id ;;
  }
  dimension: joining_key_date_owner {
    type: string
    sql: ${TABLE}.joining_key_date_owner ;;
  }
  measure: count {
    type: count
    drill_fields: [associated_contact_name, call_owner_name, associated_company_name]
  }
}
