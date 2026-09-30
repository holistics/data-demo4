view: flip_task_comments_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_task_comments_unique` ;;

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

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: is_task_comment_deleted {
    type: yesno
    sql: ${TABLE}.is_task_comment_deleted ;;
  }

  dimension: task_comment_body_character_count {
    type: number
    sql: ${TABLE}.task_comment_body_character_count ;;
  }

  dimension: task_comment_body_word_count {
    type: number
    sql: ${TABLE}.task_comment_body_word_count ;;
  }

  dimension: task_comment_id {
    type: string
    sql: ${TABLE}.task_comment_id ;;
  }

  dimension: task_comment_language {
    type: string
    sql: ${TABLE}.task_comment_language ;;
  }

  dimension: task_id {
    type: string
    sql: ${TABLE}.task_id ;;
  }

  dimension: tenant {
    type:  string
    sql: ${TABLE}.tenant ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
