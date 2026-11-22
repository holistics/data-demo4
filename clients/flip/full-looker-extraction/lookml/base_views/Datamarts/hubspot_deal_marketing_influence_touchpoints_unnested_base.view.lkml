view: hubspot_deal_marketing_influence_touchpoints_unnested_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.hubspot_deal_marketing_influence_touchpoints_unnested` ;;

  dimension: ae_name {
    type: string
    sql: ${TABLE}.ae_name ;;
  }
  dimension: bdr_name {
    type: string
    sql: ${TABLE}.bdr_name ;;
  }
  dimension_group: close {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.close_date ;;
  }
  dimension_group: contact_dmt_lead {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contact_dmt_lead ;;
  }
  dimension_group: contact_dmt_mql {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contact_dmt_mql ;;
  }
  dimension_group: contact_dmt_sql {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contact_dmt_sql ;;
  }
  dimension_group: created_at_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.created_at_date ;;
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
  dimension: deal_marketing_influence_touchpoint {
    type: string
    sql: ${TABLE}.deal_marketing_influence_touchpoint ;;
  }
  dimension: deal_name {
    type: string
    sql: ${TABLE}.deal_name ;;
  }
  dimension: deal_owner_name {
    type: string
    sql: ${TABLE}.deal_owner_name ;;
  }
  dimension: deal_segment {
    type: string
    sql: ${TABLE}.deal_segment ;;
  }
  dimension: deal_source_channel_campaign_name {
    type: string
    sql: ${TABLE}.deal_source_channel_campaign_name ;;
  }
  dimension: deal_source_channel_cluster_hubspot {
    type: string
    sql: ${TABLE}.deal_source_channel_cluster_hubspot ;;
  }
  dimension: deal_source_channel_drilldown_hubspot {
    type: string
    sql: ${TABLE}.deal_source_channel_drilldown_hubspot ;;
  }
  dimension: deal_type {
    type: string
    sql: ${TABLE}.deal_type ;;
  }
  dimension_group: dmt_closed_won {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_closed_won ;;
  }
  dimension_group: dmt_evaluation {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_evaluation ;;
  }
  dimension_group: dmt_negotiations {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_negotiations ;;
  }
  dimension_group: dmt_proposal {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_proposal ;;
  }
  dimension_group: dmt_sal {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_sal ;;
  }
  dimension_group: dmt_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_sao ;;
  }
  dimension_group: dmt_solution_design {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_solution_design ;;
  }
  dimension_group: event_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.event_date ;;
  }
  dimension: forecast_category {
    type: string
    sql: ${TABLE}.forecast_category ;;
  }
  dimension: initial_sao_amount_euros {
    type: number
    sql: ${TABLE}.initial_sao_amount_euros ;;
  }
  dimension: new_business_vs_upsell {
    type: string
    sql: ${TABLE}.new_business_vs_upsell ;;
  }
  dimension: sales_region {
    type: string
    sql: ${TABLE}.sales_region ;;
  }
  dimension: stage_label {
    type: string
    sql: ${TABLE}.stage_label ;;
  }
  measure: count {
    type: count
    drill_fields: [ae_name, bdr_name, deal_owner_name, deal_source_channel_campaign_name, deal_name]
  }

  ## --- Drilldown field ---

  dimension: created_at_date_drilldown {
    type: string
    sql: ${TABLE}.created_at_date ;;
    hidden: yes
  }

}
