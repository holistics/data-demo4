view: flip_s_chat_messages_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_staging_poc.flip_chat_messages_unique` ;;

  dimension: author_id {
    type: string
    sql: ${TABLE}.author_id ;;
  }
  dimension: chat_id {
    type: string
    sql: ${TABLE}.chat_id ;;
  }
  dimension: client_content_id {
    type: string
    sql: ${TABLE}.client_content_id ;;
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
  dimension: is_active_chat {
    type: yesno
    sql: ${TABLE}.is_active_chat ;;
  }
  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }
  dimension: is_group_first_message {
    type: yesno
    sql: ${TABLE}.is_group_first_message ;;
  }
  dimension: is_group_last_message {
    type: yesno
    sql: ${TABLE}.is_group_last_message ;;
  }
  dimension: is_message_deleted {
    type: yesno
    sql: ${TABLE}.is_message_deleted ;;
  }
  dimension: is_message_translated {
    type: yesno
    sql: ${TABLE}.is_message_translated ;;
  }
  dimension: is_private_first_message {
    type: yesno
    sql: ${TABLE}.is_private_first_message ;;
  }
  dimension: is_private_last_message {
    type: yesno
    sql: ${TABLE}.is_private_last_message ;;
  }
  dimension: message_attachments_count {
    type: number
    sql: ${TABLE}.message_attachments_count ;;
  }
  dimension: message_body_character_count {
    type: number
    sql: ${TABLE}.message_body_character_count ;;
  }
  dimension: message_body_word_count {
    type: number
    sql: ${TABLE}.message_body_word_count ;;
  }
  dimension: message_id {
    type: string
    sql: ${TABLE}.message_id ;;
  }
  dimension: message_language {
    type: string
    sql: ${TABLE}.message_language ;;
  }
  dimension: message_language_count {
    type: number
    sql: ${TABLE}.message_language_count ;;
  }
  dimension: message_reactions_count {
    type: number
    sql: ${TABLE}.message_reactions_count ;;
  }
  dimension: quoted_message_id {
    type: string
    sql: ${TABLE}.quoted_message_id ;;
  }
  dimension: sequence_number {
    type: number
    sql: ${TABLE}.sequence_number ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  measure: count {
    type: count
  }
}
