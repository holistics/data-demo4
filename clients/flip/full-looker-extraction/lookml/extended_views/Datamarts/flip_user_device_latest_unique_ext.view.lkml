include: "/base_views/Datamarts/flip_user_device_latest_unique_base.view"

view: flip_user_device_latest_unique_ext {

extends: [flip_user_device_latest_unique_base]

# --- DIMENSIONS --------------------------
    dimension: count_codes_per_user {
      type: number
    }
    dimension_group: db_row_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension: device {
      type: string
    }
    dimension: has_migration_failed {
      type: yesno
    }
    dimension: is_mobile {
      type: yesno
    }
    dimension: is_pwa {
      type: yesno
    }
    dimension: latest_device_per_user_rank {
      type: number
    }
    dimension: notification_token {
      type: string
    }
    dimension: os {
      type: string
    }
    dimension: tenant {
      type: string
    }
    dimension: user_id {
      type: string
    }

  # --- MEASURES -----------------------------
    measure: count {
      type: count
      label: "# Users"
    }

    measure: count_codes_per_user_sum {
      type: sum
      sql: ${count_codes_per_user} ;;
      label: "# Codes generated per user_id"
    }

    measure: count_codes_per_user_avg {
      type: average
      sql: ${count_codes_per_user} ;;
      label: "# Codes generated per user_id (avg)"
    }

  }
