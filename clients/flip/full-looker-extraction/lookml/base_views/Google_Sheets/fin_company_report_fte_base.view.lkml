view: fin_company_report_fte_base {
  sql_table_name: `fl-bi-p-poc.source_google_sheets_poc.fin_company_report_fte` ;;

  dimension: development {
    type: number
    sql: ${TABLE}.development ;;
  }
  dimension: general_administrative {
    type: number
    sql: ${TABLE}.general_administrative ;;
  }
  dimension: marketing {
    type: number
    sql: ${TABLE}.marketing ;;
  }
  dimension_group: month {
    type: time
    description: "%m/%d/%E4Y"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.month ;;
  }

  dimension: product {
    type: number
    sql: ${TABLE}.product ;;
  }
  dimension: sales {
    type: number
    sql: ${TABLE}.sales ;;
  }
  dimension: success_support {
    type: number
    sql: ${TABLE}.success_support ;;
  }
  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }
  measure: count {
    type: count
  }
}
