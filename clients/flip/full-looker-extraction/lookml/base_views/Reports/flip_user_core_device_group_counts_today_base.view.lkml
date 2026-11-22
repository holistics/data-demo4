view: flip_user_core_device_group_counts_today_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.flip_user_core_device_group_counts_today` ;;

  dimension: has_to_migrate {
    type: yesno
    sql: ${TABLE}.has_to_migrate ;;
  }
  dimension: latest_device_group {
    type: string
    sql: ${TABLE}.latest_device_group ;;
  }
  dimension_group: status {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.status_date ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension: unique_user_count {
    type: number
    sql: ${TABLE}.unique_user_count ;;
  }
  measure: count {
    type: count
  }
}
