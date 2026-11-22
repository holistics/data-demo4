view: cd_license_success_cohort_view_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.cd_license_success_cohort_view` ;;

  dimension: allocation {
    type: string
    sql: ${TABLE}.allocation ;;
  }
  dimension: cohort_month_label {
    type: string
    sql: ${TABLE}.cohort_month_label ;;
  }
  dimension_group: cohort_month_start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.cohort_month_start ;;
  }
  dimension: cohort_quarter_label {
    type: string
    sql: ${TABLE}.cohort_quarter_label ;;
  }
  dimension_group: cohort_quarter_start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.cohort_quarter_start ;;
  }
  dimension: company_id {
    type: string
    sql: ${TABLE}.company_id ;;
  }
  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
  }
  dimension: company_region {
    type: string
    sql: ${TABLE}.company_region ;;
  }
  dimension_group: contract_signed {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contract_signed_date ;;
  }
  dimension: cs_name {
    type: string
    sql: ${TABLE}.cs_name ;;
  }
  dimension: lsr {
    type: number
    sql: ${TABLE}.lsr ;;
  }
  dimension: months_since_signing {
    type: number
    sql: ${TABLE}.months_since_signing ;;
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
  dimension: period_month_label {
    type: string
    sql: ${TABLE}.period_month_label ;;
  }
  dimension: period_quarter_label {
    type: string
    sql: ${TABLE}.period_quarter_label ;;
  }
  dimension: quarters_since_signing {
    type: number
    sql: ${TABLE}.quarters_since_signing ;;
  }
  dimension: segment {
    type: string
    sql: ${TABLE}.segment ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  measure: count {
    type: count
    drill_fields: [cs_name, company_name]
  }
}
