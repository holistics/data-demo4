view: flip_chats_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_chats_unique` ;;

  dimension: chat_id {
    type: string
    sql: ${TABLE}.chat_id ;;
  }

  dimension: chat_members_count {
    type: number
    sql: ${TABLE}.chat_members_count ;;
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
