include: "/base_views/Datamarts/flip_user_devices_unique_base.view"

view: flip_user_devices_unique_ext {

  extends: [flip_user_devices_unique_base]

  drill_fields: [notification_token, tenant, device,is_mobile]

#------------DIMENSIONS--------------------------------------

  dimension: browser {
    type: string

  }

  dimension: browser_version {
    type: string

  }

  dimension: client_id {
    type: string

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

  }

  dimension: device {
    type: string

  }

  dimension: is_db_row_deleted {
    type: yesno

  }

  dimension: is_mobile {
    type: yesno

  }

  dimension: is_pwa {
    type: yesno

  }

  dimension: notification_token {
    type: string
    primary_key: yes
  }

  dimension: os {
    type: string

  }

  dimension: os_version {
    type: string

  }

  dimension: tenant {
    type: string

  }

  dimension: timezone_offset_in_seconds {
    type: number

  }

  dimension: user_id {
    type: string

  }

#--------------MANUALLY ADDED DIMENSIONS----------------------------

#---------------MEASURES--------------------------------------

  measure: count {
    type: count
    label: "# Notification Tokens"
    description: "Count of unique notification_token."
  }

  measure: client_id_count_distinct {
    type: count_distinct
    sql: ${client_id} ;;
    label: "# Client Ids"
    description: "Count of distinct client_ids."
  }

  measure: user_id_count_distinct {
    type: count_distinct
    sql: ${user_id} ;;
    label: "# Users"
    description: "Count of distinct user_ids."
  }

  measure: os_count_distinct {
    type: count_distinct
    sql: ${os} ;;
    label: "# OS"
    description: "Count of distinct OS (e.g. per tenant)."
  }
}
