view: flip_page_user_assignments_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_page_user_assignments_unique` ;;

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
  dimension: is_user_deleted {
    type: yesno
    sql: ${TABLE}.is_user_deleted ;;
  }
  dimension: is_user_inactive {
    type: yesno
    sql: ${TABLE}.is_user_inactive ;;
  }
  dimension: page_id {
    type: string
    sql: ${TABLE}.page_id ;;
  }
  dimension: page_user_assignment_id {
    type: string
    sql: ${TABLE}.page_user_assignment_id ;;
  }
  dimension: role_id {
    type: string
    sql: ${TABLE}.role_id ;;
  }
  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
  }
}
