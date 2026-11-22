view: gtm_partner_pipeline_over_time_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.gtm_partner_pipeline_over_time` ;;

  dimension: ae_name {
    type: string
    sql: ${TABLE}.ae_name ;;
  }
  dimension: bdr_name {
    type: string
    sql: ${TABLE}.bdr_name ;;
  }
  dimension_group: close_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.close_date ;;
  }
  dimension: current_amount_euros {
    type: number
    sql: ${TABLE}.current_amount_euros ;;
  }
  dimension: deal_allocation {
    type: string
    sql: ${TABLE}.deal_allocation ;;
  }
  dimension: deal_allocation_mix {
    type: string
    sql: ${TABLE}.deal_allocation_mix ;;
  }
  dimension: deal_id {
    type: string
    sql: ${TABLE}.deal_id ;;
  }
  dimension: deal_name {
    type: string
    sql: ${TABLE}.deal_name ;;
  }
  dimension: deal_segment {
    type: string
    sql: ${TABLE}.deal_segment ;;
  }
  dimension: deal_source_channel_department_hubspot {
    type: string
    sql: ${TABLE}.deal_source_channel_department_hubspot ;;
  }
  dimension: deal_type {
    type: string
    sql: ${TABLE}.deal_type ;;
  }
  dimension_group: dmt_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_sao ;;
  }
  dimension: forecast_category {
    type: string
    sql: ${TABLE}.forecast_category ;;
  }
  dimension: influenced_only_pipeline_euros {
    type: number
    sql: ${TABLE}.influenced_only_pipeline_euros ;;
  }
  dimension: initial_sao_amount_euros {
    type: number
    sql: ${TABLE}.initial_sao_amount_euros ;;
  }
  dimension: new_business_vs_upsell {
    type: string
    sql: ${TABLE}.new_business_vs_upsell ;;
  }
  dimension: number_of_employees {
    type: number
    sql: ${TABLE}.number_of_employees ;;
  }
  dimension: open_deals_count {
    type: number
    sql: ${TABLE}.open_deals_count ;;
  }
  dimension: partner_name {
    type: string
    sql: ${TABLE}.partner_name ;;
  }
  dimension: partner_name_distribution {
    type: string
    sql: ${TABLE}.partner_name_distribution ;;
  }
  dimension_group: period_week {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.period_week ;;
  }
  dimension_group: period_week_ending_friday {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.period_week_ending_friday ;;
  }
  #dimension: primary_key {
  #  type: string
  #  sql: ${TABLE}.primary_key ;;
  #}
  dimension: sales_region {
    type: string
    sql: ${TABLE}.sales_region ;;
  }
  dimension: sourced_pipeline_euros {
    type: number
    sql: ${TABLE}.sourced_pipeline_euros ;;
  }
  dimension: stage_label {
    type: string
    sql: ${TABLE}.stage_label ;;
  }
  dimension: total_influenced_pipeline_euros {
    type: number
    sql: ${TABLE}.total_influenced_pipeline_euros ;;
  }
  measure: count {
    type: count
    drill_fields: [partner_name]
  }
}
