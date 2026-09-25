view: cd_deal_scorecard_historized_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.cd_deal_scorecard_historized` ;;

  dimension_group: close {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.close_date ;;
  }
  dimension: company_id {
    type: string
    sql: ${TABLE}.company_id ;;
  }
  dimension: deal_amount_euros {
    type: number
    sql: ${TABLE}.deal_amount_euros ;;
  }
  dimension: deal_cs_email {
    type: string
    sql: ${TABLE}.deal_cs_email ;;
  }
  dimension: deal_cs_name {
    type: string
    sql: ${TABLE}.deal_cs_name ;;
  }
  dimension: deal_id {
    type: string
    sql: ${TABLE}.deal_id ;;
  }
  dimension: deal_name {
    type: string
    sql: ${TABLE}.deal_name ;;
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
  dimension_group: effective_deal_snapshot {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.effective_deal_snapshot_date ;;
  }
  dimension: is_closed_won_in_period {
    type: yesno
    sql: ${TABLE}.is_closed_won_in_period ;;
  }
  dimension: is_pre_deal_snapshot_period {
    type: yesno
    sql: ${TABLE}.is_pre_deal_snapshot_period ;;
  }
  dimension: is_sao_in_period {
    type: yesno
    sql: ${TABLE}.is_sao_in_period ;;
  }
  dimension: is_upsell_won_in_period {
    type: yesno
    sql: ${TABLE}.is_upsell_won_in_period ;;
  }
  dimension_group: period_end {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.period_end_date ;;
  }
  dimension: period_grain {
    type: string
    sql: ${TABLE}.period_grain ;;
  }
  dimension_group: period_start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.period_start_date ;;
  }
  dimension: scorecard_source {
    type: string
    sql: ${TABLE}.scorecard_source ;;
  }
  dimension: stage_label_at_period {
    type: string
    sql: ${TABLE}.stage_label_at_period ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  measure: count {
    type: count
    drill_fields: [deal_cs_name, deal_name]
  }
}
