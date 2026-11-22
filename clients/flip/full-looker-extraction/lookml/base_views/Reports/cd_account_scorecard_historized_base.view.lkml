view: cd_account_scorecard_historized_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.cd_account_scorecard_historized` ;;

  dimension: allocation {
    type: string
    sql: ${TABLE}.allocation ;;
  }
  dimension: arr_eop_euros {
    type: number
    sql: ${TABLE}.arr_eop_euros ;;
  }
  dimension: automatic_contract_renewal {
    type: yesno
    sql: ${TABLE}.automatic_contract_renewal ;;
  }
  dimension: carr_eop_euros {
    type: number
    sql: ${TABLE}.carr_eop_euros ;;
  }
  dimension_group: churn {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.churn_date ;;
  }
  dimension: company_id {
    type: string
    sql: ${TABLE}.company_id ;;
  }
  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
  }
  dimension: company_region {
    type: string
    sql: ${TABLE}.company_region ;;
  }
  # dimension: contraction_arr_in_window {
  #   type: number
  #   sql: ${TABLE}.contraction_arr_in_window ;;
  # }
  dimension: cs_email {
    type: string
    sql: ${TABLE}.cs_email ;;
  }
  dimension: cs_name {
    type: string
    sql: ${TABLE}.cs_name ;;
  }
  dimension: dau_30d_avg_eop {
    type: number
    sql: ${TABLE}.dau_30d_avg_eop ;;
  }
  dimension: downsell_carr_euros {
    type: number
    sql: ${TABLE}.downsell_carr_euros ;;
  }
  dimension: ending_arr_eop_euros {
    type: number
    sql: ${TABLE}.ending_arr_eop_euros ;;
  }
  dimension_group: effective_arr_end {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.effective_arr_end_date ;;
  }
  dimension: expansion_arr_in_window {
    type: number
    sql: ${TABLE}.expansion_arr_in_window ;;
  }
  dimension: industry {
    type: string
    sql: ${TABLE}.industry ;;
  }
  dimension: is_in_12m_cohort {
    type: yesno
    sql: ${TABLE}.is_in_12m_cohort ;;
  }
  dimension: is_pre_snapshot_period {
    type: yesno
    sql: ${TABLE}.is_pre_snapshot_period ;;
  }
  dimension: licence_success_rate_sold_eop {
    type: number
    sql: ${TABLE}.licence_success_rate_sold_eop ;;
  }
  dimension: licences_sold_eop {
    type: number
    sql: ${TABLE}.licences_sold_eop ;;
  }
  dimension: life_cycle_stage {
    type: string
    sql: ${TABLE}.life_cycle_stage ;;
  }
  dimension: mau_eop {
    type: number
    sql: ${TABLE}.mau_eop ;;
  }
  dimension: no_of_flows_active_eop {
    type: number
    sql: ${TABLE}.no_of_flows_active_eop ;;
  }
  dimension: number_of_employees_eop {
    type: number
    sql: ${TABLE}.number_of_employees_eop ;;
  }
  dimension_group: period_end {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.period_end_date ;;
  }
  dimension: period_grain {
    type: string
    sql: ${TABLE}.period_grain ;;
  }
  dimension_group: period_start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.period_start_date ;;
  }
  dimension_group: renewal {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.renewal_date ;;
  }
  dimension: retained_from_starting_arr_euros {
    type: number
    sql: ${TABLE}.retained_from_starting_arr_euros ;;
  }
  dimension: segment {
    type: string
    sql: ${TABLE}.segment ;;
  }
  dimension: starting_arr_12m_ago_euros {
    type: number
    sql: ${TABLE}.starting_arr_12m_ago_euros ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  dimension: vitally_overall_health_score_eop {
    type: number
    sql: ${TABLE}.vitally_overall_health_score_eop ;;
  }
  dimension: wau_eop {
    type: number
    sql: ${TABLE}.wau_eop ;;
  }
  dimension: onboarded_users_eop {
    type: number
    sql: ${TABLE}.onboarded_users_eop ;;
  }
  measure: count {
    type: count
    drill_fields: [cs_name, company_name]
  }
}
