view: gtm_sales_pipeline_over_time_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.gtm_sales_pipeline_over_time` ;;

  dimension: deal_allocation {
    type: string
    sql: ${TABLE}.deal_allocation ;;
  }
  dimension: deal_segment {
    type: string
    sql: ${TABLE}.deal_segment ;;
  }
  dimension: industry {
    type: string
    sql: ${TABLE}.industry ;;
  }
  dimension: is_a_meta_deal {
    type: yesno
    sql: ${TABLE}.is_a_meta_deal ;;
  }
  dimension: new_business_vs_upsell {
    type: string
    sql: ${TABLE}.new_business_vs_upsell ;;
  }
  dimension: open_deals_count {
    type: number
    sql: ${TABLE}.open_deals_count ;;
  }
  dimension: open_pipeline_volume_euros {
    type: number
    sql: ${TABLE}.open_pipeline_volume_euros ;;
  }
  dimension: open_pipeline_volume_in_record_currency {
    type: number
    sql: ${TABLE}.open_pipeline_volume_in_record_currency ;;
  }
  dimension: open_unique_deals_count {
    type: number
    sql: ${TABLE}.open_unique_deals_count ;;
  }
  dimension_group: period {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.period ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  measure: count {
    type: count
  }
}
