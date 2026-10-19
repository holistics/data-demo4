view: salesloft_meetings_held_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.salesloft_meetings_held` ;;

  dimension: foreign_key_date_name {
    type: string
    sql: ${TABLE}.foreign_key_date_name ;;
  }
  dimension: hs_meeting_activity_type {
    type: string
    sql: ${TABLE}.hs_meeting_activity_type ;;
  }
  dimension: hs_associated_company_id {
    type: string
    sql: ${TABLE}.hs_associated_company_id ;;
  }
  dimension: hs_associated_company_name {
    type: string
    sql: ${TABLE}.hs_associated_company_name ;;
  }
  dimension: hs_associated_company_segment {
    type: string
    sql: ${TABLE}.hs_associated_company_segment ;;
  }
  dimension: hs_associated_contact_id {
    type: string
    sql: ${TABLE}.hs_associated_contact_id ;;
  }

  dimension_group: hs_associated_deal_dmt_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.hs_associated_deal_dmt_sao ;;
  }
  dimension: hs_associated_deal_id {
    type: string
    sql: ${TABLE}.hs_associated_deal_id ;;
  }
  dimension: hs_associated_deal_name {
    type: string
    sql: ${TABLE}.hs_associated_deal_name ;;
  }

  dimension: hs_meeting_held_id {
    type: string
    sql: ${TABLE}.hs_meeting_held_id ;;
  }

  dimension: hs_meeting_outcome {
    type: string
    sql: ${TABLE}.hs_meeting_outcome ;;
  }
  dimension: hs_meeting_owner_team {
    type: string
    sql: ${TABLE}.hs_meeting_owner_team ;;
  }
  dimension_group: sl_canceled_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.sl_canceled_at_berlin_timestamp ;;
  }
  dimension_group: sl_created_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.sl_created_at_berlin_timestamp ;;
  }
  dimension: sl_created_via {
    type: string
    sql: ${TABLE}.sl_created_via ;;
  }
  dimension_group: sl_ended_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.sl_ended_at_berlin_timestamp ;;
  }
  dimension_group: sl_imported_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.sl_imported_at_berlin_timestamp ;;
  }
  dimension: sl_meeting_duration_min {
    type: number
    sql: ${TABLE}.sl_meeting_duration_min ;;
  }
  dimension: sl_meeting_held_id {
    type: string
    sql: ${TABLE}.sl_meeting_held_id ;;
  }
  dimension: sl_meeting_owner {
    type: string
    sql: ${TABLE}.sl_meeting_owner ;;
  }

  dimension_group: sl_occurred_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.sl_occurred_at_berlin_timestamp ;;
  }
  dimension_group: sl_pinned_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.sl_pinned_at_berlin_timestamp ;;
  }
  dimension_group: sl_started_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.sl_started_at_berlin_timestamp ;;
  }
  dimension_group: sl_updated_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.sl_updated_at_berlin_timestamp ;;
  }
  measure: count {
    type: count
    drill_fields: [foreign_key_date_name, hs_associated_deal_name, hs_associated_company_name]
  }
}
