include: "/base_views/Reports/gtm_partner_pipeline_over_time_base.view"
# include: "/extended_views/Datamarts/hubspot_deals_all_ext.view"

view: gtm_partner_pipeline_over_time_ext {

  extends: [gtm_partner_pipeline_over_time_base]

  drill_fields: [deal_id, deal_name, deal_type, deal_source_channel_department_hubspot, deal_segment, deal_allocation, deal_allocation_mix, new_business_vs_upsell, stage_label, partner_name, bdr_name, ae_name, sales_region, number_of_employees_sum, forecast_category, dmt_sao_date, close_date_date, initial_sao_amount_euros_sum, current_amount_euros_sum]

# ----- DIMENSIONS ---------------------------------------------------------------------------------------------------------

  dimension: ae_name {
    type: string
  }
  dimension: bdr_name {
    type: string
  }
  dimension_group: close_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: current_amount_euros {
    type: number
    hidden: yes
  }
  dimension: deal_allocation {
    type: string
  }
  dimension: deal_allocation_mix {
    type: string
  }
  dimension: deal_id {
    type: string
    primary_key: yes
  }
  dimension: deal_name {
    type: string
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/deal/{{ deal_id }}"
    }
    label: "Deal Name"
  }
  dimension: deal_segment {
    type: string
  }
  dimension: deal_source_channel_department_hubspot {
    type: string
  }
  dimension: deal_type {
    type: string
  }
  dimension_group: dmt_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: forecast_category {
    type: string
  }
  dimension: partner_name {
    type: string
  }
  dimension: partner_name_distribution {
    type: string
  }
  dimension: new_business_vs_upsell {
    type: string
  }
  dimension: number_of_employees {
    type: number
    hidden: yes
  }
  dimension: open_deals_count {
    type: number
    hidden: yes
  }
  dimension: influenced_only_pipeline_euros {
    type: number
    hidden: yes
  }
  dimension: initial_sao_amount_euros {
    type: number
    hidden: yes
  }
  dimension: total_influenced_pipeline_euros {
    type: number
    hidden: yes
  }
  dimension: sourced_pipeline_euros {
    type: number
    hidden: yes
  }
  dimension: open_unique_deals_count {
    type: number
    hidden: yes
  }
  dimension_group: period_week {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension_group: period_week_ending_friday {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: sales_region {
    type: string
  }
  dimension: stage_label {
    type: string
    label: "Deal Stage"
  }
  #dimension: primary_key {
  #  type: string
  #  primary_key: yes
  #  hidden: yes
  #}

# ----- DIMENSIONS ----------------------------------------------------------------------------------------------------------

# ----- MEASURES -----------------------------------------------------------------------------------------------------------

  measure: count {
    type: count
    hidden: yes
  }
  measure: current_amount_euros_sum {
    type: sum_distinct
    sql_distinct_key: ${deal_id} ;;
    sql: ${current_amount_euros} ;;
    #filters: [new_business_vs_upsell: "New Business, Upsell"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ Deal Volume: Current Value (total)"
  }

  measure: initial_sao_amount_euros_sum {
    type: sum_distinct
    sql_distinct_key: ${deal_id} ;;
    sql: ${initial_sao_amount_euros} ;;
    #filters: [new_business_vs_upsell: "New Business, Upsell"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ SAO Volume (total)"
  }

  measure: influenced_only_pipeline_euros_sum {
    type: sum_distinct
    sql_distinct_key: ${deal_id} ;;
    sql: ${influenced_only_pipeline_euros} ;;
    #filters: [new_business_vs_upsell: "New Business, Upsell"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ Influenced Only Pipeline Volume (all)"
  }

  measure: total_influenced_pipeline_euros_sum {
    type: sum_distinct
    sql_distinct_key: ${deal_id} ;;
    sql: ${total_influenced_pipeline_euros} ;;
    #filters: [new_business_vs_upsell: "New Business, Upsell"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ Total Influenced Pipeline Volume (all)"
  }

  measure: sourced_pipeline_euros_sum {
    type: sum_distinct
    sql_distinct_key: ${deal_id} ;;
    sql: ${sourced_pipeline_euros} ;;
    #filters: [new_business_vs_upsell: "New Business, Upsell"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ Sourced Pipeline Volume (all)"
  }

  measure: open_deals_count_sum {
    type: sum
    sql: ${open_deals_count} ;;
    label: "# Open Deals"
  }

  measure: number_of_employees_sum {
    type: sum
    sql: ${number_of_employees} ;;
    label: "# Number of Employees"
  }

}
