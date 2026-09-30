view: flip_task_comment_reactions_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_task_comment_reactions_unique` ;;

  dimension: comment_id {
    type: string
    sql: ${TABLE}.comment_id ;;
  }

  dimension: created_timestamp {
    type: number
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

  dimension: reaction_type {
    type: string
    sql: ${TABLE}.reaction_type ;;
  }

  dimension: task_comment_reaction_id {
    type: string
    sql: ${TABLE}.task_comment_reaction_id ;;
  }

  dimension: updated_count {
    type: number
    sql: ${TABLE}.updated_count ;;
  }

  dimension: updated_distinct_count {
    type: number
    sql: ${TABLE}.updated_distinct_count ;;
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

  dimension: user_comment_id {
    type: string
    sql: ${TABLE}.user_comment_id ;;
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
