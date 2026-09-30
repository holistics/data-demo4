include: "/base_views/Reports/gtm_targets_by_department_base.view"

view: gtm_targets_by_department_ext {

  extends: [gtm_targets_by_department_base]

  dimension: primary_key {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.primary_key ;;
  }

  dimension_group: date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: deal_allocation {
    type: string
    sql: ${TABLE}.deal_allocation ;;
  }

  dimension: sao_volume_daily_target {
    type: number
    hidden: yes
    sql: ${TABLE}.sao_volume_daily_target ;;
  }

  dimension: lead_count_daily_target {
    type: number
    hidden: yes
    sql: ${TABLE}.lead_count_daily_target ;;
  }

  dimension: mql_count_daily_target {
    type: number
    hidden: yes
    sql: ${TABLE}.mql_count_daily_target ;;
  }

  dimension: sql_count_daily_target {
    type: number
    hidden: yes
    sql: ${TABLE}.sql_count_daily_target ;;
  }

  dimension: sal_count_daily_target {
    type: number
    hidden: yes
    sql: ${TABLE}.sal_count_daily_target ;;
  }

  dimension: sao_count_daily_target {
    type: number
    hidden: yes
    sql: ${TABLE}.sao_count_daily_target ;;
  }

  dimension: closed_won_count_daily_target {
    type: number
    hidden: yes
    sql: ${TABLE}.closed_won_count_daily_target ;;
  }

  dimension: closed_won_volume_daily_target {
    type: number
    hidden: yes
    sql: ${TABLE}.closed_won_volume_daily_target ;;
  }

  # Measures

  measure: target_sao_volume_by_dept_sum {
    type: sum_distinct
    sql: ${sao_volume_daily_target} ;;
    sql_distinct_key: ${primary_key} ;;
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "Target SAO Volume (Department)"
  }

  measure: target_sao_count_by_dept_sum {
    type: sum_distinct
    sql: ${sao_count_daily_target} ;;
    sql_distinct_key: ${primary_key} ;;
    value_format_name: decimal_0
    label: "Target SAO Count (Department)"
  }

  measure: target_lead_count_by_dept {
    type: sum_distinct
    sql: ${lead_count_daily_target} ;;
    sql_distinct_key: ${primary_key} ;;
    value_format_name: decimal_0
    label: "Target Lead Count (Department)"
  }

  measure: target_mql_count_by_dept {
    type: sum_distinct
    sql: ${mql_count_daily_target} ;;
    sql_distinct_key: ${primary_key} ;;
    value_format_name: decimal_0
    label: "Target MQL Count (Department)"
  }

  measure: target_sql_count_by_dept {
    type: sum_distinct
    sql: ${sql_count_daily_target} ;;
    sql_distinct_key: ${primary_key} ;;
    value_format_name: decimal_0
    label: "Target SQL Count (Department)"
  }

  measure: target_sal_count_by_dept {
    type: sum_distinct
    sql: ${sal_count_daily_target} ;;
    sql_distinct_key: ${primary_key} ;;
    value_format_name: decimal_0
    label: "Target SAL Count (Department)"
  }

  measure: target_closed_won_volume_by_dept {
    type: sum_distinct
    sql: ${closed_won_volume_daily_target} ;;
    sql_distinct_key: ${primary_key} ;;
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "Target Closed Won Volume (Department)"
  }

}
