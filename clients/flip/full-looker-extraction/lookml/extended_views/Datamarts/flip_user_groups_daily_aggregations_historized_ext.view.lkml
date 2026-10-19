include: "/base_views/Datamarts/flip_user_groups_daily_aggregations_historized_base.view"
view: flip_user_groups_daily_aggregations_historized_ext {
extends: [flip_user_groups_daily_aggregations_historized_base]

# ----- DIMENSIONS -----------------
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
  dimension: user_group_id {
    type: string
  }
  dimension: wau_daily {
    type: number
  }

# ----- MEASURES ----------------------
  measure: count {
    type: count
    hidden: yes
  }

  measure: total_onboarded_users_avg {
    type: average
    sql: ${total_onboarded_users} ;;
    label: "# Onboarded Users"
  }

  measure: new_onboarded_users_avg {
    type: average
    sql: ${new_onboarded_users} ;;
    label: "# New Onboarded Users "
  }

  measure: total_created_users_avg {
    type: average
    sql: ${total_created_users} ;;
    label: "# Created Users"
  }

  measure: dau_30d_avg_avg {
    type: average
    sql: ${dau_30d_avg} ;;
    label: "# DAU 30d avg"
  }

  measure: mau_daily_avg {
    type: average
    sql: ${mau_daily} ;;
    label: "# MAU "
  }

  measure: wau_daily_avg {
    type: average
    sql: ${wau_daily} ;;
    label: "# WAU "
  }

}
