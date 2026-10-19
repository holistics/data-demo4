include: "/base_views/Google_Sheets/fin_carr_budget_base.view"

view: fin_carr_budget_ext {

  extends: [fin_carr_budget_base]

# --- DIMENSIONS ---------------------------

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: CONCAT(
          ${period_grain}, '_',
          CAST(${period_end_date} AS STRING)
        ) ;;
  }
  dimension: budget_downsell_carr {
    type: number
    hidden: yes
  }
  dimension: budget_upsell_carr {
    type: number
    hidden: yes
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

# --- MEASURES -----------------------------

  # measure: count {
  #   type: count
  #   label: "# Budgets"
  # }

  # measure: budget_downsell_carr_sum {
  #   type: sum
  #   sql: ${budget_downsell_carr} ;;
  #   label: "Budget Downsell CARR"
  #   value_format_name: eur_0
  #   description: "Quarterly Finance Budget for Downsell CARR in €."
  # }

  # measure: budget_upsell_carr_sum {
  #   type: sum
  #   sql: ${budget_upsell_carr} ;;
  #   label: "Budget Upsell CARR"
  #   value_format_name: eur_0
  #   description: "Quarterly Finance Budget for Upsell CARR in €."
  # }

  measure: target_upsell_carr {
    type: max
    sql: ${budget_upsell_carr} ;;
    value_format_name: eur_0
    label: "Target Upsell CARR (€)"
    description: "Quarterly target for Upsell CARR. Returns NULL when grain is not quarter."
  }

  measure: target_downsell_carr {
    type: max
    sql: ${budget_downsell_carr} ;;
    value_format_name: eur_0
    label: "Target Downsell CARR (€)"
    description: "Quarterly target for Downsell CARR. Returns NULL when grain is not quarter."
  }

  measure: upsell_carr_pct_of_target {
    type: number
    sql: SAFE_DIVIDE(${cd_deal_scorecard_historized_ext.upsell_carr_sum_euros}, NULLIF(${target_upsell_carr}, 0)) ;;
    value_format_name: percent_1
    label: "Upsell CARR % of Target"
    description: "Actual Upsell CARR divided by target for the period."
  }

  measure: downsell_carr_pct_of_target {
    type: number
    sql: SAFE_DIVIDE(${cd_account_scorecard_historized_ext.downsell_carr_euros_sum}, NULLIF(${target_downsell_carr}, 0)) ;;
    value_format_name: percent_1
    label: "Downsell CARR % of Target"
    description: "Actual Downsell CARR divided by target for the period."
  }

}
