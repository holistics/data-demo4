view: fin_company_report_finance_kpis_base {
  sql_table_name: `fl-bi-p-poc.source_google_sheets_poc.fin_company_report_finance_kpis` ;;

  dimension: burn_multiple_t6m {
    type: number
    sql: ${TABLE}.burn_multiple_t6m ;;
  }
  dimension: burn_multiple_t6m_signed {
    type: number
    sql: ${TABLE}.burn_multiple_t6m_signed ;;
  }
  dimension: burn_multiple_ttm {
    type: number
    sql: ${TABLE}.burn_multiple_ttm ;;
  }
  dimension: burn_multiple_ttm_signed {
    type: number
    sql: ${TABLE}.burn_multiple_ttm_signed ;;
  }
  dimension: cac_payback_t6m {
    type: number
    sql: ${TABLE}.cac_payback_t6m ;;
  }
  dimension: cac_payback_ttm {
    type: number
    sql: ${TABLE}.cac_payback_ttm ;;
  }
  dimension: cash_burn {
    type: number
    sql: ${TABLE}.cash_burn ;;
  }
  dimension: cash_eop {
    type: number
    sql: ${TABLE}.cash_eop ;;
  }
  dimension: customer_segment {
    type: string
    sql: ${TABLE}.customer_segment ;;
  }
  dimension_group: date {
    type: time
    description: "%m/%d/%E4Y"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }
  dimension: ebitda {
    type: number
    sql: ${TABLE}.ebitda ;;
  }
  dimension: gm_rr {
    type: number
    sql: ${TABLE}.gm_rr ;;
  }
  dimension: grr {
    type: number
    sql: ${TABLE}.grr ;;
  }
  dimension: logo_retention {
    type: number
    sql: ${TABLE}.logo_retention ;;
  }
  dimension: lost_customers {
    type: number
    sql: ${TABLE}.lost_customers ;;
  }
  dimension: net_sales_efficiency_t6m {
    type: number
    sql: ${TABLE}.net_sales_efficiency_t6m ;;
  }
  dimension: net_sales_efficiency_t6m_signed {
    type: number
    sql: ${TABLE}.net_sales_efficiency_t6m_signed ;;
  }
  dimension: net_sales_efficiency_ttm {
    type: number
    sql: ${TABLE}.net_sales_efficiency_ttm ;;
  }
  dimension: net_sales_efficiency_ttm_signed {
    type: number
    sql: ${TABLE}.net_sales_efficiency_ttm_signed ;;
  }
  dimension: new_customers {
    type: number
    sql: ${TABLE}.new_customers ;;
  }
  dimension: nrr {
    type: number
    sql: ${TABLE}.nrr ;;
  }
  dimension: recognized_arr_churn {
    type: number
    sql: ${TABLE}.recognized_arr_churn ;;
  }
  dimension: recognized_arr_new_logo {
    type: number
    sql: ${TABLE}.recognized_arr_new_logo ;;
  }
  dimension: recognized_arr_running_total {
    type: number
    sql: ${TABLE}.recognized_arr_running_total ;;
  }
  dimension: recognized_arr_upsell {
    type: number
    sql: ${TABLE}.recognized_arr_upsell ;;
  }
  dimension: regonized_arr_downsell {
    type: number
    sql: ${TABLE}.regonized_arr_downsell ;;
  }
  dimension: runway_current_month {
    type: number
    sql: ${TABLE}.runway_current_month ;;
  }
  dimension: runway_t6m {
    type: number
    sql: ${TABLE}.runway_t6m ;;
  }
  dimension: signed_arr_churn_downsell {
    type: number
    sql: ${TABLE}.signed_arr_churn_downsell ;;
  }
  dimension: signed_arr_new_logo {
    type: number
    sql: ${TABLE}.signed_arr_new_logo ;;
  }
  dimension: signed_arr_running_total {
    type: number
    sql: ${TABLE}.signed_arr_running_total ;;
  }
  dimension: signed_arr_upsell {
    type: number
    sql: ${TABLE}.signed_arr_upsell ;;
  }
  dimension: signed_arr_yoy_growth {
    type: number
    sql: ${TABLE}.signed_arr_yoy_growth ;;
  }
  measure: count {
    type: count
  }
}
