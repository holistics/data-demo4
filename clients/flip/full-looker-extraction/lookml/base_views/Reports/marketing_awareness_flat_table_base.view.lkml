view: marketing_awareness_flat_table_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.marketing_awareness_flat_table` ;;

  dimension: avg_engagement_time_sec_target {
    type: number
    sql: ${TABLE}.avg_engagement_time_sec_target ;;
  }
  dimension: avg_pageviews_per_user_target {
    type: number
    sql: ${TABLE}.avg_pageviews_per_user_target ;;
  }
  dimension_group: calendar {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.calendar ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }
  dimension: branded_impressions_daily_target {
    type: number
    sql: ${TABLE}.branded_impressions_daily_target ;;
  }
  dimension: branded_clicks_daily_target {
    type: number
    sql: ${TABLE}.branded_clicks_daily_target ;;
  }
  dimension: branded_ctr_target {
    type: number
    sql: ${TABLE}.branded_ctr_target ;;
  }
  dimension: branded_avg_position_target {
    type: number
    sql: ${TABLE}.branded_avg_position_target ;;
  }
  dimension: non_branded_impressions_daily_target {
    type: number
    sql: ${TABLE}.non_branded_impressions_daily_target ;;
  }
  dimension: non_branded_clicks_daily_target {
    type: number
    sql: ${TABLE}.non_branded_clicks_daily_target ;;
  }
  dimension: non_branded_ctr_target {
    type: number
    sql: ${TABLE}.non_branded_ctr_target ;;
  }
  dimension: non_branded_avg_position_target {
    type: number
    sql: ${TABLE}.non_branded_avg_position_target ;;
  }
  dimension: demo_conversion_rate_target {
    type: number
    sql: ${TABLE}.demo_conversion_rate_target ;;
  }
  dimension: non_demo_conversion_rate_target {
    type: number
    sql: ${TABLE}.non_demo_conversion_rate_target ;;
  }
  dimension: target_keywords_target {
    type: string
    sql: ${TABLE}.target_keywords_target ;;
  }
  dimension: number_of_keywords_in_top_10_dach_target {
    type: number
    sql: ${TABLE}.number_of_keywords_in_top_10_dach_target ;;
  }
  dimension: number_of_keywords_in_top_10_uk_target {
    type: number
    sql: ${TABLE}.number_of_keywords_in_top_10_uk_target ;;
  }
  dimension: users_active_daily_target {
    type: number
    sql: ${TABLE}.users_active_daily_target ;;
  }
  dimension: users_new_daily_target {
    type: number
    sql: ${TABLE}.users_new_daily_target ;;
  }
  dimension: users_returning_daily_target {
    type: number
    sql: ${TABLE}.users_returning_daily_target ;;
  }
  measure: count {
    type: count
  }
}
