view: cs_import_vitally_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.cs_import_vitally` ;;

  dimension: activation_rate {
    type: number
    sql: ${TABLE}.activation_rate ;;
  }
  dimension: added_onboarded_users_14d {
    type: number
    sql: ${TABLE}.added_onboarded_users_14d ;;
  }
  dimension: added_onboarded_users_30d {
    type: number
    sql: ${TABLE}.added_onboarded_users_30d ;;
  }
  dimension: avg_all {
    type: number
    sql: ${TABLE}.avg_all ;;
  }
  dimension: avg_feedback {
    type: number
    sql: ${TABLE}.avg_feedback ;;
  }
  dimension: avg_issue {
    type: number
    sql: ${TABLE}.avg_issue ;;
  }
  dimension: avg_request {
    type: number
    sql: ${TABLE}.avg_request ;;
  }
  dimension: created_users {
    type: number
    sql: ${TABLE}.created_users ;;
  }
  dimension: created_users_14d {
    type: number
    sql: ${TABLE}.created_users_14d ;;
  }
  dimension: created_users_30d {
    type: number
    sql: ${TABLE}.created_users_30d ;;
  }
  dimension: current_arr {
    type: number
    sql: ${TABLE}.current_arr ;;
  }
  dimension: daily_active_users_30d_avg {
    type: number
    sql: ${TABLE}.daily_active_users_30d_avg ;;
  }
  dimension_group: date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }
  dimension: days_in_current_stage {
    type: number
    sql: ${TABLE}.days_in_current_stage ;;
  }
  dimension: days_in_stage_1 {
    type: number
    sql: ${TABLE}.days_in_stage_1 ;;
  }
  dimension: days_in_stage_2 {
    type: number
    sql: ${TABLE}.days_in_stage_2 ;;
  }
  dimension: days_in_stage_3 {
    type: number
    sql: ${TABLE}.days_in_stage_3 ;;
  }
  dimension: days_in_stage_4 {
    type: number
    sql: ${TABLE}.days_in_stage_4 ;;
  }
  dimension: days_in_technical_onboarding_cse {
    type: number
    sql: ${TABLE}.days_in_technical_onboarding_cse ;;
  }
  dimension_group: end_of_technical_onboarding_cse {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.end_of_technical_onboarding_cse_date ;;
  }
  dimension_group: first_1percent {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_1percent_date ;;
  }
  dimension_group: first_2percent_act_rate {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_2percent_act_rate_date ;;
  }
  dimension_group: first_30percent {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_30percent_date ;;
  }
  dimension_group: first_50percent {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_50percent_date ;;
  }
  dimension_group: first_5percent {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_5percent_date ;;
  }
  dimension_group: first_80percent {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_80percent_date ;;
  }
  dimension: health_score_mau {
    type: number
    sql: ${TABLE}.health_score_mau ;;
  }
  dimension: hubspot_company_id {
    type: string
    sql: ${TABLE}.hubspot_company_id ;;
  }
  dimension: hubspot_company_name {
    type: string
    sql: ${TABLE}.hubspot_company_name ;;
  }
  dimension_group: latest {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.latest_date ;;
  }
  dimension: licence_deviation {
    type: number
    sql: ${TABLE}.licence_deviation ;;
  }
  dimension: licence_success_rate {
    type: number
    sql: ${TABLE}.licence_success_rate ;;
  }
  dimension: licence_success_rate_14d {
    type: number
    sql: ${TABLE}.licence_success_rate_14d ;;
  }
  dimension: licence_success_rate_30d {
    type: number
    sql: ${TABLE}.licence_success_rate_30d ;;
  }
  dimension: licences_sold {
    type: number
    sql: ${TABLE}.licences_sold ;;
  }
  dimension: licences_tc {
    type: number
    sql: ${TABLE}.licences_tc ;;
  }
  dimension: life_cycle_stage {
    type: string
    sql: ${TABLE}.life_cycle_stage ;;
  }
  dimension: lifetime_net_retention_rate {
    type: number
    sql: ${TABLE}.lifetime_net_retention_rate ;;
  }
  dimension: lsr_percent_points_change_14d {
    type: number
    sql: ${TABLE}.lsr_percent_points_change_14d ;;
  }
  dimension: lsr_percent_points_change_30d {
    type: number
    sql: ${TABLE}.lsr_percent_points_change_30d ;;
  }
  dimension: monthly_active_users {
    type: number
    sql: ${TABLE}.monthly_active_users ;;
  }
  dimension: new_logo_arr {
    type: number
    sql: ${TABLE}.new_logo_arr ;;
  }
  dimension: onboarded_users {
    type: number
    sql: ${TABLE}.onboarded_users ;;
  }
  dimension: onboarded_users_14d {
    type: number
    sql: ${TABLE}.onboarded_users_14d ;;
  }
  dimension: onboarded_users_30d {
    type: number
    sql: ${TABLE}.onboarded_users_30d ;;
  }
  dimension: onboarding_rate {
    type: number
    sql: ${TABLE}.onboarding_rate ;;
  }
  dimension_group: start_of_technical_onboarding_cse {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.start_of_technical_onboarding_cse_date ;;
  }
  dimension: stickiness {
    type: number
    sql: ${TABLE}.stickiness ;;
  }
  dimension: ticket_change_all {
    type: number
    sql: ${TABLE}.ticket_change_all ;;
  }
  dimension: ticket_change_feedback {
    type: number
    sql: ${TABLE}.ticket_change_feedback ;;
  }
  dimension: ticket_change_issue {
    type: number
    sql: ${TABLE}.ticket_change_issue ;;
  }
  dimension: ticket_change_request {
    type: number
    sql: ${TABLE}.ticket_change_request ;;
  }
  dimension: ticket_count_all {
    type: number
    sql: ${TABLE}.ticket_count_all ;;
  }
  dimension: ticket_count_feedback {
    type: number
    sql: ${TABLE}.ticket_count_feedback ;;
  }
  dimension: ticket_count_issue {
    type: number
    sql: ${TABLE}.ticket_count_issue ;;
  }
  dimension: ticket_count_request {
    type: number
    sql: ${TABLE}.ticket_count_request ;;
  }
  dimension: users_never_login_total {
    type: number
    sql: ${TABLE}.users_never_login_total ;;
  }
  dimension: vitally_customer_journey_stage {
    type: string
    sql: ${TABLE}.vitally_customer_journey_stage ;;
  }
  dimension: weekly_active_users {
    type: number
    sql: ${TABLE}.weekly_active_users ;;
  }
  measure: count {
    type: count
    drill_fields: [hubspot_company_name]
  }
}
