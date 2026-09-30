view: rd_integrate_standard_integrations_base {
  sql_table_name: `fl-bi-p-poc.source_google_sheets_poc.rd_integrate_standard_integrations` ;;

  dimension: custom_integration_instances_hosted_on_the_platform {
    type: number
    sql: ${TABLE}.custom_integration_instances_hosted_on_the_platform ;;
  }
  dimension: distinct_standard_integrations_deployed {
    type: number
    sql: ${TABLE}.distinct_standard_integrations_deployed ;;
  }
  dimension: environment {
    type: string
    sql: ${TABLE}.environment ;;
  }
  dimension_group: month {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.month ;;
  }
  dimension: standard_integration_instances_hosted_on_the_platform {
    type: number
    sql: ${TABLE}.standard_integration_instances_hosted_on_the_platform ;;
  }
  dimension: tenants_using_standard_integrations {
    type: number
    sql: ${TABLE}.tenants_using_standard_integrations ;;
  }
  measure: count {
    type: count
  }
}
