view: fin_mrr_per_customer_group_normalized_nrr_base {
  sql_table_name: `fl-bi-p-poc.source_google_sheets_poc.fin_mrr_per_customer_group_normalized_nrr` ;;

  dimension_group: fin_customer_group_cohort {
    type: time
    description: "Recognized Customer Group Cohort"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.fin_customer_group_cohort ;;
  }
  dimension: fin_customer_group_id {
    type: string
    sql: ${TABLE}.fin_customer_group_id ;;
  }
  dimension: fin_customer_group_name {
    type: string
    sql: ${TABLE}.fin_customer_group_name ;;
  }
  dimension_group: month {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.month ;;
  }
  dimension: month_string {
    type: string
    sql: ${TABLE}.month_string ;;
  }
  dimension: mrr {
    type: number
    sql: ${TABLE}.mrr ;;
  }
  dimension: mrr_string {
    type: string
    sql: ${TABLE}.mrr_string ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  measure: count {
    type: count
    drill_fields: [fin_customer_group_name]
  }
}
