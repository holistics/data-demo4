include: "/base_views/Datamarts_Staging/flip_s_users_unique_base.view"

view: flip_s_users_unique_ext {

  extends: [flip_s_users_unique_base]

  drill_fields: [user_id]

# --- DIMENSIONS ---------------------------------------------------------

  dimension: already_logged_in {
    type: yesno
    label: "Is User Onboarded"
    description: "Indicates whether a User has logged in at least once already."
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
  }

    dimension: creator_type {
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

  dimension: department {
    type: string
  }

  dimension_group: first_login_timestamp {
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
  hidden: yes  }

  dimension_group: first_login_timestamp_filled {
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
  label: "First Login"  }

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

    dimension: is_db_row_deleted {
      type: yesno
      hidden: yes
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

  dimension: location {
    type: string
  }

    dimension: missed_notification_count {
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

    dimension: user_creator_id {
      type: string
    }

    dimension: user_id {
      type: string
      primary_key: yes
      }

    dimension: user_language {
      type: string
    }

    dimension: user_timezone {
      type: string
    }

  dimension: user_type {
    type: string
  }

# --- MANUALLY ADDED DIMENSIONS -------------------

# --- MEASURES -------------------------------

    measure: count {
      type: count
      label: "# Users"
      description: "Count of unique user_ids."
    }

    measure: count_enabled {
      type: count
      label: "# Users enabled"
      filters: [is_user_enabled: "Yes", is_user_deleted: "No"]
      description: "Count of unique user_ids where is_user_enabled is true and is_user_deleted is false."
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

  }
