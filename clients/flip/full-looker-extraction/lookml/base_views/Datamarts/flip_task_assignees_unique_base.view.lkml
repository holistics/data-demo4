view: flip_task_assignees_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_task_assignees_unique` ;;

  dimension: author_id {
    type: string
    sql: ${TABLE}.author_id ;;
  }

  dimension_group: created_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_timestamp ;;
  }

  dimension_group: db_row_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.db_row_timestamp ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: is_task_assignee_deleted {
    type: yesno
    sql: ${TABLE}.is_task_assignee_deleted ;;
  }

  dimension: is_user_inactive {
    type: yesno
    sql: ${TABLE}.is_user_inactive ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: task_assignee_id {
    type: string
    sql: ${TABLE}.task_assignee_id ;;
  }

  dimension: task_assigned_to_personal_id {
    type: string
    sql: ${TABLE}.task_assigned_to_personal_id ;;
  }

  dimension: task_assigneed_to_user_id {
    type: string
    sql: ${TABLE}.task_assigneed_to_user_id ;;
  }

  dimension: task_id {
    type: string
    sql: ${TABLE}.task_id ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  dimension_group: updated_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_timestamp ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
