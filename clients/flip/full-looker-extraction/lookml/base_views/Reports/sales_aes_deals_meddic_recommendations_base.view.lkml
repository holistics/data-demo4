view: sales_aes_deals_meddic_recommendations_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.sales_aes_deals_meddic_recomendations` ;;

  dimension: deal_id {
    type: string
    sql: ${TABLE}.deal_id ;;
  }
  dimension: meddic_element {
    type: string
    sql: ${TABLE}.meddic_element ;;
  }
  dimension: meddic_metrics_recommendations {
    type: string
    sql: ${TABLE}.meddic_metrics_recommendations ;;
  }
  measure: count {
    type: count
  }
}
