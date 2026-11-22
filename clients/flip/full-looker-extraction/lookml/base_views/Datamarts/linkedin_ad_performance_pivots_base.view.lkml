view: linkedin_ad_performance_pivots_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.linkedin_ad_performance_pivots` ;;

  dimension: ad_cost_euros {
    type: number
    sql: ${TABLE}.ad_cost_euros ;;
  }

  dimension: clicks {
    type: number
    sql: ${TABLE}.clicks ;;
  }

  dimension_group: date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: foreign_key_account_scoring {
    type: string
    sql: ${TABLE}.foreign_key_account_scoring ;;
  }

  dimension: hubspot_company_id {
    type: string
    sql: ${TABLE}.hubspot_company_id ;;
  }

  dimension: hubspot_company_name {
    type: string
    sql: ${TABLE}.hubspot_company_name ;;
  }

  dimension_group: imported_at {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.imported_at ;;
  }

  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
  }

  dimension: pivot {
    type: string
    sql: ${TABLE}.pivot ;;
  }

  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }

  dimension: total_engagements {
    type: number
    sql: ${TABLE}.total_engagements ;;
  }

  dimension: value_label {
    type: string
    sql: ${TABLE}.value_label ;;
  }

  measure: count {
    type: count
  }

}
