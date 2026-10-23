view: gtm_targets_by_department_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.gtm_targets_by_department` ;;

  dimension: closed_won_count_daily_target {
    type: number
    sql: ${TABLE}.closed_won_count_daily_target ;;
  }
  dimension: closed_won_volume_daily_target {
    type: number
    sql: ${TABLE}.closed_won_volume_daily_target ;;
  }
  dimension_group: date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }
  dimension: deal_allocation {
    type: string
    sql: ${TABLE}.deal_allocation ;;
  }
  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }
  dimension: lead_count_daily_target {
    type: number
    sql: ${TABLE}.lead_count_daily_target ;;
  }
  dimension: mql_count_daily_target {
    type: number
    sql: ${TABLE}.mql_count_daily_target ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  dimension: sal_count_daily_target {
    type: number
    sql: ${TABLE}.sal_count_daily_target ;;
  }
  dimension: sao_count_daily_target {
    type: number
    sql: ${TABLE}.sao_count_daily_target ;;
  }
  dimension: sao_volume_daily_target {
    type: number
    sql: ${TABLE}.sao_volume_daily_target ;;
  }
  dimension: sql_count_daily_target {
    type: number
    sql: ${TABLE}.sql_count_daily_target ;;
  }
  measure: count {
    type: count
  }
}
