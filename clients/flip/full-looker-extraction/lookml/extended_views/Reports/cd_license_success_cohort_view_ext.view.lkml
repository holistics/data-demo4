include: "/base_views/Reports/cd_license_success_cohort_view_base.view"

view: cd_license_success_cohort_view_ext {
  extends: [cd_license_success_cohort_view_base]

  ## DIMENSIONS

  ## --- Grain & period ---
  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: CONCAT(
          ${company_id}, '_',
          ${period_grain}, '_',
          CAST(${period_end_date} AS STRING)
        ) ;;
  }
  dimension: allocation {
    type: string
  }
  dimension: cohort_month_label {
    type: string
    order_by_field: period_end_date
  }
  dimension_group: cohort_month_start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: cohort_quarter_label {
    type: string
    order_by_field: period_end_date
  }
  dimension_group: cohort_quarter_start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: company_id {
    type: string
  }
  dimension: company_name {
    type: string
  }
  dimension: company_region {
    type: string
  }
  dimension_group: contract_signed {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: cs_name {
    type: string
  }
  dimension: lsr {
    type: number
    hidden: yes
  }
  dimension: months_since_signing {
    type: number
  }
  dimension_group: period_end {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: period_grain {
    type: string
  }
  dimension: period_month_label {
    type: string
    order_by_field: period_end_date
  }
  dimension: period_quarter_label {
    type: string
    order_by_field: period_end_date
  }
  dimension: quarters_since_signing {
    type: number
  }
  dimension: segment {
    type: string
  }
  dimension: tenant {
    type: string
  }

    ## MEASURES

  measure: avg_lsr {
    type: average
    sql: ${lsr} ;;
    value_format_name: percent_0
    label: "Avg LSR"
  }

  measure: count_accounts_in_cohort {
    type: count_distinct
    sql: ${company_id} ;;
    label: "# Accounts in Cohort"
  }

  ## PARAMETER

  parameter: cohort_grain {
    type: unquoted
    default_value: "quarter"
    allowed_value: { value: "month" }
    allowed_value: { value: "quarter" }
  }

  dimension: cohort_label {
    type: string
    sql:
    {% if cohort_grain._parameter_value == 'month' %}
      ${cohort_month_label}
    {% else %}
      ${cohort_quarter_label}
    {% endif %} ;;
  }

  dimension: period_label {
    type: string
    sql:
    {% if cohort_grain._parameter_value == 'month' %}
      ${period_month_label}
    {% else %}
      ${period_quarter_label}
    {% endif %} ;;
  }
}
