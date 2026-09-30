view: sales_aes_monthly_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.sales_aes_monthly` ;;

  dimension: added_arr_running_sum_euros {
    type: number
    sql: ${TABLE}.added_arr_running_sum_euros ;;
  }
  dimension: ae_name {
    type: string
    sql: ${TABLE}.ae_name ;;
  }
  dimension_group: ae_start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ae_start_date ;;
  }
  dimension: ae_team {
    type: string
    sql: ${TABLE}.ae_team ;;
  }
  dimension_group: calendar {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.calendar ;;
  }
  dimension: days_since_last_happy_call {
    type: number
    sql: ${TABLE}.days_since_last_happy_call ;;
  }
  dimension_group: first_deal {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_deal_date ;;
  }
  dimension: has_ae_attained_100_percent_quota_running_sum {
    type: string
    sql: ${TABLE}.has_ae_attained_100_percent_quota_running_sum ;;
  }
  dimension: is_active_ae {
    type: string
    sql: ${TABLE}.is_active_ae ;;
  }
  dimension: is_ae_ramped_up {
    type: string
    sql: ${TABLE}.is_ae_ramped_up ;;
  }
  dimension: is_member_of_team {
    type: yesno
    sql: ${TABLE}.is_member_of_team ;;
  }
  dimension: is_onboarding_finished {
    type: string
    sql: ${TABLE}.is_onboarding_finished ;;
  }
  dimension: is_year_to_date {
    type: yesno
    sql: ${TABLE}.is_year_to_date ;;
  }
  dimension_group: last_happy_call {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_happy_call_date ;;
  }
  dimension: month_at_flip {
    type: number
    sql: ${TABLE}.month_at_flip ;;
  }
  dimension: monthly_added_arr_euros {
    type: number
    sql: ${TABLE}.monthly_added_arr_euros ;;
  }
  dimension: monthly_quota {
    type: number
    sql: ${TABLE}.monthly_quota ;;
  }
  dimension: monthly_quota_teamlead {
    type: number
    sql: ${TABLE}.monthly_quota_teamlead ;;
  }
  dimension: months_at_flip_max {
    type: number
    sql: ${TABLE}.months_at_flip_max ;;
  }
  dimension: months_to_first_deal {
    type: number
    sql: ${TABLE}.months_to_first_deal ;;
  }
  dimension: months_to_ramp {
    type: number
    sql: ${TABLE}.months_to_ramp ;;
  }
  dimension: pipeline_open_euros {
    type: number
    sql: ${TABLE}.pipeline_open_euros ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  dimension: primary_team_name {
    type: string
    sql: ${TABLE}.primary_team_name ;;
  }
  dimension_group: quota_attainment_100_percent_first_month {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.quota_attainment_100_percent_first_month ;;
  }
  dimension: quota_attaintment_percentage {
    type: number
    sql: ${TABLE}.quota_attaintment_percentage ;;
  }
  dimension: quota_running_sum {
    type: number
    sql: ${TABLE}.quota_running_sum ;;
  }
  dimension: row_num {
    type: number
    sql: ${TABLE}.row_num ;;
  }
  dimension: secondary_team_name {
    type: string
    sql: ${TABLE}.secondary_team_name ;;
  }
  dimension: team_region {
    type: string
    sql: ${TABLE}.team_region ;;
  }
  measure: count {
    type: count
    drill_fields: [ae_name, primary_team_name, secondary_team_name]
  }
}
