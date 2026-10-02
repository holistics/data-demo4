include: "/base_views/Reports/marketing_awareness_flat_table_base.view"

view: marketing_awareness_flat_table_ext {

  extends: [marketing_awareness_flat_table_base]

  drill_fields: []

# ----- DIMENSIONS ---------------------------------------------------------------------------------------------------------

  dimension: avg_engagement_time_sec_target {
    type: number
    hidden: yes
  }
  dimension: avg_pageviews_per_user_target {
    type: number
    hidden: yes
  }
  dimension_group: calendar {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: primary_key {
    type: string
    primary_key: yes
    hidden: yes
  }
  dimension: region {
    type: string
  }
  dimension: branded_impressions_daily_target {
    type: number
    hidden: yes
  }
  dimension: branded_clicks_daily_target {
    type: number
    hidden: yes
  }
  dimension: branded_ctr_target {
    type: number
    hidden: yes
  }
  dimension: branded_avg_position_target {
    type: number
    hidden: yes
  }
  dimension: non_branded_impressions_daily_target {
    type: number
    hidden: yes
  }
  dimension: non_branded_clicks_daily_target {
    type: number
    hidden: yes
  }
  dimension: non_branded_ctr_target {
    type: number
    hidden: yes
  }
  dimension: non_branded_avg_position_target {
    type: number
    hidden: yes
  }
  dimension: demo_conversion_rate_target {
    type: number
    hidden: yes
  }
  dimension: non_demo_conversion_rate_target {
    hidden: yes
  }
  dimension: target_keywords_target {
    type: string
    hidden: yes
  }
  dimension: number_of_keywords_in_top_10_dach_target {
    type: number
    hidden: yes
  }
  dimension: number_of_keywords_in_top_10_uk_target {
    type: number
    hidden: yes
  }
  dimension: users_active_daily_target {
    type: number
    hidden: yes
  }
  dimension: users_new_daily_target {
    type: number
    hidden: yes
  }
  dimension: users_returning_daily_target {
    type: number
    hidden: yes
  }

  # ----- CUSTOM DIMENSIONS ---------------------------------------------------------------------------------------------------------

  # due to connector limitations or loading time, we want to filter out all data points from all data sources for specific dates
  dimension: to_be_removed {
    sql: CASE WHEN ${calendar_date} < "2024-02-06" THEN "yes"
              WHEN ${calendar_date} = CURRENT_DATE() THEN "yes"
              ELSE "no" END ;;
  }

  # ----- MEASURES ---------------------------------------------------------------------------------------------------------

  measure: count {
    type: count
    hidden: yes
  }

  measure: count_distinct_days {
    type: number
    sql: COUNT(DISTINCT(${calendar_date})) ;;
    label: "# Distinct days"
  }

  measure: users_active_target_sum {
    type: sum_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${users_active_daily_target} ;;
    value_format: "#,##0"
    label: "Target User active"
  }

  measure: users_new_target_sum {
    type: sum_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${users_new_daily_target} ;;
    value_format: "#,##0"
    label: "Target User new"
  }

  measure: users_returning_target_sum {
    type: sum_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${users_returning_daily_target} ;;
    value_format: "#,##0"
    label: "Target User returning"
  }

  measure: demo_conversion_rate_target_avg {
    type: average_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${demo_conversion_rate_target} ;;
    value_format: "0%"
    label: "Target Demo CR"
  }

  measure: non_demo_conversion_rate_target_avg {
    type: average_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${non_demo_conversion_rate_target} ;;
    value_format: "0%"
    label: "Target non-Demo CR"
  }

  measure: avg_engagement_time_sec_target_avg {
    type: average_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${avg_engagement_time_sec_target} ;;
    value_format: "0"
    label: "Target avg engagement time (sec)"
  }

  measure: avg_pageviews_per_user_target_avg {
    type: average_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${avg_pageviews_per_user_target} ;;
    value_format: "0.00"
    label: "Target avg page views / user"
  }

  measure: branded_impressions_daily_target_sum {
    type: sum_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${branded_impressions_daily_target} ;;
    value_format: "#,##0"
    label: "Target branded impressions"
  }

  measure: branded_clicks_daily_target_sum {
    type: sum_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${branded_clicks_daily_target} ;;
    value_format: "#,##0"
    label: "Target branded clicks"
  }

  measure: branded_ctr_target_avg {
    type: average_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${branded_ctr_target} ;;
    value_format: "0%"
    label: "Target branded CTR"
  }

  measure: branded_avg_position_target_avg {
    type: average_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${branded_avg_position_target} ;;
    value_format: "0"
    label: "Target branded avg position"
  }

  measure: non_branded_impressions_daily_target_sum {
    type: sum_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${non_branded_impressions_daily_target} ;;
    value_format: "#,##0"
    label: "Target non-branded impressions"
  }

  measure: non_branded_clicks_daily_target_sum {
    type: sum_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${non_branded_clicks_daily_target} ;;
    value_format: "#,##0"
    label: "Target non-branded clicks"
  }

  measure: non_branded_ctr_target_avg {
    type: average_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${non_branded_ctr_target} ;;
    value_format: "0%"
    label: "Target non-branded CTR"
  }

  measure: non_branded_avg_position_target_avg {
    type: average_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${non_branded_avg_position_target} ;;
    value_format: "0"
    label: "Target non-branded avg position"
  }

  measure: number_of_keywords_in_top_10_dach_target_avg {
    type: average_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${number_of_keywords_in_top_10_dach_target} ;;
    value_format: "0"
    label: "Target DACH # Keywords in top 10"
  }

  measure: number_of_keywords_in_top_10_uk_target_avg {
    type: average_distinct
    sql_distinct_key: ${calendar_date} ;;
    sql: ${number_of_keywords_in_top_10_uk_target} ;;
    value_format: "0"
    label: "Target UK # Keywords in top 10"
  }

}
