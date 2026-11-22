view: flip_app_migration_code_entries_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_app_migration_code_entries_unique` ;;

  dimension: created_by_installation_id {
    type: string
    sql: ${TABLE}.created_by_installation_id ;;
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
  dimension: entry_id {
    type: string
    sql: ${TABLE}.entry_id ;;
  }
  dimension: has_logged_in_after_redemption {
    type: yesno
    sql: ${TABLE}.has_logged_in_after_redemption ;;
  }
  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }
  dimension: migration_status {
    type: string
    sql: ${TABLE}.migration_status ;;
  }
  dimension: os_family {
    type: string
    sql: ${TABLE}.os_family ;;
  }
  dimension: redeemed_by_installation_id {
    type: string
    sql: ${TABLE}.redeemed_by_installation_id ;;
  }
  dimension_group: redeemed_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.redeemed_timestamp ;;
  }
  dimension_group: redeemed_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.redeemed_timestamp_berlin ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension: unique_user_ranking {
    type: number
    sql: ${TABLE}.unique_user_ranking ;;
  }
  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }
  dimension_group: valid_until_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.valid_until_timestamp ;;
  }
  dimension_group: valid_until_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.valid_until_timestamp_berlin ;;
  }
  measure: count {
    type: count
  }
}
