include: "/base_views/Reports/sales_aes_deals_meddic_recommendations_base.view"

# ------ BASE DIMENSIONS ----------------------------------------------------------------------------------------------

view: sales_aes_deals_meddic_recommendations_ext {

  extends: [sales_aes_deals_meddic_recommendations_base]

  drill_fields: []

  dimension: deal_id {
    type: string
  }

  dimension: meddic_element {
    type: string
  }

  dimension: meddic_metrics_recommendations {
    type: string
  }

  measure: count {
    type: count
    hidden: yes
  }

}
