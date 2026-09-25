
include: "/base_views/Reports/cs_import_vitally_base.view"
view: cs_import_vitally_ext {

extends: [cs_import_vitally_base]

    dimension: activation_rate {
      type: number
      hidden:  yes
    }

    dimension: added_onboarded_users_14d {
      type: number
      hidden:  yes
      }

    dimension: added_onboarded_users_30d {
      type: number
      hidden:  yes
      }
    dimension: avg_all {
      type: number
      hidden:  yes
      }
    dimension: avg_feedback {
      type: number
      hidden:  yes
      }
    dimension: avg_issue {
      type: number
      hidden:  yes
      }
    dimension: avg_request {
      type: number
      hidden:  yes
      }
    dimension: created_users {
      type: number
      hidden:  yes
      }
    dimension: created_users_14d {
      type: number
      hidden:  yes
      }
    dimension: created_users_30d {
      type: number
      hidden:  yes
      }
    dimension: current_arr {
      type: number
      hidden:  yes
      }
    dimension: daily_active_users_30d_avg {
      type: number
      hidden:  yes
      }
    dimension_group: date {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension: days_in_current_stage {
      type: number
      hidden:  yes
    }
    dimension: days_in_stage_1 {
      type: number
      hidden:  yes
      }
    dimension: days_in_stage_2 {
      type: number
      hidden:  yes
      }
    dimension: days_in_stage_3 {
      type: number
      hidden:  yes
      }
    dimension: days_in_stage_4 {
      type: number
      hidden:  yes
      }
    dimension: days_in_technical_onboarding_cse {
      type: number
      hidden:  yes
      }
    dimension_group: end_of_technical_onboarding_cse {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: first_1percent {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: first_2percent_act_rate {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: first_30percent {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: first_50percent {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: first_5percent {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: first_80percent {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension: health_score_mau {
      type: number
      hidden:  yes
      }
    dimension: hubspot_company_id {
      type: string
      primary_key: yes
    }
    dimension: hubspot_company_name {
      type: string

    }
    dimension_group: latest {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension: licence_deviation {
      type: number
      hidden:  yes
      }
    dimension: licence_success_rate {
      type: number
      hidden:  yes
      }
    dimension: licence_success_rate_14d {
      type: number
      hidden:  yes
      }
    dimension: licence_success_rate_30d {
      type: number
      hidden:  yes
      }
    dimension: licences_sold {
      type: number
      hidden:  yes
      }
    dimension: licences_tc {
      type: number
      hidden:  yes
      }
    dimension: life_cycle_stage {
      type: string
      hidden:  yes
      }
    dimension: lifetime_net_retention_rate {
      type: number
      hidden:  yes
      }
    dimension: lsr_percent_points_change_14d {
      type: number
      hidden:  yes
      }
    dimension: lsr_percent_points_change_30d {
      type: number
      hidden:  yes
      }
    dimension: monthly_active_users {
      type: number
      hidden:  yes
      }
    dimension: new_logo_arr {
      type: number
      hidden:  yes
      }
    dimension: onboarded_users {
      type: number
      hidden:  yes
      }
    dimension: onboarded_users_14d {
      type: number
      hidden:  yes
      }
    dimension: onboarded_users_30d {
      type: number
      hidden:  yes
      }
    dimension: onboarding_rate {
      type: number
      hidden:  yes
      }
    dimension_group: start_of_technical_onboarding_cse {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
      hidden:  yes
      }
    dimension: stickiness {
      type: number
      hidden:  yes
      }
    dimension: ticket_change_all {
      type: number
      hidden:  yes
      }
    dimension: ticket_change_feedback {
      type: number
      hidden:  yes
      }
    dimension: ticket_change_issue {
      type: number
      hidden:  yes
      }
    dimension: ticket_change_request {
      type: number
      hidden:  yes
      }
    dimension: ticket_count_all {
      type: number
      hidden:  yes
      }
    dimension: ticket_count_feedback {
      type: number
      hidden:  yes
      }
    dimension: ticket_count_issue {
      type: number
      hidden:  yes
      }
    dimension: ticket_count_request {
      type: number
      hidden:  yes
      }
    dimension: users_never_login_total {
      type: number
      hidden:  yes
      }
    dimension: vitally_customer_journey_stage {
      type: string
      hidden:  yes
      }
    dimension: weekly_active_users {
      type: number
      hidden:  yes
      }

    # --- MEASURES --------------
    measure: count {
      type: count
      drill_fields: [hubspot_company_name]
      label: "# Customers"
    }

    measure: added_onboarded_users_l14d_avg {
      type: average
      sql: ${added_onboarded_users_14d}/NULLIF(${onboarded_users},0) ;;
      value_format_name: percent_1
      label: "% Users Onboarded added (l14d) "
    }

    measure: onboarded_users_l14d_sum {
      type: sum
      sql: ${onboarded_users_14d} ;;
      value_format_name: decimal_0
      label: "# Users Onboarded (14d ago)"
    }

    measure: added_onboarded_users_l14d_sum {
    type: sum
    sql: ${added_onboarded_users_14d} ;;
    value_format_name: decimal_0
    label: "# Users Onboarded added (l14d)"
    }

    measure: onboarded_users_sum {
    type: sum
    sql: ${onboarded_users} ;;
    value_format_name: decimal_0
    label: "# Users Onboarded"
    }

    measure: lsr_percent_points_change_l14d_avg {
      type: average
      sql: ${lsr_percent_points_change_14d} ;;
      value_format_name: percent_1
      label: "% change LSR (l14d)"
    }

  # --- SETS -----------
    set: all_flip_customers_and_deals_relevant {
      fields: [added_onboarded_users_l14d_avg, onboarded_users_l14d_sum, added_onboarded_users_l14d_sum, lsr_percent_points_change_l14d_avg]
    }

    }
