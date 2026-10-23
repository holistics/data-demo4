include: "/base_views/Reports/gtm_sales_pipeline_over_time_base.view"
# include: "/extended_views/Datamarts/hubspot_deals_all_ext.view"

view: gtm_sales_pipeline_over_time_ext {

  extends: [gtm_sales_pipeline_over_time_base]

  drill_fields: [deal_segment, industry, is_a_meta_deal, period_month]

# ----- DIMENSIONS ---------------------------------------------------------------------------------------------------------

  dimension: deal_allocation {
    type: string
  }
  dimension: deal_segment {
    type: string
  }
  dimension: industry {
    type: string
  }
  dimension: is_a_meta_deal {
    type: yesno
  }
  dimension: new_business_vs_upsell {
    type: string
  }
  dimension: open_deals_count {
    type: number
    hidden: yes
  }
  dimension: open_pipeline_volume_euros {
    type: number
    hidden: yes
  }
  dimension: open_pipeline_volume_in_record_currency {
    type: number
    hidden: yes
  }
  dimension: open_unique_deals_count {
    type: number
    hidden: yes
  }
  dimension_group: period {
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

# ----- DIMENSIONS ----------------------------------------------------------------------------------------------------------

# ----- MEASURES -----------------------------------------------------------------------------------------------------------

  measure: count {
    type: count
    hidden: yes
  }

  measure: open_pipeline_volume_euros_sum {
    type: sum_distinct
    sql_distinct_key: ${primary_key} ;;
    sql: ${open_pipeline_volume_euros} ;;
    filters: [new_business_vs_upsell: "New Business, Upsell"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ Open Pipeline Volume (all)"
  }

  measure: open_pipeline_volume_euros_new_business_sum {
    type: sum_distinct
    sql_distinct_key: ${primary_key} ;;
    sql: ${open_pipeline_volume_euros} ;;
    filters: [new_business_vs_upsell: "New Business"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ Open Pipeline Volume (New Business)"
  }

  measure: open_pipeline_volume_euros_upsell_sum {
    type: sum_distinct
    sql_distinct_key: ${primary_key} ;;
    sql: ${open_pipeline_volume_euros} ;;
    filters: [new_business_vs_upsell: "Upsell"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ Open Pipeline Volume (Upsell)"
  }

  measure: open_unique_deals_count_sum {
    type: sum
    sql: ${open_unique_deals_count} ;;
    label: "# Open Deals"
  }

}
