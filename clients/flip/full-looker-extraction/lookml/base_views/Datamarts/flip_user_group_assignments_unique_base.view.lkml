view: flip_user_group_assignments_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_user_group_assignments_unique` ;;

  dimension: assignment_source {
    type: string
    sql: ${TABLE}.assignment_source ;;
  }
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
  dimension: role_id {
    type: string
    sql: ${TABLE}.role_id ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension_group: updated_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_timestamp ;;
  }
  dimension_group: updated_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_timestamp_berlin ;;
  }
  dimension: user_group_assignment_id {
    type: string
    sql: ${TABLE}.user_group_assignment_id ;;
  }
  dimension: user_group_id {
    type: string
    sql: ${TABLE}.user_group_id ;;
  }
  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
  }
}
