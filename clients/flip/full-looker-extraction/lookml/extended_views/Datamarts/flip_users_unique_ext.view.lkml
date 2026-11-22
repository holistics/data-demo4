include: "/base_views/Datamarts/flip_users_unique_base.view"

view: flip_users_unique_ext {

  extends: [flip_users_unique_base]

  drill_fields: [user_id, already_logged_in, first_login_timestamp_filled_berlin_date, is_user_enabled, is_user_deleted, tenant]

# --- DIMENSIONS ---------------------------------------------------------

  dimension: already_logged_in {
    type: yesno
    label: "Is User Onboarded"
    description: "Indicates whether a User has logged in at least once already."
  }

  dimension: bookmarks_count {
    type: number
    hidden: yes
  }

  dimension: created_by_actor_id {
    type: string
  }

  dimension: creator_type {
    type: string
  }

  dimension: creator_service_type {
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
    hidden: yes
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
    label: "First Login"
    }

  dimension: group_chat_count {
    type: number
    hidden: yes
  }

  dimension: has_about_me_text {
    type: yesno
  }

  dimension: has_profile_picture {
    type: yesno
  }

  dimension: has_push_noti_resting_days_activated {
    type: yesno
  }

  dimension: has_push_noti_resting_period_activated {
    type: yesno
  }

  dimension: is_askai_enabled_via_tenant {
    type: yesno
  }

  dimension: is_askai_enabled_via_user_group {
    type: yesno
  }

  dimension: is_db_row_deleted {
    type: yesno
    hidden: no
    description: "Hard deletion flag (when tenant is deleted)."
  }

  dimension: is_user_deleted {
    type: yesno
  }

  dimension: is_user_enabled {
    type: yesno
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
  }

  dimension: missed_notification_count {
    type: number
  }

  dimension: private_chat_count {
    type: number
  }

  dimension: push_noti_resting_days {
    hidden: yes
  }

  dimension: push_noti_resting_period_end_time {
    type: string
  }

  dimension: push_noti_resting_period_start_time {
    type: string
  }

  dimension: system_role {
    type: string
  }

  dimension: tenant {
    type: string
  }

  dimension: user_id {
    type: string
    primary_key: yes
  }

  dimension: user_language {
    type: string
  }

  dimension: user_status {
    type: string
    description: "PENDING_DELETION: User will be deleted in 14 days (or restored). DELETED: User is 'hard deleted' and the user record is anonymized."
  }

  dimension: user_timezone {
    type: string
  }

  dimension: user_type {
    type: string
  }

# --- MANUALLY ADDED DIMENSIONS -------------------

 ## TEST FOR AUs dynamic filtering @Andrea

  dimension: last_activity_date_value {
    type: date
    sql: date(${last_activity_date_berlin_date}) ;;
    label: "AU: Last Activity Date Value"
  }

  filter: period_filter {
    type: date
    # suggest_dimension: last_activity_date_value
    suggest_dimension: last_activity_date_berlin_date
    label: "AU: period filter"
  }

  dimension: period_satisfies_filter {
    type: yesno
    hidden: yes
    sql: {% condition period_filter %} timestamp(${last_activity_date_berlin_date}) {% endcondition %} ;; #--> timestamp

  }

  measure: count_active_last1d_period {
    type: number
    label: "# DAU (period filter)"
    sql: count(distinct case when ${last_activity_date_berlin_date} between date_sub(date({% date_start period_filter %}), interval 1 day) and date({% date_start period_filter %}) then ${user_id} end) ;;
  }

  measure: count_active_last7d_period {
    type: number
    label: "# WAU (period filter)"
    sql: count(distinct case when ${last_activity_date_berlin_date} between date_sub(date({% date_start period_filter %}), interval 6 day) and date({% date_start period_filter %}) then ${user_id} end) ;;
  }

  measure: count_active_last30d_period {
    type: number
    label: "# MAU (period filter)"
    sql: count(distinct case when ${last_activity_date_berlin_date} between date_sub(date({% date_start period_filter %}), interval 29 day) and date({% date_start period_filter %}) then ${user_id} end) ;;
  }

  dimension: is_askai_enabled {
    type: yesno
    sql: CASE WHEN ${is_askai_enabled_via_tenant} OR ${is_askai_enabled_via_user_group} THEN true else false END ;;
  }

  dimension: group_chat_count_tier {
    type: tier
    sql: ${group_chat_count} ;;
    tiers: [0 ,1,5,10,15,20,25, 30]
    style: integer
  }

  dimension: private_chat_count_tier {
    type: tier
    sql: ${private_chat_count} ;;
    tiers: [0,1,5,10,15,20,25,30]
    style: integer
  }

  dimension: bookmarks_count_tier {
    type: tier
    sql: ${bookmarks_count} ;;
    tiers: [1, 2, 3, 4, 6, 11, 21]
    style: integer
  }

# --- MEASURES -------------------------------

  measure: count {
    type: count
    drill_fields: [user_id, already_logged_in, first_login_timestamp_filled_berlin_date, is_user_enabled, is_user_deleted, tenant]
    label: "# Users created Gross"
    description: "Count of unique user_ids. Includes all users that were created in the system (gross)."
  }

  measure: count_net {
    type: count
    drill_fields: [user_id, already_logged_in, first_login_timestamp_filled_berlin_date, is_user_enabled, is_user_deleted, tenant]
    filters: [is_user_deleted: "No"]
    label: "# Users created"
    description: "Count of unique user_ids that were not deleted."
  }

  measure: count_status_active {
    type: count
    label: "# Users w. status: active"
    filters: [user_status: "ACTIVE"]
    description: "Count of unique user_ids where user_status = 'ACTIVE' (instead of DELETED, PENDING DELETION, LOCKED)."
  }

  measure: count_enabled {
    type: count
    label: "# Users enabled"
    filters: [is_user_enabled: "Yes", is_user_deleted: "No"]
    description: "Count of unique user_ids where is_user_enabled is true and is_user_deleted is false. Per default every user is enabled."
  }

  measure: count_disabled {
    type: count
    label: "# Users disabled"
    filters: [is_user_enabled: "No", is_user_deleted: "No"]
    description: "Count of unique user_ids where is_user_enabled is false and is_user_deleted is false."
  }

  measure: count_deleted {
    type: count
    label: "# Users deleted"
    filters: [is_user_deleted: "Yes"]
    description: "Count of unique user_ids where is_user_deleted is true."
  }

  measure: count_onboarded {
    type: count
    label: "# Users onboarded"
    filters: [already_logged_in: "Yes", is_user_deleted: "No"]
  }

  measure: count_onboarded_gross {
    type: count
    label: "# Users onboarded Gross"
    filters: [already_logged_in: "Yes"]
  }

  measure: count_active_last1d {
    type: count
    label: "# DAU (today)"
    filters: [last_activity_date_berlin_date: "1 days, before 1 day ago"]
    description: "Count of distinct user_ids who's last activity was within the last 1 day."
  }

  measure: count_active_last7d {
    type: count
    label: "# WAU (today)"
    filters: [last_activity_date_berlin_date: "7 days, before 1 day ago"]
    description: "Count of distinct user_ids who's last activity was within the last 7 days."
  }

  measure: count_active_last30d {
    type: count
    label: "# MAU (today)"
    filters: [last_activity_date_berlin_date: "30 days, before 1 day ago"]
    description: "Count of distinct user_ids who's last activity was within the last 30 days."
  }

  measure: bookmarks_sum {
    type: sum
    sql: ${bookmarks_count} ;;
    label: "# Bookmarks"

  }

  # ------- SETS --------------

  set: excluding_period_au_fields {
    fields: [ last_activity_date_value , period_filter, period_satisfies_filter, count_active_last1d_period, count_active_last30d_period, count_active_last7d_period]

  }

}
