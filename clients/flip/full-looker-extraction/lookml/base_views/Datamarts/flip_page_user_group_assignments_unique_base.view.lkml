view: flip_page_user_group_assignments_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_page_user_group_assignments_unique` ;;

  dimension_group: created_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_timestamp ;;
  }
  dimension_group: created_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_timestamp_berlin ;;
  }
  dimension_group: db_row_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp ;;
  }
  dimension_group: db_row_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp_berlin ;;
  }
  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }
  dimension: page_id {
    type: string
    sql: ${TABLE}.page_id ;;
  }
  dimension: page_user_group_assignment_id {
    type: string
    sql: ${TABLE}.page_user_group_assignment_id ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension: user_group_id {
    type: string
    sql: ${TABLE}.user_group_id ;;
  }
  measure: count {
    type: count
  }
}
