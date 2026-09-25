view: fin_carr_budget_base {
  sql_table_name: `fl-bi-p-poc.source_google_sheets_poc.fin_carr_budget` ;;

  dimension: budget_downsell_carr {
    type: number
    sql: ${TABLE}.budget_downsell_carr ;;
  }
  dimension: budget_upsell_carr {
    type: number
    sql: ${TABLE}.budget_upsell_carr ;;
  }
  dimension: period_grain {
    type: string
    sql: ${TABLE}.period_grain ;;
  }
  dimension_group: period_end {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.period_end ;;
  }
  dimension_group: period_start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.period_start ;;
  }
  measure: count {
    type: count
  }
}
