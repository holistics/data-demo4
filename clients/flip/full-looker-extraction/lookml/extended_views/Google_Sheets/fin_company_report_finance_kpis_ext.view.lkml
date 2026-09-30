include: "/base_views/Google_Sheets/fin_company_report_finance_kpis_base.view"
include: "/extended_views/Google_Sheets/fin_company_report_fte_ext.view"

view: fin_company_report_finance_kpis_ext {

  extends: [fin_company_report_finance_kpis_base]

# --- DIMENSIONS ---------------------------

  dimension: burn_multiple_t6m {
    type: number
    hidden: yes
  }
  dimension: burn_multiple_t6m_signed {
    type: number
    hidden: yes
  }
  dimension: burn_multiple_ttm {
    type: number
    hidden: yes
  }
  dimension: burn_multiple_ttm_signed {
    type: number
    hidden: yes
  }
  dimension: cac_payback_t6m {
    type: number
    hidden: yes
  }
  dimension: cac_payback_ttm {
    type: number
    hidden: yes
  }
  dimension: cash_burn {
    type: number
    hidden: yes
  }
  dimension: cash_eop {
    type: number
    hidden: yes
  }
  dimension: customer_segment {
    type: string
  }
  dimension_group: date {
    type: time
    description: "%m/%d/%E4Y"
    timeframes: [raw, date, week, month, month_name, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: ebitda {
    type: number
    hidden: yes
  }
  dimension: gm_rr {
    type: number
    hidden: yes
  }
  dimension: grr {
    type: number
    hidden: yes
  }
  dimension: logo_retention {
    type: number
    hidden: yes
  }
  dimension: lost_customers {
    type: number
    hidden: yes
  }
  dimension: net_sales_efficiency_ttm {
    type: number
    hidden: yes
  }
  dimension: net_sales_efficiency_ttm_signed {
    type: number
    hidden: yes
  }
  dimension: net_sales_efficiency_t6m {
    type: number
    hidden: yes
  }
  dimension: net_sales_efficiency_t6m_signed {
    type: number
    hidden: yes
  }
  dimension: new_customers {
    type: number
    hidden: yes
  }
  dimension: nrr {
    type: number
    hidden: yes
  }
  dimension: recognized_arr_churn {
    type: number
    hidden: yes
  }
  dimension: recognized_arr_downsell {
    type: number
    hidden: yes
  }
  dimension: recognized_arr_new_logo {
    type: number
    hidden: yes
  }
  dimension: recognized_arr_upsell {
    type: number
    hidden: yes
  }
  dimension: runway_current_month {
    type: number
    hidden: yes
  }
  dimension: runway_t6m {
    type: number
    hidden: yes
  }
  dimension: signed_arr_new_logo {
    type: number
    hidden: yes
  }
  dimension: signed_arr_running_total {
    type: number
    hidden: yes
  }
  dimension: signed_arr_upsell {
    type: number
    hidden: yes
  }
  dimension: signed_arr_yoy_growth {
    type: number
    hidden: yes
  }

  # --- MANUAL DIMENSIONS ----------------------------------------------------

  dimension: primary_key {
    type: string
    sql: CONCAT(${date_month}, ${customer_segment}) ;;
    primary_key: yes
  }

  # --- MEASURES -------------------------------------------------------

  measure: count {
    type: count
    hidden: yes
  }

    # --- SaaS KPIs ------------------------------------------
  measure: burn_multiple_ttm_avg {
    type: average
    sql: ${burn_multiple_ttm} ;;
    label: "Burn Multiple t12m"
    value_format_name: decimal_1
  }

  measure: burn_multiple_t6m_avg {
    type: average
    sql: ${burn_multiple_t6m} ;;
    label: "Burn Multiple t6m"
    value_format_name: decimal_1
  }

  measure: cash_burn_avg {
    type: average
    sql: ${cash_burn}*(-1) ;;
    label: "Cash Burn"
    value_format_name: eur_0
  }

  measure: cac_payback_ttm_avg {
    type: average
    sql: ${cac_payback_ttm} ;;
    filters: [customer_segment: "TOTAL"]
    label: "CAC Payback t12m avg."
    value_format_name: decimal_1
  }

  measure: cac_payback_t6m_avg {
    type: average
    sql: ${cac_payback_t6m} ;;
    filters: [customer_segment: "TOTAL"]
    label: "CAC Payback t6m avg."
    value_format_name: decimal_1
  }

  measure: net_sales_efficiency_ttm_recognized_avg {
    type: average
    sql: ${net_sales_efficiency_ttm} ;;
    label: "GTM Efficiency t12m (recognized)"
    description: "Net Sales Efficiency"
    value_format_name: decimal_2
  }

  measure: net_sales_efficiency_ttm_signed_avg {
    type: average
    sql: ${net_sales_efficiency_ttm_signed} ;;
    label: "GTM Efficiency t12m (signed)"
    description: "Net Sales Efficiency"
    value_format_name: decimal_2
  }

  measure: net_sales_efficiency_t6m_recognized_avg {
    type: average
    sql: ${net_sales_efficiency_t6m} ;;
    label: "GTM Efficiency t6m"
    description: "Net Sales Efficiency (regcognized)"
    value_format_name: decimal_2
  }

  measure: net_sales_efficiency_t6m_signed_avg {
    type: average
    sql: ${net_sales_efficiency_t6m_signed} ;;
    label: "GTM Efficiency t6m avg. (signed)"
    description: "Net Sales Efficiency"
    value_format_name: decimal_2
  }

  measure: gm_rr_avg {
    type: average
    sql: ${gm_rr} ;;
    value_format_name: percent_0
    label: "Gross Margin (RR) %"
    description: "Gross Margin of recurring revenue. Difference between our revenue  the cost of goods sold (COGS). It shows how much money is left over from sales after covering the direct costs of providing our app to the customer"
  }

  measure: grr_yoy_avg {
    type: average
    sql: ${grr} ;;
    value_format_name: percent_0
    label: "GRR %"
    description: "Percentage of ARR retained from all customers over the last 12 months."
  }

  measure: logo_retention_yoy_avg {
    type: average
    sql: ${logo_retention} ;;
    label: "Logo Retention %"
    value_format_name: percent_0
    description: "Percentage of customers retained over 12 months."
  }

  measure: lost_customers_sum {
    type: sum
    sql: ${lost_customers} ;;
    label: "Lost Customers"
    value_format_name: decimal_0
  }

  measure: lost_customers_avg {
    type: average
    sql: ${lost_customers} ;;
    label: "Lost Customers avg."
    value_format_name: decimal_0
  }

  measure: new_customers_sum {
    type: sum
    sql: ${new_customers} ;;
    label: "New Customers"
    value_format_name: decimal_0
  }

  measure: new_customers_avg {
    type: average
    sql: ${new_customers} ;;
    label: "New Customers avg."
    value_format_name: decimal_0
  }

  measure: net_added_customers_sum {
    type: sum
    sql: ${new_customers}-${lost_customers} ;;
    label: "Net New Customers"
    value_format_name: decimal_0
  }

  measure: runway_t6m_avg {
    type: average
    sql: ${runway_t6m} ;;
    label: "Runway (t6m)"
    value_format_name: decimal_0
  }

  measure: ebitda_avg {
    type: average
    sql: ${ebitda} ;;
    label: "EBITDA avg."
    value_format_name: eur_0
  }

    # --- Recognized ARR ----------------------------------------------------------------------------
  measure: recognized_arr_churn_sum {
    type: sum
    sql: ${recognized_arr_churn} ;;
    filters: [customer_segment: "-TOTAL"]
    label: "Churn ARR € (recognized) "
    value_format_name: eur_0
  }

  measure: recognized_arr_churn_avg {
    type: average
    sql: ${recognized_arr_churn} ;;
    filters: [customer_segment: "-TOTAL"]
    label: "Churn ARR € avg. (recognized)"
    value_format_name: eur_0
  }

  measure: recognized_arr_downsell_sum {
    type: sum
    sql: ${recognized_arr_downsell} ;;
    filters: [customer_segment: "-TOTAL"]
    label: "Downsell ARR € (recognized)"
    value_format_name: eur_0
  }

  measure: recognized_arr_downsell_avg {
    type: average
    sql: ${recognized_arr_downsell} ;;
    filters: [customer_segment: "-TOTAL"]
    label: "Downsell ARR € avg. (recognized)"
    value_format_name: eur_0
  }

  measure: recognized_arr_new_logo_sum {
    type: sum
    sql: ${recognized_arr_new_logo} ;;
    filters: [customer_segment: "-TOTAL"]
    label: "New Logo ARR € (recognized)"
    value_format_name: eur_0
  }

  measure: recognized_arr_new_logo_avg {
    type: average
    sql: ${recognized_arr_new_logo} ;;
    filters: [customer_segment: "-TOTAL"]
    label: "New Logo ARR € avg. (recognized)"
    value_format_name: eur_0
  }

  measure: recognized_arr_upsell_sum {
    type: sum
    sql: ${recognized_arr_upsell} ;;
    filters: [customer_segment: "-TOTAL"]
    label: "Upsell ARR € (recognized)"
    value_format_name: eur_0
  }

  measure: recognized_arr_upsell_avg {
    type: average
    sql: ${recognized_arr_upsell}  ;;
    filters: [customer_segment: "-TOTAL"]
    label: "Upsell ARR € avg. (recognized)"
    value_format_name: eur_0
  }

  measure: recognized_arr_running_total_sum {
    type: sum
    sql: ${recognized_arr_running_total} ;;
    value_format_name: eur_0
    label: "ARR € (recognized, run. total)"
  }

  measure: recognized_mrr_running_total_sum {
    type: sum
    sql: ${recognized_arr_running_total}/12 ;;
    value_format_name: eur_0
    label: "MRR € (recognized, run. total)"
  }

  # --- Signed ARR ---------------------------------------------------------

  measure: signed_arr_churn_downsell_sum {
    type: sum
    sql: ${signed_arr_churn_downsell} ;;
    label: "Churn/Downsell ARR € (signed)"
    value_format_name: eur_0
  }
  measure: signed_arr_new_logo_sum {
    type: sum
    sql: ${signed_arr_new_logo} ;;
    label: "New Logo ARR € (signed)"
    value_format_name: eur_0
  }

  measure: signed_arr_upsell_sum {
    type: sum
    sql: ${signed_arr_upsell} ;;
    label: "Upsell ARR € (signed)"
    value_format_name: eur_0
  }

  measure: signed_arr_upsell_running {
    type: running_total
    sql: ${signed_arr_upsell_sum} ;;
    label: "Upsell ARR € (signed, run. total)"
    value_format_name: eur_0
  }

  measure: added_signed_arr_total_sum {
    type: sum
    sql: ${signed_arr_new_logo} + ${signed_arr_upsell};;
    value_format_name: eur_0
    label: "ARR € added (signed)"
  }

  measure: net_added_signed_arr_total_sum {
    type: sum
    sql: ${signed_arr_new_logo} + ${signed_arr_upsell} + ${signed_arr_churn_downsell} ;;
    value_format_name: eur_0
    label: "ARR € net added (signed)"
  }

  measure: signed_arr_running_total_sum {
    type: sum
    sql: ${signed_arr_running_total} ;;
    value_format_name: eur_0
    label: "ARR € (signed, run. total)"
  }

  measure: signed_arr_running_total_per_fte_sum {
    type: sum
    sql: ${signed_arr_running_total}/nullif(${fin_company_report_fte_ext.product}+${fin_company_report_fte_ext.development}+${fin_company_report_fte_ext.marketing}+${fin_company_report_fte_ext.sales}+${fin_company_report_fte_ext.success_support}+${fin_company_report_fte_ext.general_administrative},0) ;;
    label: "ARR € per FTE (signed, run. total)"
    value_format_name: eur_0
  }

  # measure: eoy_signed_arr_running_total_sum {
  #   type: sum
  #   sql: ${signed_arr_running_total} ;;
  #   filters: [date_month_name: "December"]
  #   value_format_name: eur_0
  #   label: "ARR € EOY (signed, run. total)"
  # }

  # measure: ytd_added_signed_arr_running_total_sum {
  #   type: number
  #   sql: CASE WHEN ${date_month_num} = 12 AND ${month_year} = EXTRACT(YEAR FROM current_date()) THEN ${signed_arr_running_total}- END;;
  #   value_format_name: eur_0
  #   label: "ARR € YTD added (signed, run. total)"
  # }

  # measure: test {
  #   type: sum
  #   sql: CASE WHEN DATE_TRUNC(${date_date}, MONTH) <= DATE_TRUNC(current_date(), MONTH) AND DATE_TRUNC(${date_date}, YEAR) = DATE_TRUNC(current_date(), YEAR)
  #   THEN ${signed_arr_new_logo} + ${signed_arr_upsell} + ${signed_arr_churn_downsell} ELSE null END ;;
  #   value_format_name: eur_0
  #   label: "ARR € added (signed, run. total)"
  # }

  measure: signed_mrr_running_total_sum {
    type: sum
    sql: ${signed_arr_running_total}/12 ;;
    value_format_name: eur_0
    label: "MRR € (signed, run. total)"
  }

  measure: signed_arr_yoy_growth_avg {
    type: average
    sql: ${signed_arr_yoy_growth} ;;
    value_format_name: percent_0
    label: "ARR€ (signed) YoY Growth % (avg)"
  }

}
