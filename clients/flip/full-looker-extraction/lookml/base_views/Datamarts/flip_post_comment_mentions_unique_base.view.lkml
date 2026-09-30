view: flip_post_comment_mentions_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_post_comment_mentions_unique` ;;

  dimension: comment_id {
    type: string
    sql: ${TABLE}.comment_id ;;
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
  dimension: is_deleted {
    type: yesno
    sql: ${TABLE}.is_deleted ;;
  }
  dimension: mentioned_user_id {
    type: string
    sql: ${TABLE}.mentioned_user_id ;;
  }
  dimension: post_comment_mention_id {
    type: string
    sql: ${TABLE}.post_comment_mention_id ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  measure: count {
    type: count
  }
}
