view: marketing_account_scoring_engagements_last_90_days_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.marketing_account_scoring_engagements_last_90_days` ;;

  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }
  dimension: last_90_days_account_engagement_score {
    type: number
    sql: ${TABLE}.last_90_days_account_engagement_score ;;
  }
  dimension: last_90_days_account_engagement_stage {
    type: string
    sql: ${TABLE}.last_90_days_account_engagement_stage ;;
  }
  dimension: last_90_days_account_intent_score {
    type: number
    sql: ${TABLE}.last_90_days_account_intent_score ;;
  }
  dimension: last_90_days_account_intent_stage {
    type: string
    sql: ${TABLE}.last_90_days_account_intent_stage ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  dimension: touchpoint_details {
    type: string
    sql: ${TABLE}.touchpoint_details ;;
  }
  dimension_group: touchpoint_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.touchpoint_timestamp ;;
  }
  dimension: touchpoint_type {
    type: string
    sql: ${TABLE}.touchpoint_type ;;
  }
  dimension: touchpoint_url {
    type: string
    sql: ${TABLE}.touchpoint_url ;;
  }
  measure: count {
    type: count
  }
}
