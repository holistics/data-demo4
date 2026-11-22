view: flip_user_devices_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_user_devices_unique` ;;

  dimension: browser {
    type: string
    sql: ${TABLE}.browser ;;
  }

  dimension: browser_version {
    type: string
    sql: ${TABLE}.browser_version ;;
  }

  dimension: client_id {
    type: string
    sql: ${TABLE}.client_id ;;
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

  dimension: device {
    type: string
    sql: ${TABLE}.device ;;
  }

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: is_mobile {
    type: yesno
    sql: ${TABLE}.is_mobile ;;
  }

  dimension: is_pwa {
    type: yesno
    sql: ${TABLE}.is_pwa ;;
  }

  dimension: notification_token {
    type: string
    sql: ${TABLE}.notification_token ;;
  }

  dimension: os {
    type: string
    sql: ${TABLE}.os ;;
  }

  dimension: os_version {
    type: string
    sql: ${TABLE}.os_version ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  dimension: timezone_offset_in_seconds {
    type: number
    sql: ${TABLE}.timezone_offset_in_seconds ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
