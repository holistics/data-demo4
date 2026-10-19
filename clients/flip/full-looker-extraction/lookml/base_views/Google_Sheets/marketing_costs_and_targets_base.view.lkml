view: marketing_costs_and_targets_base {
  sql_table_name: `fl-bi-p-poc.source_google_sheets_poc.marketing_costs_and_targets` ;;

  dimension: action_type {
    type: string
    sql: ${TABLE}.action_type ;;
  }
  dimension: cost_euros {
    type: number
    sql: ${TABLE}.cost_euros ;;
  }
  dimension_group: date {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }
  dimension: leads {
    type: number
    sql: ${TABLE}.leads ;;
  }
  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }
  dimension: marketing_action {
    type: string
    sql: ${TABLE}.marketing_action ;;
  }
  dimension: mqls {
    type: number
    sql: ${TABLE}.mqls ;;
  }
  dimension: sals {
    type: number
    sql: ${TABLE}.sals ;;
  }
  dimension: saos {
    type: number
    sql: ${TABLE}.saos ;;
  }
  dimension: sao_volume {
    type: number
    sql: ${TABLE}.sao_volume ;;
  }
  dimension: source_channel_department {
    type: string
    sql: ${TABLE}.source_channel_department ;;
  }
  dimension: source_channel_drilldown {
    type: string
    sql: ${TABLE}.source_channel_drilldown ;;
  }
  dimension: sqls {
    type: number
    sql: ${TABLE}.sqls ;;
  }
  measure: count {
    type: count
  }
}
