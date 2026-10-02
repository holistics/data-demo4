view: flip_post_comment_reports_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_post_comment_reports_unique` ;;

  dimension: channel_id {
    type: string
    sql: ${TABLE}.channel_id ;;
  }
  dimension: comment_author_id {
    type: string
    sql: ${TABLE}.comment_author_id ;;
  }
  dimension: comment_id {
    type: string
    sql: ${TABLE}.comment_id ;;
  }
  dimension: comment_report_id {
    type: string
    sql: ${TABLE}.comment_report_id ;;
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
  dimension: post_id {
    type: string
    sql: ${TABLE}.post_id ;;
  }
  dimension: reporter_id {
    type: string
    sql: ${TABLE}.reporter_id ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  measure: count {
    type: count
  }
}
