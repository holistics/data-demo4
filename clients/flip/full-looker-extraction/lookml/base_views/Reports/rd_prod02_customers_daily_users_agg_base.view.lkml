view: rd_prod02_customers_daily_users_agg_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.rd_prod02_customers_daily_users_agg` ;;

  dimension_group: date_berlin {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_berlin ;;
  }
  dimension: dau {
    type: number
    sql: ${TABLE}.dau ;;
  }
  dimension: mau {
    type: number
    sql: ${TABLE}.mau ;;
  }
  dimension: users_created {
    type: number
    sql: ${TABLE}.users_created ;;
  }
  dimension: users_onboarded {
    type: number
    sql: ${TABLE}.users_onboarded ;;
  }
  dimension: wau {
    type: number
    sql: ${TABLE}.wau ;;
  }
  measure: count {
    type: count
  }
}
