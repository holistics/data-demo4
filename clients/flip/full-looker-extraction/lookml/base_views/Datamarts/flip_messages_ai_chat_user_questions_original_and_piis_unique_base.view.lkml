view: flip_messages_ai_chat_user_questions_original_and_piis_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_messages_ai_chat_user_questions_original_and_piis_unique` ;;

  dimension: author_id {
    type: string
    sql: ${TABLE}.author_id ;;
  }
  dimension: chat_id {
    type: string
    sql: ${TABLE}.chat_id ;;
  }
  dimension_group: db_row_timestamp {
    type: time
    timeframes: [raw, time, date, week, day_of_week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp ;;
  }
  dimension_group: db_row_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp_berlin ;;
  }
  dimension: message_body_character_count {
    type: number
    sql: ${TABLE}.message_body_character_count ;;
  }
  dimension: message_body_word_count {
    type: number
    sql: ${TABLE}.message_body_word_count ;;
  }
  dimension: messages_per_chat_count {
    type: number
    sql: ${TABLE}.messages_per_chat_count ;;
  }
  dimension: message_id {
    type: string
    sql: ${TABLE}.message_id ;;
  }
  dimension: trace_id {
    type: string
    sql: ${TABLE}.trace_id ;;
  }
  dimension: message_language {
    type: string
    sql: ${TABLE}.message_language ;;
  }
  dimension: sequence_number {
    type: number
    sql: ${TABLE}.sequence_number ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension: user_group_id {
    type: string
    sql: ${TABLE}.user_group_id ;;
  }
  dimension: time_since_previous_message_seconds {
    type: number
    sql: ${TABLE}.time_since_previous_message_seconds ;;
  }
  measure: count {
    type: count
  }
}
