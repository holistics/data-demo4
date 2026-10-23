view: flip_livestreams_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_livestreams_unique` ;;

  dimension: actor_id {
    type: string
    sql: ${TABLE}.actor_id ;;
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
  dimension: external_id {
    type: string
    sql: ${TABLE}.external_id ;;
  }
  dimension: external_provider {
    type: string
    sql: ${TABLE}.external_provider ;;
  }
  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }
  dimension: is_livestream_deleted {
    type: yesno
    sql: ${TABLE}.is_livestream_deleted ;;
  }
  dimension: livestream_id {
    type: string
    sql: ${TABLE}.livestream_id ;;
  }
  dimension: livestream_status {
    type: string
    sql: ${TABLE}.livestream_status ;;
  }
  dimension_group: scheduled_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.scheduled_timestamp ;;
  }
  dimension_group: scheduled_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.scheduled_timestamp_berlin ;;
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
  dimension: viewer_count {
    type: number
    sql: ${TABLE}.viewer_count ;;
  }
  measure: count {
    type: count
  }
}
