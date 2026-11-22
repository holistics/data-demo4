view: sales_aes_deals_next_steps_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.sales_aes_deals_next_steps` ;;

  dimension_group: copied_at {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.copied_at_date ;;
  }

  dimension: date_and_step {
    type: string
    sql: ${TABLE}.date_and_step ;;
  }

  dimension: deal_id {
    type: string
    sql: ${TABLE}.deal_id ;;
  }

  dimension: deal_next_step {
    type: string
    sql: ${TABLE}.deal_next_step ;;
  }

  measure: count {
    type: count
  }

}
