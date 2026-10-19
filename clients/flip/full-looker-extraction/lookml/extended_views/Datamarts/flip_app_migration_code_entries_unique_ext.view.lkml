include: "/base_views/Datamarts/flip_app_migration_code_entries_unique_base.view"

view: flip_app_migration_code_entries_unique_ext {

  extends: [flip_app_migration_code_entries_unique_base]

# --- DIMENSIONS -------------------------

    dimension: created_by_installation_id {
      type: string
    }
    dimension_group: created_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: created_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, hour, week, month, quarter, year]
      hidden: yes
    }
    dimension_group: db_row_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: db_row_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }
    dimension: entry_id {
      type: string
      primary_key: yes
    }
    dimension: has_logged_in_after_redemption {
      type: yesno
    }
    dimension: is_db_row_deleted {
      type: yesno
    }
    dimension: migration_status {
      type: string
    }
    dimension: os_family {
      type: string
    }
    dimension: redeemed_by_installation_id {
      type: string
    }
    dimension_group: redeemed_timestamp {
      type: time
      timeframes: [raw, time, date, hour, week, month, quarter, year]
    }
    dimension_group: redeemed_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }
    dimension: tenant {
      type: string
    }
    dimension: unique_user_ranking {
      type: number
    }
    dimension: user_id {
      type: string
    }
    dimension_group: valid_until_timestamp {
      type: time
      timeframes: [raw, time, date, hour, week, month, quarter, year]
    }
    dimension_group: valid_until_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }

  # --- MEASURES -----------------
    measure: count {
      type: count
      label: "# Entries"
    }

    measure: count_distinct_user_id {
      type: count_distinct
      sql: ${user_id} ;;
      label: "# Users (unique)"
    }

    measure: count_distinct_user_id_logged_in {
      type: count_distinct
      filters: [has_logged_in_after_redemption: "Yes"]
      sql: ${user_id} ;;
      label: "# Users logged in (unique)"
    }

    # measure: migration_duration {
    #   type: average
    #   sql: DATE_DIFF( ;;
    # }
  }
