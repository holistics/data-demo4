connection: "fl-bi-p-looker-sa"

# HubSpot
include: "/extended_views/Datamarts/hubspot_contacts_all_ext.view"
include: "/extended_views/Datamarts/hubspot_deals_all_ext.view"
include: "/extended_views/Datamarts/hubspot_deals_all_historized_ext.view"

include: "/extended_views/Datamarts/hubspot_engagement_calls_sales_ext.view"
include: "/extended_views/Datamarts/hubspot_engagement_emails_sales_ext.view"
include: "/extended_views/Datamarts/hubspot_engagement_meetings_sales_ext.view"
# include: "/extended_views/Datamarts/hubspot_engagement_notes_sales_ext.view"
# include: "/extended_views/Datamarts/hubspot_engagement_tasks_sales_ext.view"

# BDRs

# AEs
include: "/extended_views/Reports/sales_aes_monthly_ext.view"
include: "/extended_views/Reports/sales_aes_deals_next_steps_ext.view"

#************************
#***  Caching         ***
#************************
datagroup: model_refresh_morning {
  sql_trigger: SELECT FLOOR(((TIMESTAMP_DIFF(CURRENT_TIMESTAMP(),'1970-01-01 00:00:00',SECOND)) - 60*60*6)/(60*60*24)) ;;
  max_cache_age: "6 hours"
}

# ------- BDR Dashboards --------------------------------------------------------------------------------------------

# ------- Deals Today's Snapshot ------------------------------------------------------------------------------------

# ------- Deals Historical Snapshots --------------------------------------------------------------------------------

explore: hubspot_deals_all_historized_ext {

  label: "Deals - historical snapshots"
  view_label: "Fields"
  persist_for: "6 hours"

  description: "Explore for deals historical data related questions. Includes data from all deals for each snapshot day - without joins"
}
