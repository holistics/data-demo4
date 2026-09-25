connection: "fl-bi-p-looker-sa"

include: "/extended_views/Datamarts/hubspot_deals_all_ext.view"
include: "/extended_views/Reports/sales_aes_monthly_ext.view"
include: "/extended_views/Reports/sales_aes_deals_next_steps_ext.view"
include: "/extended_views/Reports/sales_aes_deals_meddic_recommendations_ext.view"

include: "/extended_views/Reports/marketing_account_scoring_engagements_last_90_days_ext.view"

include: "/extended_views/Reports/cd_account_scorecard_historized_ext.view"
include: "/extended_views/Reports/cd_deal_scorecard_historized_ext.view"
include: "/extended_views/Reports/cd_license_success_cohort_view_ext.view"
include: "/extended_views/Google_Sheets/fin_carr_budget_ext.view"

#************************
#***  Caching         ***
#************************
datagroup: model_refresh_morning {
  sql_trigger: SELECT FLOOR(((TIMESTAMP_DIFF(CURRENT_TIMESTAMP(),'1970-01-01 00:00:00',SECOND)) - 60*60*6)/(60*60*24)) ;;
  max_cache_age: "6 hours"
}

# label: "Management"

# ------- Repeatability  -----------------------------------------------------------------
# For Repeatability dashboards for Management

# -----------------------------------------

explore: sales_aes_monthly_ext {

  label: "Sales Repeatability"
  view_label: "AEs & Quotas"
  persist_for: "6 hours"

  fields: [ALL_FIELDS*, -joining_closed_won.all_datamart_hubspot_customers_all_related_fields*, -joining_close_date.all_datamart_hubspot_customers_all_related_fields*]

  join: joining_sal {
    from: hubspot_deals_all_ext
    type: left_outer
    relationship: one_to_many

    sql_on: ${sales_aes_monthly_ext.primary_key} = ${joining_sal.foreign_key_trunc_month_dmt_sal_ae_name}
     AND  ${joining_sal.is_license_overrun_deal} IS false AND ${joining_sal.exclude_flip_flow_sals} IS true ;;
    view_label: "Join on DMT SAL"
  }

  join: joining_closed_won {
    from: hubspot_deals_all_ext
    type: left_outer
    relationship: one_to_many
    sql_on: ${sales_aes_monthly_ext.primary_key} = ${joining_closed_won.foreign_key_trunc_month_dmt_closed_won_ae_name} ;;
    view_label: "Join on DMT Closed Won"
  }

  join: joining_close_date {
    from: hubspot_deals_all_ext
    type: left_outer
    relationship: one_to_many
    sql_on: ${sales_aes_monthly_ext.primary_key} = ${joining_close_date.foreign_key_trunc_month_close_date_ae_name} ;;
    view_label: "Join on Close Date"
  }

  join: joining_sao_date {
    from: hubspot_deals_all_ext
    type: left_outer
    relationship: one_to_many
    sql_on: ${sales_aes_monthly_ext.primary_key} = ${joining_sao_date.foreign_key_trunc_month_dmt_sao_ae_name} ;;
    view_label: "Join on DMT SAO"
  }

  join: sales_aes_deals_next_steps_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${joining_close_date.deal_id} = ${sales_aes_deals_next_steps_ext.deal_id} ;;
    view_label: "Deal Next Steps - Snapshots"
  }

  join: sales_aes_deals_meddic_recommendations_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${joining_close_date.deal_id} = ${sales_aes_deals_meddic_recommendations_ext.deal_id} ;;
    view_label: "Deal MEDDIC Recommendations"
  }

  join: marketing_account_scoring_engagements_last_90_days_ext {
    type: left_outer
    relationship: many_to_many
    sql_on: ${joining_close_date.company_id} = ${marketing_account_scoring_engagements_last_90_days_ext.account_id} ;;
    view_label: "Account Scoring (l90d)"
  }
  }

  # ----- PEOPLE ------------

##############################################
# CD Dashboard Explores
#
# Joins account-grain scorecard (stocks, downsell, NDR/GDR) with
# deal-grain scorecard (SAO, Upsell events) on
# (company_id, period_grain, period_end_date).
#
# Two-CSM attribution model:
#   - Stocks (ARR, MAU, downsell, NDR/GDR) → Account.CS Name
#   - Flows (SAO, Upsell CARR)            → Deal.Deal CS Name
#
# Fan-out caution:
#   The join is one_to_many. Querying account-level sums across
#   the join multiplies them by deal count. For tiles mixing
#   stock + flow metrics, use merge_results in Looker, or design
#   tiles to use one view only.
##############################################

explore: cd_account_scorecard_historized_ext {
  label: "CD Dashboard"
  description: "Customer Delivery Dashboard data source. Account stocks (ARR, MAU, NDR/GDR) joined to deal-level events (SAO, Upsell) at (company × period) grain."
  view_label: "Account"
  group_label: "Reports"

  always_filter: {
    filters: [
      cd_account_scorecard_historized_ext.period_grain: "quarter"
    ]
  }

  join: cd_deal_scorecard_historized_ext {
    view_label: "Deal"
    type: left_outer
    relationship: one_to_many
    sql_on:
      ${cd_account_scorecard_historized_ext.company_id} = ${cd_deal_scorecard_historized_ext.company_id}
      AND ${cd_account_scorecard_historized_ext.period_grain} = ${cd_deal_scorecard_historized_ext.period_grain}
      AND ${cd_account_scorecard_historized_ext.period_end_date} = ${cd_deal_scorecard_historized_ext.period_end_date} ;;
  }

  join: fin_carr_budget_ext {
    view_label: "Targets"
    type: left_outer
    relationship: many_to_one
    sql_on:
      ${cd_account_scorecard_historized_ext.period_grain} = ${fin_carr_budget_ext.period_grain}
      AND ${cd_account_scorecard_historized_ext.period_end_date} = ${fin_carr_budget_ext.period_end_date} ;;
  }
}

#################################################
## License Success View Explore

explore: cd_license_success_cohort_view_ext {
  label: "CD License Success Cohort"
  description: "Data Source for the License Success Cohort on the CD Dashboard. One row per (account, period_grain, period_end_date) for accounts with a signed New Business deal. Supports both monthly and quarterly views — filter on period_grain in Looker, and pair with the matching cohort dimension (cohort_month_label OR cohort_quarter_label)."
  group_label: "Reports"
}

#################################################
## Finance Budget CARR

# explore: fin_carr_budget_ext {
#   label: "CD Finance CARR Budget"
#   description: "Finance CARR Budget per Quarter."
#   group_label: "Reports"
# }
