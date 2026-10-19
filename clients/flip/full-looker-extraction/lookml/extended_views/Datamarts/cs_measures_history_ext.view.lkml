include: "/base_views/Datamarts/cs_measures_history_base.view"

view: cs_measures_history_ext {

  extends: [cs_measures_history_base]

    dimension: company_id {
      type: string
      hidden: yes
    }

    dimension_group: date {
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
      label: "History Date"
    }

  dimension: licences_sold {
    type: number
    hidden: yes
  }

    dimension: licences_tenant_controller {
      type: number
      hidden: yes
    }

    dimension: overall_health_score {
      type: number
      hidden: yes
    }

    dimension: primary_key {
      type: string
      primary_key: yes
      hidden: yes
      }

    dimension: scoped_licences {
      type: number
      hidden: yes
    }

    dimension: tenant {
      type: string
    }

  dimension: users_created_net {
    type: number
    hidden:  yes
  }

    dimension: users_onboarded_net {
      type: number
      hidden: yes
    }

  dimension: vitally_customer_journey_stage {
    type: string
  }

  dimension: vitally_customer_journey_stage_number {
    type: string
    hidden: yes
  }

  dimension: vitally_customer_journey_stage_number_yesterday {
    type: string
    hidden: yes
  }

  dimension: vitally_customer_journey_switch {
    type: string
  }

  dimension: vitally_customer_journey_switch_order {
    type: number
    hidden: yes
  }

  dimension: vitally_nps {
    type: number
    }

# --- MANUALLY ADDED DIMENSIONS

  dimension: is_last_day_of_month {
    type: yesno
    sql: date(${date_date}) = last_day(date(${date_date}), month)
      OR DATE(${date_date}) = CURRENT_DATE();;
    description: "Filters for the last day of each month. Current month: today"
  }

  dimension: is_last_day_of_quarter {
    type: yesno
    sql: date(${date_date}) = last_day(date(${date_date}), quarter)
      OR DATE(${date_date}) = CURRENT_DATE();;
    description: "Filters for the last day of each month. Current month: today"
  }

  dimension: now_vs_30d_ago {
    type: yesno
    sql: DATE_DIFF(current_date(), ${date_date},  DAY) IN (0,30)  ;;
  }

  dimension: now_vs_14d_ago {
    type: yesno
    sql: DATE_DIFF(current_date(), ${date_date},  DAY) IN (0,14)  ;;
  }

  dimension: now_vs_7d_ago {
    type: yesno
    sql: DATE_DIFF(current_date(), ${date_date},  DAY) IN (0,7)  ;;
  }

# --- MEASURES -------------------------
    measure: count {
      type: count
      drill_fields: []
      hidden: yes
    }

    measure: count_distinct_company_id {
      type: count_distinct
      sql: ${company_id} ;;
      label: "# Customers"
    }

  measure: licences_sold_sum {
    type: sum
    sql: ${licences_sold} ;;
    label: "# Licences Sold"
  }

    measure: licences_tenant_controller_sum {
      type: sum
      sql: ${licences_tenant_controller} ;;
      label: "# Licences TC"
    }

    measure: licences_tenant_controller_avg {
      type: average
      sql: ${licences_tenant_controller} ;;
      label: "# Licences TC avg"
    }

  measure: overall_health_score_sum {
    type: sum
    sql: ${overall_health_score} ;;
    label: "Health Score"
  }

  measure: overall_health_scorer_avg {
    type: average
    sql: ${overall_health_score} ;;
    label: "Health Score avg"
    value_format_name: decimal_1

  }

  measure: scoped_licences_sum {
    type: sum
    sql: ${scoped_licences} ;;
    label: "# Licences Scoped"
  }

  measure: scoped_licences_avg {
    type: average
    sql: ${scoped_licences} ;;
    label: "# Licences Scoped avg"
    value_format_name: decimal_1

  }

  measure: users_created_net_sum {
    type: sum
    sql: ${users_created_net} ;;
    label: "# Users Created"
  }

  measure: users_created_net_avg {
    type: average
    sql: ${users_created_net} ;;
    label: "# Users Created avg"
    value_format_name: decimal_1
  }

  measure: users_onboarded_net_sum {
    type: sum
    sql: ${users_onboarded_net} ;;
    label: "# Users Onboarded"
  }

  measure: users_onboarded_net_avg {
    type: average
    sql: ${users_onboarded_net} ;;
    label: "# Users Onboarded avg"
    value_format_name: decimal_1
  }

  }
