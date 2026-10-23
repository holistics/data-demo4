view: flip_s_chats_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_staging_poc.flip_chats_unique` ;;

  dimension: chat_id {
    type: string
    sql: ${TABLE}.chat_id ;;
  }
  dimension: chat_members_count {
    type: number
    sql: ${TABLE}.chat_members_count ;;
  }
  dimension: chat_type {
    type: string
    sql: ${TABLE}.chat_type ;;
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
  dimension: is_chat_deleted {
    type: yesno
    sql: ${TABLE}.is_chat_deleted ;;
  }
  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }
  dimension: is_private_chat {
    type: yesno
    sql: ${TABLE}.is_private_chat ;;
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
  measure: count {
    type: count
  }
}
