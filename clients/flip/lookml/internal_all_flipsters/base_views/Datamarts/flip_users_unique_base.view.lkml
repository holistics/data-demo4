explore: flip_users_unique_base {
  hidden: yes

  join: flip_users_unique__push_noti_resting_days {
    view_label: "Flip Users Unique: Push Noti Resting Days"
    sql: LEFT JOIN UNNEST(${flip_users_unique_base.push_noti_resting_days}) as flip_users_unique__push_noti_resting_days ;;
    relationship: one_to_many
  }
}

view: flip_users_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_users_unique`
    ;;

  dimension: already_logged_in {
    type: yesno
    sql: ${TABLE}.already_logged_in ;;
  }

  dimension: bookmarks_count {
    type: number
    sql: ${TABLE}.bookmarks_count ;;
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

  dimension: creator_service_type {
    type: string
    sql: ${TABLE}.creator_service_type;;
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

  dimension_group: deleted_timestamp {
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
    sql: ${TABLE}.deleted_timestamp ;;
  }

  dimension_group: deleted_timestamp_berlin {
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
    sql: ${TABLE}.deleted_timestamp_berlin ;;
  }

  dimension_group: first_login_timestamp_berlin {
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
    sql: ${TABLE}.first_login_timestamp_berlin ;;
  }

  dimension_group: first_login_timestamp_filled_berlin {
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
    sql: ${TABLE}.first_login_timestamp_filled_berlin ;;
  }

  dimension: group_chat_count {
    type: number
    sql: ${TABLE}.group_chat_count ;;
  }

  dimension: has_about_me_text {
    type: yesno
    sql: ${TABLE}.has_about_me_text ;;
  }

  dimension: has_profile_picture {
    type: yesno
    sql: ${TABLE}.has_profile_picture ;;
  }

  dimension: has_push_noti_resting_days_activated {
    type: yesno
    sql: ${TABLE}.has_push_noti_resting_days_activated ;;
  }

  dimension: has_push_noti_resting_period_activated {
    type: yesno
    sql: ${TABLE}.has_push_noti_resting_period_activated ;;
  }

  dimension: is_askai_enabled_via_tenant {
    type: yesno
    sql: ${TABLE}.is_askai_enabled_via_tenant ;;
  }

  dimension: is_askai_enabled_via_user_group {
    type: yesno
    sql: ${TABLE}.is_askai_enabled_via_user_group ;;
  }

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: is_user_deleted {
    type: yesno
    sql: ${TABLE}.is_user_deleted ;;
  }

  dimension: is_user_enabled {
    type: yesno
    sql: ${TABLE}.is_user_enabled ;;
  }

  dimension_group: last_activity_date_berlin {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_activity_date_berlin ;;
  }

  dimension_group: last_modified_sync_api_timestamp {
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
    sql: ${TABLE}.last_modified_sync_api_timestamp ;;
  }

  dimension_group: last_modified_timestamp {
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
    sql: ${TABLE}.last_modified_timestamp ;;
  }

  dimension: missed_notification_count {
    type: number
    sql: ${TABLE}.missed_notification_count ;;
  }

  dimension: private_chat_count {
    type: number
    sql: ${TABLE}.private_chat_count ;;
  }

  dimension: push_noti_resting_days {
    hidden: yes
    sql: ${TABLE}.push_noti_resting_days ;;
  }

  dimension: push_noti_resting_period_end_time {
    type: string
    sql: ${TABLE}.push_noti_resting_period_end_time ;;
  }

  dimension: push_noti_resting_period_start_time {
    type: string
    sql: ${TABLE}.push_noti_resting_period_start_time ;;
  }

  dimension: system_role {
    type: string
    sql: ${TABLE}.system_role ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: user_language {
    type: string
    sql: ${TABLE}.user_language ;;
  }

  dimension: user_status {
    type: string
    sql: ${TABLE}.user_status ;;
  }

  dimension: user_timezone {
    type: string
    sql: ${TABLE}.user_timezone ;;
  }

  dimension: user_type {
    type: string
    sql: ${TABLE}.user_type ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

view: flip_users_unique__push_noti_resting_days {
  dimension: flip_users_unique__push_noti_resting_days {
    type: number
    sql: flip_users_unique__push_noti_resting_days ;;
  }
}
