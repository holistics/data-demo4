view: flip_tasks_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_tasks_unique` ;;

  dimension: author_id {
    type: string
    sql: ${TABLE}.author_id ;;
  }

  dimension: client_content_id {
    type: string
    sql: ${TABLE}.client_content_id ;;
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

  dimension_group: due_date_timestamp {
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
    sql: ${TABLE}.due_date_timestamp ;;
  }

  dimension: due_days {
    type: number
    sql: ${TABLE}.due_days ;;
  }

  dimension: has_due_time {
    type: yesno
    sql: ${TABLE}.has_due_time ;;
  }

  dimension: is_comment_enabled {
    type: yesno
    sql: ${TABLE}.is_comment_enabled ;;
  }

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: is_first_personal {
    type: yesno
    sql: ${TABLE}.is_first_personal ;;
  }

  dimension: is_last_personal {
    type: yesno
    sql: ${TABLE}.is_last_personal ;;
  }

  dimension: is_first_distributed {
    type: yesno
    sql: ${TABLE}.is_first_distributed ;;
  }

  dimension: is_last_distributed {
    type: yesno
    sql: ${TABLE}.is_last_distributed ;;
  }

  dimension: is_task_deleted {
    type: yesno
    sql: ${TABLE}.is_task_deleted ;;
  }

  dimension: is_task_overdue {
    type: yesno
    sql: ${TABLE}.is_task_overdue ;;
  }

  dimension: is_task_personal {
    type: yesno
    sql: ${TABLE}.is_task_personal ;;
  }

  dimension: task_assignee_count {
    type: number
    sql: ${TABLE}.task_assignee_count ;;
  }

  dimension: task_attachments_count {
    type: number
    sql: ${TABLE}.task_attachments_count ;;
  }

  dimension: task_body_character_count {
    type: number
    sql: ${TABLE}.task_body_character_count ;;
  }

  dimension: task_body_word_count {
    type: number
    sql: ${TABLE}.task_body_word_count ;;
  }

  dimension: task_id {
    type: string
    sql: ${TABLE}.task_id ;;
  }

  dimension: task_language {
    type: string
    sql: ${TABLE}.task_language ;;
  }

  dimension: task_processing_time_min {
    type: number
    sql: ${TABLE}.task_processing_time_min ;;
  }

  dimension: task_times_updated_count {
    type: number
    sql: ${TABLE}.task_times_updated_count ;;
  }

  dimension: task_title {
    type: string
    sql: ${TABLE}.task_title ;;
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

  measure: count {
    type: count
    drill_fields: []
  }
}
