include: "/base_views/Reports/flip_user_core_device_group_counts_today_base.view"

view: flip_user_core_device_group_counts_today_ext {
extends: [flip_user_core_device_group_counts_today_base]

# --- DIMENSIONS -------------
    dimension: has_to_migrate {
      type: yesno
    }
    dimension: latest_device_group {
      type: string
    }
    dimension_group: status {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
      hidden: yes
    }
    dimension: tenant {
      type: string
    }
    dimension: unique_user_count {
      type: number
      hidden: yes
    }

    dimension: primary_key {
      type: string
      sql: CONCAT(${tenant}, ${latest_device_group}) ;;
      hidden: yes
      primary_key: yes
    }
#--- MEASURES --------------------
    measure: count {
      type: count
      hidden: yes
    }

    measure: unique_user_count_sum {
      type: sum
      sql: ${unique_user_count} ;;
      label: "# Users"
    }

  measure: unique_user_count_avg {
    type: average
    sql: ${unique_user_count} ;;
    label: "# Users (Avg)"
  }

  measure: latest_device_group_count_distinct {
    type: count_distinct
    sql: ${latest_device_group} ;;
    label: "# Device Groups"
  }

  measure: tenant_count_distinct {
    type: count_distinct
    sql: ${tenant} ;;
    label: "# Tenants"
  }
  }
