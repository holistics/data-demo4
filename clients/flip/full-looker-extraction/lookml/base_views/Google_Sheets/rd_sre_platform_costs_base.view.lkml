view: rd_sre_platform_costs_base {
  sql_table_name: `fl-bi-p-poc.source_google_sheets_poc.rd_sre_platform_costs` ;;

  dimension: aks {
    type: number
    sql: ${TABLE}.aks ;;
  }
  dimension: azure_ai {
    type: number
    sql: ${TABLE}.azure_ai ;;
  }
  dimension: compute_ppu {
    type: number
    sql: ${TABLE}.compute_ppu ;;
  }
  dimension: compute_reserved_1yo3y {
    type: number
    sql: ${TABLE}.compute_reserved_1yo3y ;;
  }
  dimension: database_server {
    type: number
    sql: ${TABLE}.database_server ;;
  }
  dimension: integration_placeholder1 {
    type: number
    sql: ${TABLE}.integration_placeholder1 ;;
  }
  dimension: integration_placeholder2 {
    type: number
    sql: ${TABLE}.integration_placeholder2 ;;
  }
  dimension: integration_placeholder3 {
    type: number
    sql: ${TABLE}.integration_placeholder3 ;;
  }
  dimension: misc {
    type: number
    sql: ${TABLE}.misc ;;
  }
  dimension_group: month {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.month ;;
  }
  dimension: network_bandwith {
    type: number
    sql: ${TABLE}.network_bandwith ;;
  }
  dimension: pulumi_iac_costs {
    type: number
    sql: ${TABLE}.pulumi_iac_costs ;;
  }
  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }
  dimension: sre_hardware_server {
    type: number
    sql: ${TABLE}.sre_hardware_server ;;
  }
  dimension: sre_platform_placeholder1 {
    type: number
    sql: ${TABLE}.sre_platform_placeholder1 ;;
  }
  dimension: sre_platform_placeholder2 {
    type: number
    sql: ${TABLE}.sre_platform_placeholder2 ;;
  }
  dimension: storage {
    type: number
    sql: ${TABLE}.storage ;;
  }
  measure: count {
    type: count
  }
}
