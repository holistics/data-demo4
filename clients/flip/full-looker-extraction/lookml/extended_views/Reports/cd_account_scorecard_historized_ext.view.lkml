
include: "/base_views/Reports/cd_account_scorecard_historized_base.view"
view: cd_account_scorecard_historized_ext {

  extends: [cd_account_scorecard_historized_base]

  ## DIMENSIONS

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: CONCAT(
          ${company_id}, '_',
          ${period_grain}, '_',
          CAST(${period_end_date} AS STRING)
        ) ;;
  }
    dimension: allocation {
      type: string
    }
    dimension: arr_eop_euros {
      type: number
      hidden:  yes
    }
    dimension: automatic_contract_renewal {
      type: yesno
    }
    dimension: carr_eop_euros {
      type: number
      hidden:  yes
    }
    dimension_group: churn {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      datatype: datetime
    }
    dimension: company_id {
      type: string
    }
    dimension: company_name {
      type: string
    }
    dimension: company_region {
      type: string
    }
    # dimension: contraction_arr_in_window {
    #   type: number
    #   hidden:  yes
    # }
    dimension: cs_email {
      type: string
    }
    dimension: cs_name {
      type: string
    }
    dimension: dau_30d_avg_eop {
      type: number
      hidden:  yes
    }
    dimension: downsell_carr_euros {
      type: number
      hidden:  yes
    }
    dimension: ending_arr_eop_euros {
      type: number
      hidden:  yes
    }
    dimension_group: effective_arr_end {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension: expansion_arr_in_window {
      type: number
      hidden:  yes
    }
    dimension: industry {
      type: string
    }
    dimension: is_in_12m_cohort {
      type: yesno
    }
    dimension: is_pre_snapshot_period {
      type: yesno
    }
    dimension: licence_success_rate_sold_eop {
      type: number
      hidden:  yes
    }
    dimension: licences_sold_eop {
      type: number
      hidden:  yes
    }
    dimension: life_cycle_stage {
      type: string
    }
    dimension: mau_eop {
      type: number
      hidden:  yes
    }
    dimension: no_of_flows_active_eop {
      type: number
      hidden:  yes
    }
    dimension: number_of_employees_eop {
      type: number
      hidden:  yes
    }
    dimension_group: period_end {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension: period_grain {
      type: string
    }
    dimension_group: period_start {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: renewal {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension: retained_from_starting_arr_euros {
      type: number
      hidden: yes
    }
    dimension: segment {
      type: string
    }
    dimension: starting_arr_12m_ago_euros {
      type: number
      hidden:  yes
    }
    dimension: tenant {
      type: string
    }
    dimension_group: updated {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension: vitally_overall_health_score_eop {
      type: number
      hidden:  yes
    }
    dimension: wau_eop {
      type: number
      hidden:  yes
    }
    dimension: onboarded_users_eop {
      type: number
      hidden: yes
    }

    dimension: is_active_account {
      type: yesno
      sql: ${life_cycle_stage} = 'customer' AND ${churn_raw} IS NULL ;;
    }

    dimension: days_to_renewal {
      type: number
      sql: DATE_DIFF(${renewal_date}, ${period_end_date}, DAY) ;;
    }

    dimension: months_since_first_arr {
      type: number
      sql: DATE_DIFF(${period_end_date}, ${TABLE}.contract_start_date, MONTH) ;;
    }

  ## MEASURES

  ## --- Counts ---
  measure: count {
    type: count
    drill_fields: [cs_name, company_name]
  }

  measure: count_distinct_companies {
    type: count_distinct
    sql: ${company_id} ;;
    label: "# Accounts"
    drill_fields: [cs_name, company_name, arr_eop_euros_sum]
  }

  ## --- Stock metrics (at period_end_date) ---
  measure: arr_eop_euros_sum {
    type: sum
    sql: ${arr_eop_euros} ;;
    value_format_name: decimal_0
    label: "ARR (€)"
  }

  measure: carr_eop_euros_sum {
    type: sum
    sql: ${carr_eop_euros} ;;
    value_format_name: decimal_0
    label: "CARR (€)"
  }

  measure: mau_eop_sum {
    type: sum
    sql: ${mau_eop} ;;
    value_format_name: decimal_0
    label: "# MAU"
  }

  measure: dau_30d_avg_eop_sum {
    type: sum
    sql: ${dau_30d_avg_eop} ;;
    value_format_name: decimal_0
    label: "# DAU (30d avg)"
  }

  measure: wau_eop_sum {
    type: sum
    sql: ${wau_eop} ;;
    value_format_name: decimal_0
    label: "# WAU"
  }

  measure: onboarded_users_eop_sum {
    type: sum
    sql: ${onboarded_users_eop} ;;
    value_format_name: decimal_0
    label: "# Onboarded Users"
  }

  measure: licences_sold_eop_sum {
    type: sum
    sql: ${licences_sold_eop} ;;
    value_format_name: decimal_0
    label: "# Licences Sold"
  }

  measure: number_of_employees_eop_sum {
    type: sum
    sql: ${number_of_employees_eop} ;;
    value_format_name: decimal_0
    label: "# Employees"
  }

  measure: no_of_flows_active_eop_sum {
    type: sum
    sql: ${no_of_flows_active_eop} ;;
    value_format_name: decimal_0
    label: "# Active Flows"
  }

  measure: vitally_overall_health_score_eop_avg {
    type: average
    sql: ${vitally_overall_health_score_eop} ;;
    value_format_name: decimal_1
    label: "Avg Vitally Health Score"
  }

  measure: licence_success_rate_sold_eop_avg {
    type: average
    sql: ${licence_success_rate_sold_eop} ;;
    value_format_name: percent_1
    label: "Avg Licence Success Rate (sold)"
  }

  ## --- Flow metrics (within period) ---
  measure: downsell_carr_euros_sum {
    type: sum
    sql: ${downsell_carr_euros} ;;
    filters: [downsell_carr_euros: ">0"]
    value_format_name: decimal_0
    label: "Downsell CARR (€)"
    drill_fields: [company_name, allocation, industry, cs_name, arr_eop_euros_sum, downsell_carr_euros_sum]
  }

  ## --- NDR/GDR components (trailing 12M, cohort-filtered) ---
  ## Filter ensures only valid cohort members contribute.
  ## Ratios below use these as building blocks.

  measure: starting_arr_12m_ago_euros_sum {
    type: sum
    sql: ${starting_arr_12m_ago_euros} ;;
    filters: [is_in_12m_cohort: "yes"]
    value_format_name: decimal_0
    label: "Starting ARR (12M ago, € — cohort only)"
  }

  measure: ending_arr_eop_euros_sum {
    type: sum
    sql: ${ending_arr_eop_euros} ;;
    filters: [is_in_12m_cohort: "yes"]
    value_format_name: decimal_0
    label: "Ending ARR (EOP, € — cohort only)"
  }

  measure: expansion_arr_in_window_sum {
    type: sum
    sql: ${expansion_arr_in_window} ;;
    filters: [is_in_12m_cohort: "yes"]
    value_format_name: decimal_0
    label: "Expansion ARR (12M window, € — cohort only)"
  }

  # measure: contraction_arr_in_window_sum {
  #   type: sum
  #   sql: ${contraction_arr_in_window} ;;
  #   filters: [is_in_12m_cohort: "yes"]
  #   value_format_name: decimal_0
  #   label: "Contraction ARR (12M window, € — cohort only)"
  # }

  ## --- Ratios (computed after aggregating components) ---
  ## Inherit cohort filter via the component measures' own filters.

  measure: ndr_12m {
    type: number
    sql: SAFE_DIVIDE(${ending_arr_eop_euros_sum}, NULLIF(${starting_arr_12m_ago_euros_sum}, 0)) ;;
    value_format_name: percent_1
    label: "NDR (12M)"
    drill_fields: [company_name, allocation, industry, cs_name, is_in_12m_cohort, starting_arr_12m_ago_euros, ending_arr_eop_euros, arr_eop_euros_sum]
    description: "Net Dollar Retention: ending ARR / starting ARR 12M ago, for accounts in the 12M cohort."
  }

  # measure: gdr_12m {
  #   type: number
  #   sql: SAFE_DIVIDE(
  #     ${starting_arr_12m_ago_euros_sum} - ${contraction_arr_in_window_sum},
  #     NULLIF(${starting_arr_12m_ago_euros_sum}, 0)
  #   ) ;;
  #   value_format_name: percent_1
  #   label: "GDR (12M)"
  #   description: "Gross Dollar Retention: (starting ARR - contractions) / starting ARR 12M ago, for accounts in the 12M cohort."
  # }

  measure: retained_from_starting_arr_sum {
    type: sum
    sql: ${retained_from_starting_arr_euros} ;;
    filters: [is_in_12m_cohort: "yes"]
    value_format_name: decimal_0
    label: "Retained ARR (from starting cohort, €)"
    hidden: yes
  }

  measure: gdr_12m {
    type: number
    sql: SAFE_DIVIDE(${retained_from_starting_arr_sum}, NULLIF(${starting_arr_12m_ago_euros_sum}, 0)) ;;
    value_format_name: percent_1
    label: "GDR (12M)"
    drill_fields: [company_name, allocation, industry, cs_name, is_in_12m_cohort, starting_arr_12m_ago_euros, ending_arr_eop_euros, retained_from_starting_arr_euros]
    description: "Gross Dollar Retention: retained ARR from starting cohort ÷ starting ARR 12M ago. Bounded [0%, 100%]. Excludes expansion."
  }

  ## --- Usage ---
  measure: dau_30d_avg_per_onboarded_users{
    type: number
    sql: SAFE_DIVIDE(
      ${dau_30d_avg_eop_sum},
      NULLIF(${onboarded_users_eop_sum}, 0)
    ) ;;
    value_format_name: percent_1
    label: "%DAU per Onboarded Users"
  }

  measure: mau_per_onboarded_users{
    type: number
    sql: SAFE_DIVIDE(
      ${mau_eop_sum},
      NULLIF(${onboarded_users_eop_sum}, 0)
    ) ;;
    value_format_name: percent_1
    label: "%MAU per Onboarded Users"
  }

  measure: wau_per_per_onboarded_users{
    type: number
    sql: SAFE_DIVIDE(
      ${wau_eop_sum},
      NULLIF(${onboarded_users_eop_sum}, 0)
    ) ;;
    value_format_name: percent_1
    label: "%WAU per Onboarded Users"
  }

  measure: adoption_rate {
    type: number
    sql: SAFE_DIVIDE(${onboarded_users_eop_sum}, NULLIF(${licences_sold_eop_sum}, 0)) ;;
    value_format_name: percent_1
    label: "Adoption Rate"
    description: "Onboarded users as % of licences sold. Values >100% indicate licence overage."
  }

  ## --- Coverage ratio ---
  measure: seat_coverage {
    type: number
    sql: SAFE_DIVIDE(${licences_sold_eop_sum}, NULLIF(${number_of_employees_eop_sum}, 0)) ;;
    value_format_name: percent_1
    label: "Seat Coverage"
    description: "Licences sold / total employees."
  }

  }
