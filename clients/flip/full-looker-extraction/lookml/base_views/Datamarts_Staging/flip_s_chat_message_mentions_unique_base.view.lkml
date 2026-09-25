view: flip_s_chat_message_mentions_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_staging_poc.flip_chat_message_mentions_unique` ;;

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

  dimension: is_mention_deleted {
    type: yesno
    sql: ${TABLE}.is_mention_deleted ;;
  }

  dimension: mentioned_user_id {
    type: string
    sql: ${TABLE}.mentioned_user_id ;;
  }

  dimension: message_id {
    type: string
    sql: ${TABLE}.message_id ;;
  }

  dimension: message_mention_id {
    type: string
    sql: ${TABLE}.message_mention_id ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
