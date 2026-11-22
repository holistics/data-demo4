view: flip_user_device_latest_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_user_device_latest_unique` ;;

  dimension: count_codes_per_user {
    type: number
    sql: ${TABLE}.count_codes_per_user ;;
  }
  dimension_group: db_row_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp_berlin ;;
  }
  dimension: device {
    type: string
    sql: ${TABLE}.device ;;
  }
  dimension: has_migration_failed {
    type: yesno
    sql: ${TABLE}.has_migration_failed ;;
  }
  dimension: is_mobile {
    type: yesno
    sql: ${TABLE}.is_mobile ;;
  }
  dimension: is_pwa {
    type: yesno
    sql: ${TABLE}.is_pwa ;;
  }
  dimension: latest_device_per_user_rank {
    type: number
    sql: ${TABLE}.latest_device_per_user_rank ;;
  }
  dimension: notification_token {
    type: string
    sql: ${TABLE}.notification_token ;;
  }
  dimension: os {
    type: string
    sql: ${TABLE}.os ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
  }
}
