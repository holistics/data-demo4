include: "/base_views/Datamarts/flip_channels_daily_aggregations_historized_base.view"

view: flip_channels_daily_aggregations_historized_ext {

  extends: [flip_channels_daily_aggregations_historized_base]

# --- DIMENSIONS---
    dimension: channel_id {
      type: string
    }
    dimension_group: date_berlin {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension: dau_30d_avg {
      type: number
      hidden: yes
    }
    dimension: dau_daily {
      type: number
      hidden: yes
    }
    dimension: mau_30d_avg {
      type: number
      hidden: yes
    }
    dimension: mau_daily {
      type: number
      hidden: yes
    }
    dimension: message_reactions {
      type: number
      hidden: yes
    }
    dimension: new_onboarded_users {
      type: number
      hidden: yes
    }
    dimension: posts {
      type: number
      hidden: yes
    }
    dimension: primary_key {
      type: string
      primary_key: yes
    }
    dimension: tenant {
      type: string
    }
    dimension: total_created_users {
      type: number
      hidden: yes
    }
    dimension: total_onboarded_users {
      type: number
      hidden: yes
    }
    dimension: total_post_interactions {
      type: number
      hidden: yes
    }
    dimension: total_reactions {
      type: number
      hidden: yes
    }
    dimension: wau_30d_avg {
      type: number
      hidden: yes
    }
    dimension: wau_daily {
      type: number
      hidden: yes
    }

  # ---- MANUALLY ADDED DIMENSIONS --------

    dimension: now_vs_30d_ago {
      type: yesno
      sql: DATE_DIFF(current_date(), ${date_berlin_date},  DAY) IN (0,30)  ;;
    }

    dimension: yesterday_vs_30d_ago {
      type: yesno
      sql: DATE_DIFF(current_date(), ${date_berlin_date},  DAY) IN (1,30)  ;;
    }

    dimension: now_vs_14d_ago {
      type: yesno
      sql: DATE_DIFF(current_date(), ${date_berlin_date},  DAY) IN (0,14)  ;;
    }

    dimension: now_vs_7d_ago {
      type: yesno
      sql: DATE_DIFF(current_date(), ${date_berlin_date},  DAY) IN (0,7)  ;;
    }

    dimension: is_last_day_of_month {
      type: yesno
      sql: date(${date_berlin_date}) = last_day(date(${date_berlin_date}), month)
        OR DATE(${date_berlin_date}) = CURRENT_DATE();;
      description: "Filters for the last day of each month. Current month: today"
    }

    dimension: last_30d_dimension {
      type: string
      sql: CASE
              WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 29 THEN "last 30d"
              WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 59 THEN "last 31d-60d"
              END ;;
    }

    dimension: last_14d_dimension_run {
      type: string
      sql: CASE
              WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 13 THEN "last 14d"
              ELSE "before" END ;;
    }

    dimension: last_14d_dimension {
      type: string
      sql: CASE
              WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 13 THEN "last 14d"
              WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 27 THEN "last 15d-28d"
              END ;;
    }

    dimension: last_7d_dimension {
      type: string
      sql: CASE
            WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 6 THEN "last 7d"
            WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 13 THEN "last 8d-14d"
            END ;;
    }

  # --- MEASURES ---

    measure: count {
      type: count
      hidden: yes
    }

    measure: total_onboarded_users_sum {
      type: sum
      sql: ${total_onboarded_users} ;;
      label: "# Onboarded Users"
    }

    measure: new_onboarded_users_sum {
      type: sum
      sql: ${new_onboarded_users} ;;
      label: "# New Onboarded Users "
    }

    measure: total_created_users_sum {
      type: sum
      sql: ${total_created_users} ;;
      label: "# Created Users"
    }

  measure: dau_30d_avg_avg {
    type: average
    sql: ${dau_30d_avg} ;;
    label: "# DAU 30d avg"
    value_format_name: decimal_1
  }

  measure: mau_30d_avg_avg {
    type: average
    sql: ${mau_30d_avg} ;;
    label: "# MAU 30d avg"
    value_format_name: decimal_1
  }

  measure: wau_30d_avg_avg {
    type: average
    sql: ${wau_30d_avg} ;;
    label: "# WAU 30d avg"
    value_format_name: decimal_1
  }

  measure: mau_daily_avg {
    type: average
    sql: ${mau_daily} ;;
    label: "# MAU "
  }

  measure: wau_daily_avg {
    type: average
    sql: ${mau_daily} ;;
    label: "# WAU "
  }

  measure: posts_sum {
    type: sum
    sql: ${posts} ;;
    label: "# Posts"
  }

  measure: total_post_interactions_sum {
    type: sum
    sql: ${total_post_interactions} ;;
    label: "# Total Post Interactions"
  }

  measure: total_reactions_sum {
    type: sum
    sql: ${total_reactions} ;;
    label: "# Total Reactions"
  }
  }
