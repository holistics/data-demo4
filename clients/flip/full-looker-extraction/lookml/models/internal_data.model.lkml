connection: "fl-bi-p-looker-sa"

include: "/extended_views/Meta_Data/*.view.lkml"      # include all views in the views/ folder in this project
include: "/extended_views/Datamarts/*.view.lkml"
include: "/extended_views/Google_Sheets/*.view.lkml"

label: "Dpt. Data"

explore: fl_bi_p_customer_dashboards_meta {
  label: "Customer Dashboards: Query Costs"
  from: project_costs_daily_ext
  description: "Monitoring of GCP Costs for fl-bi-p-customer-dashboards (metabase)"

  # join: tablesize_datamarts_tables_historized_ext {
  #   type: left_outer
  #   relationship: one_to_many
  #   sql_on: ${fl_bi_p_customer_dashboards_meta.day_date} = ${tablesize_datamarts_tables_historized_ext.history_date} ;;
  # }
}

