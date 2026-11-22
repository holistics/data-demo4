include: "/base_views/Reports/cd_deal_scorecard_historized_base.view"

view: cd_deal_scorecard_historized_ext {
  extends: [cd_deal_scorecard_historized_base]

  ## DIMENSIONS

  ## --- Grain & period ---
  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: CONCAT(
          ${deal_id}, '_',
          ${period_grain}, '_',
          CAST(${period_end_date} AS STRING)
        ) ;;
  }

  dimension: deal_id {
    type: string
  }
  dimension: period_grain {
    type: string
  }
  dimension_group: period_end {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension_group: period_start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  ## --- Deal identity ---
  dimension: company_id {
    type: string
  }
  dimension: deal_name {
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
  dimension_group: close {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  ## --- Period-specific attributes ---
  dimension: deal_cs_name {
    type: string
  }
  dimension: deal_cs_email {
    type: string
  }
  dimension: deal_amount_euros {
    type: number
    hidden: yes
  }
  dimension: stage_label_at_period {
    type: string
  }

  ## --- Event flags ---
  dimension: is_sao_in_period {
    type: yesno
  }
  dimension: is_closed_won_in_period {
    type: yesno
  }
  dimension: is_upsell_won_in_period {
    type: yesno
  }

  ## --- Lineage ---
  dimension_group: effective_deal_snapshot {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: is_pre_deal_snapshot_period {
    type: yesno
  }
  dimension: scorecard_source {
    type: string
    hidden: yes
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    hidden: yes
  }

  dimension: days_in_pipeline {
    type: number
    sql: DATE_DIFF(${close_date}, ${dmt_sao_date}, DAY) ;;
    description: "Days between SAO and close. NULL for unclosed deals."
  }

  dimension: is_new_business {
    type: yesno
    sql: ${deal_type} IN ('New Business', 'New Business EDEKA') ;;
  }

  dimension: is_upsell {
    type: yesno
    sql: ${deal_type} IN ('Upsell', 'Upsell EDEKA') ;;
  }

  ## MEASURES

  ## --- Counts ---
  measure: count {
    type: count
    drill_fields: [deal_cs_name, deal_name]
  }

  measure: count_distinct_deals {
    type: count_distinct
    sql: ${deal_id} ;;
    label: "# Deals"
    drill_fields: [deal_cs_name, deal_name]
  }

  ## --- SAO events ---
  measure: sao_count {
    type: count
    filters: [is_sao_in_period: "yes"]
    label: "# SAOs"
    drill_fields: [deal_cs_name, deal_name, dmt_sao_date]
  }

  measure: sao_volume_sum_euros {
    type: sum
    sql: ${deal_amount_euros} ;;
    filters: [is_sao_in_period: "yes"]
    value_format_name: decimal_0
    label: "SAO Volume (€)"
  }

  ## --- Closed Won events ---
  measure: closed_won_count {
    type: count
    filters: [is_closed_won_in_period: "yes"]
    label: "# Closed Won"
    drill_fields: [deal_cs_name, deal_name, close_date]
  }

  ## --- Upsell events (subset of Closed Won) ---
  measure: upsell_won_count {
    type: count
    filters: [is_upsell_won_in_period: "yes"]
    label: "# Upsells Won"
    drill_fields: [deal_cs_name, deal_name, close_date]
  }

  measure: upsell_carr_sum_euros {
    type: sum
    sql: ${deal_amount_euros} ;;
    filters: [is_upsell_won_in_period: "yes"]
    value_format_name: decimal_0
    label: "Upsell CARR (€)"
    drill_fields: [deal_name, deal_type, stage_label_at_period, deal_cs_name, upsell_carr_sum_euros]
  }
}
