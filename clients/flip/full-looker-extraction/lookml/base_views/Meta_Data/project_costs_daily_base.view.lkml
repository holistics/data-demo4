view: project_costs_daily_base {
  sql_table_name: `fl-bi-p-poc.meta_poc.project_costs_daily` ;;

  dimension_group: day {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.day ;;
  }

  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }

  dimension: project_id {
    type: string
    sql: ${TABLE}.project_id ;;
  }
  dimension: total_dollar_billed {
    type: number
    sql: ${TABLE}.total_dollar_billed ;;
  }
  dimension: total_tb_billed {
    type: number
    sql: ${TABLE}.total_tb_billed ;;
  }
  dimension: user_email {
    type: string
    sql: ${TABLE}.user_email ;;
  }
  measure: count {
    type: count
  }
}
