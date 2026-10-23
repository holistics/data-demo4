connection: "fl-bi-p-looker-sa"

include: "/extended_views/Datamarts/*.view"
include: "/extended_views/Google_Sheets/cs_nps_surveys_ext.view"
include: "/extended_views/Google_Sheets/fin_mrr_per_customer_group_normalized_nrr_ext.view"
include: "/extended_views/Google_Sheets/fin_company_report_finance_kpis_ext.view"
include: "/extended_views/Google_Sheets/fin_company_report_fte_ext.view"
include: "/extended_views/Google_Sheets/rd_sre_platform_costs_ext.view"
include: "/extended_views/Google_Sheets/rd_weekly_vibe_survey_ext.view"
include: "/extended_views/Google_Sheets/cs_biweekly_vibe_survey_ext.view"

include: "/extended_views/Google_Sheets/rd_integrate_standard_integrations_ext.view"
include: "/extended_views/Google_Sheets/rd_linear_issues_ext.view"
include: "/extended_views/Google_Sheets/rd_linear_teams_ext.view"

include: "/extended_views/Reports/*.view"

label: "All Flipsters"

#************************
#***  Caching         ***
#************************
datagroup: model_refresh_morning {
  sql_trigger:
  SELECT
    FLOOR( -- largest integer value that is smaller than or equal to:
      ((TIMESTAMP_DIFF(CURRENT_TIMESTAMP(),'1970-01-01 00:00:00',SECOND))
      - 60*60*7) -- 7h -> refeshs at 7 in the morning
        /(60*60*24)) ;;
  max_cache_age: "25 hours"
}

# ------- Flip Monitoring Sheet -------------------

#### --- G-Sheets Meta Data -------------creation_month_for_join_aggregations---------------

# --- Company-Reporting (Finance/Maxi) -----

explore: fin_company_report_finance_kpis_ext {
  label: "Company KPIs"
  persist_for: "24 hours"
  description: "Revenue, headcount and other company-wide KPIs curated and reported by Finance Dpt. (Maxi)."
  view_label: "Dimensions & Measures"

  join: fin_company_report_fte_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fin_company_report_finance_kpis_ext.date_month} = ${fin_company_report_fte_ext.month_month} ;;
    view_label: "Dimensions & Measures"
  }
}

# --- Deals & Companies all ----------------------

explore: hubspot_deals_and_companies_all {
  from: hubspot_deals_all_ext
  label: "HS all Deals, Companies & Source Channel Contacts"
  view_label: "HS Deals"
  #fields: [hubspot_deals_and_companies_all.all_flipsters_fields*, hubspot_companies_all_ext*, hubspot_customers_all_ext*]

  persist_for: "6 hours"

  join: hubspot_companies_all_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${hubspot_deals_and_companies_all.company_id} = ${hubspot_companies_all_ext.company_id} ;;
    view_label: "HS Companies"
  }

  join: hubspot_customers_all_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${hubspot_deals_and_companies_all.company_id} = ${hubspot_customers_all_ext.company_id} ;;
    view_label: "HS Customer Companies"
  }

  join: hubspot_deals_all_historized_ext {
    type: full_outer
    relationship: one_to_many
    sql_on: ${hubspot_deals_and_companies_all.deal_id} = ${hubspot_deals_all_historized_ext.deal_id} ;;
    view_label: "HS Deals historized (daily)"
  }

  join: hubspot_contacts_all_ext {
    type: full_outer
    relationship: one_to_many
    sql_on: ${hubspot_deals_and_companies_all.deal_source_channel_first_contact_id_associated_hubspot} = ${hubspot_contacts_all_ext.contact_id} ;;
    view_label: "HS Contacts (first associated for Source Ch.)"
  }
}

# --- Contacts all ----------------------

# ---------------------

# ---- Customers & Deals  ----------------------------------------------

explore: all_flipsters_customers_and_deals {
  from: hubspot_customers_all_ext
  label: "Customers & Deals"
  fields: [all_flipsters_customers_and_deals.all_flipsters_usage_relevant*, hubspot_deals_all_ext.all_flipsters_fields*,
    hubspot_deals_all_ext.all_net_retention_fields*, hubspot_deals_all_ext.all_gross_retention_fields*,
    product_deals_feature_matrix_ext*, cs_measures_history_ext_id*,cs_measures_history_ext_id_and_date*, flip_feature_tenant_unique_ext*, flip_tenants_daily_aggregations_historized_ext*, cs_nps_surveys_ext*,
    flip_user_groups_unique_ext*, zendesk_tickets_all_ext*,
    cs_import_vitally_ext.all_flip_customers_and_deals_relevant*, cs_customer_lifecycle_thresholds_ext.all_flipster_relevant*]

  view_label: "Customers"
  persist_for: "3 hours"
  description: "Customer accounts, tenant and deal information. Per default filtered for 'Customers' only, but can be extended to 'PoVs, Churns'."

  always_filter: {
    filters: [all_flipsters_customers_and_deals.vitally_lifecycle: "Customer"]
  }

  join: hubspot_deals_all_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${all_flipsters_customers_and_deals.company_id} = ${hubspot_deals_all_ext.company_id} ;;
    view_label: "Deals"
    fields: [hubspot_deals_all_ext.all_flipsters_fields*, hubspot_deals_all_ext.all_net_retention_fields*, hubspot_deals_all_ext.all_gross_retention_fields*]
  }

  join: product_deals_feature_matrix_ext {
    type: left_outer
    relationship: one_to_one
    sql_on: ${hubspot_deals_all_ext.deal_id} = ${product_deals_feature_matrix_ext.deal_id} ;;
    # fields: [product_deals_feature_matrix_ext*]
    view_label: "Features per Deal (Hubspot)"
  }

  join: cs_import_vitally_ext {
    type: left_outer
    relationship: one_to_one
    sql_on: ${all_flipsters_customers_and_deals.company_id} = ${cs_import_vitally_ext.hubspot_company_id} ;;
    view_label: "Customers"
  }

  join: flip_feature_tenant_unique_ext {
    type:  left_outer
    sql_on: ${all_flipsters_customers_and_deals.tenant} = ${flip_feature_tenant_unique_ext.tenant} ;;
    relationship: one_to_many
    view_label: "Features per Tenant (Tenant Controller)"
  }

  join: flip_tenants_daily_aggregations_historized_ext {
    type: left_outer
    relationship: one_to_many
    #sql_on: ${flip_feature_tenant_unique_ext.tenant} = ${flip_tenants_daily_aggregations_historized_ext.tenant} ;;
    sql_on: ${all_flipsters_customers_and_deals.tenant} = ${flip_tenants_daily_aggregations_historized_ext.tenant} ;;
    view_label: "Tenants (daily agg.)"
  }

  join: flip_user_groups_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${all_flipsters_customers_and_deals.tenant} = ${flip_user_groups_unique_ext.tenant} ;;
    view_label: "User Groups"
  }

  join: cs_measures_history_ext_id {
    from: cs_measures_history_ext
    type: left_outer
    relationship: one_to_many
    sql_on: ${all_flipsters_customers_and_deals.company_id} = ${cs_measures_history_ext_id.company_id} ;;
    view_label: "Customers Metric History (on id)"
  }

  join: cs_measures_history_ext_id_and_date { ##
    from: cs_measures_history_ext
    type: left_outer
    relationship: one_to_one
    sql_on: ${flip_tenants_daily_aggregations_historized_ext.tenant} = ${cs_measures_history_ext_id_and_date.tenant}
    AND ${flip_tenants_daily_aggregations_historized_ext.date_berlin_date} = ${cs_measures_history_ext_id_and_date.date_date} ;;
    view_label: "Customers Metric History (on id & date)"
  }

  join: cs_customer_lifecycle_thresholds_ext {
    type: left_outer
    relationship: one_to_one
    sql_on:  ${all_flipsters_customers_and_deals.company_id} = ${cs_customer_lifecycle_thresholds_ext.company_id};;
    view_label: "Customers"
  }

  join: zendesk_tickets_all_ext {
    type: full_outer
    relationship: one_to_many
    sql_on: ${all_flipsters_customers_and_deals.company_id} = ${zendesk_tickets_all_ext.hubspot_id} ;;
    view_label: "Tickets Zendesk"
  }

  join: cs_nps_surveys_ext {
    type: left_outer
    relationship: one_to_many
    sql_on:  ${all_flipsters_customers_and_deals.company_id} = ${cs_nps_surveys_ext.hubspot_company_id} ;;
    view_label: "NPS"
  }
}

# ----- USER GROUPS (DAILY AGG.) -------------------------------

# ----- USERS (gross)

# ----- APP MIGRATION & TENANTS --------------------------
explore: app_migration_codes_all_flip {
  from: flip_app_migration_code_entries_unique_ext
  label: "Flip PROD App Migration"
  #description: "Daily stats on User level incl. User Group information, including User Group assignments. Deleted users excluded."
  view_label: "Migration Code Entries"

  persist_for: "4 hours"
  # always_filter: {
  #   filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  # }

  join: flip_tenants_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${app_migration_codes_all_flip.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenant"
  }

  join: hubspot_customers_all_ext { # for production only
    type: left_outer
    relationship: one_to_one
    sql_on: ${flip_tenants_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    #fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }

  join: flip_user_core_device_group_counts_today_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_tenants_unique_ext.tenant} = ${flip_user_core_device_group_counts_today_ext.tenant}  ;;
    view_label: "Tenant: Users per Device Group Counts"
  }

  join: flip_user_device_latest_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${app_migration_codes_all_flip.user_id} = ${flip_user_device_latest_unique_ext.user_id} ;;
    view_label: "User Devices (latest)"
    # fields: [count_codes_per_user_sum, count_codes_per_user, user_id, count]
  }
  }

# ----- USERS & USER GROUPS -------------------------------

explore: users_and_user_groups_historized_all_flip { # no renaming of explore as chaning tiles would be too much effort
  from: flip_users_daily_aggregations_historized_ext
  label: "Flip PROD Users & User Groups (incl. daily agg)"
  description: "Daily stats on User level incl. User Group information, including User Group assignments. Deleted users excluded."
  view_label: "Users (daily agg.) incl. AU"

  always_filter: {
    filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

  join: flip_users_daily_aggregations_historized_ext__user_group_ids {
    view_label: "User agg: User Group Ids"
    sql: left join unnest(${users_and_user_groups_historized_all_flip.user_group_ids}) as flip_users_daily_aggregations_historized__user_group_ids ;;
    relationship: one_to_many
  }

  join: flip_users_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${users_and_user_groups_historized_all_flip.user_id} = ${flip_users_unique_ext.user_id} ;;
    view_label: "Users Net"
  }

  # join: flip_user_groups_daily_aggregations_historized_ext {
  #   sql_on: ${flip_user_groups_unique_ext.user_group_id} = ${flip_user_groups_daily_aggregations_historized_ext.user_group_id} ;;
  #   relationship: one_to_many
  #   view_label: "User Groups (historized)"
  # }

  join: flip_user_groups_unique_ext {
    type: left_outer
    relationship: many_to_one
    # sql_on: ${flip_user_group_assignments_unique_ext.user_group_id} = ${flip_user_groups_unique_ext.user_group_id} ;;
    sql_on: ${flip_users_daily_aggregations_historized_ext__user_group_ids.flip_users_daily_aggregations_historized__user_group_ids} = ${flip_user_groups_unique_ext.user_group_id} ;;
    view_label: "User Groups"
  }

  join: flip_user_group_assignments_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_users_unique_ext.user_id} = ${flip_user_group_assignments_unique_ext.user_id} ;; # joining directly on base table would be n:m
    # sql_on: ${flip_user_groups_unique_ext.user_group_id} = ${flip_user_group_assignments_unique_ext.user_group_id} ;; # always join on user_id, joins on user_group_id cause fanouts in user measures
    view_label: "User Group Assignments"
  }

  join: flip_tenants_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users_and_user_groups_historized_all_flip.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenant"
  }

  join: flip_feature_tenant_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_tenants_unique_ext.tenant} = ${flip_feature_tenant_unique_ext.tenant} ;;
    view_label: "Feature Toggles (Tenant)"
  }

  join: hubspot_customers_all_ext { # for production only
    type: left_outer
    relationship: one_to_one
    sql_on: ${flip_tenants_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    #fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }

  join: flip_user_devices_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users_and_user_groups_historized_all_flip.user_id} = ${flip_user_devices_unique_ext.user_id} ;;
    view_label: "User Devices"
  }
}

# ----- USERS & CHANNELS -------------------------------

explore: users_and_channels_historized_all_flip { # no renaming of explore as chaning tiles would be too much effort
  from: flip_users_daily_aggregations_historized_ext
  label: "Flip PROD Users & Channels (incl. daily agg.)"
  description: "Daily stats on User level incl. Channel information, including Channel memberships. Deleted users excluded."
  view_label: "Users (daily agg.) incl. AU"

  always_filter: {
  filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

  join: flip_users_daily_aggregations_historized_ext__channel_ids {
    view_label: "Users Explore Andrea: Channel Ids"
    sql: left join unnest(${users_and_channels_historized_all_flip.channel_ids}) as flip_users_daily_aggregations_historized__channel_ids ;;
    relationship: one_to_many
  }

  join: flip_users_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${users_and_channels_historized_all_flip.user_id} = ${flip_users_unique_ext.user_id} ;;
    view_label: "Users Net"
  }

  join: flip_channels_daily_aggregations_historized_ext {
    sql_on: ${flip_channels_unique_ext.channel_id} = ${flip_channels_daily_aggregations_historized_ext.channel_id} ;;
    relationship: one_to_many
    view_label: "Channels (daily agg.)"
  }

  join: flip_channels_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_users_daily_aggregations_historized_ext__channel_ids.flip_users_daily_aggregations_historized__channel_ids} = ${flip_channels_unique_ext.channel_id} ;;
    view_label: "Channels"
  }

  join: flip_user_groups_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on:  ${flip_channels_unique_ext.managing_user_group_id} = ${flip_user_groups_unique_ext.user_group_id} ;;
    view_label: "Channel Managing User Group"
  }

    join: flip_channels_unique__admin_permissions {
      view_label: "Flip Channel Unique: Admin Permissions"
      sql: LEFT JOIN UNNEST(${flip_channels_unique_ext.admin_permissions}) as flip_channels_unique__admin_permissions ;;
      relationship: one_to_many
    }

    join: flip_channels_unique__member_permissions {
      view_label: "Flip Post Groups Unique: Member Permissions"
      sql: LEFT JOIN UNNEST(${flip_channels_unique_ext.member_permissions}) as flip_channels_unique__member_permissions ;;
      relationship: one_to_many
    }

    join: flip_channels_unique__moderator_permissions {
      view_label: "Flip Channels Unique: Moderator Permissions"
      sql: LEFT JOIN UNNEST(${flip_channels_unique_ext.moderator_permissions}) as flip_channels_unique__moderator_permissions ;;
      relationship: one_to_many
    }

  join: flip_channel_memberships_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_channels_unique_ext.channel_id} = ${flip_channel_memberships_unique_ext.channel_id} ;; # always join on user_id, joins on post_group_id cause fanouts in user measures
    view_label: "Channel Memberships"
  }

  # join: flip_user_groups_unique_ext { \ tbd
  #   type: left_outer
  #   relationship: one_to_many
  #   sql_on: user_group_id ;;
  # }

  join: flip_tenants_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users_and_channels_historized_all_flip.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenant"
  }

  join: flip_feature_tenant_unique_ext { # remove once customers have transitioned to UGs
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_tenants_unique_ext.tenant} = ${flip_feature_tenant_unique_ext.tenant} ;;
    view_label: "Feature Toggles (Tenant)"
  }

  join: hubspot_customers_all_ext { # for production only
    type: left_outer
    relationship: one_to_one
    sql_on: ${flip_tenants_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    #fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }

  join: flip_user_devices_unique_ext { # remove once customers have transitioned to UGs
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_users_unique_ext.user_id} = ${flip_user_devices_unique_ext.user_id} ;;
    view_label: "User Devices"
  }
  }

# # -----  CHANNELS AND POSTS  -------

# -----  CHANNELS AND USER GROUPS -------

explore: flip_channels_and_user_groups {
  from: flip_channels_unique_ext
  label: "Flip PROD Channels & User Groups"
  view_label: "Channels"
  description: "Flip Core PRODUCTION data / Go-To Explore the interplay of Channels x User Groups."

  persist_for: "24 hours"

  always_filter: {
    filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

  join: flip_user_groups_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_channels_and_user_groups.managing_user_group_id} = ${flip_user_groups_unique_ext.user_group_id};;
    view_label: "Channel managing UGs"
  }

  join: flip_channel_memberships_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_channels_and_user_groups.channel_id} = ${flip_channel_memberships_unique_ext.channel_id} ;;
    view_label: "Channel Memberships"
  }

  join: flip_user_group_assignments_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_user_groups_unique_ext.user_group_id} = ${flip_user_group_assignments_unique_ext.user_group_id}  ;;
    view_label: "Channel managing UG Assignments"
  }

  join: hubspot_customers_all_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_channels_and_user_groups.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    view_label: "Customers"
  }

  join: flip_tenants_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_channels_and_user_groups.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenants"
  }

  join: flip_feature_tenant_unique_ext { # remove once customers have transitioned to UGs
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_tenants_unique_ext.tenant} = ${flip_feature_tenant_unique_ext.tenant} ;;
    view_label: "Tenant Feature Toggles"
  }

  # join: flip_channels_daily_aggregations_historized_ext {
  #   type: left_outer
  #   sql_on: ${flip_channels_and_user_groups.channel_id} = ${flip_channels_daily_aggregations_historized_ext.channel_id} ;;
  #   relationship: one_to_many
  #   view_label: "Channels (daily agg.)"
  # }
}

# ----- PAGES --------------------------
explore: pages_all_flip {
  from: flip_page_settings_unique_ext
  label: "Flip PROD Pages"
  view_label: "Page Settings"

  persist_for: "3 hours"

  # always_filter: {
  #   filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  # }

  join: flip_tenants_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${pages_all_flip.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenant"
  }

  join: hubspot_customers_all_ext { # for production only
    type: left_outer
    relationship: one_to_one
    sql_on: ${flip_tenants_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    #fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }

  join: flip_page_contents_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${pages_all_flip.page_id} = ${flip_page_contents_unique_ext.page_id}  ;;
    view_label: "Page Contents"
  }

  join: flip_page_user_assignments_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${pages_all_flip.page_id} = ${flip_page_user_assignments_unique_ext.page_id};;
    view_label: "User Assignments"
  }

  join: flip_page_user_group_assignments_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${pages_all_flip.page_id} = ${flip_page_user_group_assignments_unique_ext.page_id};;
    view_label: "User Group Assignments"
  }

  join: flip_attachments_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${pages_all_flip.page_id} = ${flip_attachments_unique_ext.attachment_element_id} ;;
    view_label: "Page Attachments"
  }

  join: flip_feature_tenant_unique_ext {
    type:  left_outer
    sql_on: ${pages_all_flip.tenant} = ${flip_feature_tenant_unique_ext.tenant} ;;
    relationship: one_to_many
    view_label: "Features per Tenant (Tenant Controller)"
  }

  #might need to add parent_paths on request (check channel permissions for code) // on request only
}

# ---- ACTIVITIES PER USER -----------

explore: flip_production_user_activities { # no renaming of explore as chaning tiles would be too much effort
  from:  flip_users_au_activities_historized_ext
  label: "Flip PROD User Activites"
  view_label: "Single Activites per User per day"
  description: "Flip Core PRODUCTION data / Go-To Explore for understand what kind of actions our users conduct."

  join: hubspot_customers_all_ext { # for production only
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_production_user_activities.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    #fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }
  }

# ---- R&D Server Costs ------------------------

explore: rd_sre_platform_costs_ext {
  label: "R&D Monthly KPIs (Platform Costs, Standard Integrations)"
  description: "Includes monthly R&D KPIs such as standard integrations and platform costs and user stats for all PROD02 tenants that are customers (excl. PoVs, churns, test-tenants, etc.)."
  view_label: "Monthly Costs"

  persist_for: "4 hours"

  always_filter: {
    filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

  join: rd_prod02_customers_daily_users_agg_ext { # -- only includes vitally_lifecycle: "Customer"
    type: left_outer
    relationship: many_to_one
    sql_on: DATE_TRUNC(${rd_sre_platform_costs_ext.month_date}, MONTH) = DATE_TRUNC(${rd_prod02_customers_daily_users_agg_ext.date_berlin_date}, MONTH) ;;
    view_label: "Users"
  }

  join: rd_integrate_standard_integrations_ext {
    type: left_outer
    relationship: one_to_one
    sql_on: ${rd_sre_platform_costs_ext.primary_key} = ${rd_integrate_standard_integrations_ext.primary_key} ;;
  }

  join: flip_tenants_daily_aggregations_historized_ext {
    type: left_outer
    relationship: many_to_many
    sql_on: DATE_TRUNC(${rd_sre_platform_costs_ext.month_date}, MONTH) = DATE_TRUNC(${flip_tenants_daily_aggregations_historized_ext.date_berlin_date}, MONTH) ;;
    sql_where: ${flip_tenants_daily_aggregations_historized_ext.is_last_day_of_month} ;;
    view_label: "Tenants (monthly agg)"
  }

  join: hubspot_customers_all_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${hubspot_customers_all_ext.tenant} = ${flip_tenants_daily_aggregations_historized_ext.tenant} ;;
    view_label: "Customers"
  }
}

# ----- R&D Weekly Vibe Survey ----------------

explore: rd_weekly_vibe_survey_ext {
  label: "R&D weekly Vibe"
  view_label: "Survey Results"
  description: "Weekly anonymous survey on mood within R&D."
}

# ----- CS Bi-Weekly Vibe Survey ----------------

explore: cs_biweekly_vibe_survey_ext {
  label: "CS bi-weekly Vibe"
  view_label: "Survey Results"
  description: "Bi-weekly anonymous survey on mood within CS."
}

# ---- NET RETENTION --------------------------------------

## new NRR recognized, based on FIN data

explore: fin_mrr_per_customer_group_normalized_nrr_ext {
  label: "NRR (recognized)"
  view_label: "NRR (Finance)"

  #always_filter: {
  # filters: [fin_mrr_per_customer_group_normalized_nrr_ext.month_month: "last 12 months"]}

  persist_for: "3 hours"

  join: fin_customer_groups_lookup_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fin_mrr_per_customer_group_normalized_nrr_ext.fin_customer_group_id} = ${fin_customer_groups_lookup_ext.fin_customer_group_id} ;;
            # AND ${fin_mrr_per_customer_group_normalized_nrr_ext.month_month} = ${fin_customer_groups_lookup_ext.fin_customer_group_cohort_month} ;;
            # would only show revenue per customer for the cohort year
    view_label: "Customer Groups"
  }

  join: fin_customer_groups_lookup__hubspot_company_ids_ext {
    sql: LEFT JOIN UNNEST(${fin_customer_groups_lookup_ext.hubspot_company_ids}) as fin_customer_groups_lookup__hubspot_company_ids ;;
    relationship: one_to_many
    view_label: "Customer Groups"
  }
}

# ----- LINEAR TICKETS (single) -------------------- (7/24)

explore: rd_linear_issues_ext {
  persist_for: "4 hours"
  label: "R&D Linear Tickets (single)"
  view_label: "Issues"

  join: rd_linear_teams_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${rd_linear_issues_ext.team} = ${rd_linear_teams_ext.sub_team_name}  ;;
    view_label: "Squads & Teams"
  }
  }

# ----- LINEAR TICKETS MONTHLY AGG -------------------- (5/25

# ----- LINEAR TICKETS MONTHLY AGG DATES SPINE -------------------- (10/25

# ----- R&D EXPLORATORY TESTING EFFECTIVENESS -------------------- (9/25)

# ----- R&D SONARQUBE ANALYSIS -------------------- (9/25)

# ----- R&D TEST COVERAGE MINI APPS -------------------- (9/25)

# -- CORE PRODUCTION DATA -------------------------------------------------------------------------

#### --- TENANT Explore ------------ new 11/23

explore: flip_production_tenants {
  from: flip_tenants_daily_aggregations_historized_ext
  label: "Flip PROD Tenants"
  view_label: "Tenants (daily agg.) incl. AU"
  description: "Flip Core PRODUCTION data including all relevant information on our tenants. db_row_deleted = hard delete."

  fields: [ALL_FIELDS*]

  persist_for: "4 hours"

  always_filter: {
    filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

join: flip_tenants_unique_ext {
  type: full_outer
  relationship: many_to_one
  sql_on: ${flip_production_tenants.tenant} = ${flip_tenants_unique_ext.tenant} ;;
  view_label: "Tenants"
}

join: hubspot_customers_all_ext {
  type: left_outer
  relationship: one_to_one
  sql_on: ${flip_tenants_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
  fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
  view_label: "Customer Properties (Hubspot)"
}

join: flip_feature_tenant_unique_ext {
  type: left_outer
  relationship: one_to_many
  sql_on: ${flip_tenants_unique_ext.tenant} = ${flip_feature_tenant_unique_ext.tenant} ;;
  view_label: "Feature Toggles (Tenant)"
}
}

#### --- USERS Explore ------------ new 11/23

# --- CHAT & MESSAGE EXPLORE -- added 12/23

explore: flip_production_chats {
  from: flip_chat_messages_unique_ext
  label: "Flip PROD Chats & Messages"
  view_label: "Messages"
  description: "Flip Core PRODUCTION data including all relevant information on chats. db_row_deleted = hard delete."

  fields: [ALL_FIELDS*, -flip_users_unique_ext.excluding_period_au_fields*]

  persist_for: "4 hours"

  always_filter: {
    filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

  join: flip_chat_message_mentions_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_production_chats.message_id} = ${flip_chat_message_mentions_unique_ext.message_id} ;;
    view_label: "Message Mentions"
  }

  join: flip_chats_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_production_chats.chat_id} = ${flip_chats_unique_ext.chat_id};;
    view_label: "Chats"
  }

  join: flip_chat_memberships_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_chats_unique_ext.chat_id} = ${flip_chat_memberships_unique_ext.chat_id} ;;
    view_label: "Chat Membership"
  }

  join: flip_attachments_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_production_chats.message_id} = ${flip_attachments_unique_ext.attachment_element_id} ;;
    #sql_where: ${flip_attachments_unique_ext.attachment_element_type} = "message" ;;
    view_label: "Message Attachments (incl. Voice Msgs)"
  }

  join: flip_users_unique_ext {
    from: flip_users_unique_ext
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_chat_memberships_unique_ext.user_id} = ${flip_users_unique_ext.user_id} ;;
    view_label: "Users: Chat Members (simple)"
  }

  join: flip_tenants_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_chats_unique_ext.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenants"
  }

  join: hubspot_customers_all_ext {
    type: left_outer
    relationship: one_to_one
    sql_on: ${flip_tenants_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }
}

# --- TASKS EXPLORE --- 12/23

explore: flip_production_tasks {
  from: flip_task_assignees_unique_ext
  label: "Flip PROD Tasks"
  view_label: "Task Assignees"
  description: "Flip Core PRODUCTION data including all relevant tables/features regarding tasks. db_row_deleted = hard delete."

  fields: [ALL_FIELDS*, -flip_users_unique_ext_authors.excluding_period_au_fields*, -flip_users_unique_ext_assignees.excluding_period_au_fields*]

  persist_for: "4 hours"

  always_filter: {
    filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

  join: flip_tasks_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_production_tasks.task_id} = ${flip_tasks_unique_ext.task_id};;
    view_label: "Tasks"
  }

  join: flip_task_comments_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_tasks_unique_ext.task_id} = ${flip_task_comments_unique_ext.task_id};;
    view_label: "Task Comments"
  }

  join: flip_task_comment_reactions_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_task_comments_unique_ext.task_comment_id} = ${flip_task_comment_reactions_unique_ext.comment_id};;
   # sql_on: ${flip_users_unique_ext.user_id} = ${flip_task_comment_reactions_unique_ext.user_id};;
    view_label: "Task Comment Reactions"
  }

  join: flip_users_unique_ext_authors {
    from: flip_users_unique_ext
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_tasks_unique_ext.author_id} = ${flip_users_unique_ext_authors.user_id} ;;
    view_label: "Users: Task Authors (simple)"
  }

  join: flip_users_unique_ext_assignees {
    from: flip_users_unique_ext
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_tasks_unique_ext.author_id} = ${flip_users_unique_ext_assignees.user_id} ;;
    view_label: "Users: Task Assignees (simple)"
  }

  join: flip_tenants_unique_ext {
       type: full_outer
    relationship: many_to_one
    sql_on: ${flip_tasks_unique_ext.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenants"
  }

  join: hubspot_customers_all_ext {
    type: left_outer
    relationship: one_to_one
    sql_on: ${flip_tenants_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }
  }

# --- CALENDAR EXPLORE --- 12/23

#### --- REACTIONS Explore ------------ new 02/24

explore: flip_production_reactions {
  from: flip_reactions_unique_ext
  label: "Flip PROD Reactions (all)"
  view_label: "Reactions"
  description: "Flip Core PRODUCTION data including all relevant tables/features regarding Reactions. db_row_deleted = hard delete."

  fields: [ALL_FIELDS*, -flip_users_unique_ext.excluding_period_au_fields*]

  persist_for: "4 hours"

  always_filter: {
    filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

  join: flip_users_unique_ext { # add field restrictions
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_production_reactions.user_id} = ${flip_users_unique_ext.user_id} ;;
    view_label: "Users (simple)"
  }

  join: hubspot_customers_all_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_users_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }

  join: flip_tenants_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_production_reactions.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenant"
  }
}

#### --- ABSENCES Explore ------------ new 11/23

#### --- MENU ITEMS Explore ------------ new 11/23

explore: flip_production_menu_items {
  from: flip_channel_menu_items_unique_ext
  label: "Flip PROD Menu Items"
  view_label: "Channel Menu Items"
  description: "Flip Core PRODUCTION data including all relevant tables/features regarding (channel) menu items. db_row_deleted = hard delete."

  fields: [ALL_FIELDS*]

  persist_for: "4 hours"

  always_filter: {
    filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

  join: flip_menu_items_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_production_menu_items.menu_item_id} = ${flip_menu_items_unique_ext.menu_item_id} ;;
    view_label: "Menu Items"
  }

  join: flip_channels_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_production_menu_items.channel_id} = ${flip_channels_unique_ext.channel_id}  ;;
    view_label: "Channels"
    #fields: [ALL_FIELDS*, ]
  }

  # join: flip_channel_menu_items_unique_ext {
  #   type: left_outer
  #   relationship: one_to_many
  #   sql_on: ${flip_menu_items_unique_ext.menu_item_id} = ${flip_channel_menu_items_unique_ext.menu_item_id} ;;
  #   view_label: "Channel Menu Items"
  # }

  join: flip_tenants_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_production_menu_items.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenants"
  }

  join: flip_feature_tenant_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_tenants_unique_ext.tenant} = ${flip_feature_tenant_unique_ext.tenant} ;;
    view_label: "Feature Toggles (Tenant)"
  }

  # join: flip_tenants_daily_aggregations_historized_ext {
  #   type: left_outer
  #   relationship: one_to_many
  #   sql_on: ${flip_tenants_unique_ext.tenant} = ${flip_tenants_daily_aggregations_historized_ext.tenant};;
  #   view_label: "Tenants (daily agg)"
  # }

  join: hubspot_customers_all_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_tenants_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }
  }

# #### --- SHAREPOINT PAGES Explore ------------ new 12/23

# explore: flip_production_sharepoint_pages {
#   from: flip_sharepoint_pages_unique_ext
#   label: "Flip PROD Sharepoint Pages"
#   view_label: "Sharepoint Pages"
#   description: "Flip Core PRODUCTION data including all relevant tables/features regarding sharepoint pages. db_row_deleted = hard delete."

#   fields: [ALL_FIELDS*]

#   persist_for: "4 hours"

#   always_filter: {
#     filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
#   }

#   join: flip_tenants_unique_ext {
#     type: full_outer
#     relationship: many_to_one
#     sql_on: ${flip_production_sharepoint_pages.tenant} = ${flip_tenants_unique_ext.tenant} ;;
#     view_label: "Tenants"
#   }

#   join: hubspot_customers_all_ext {
#     type: left_outer
#     relationship: many_to_one
#     sql_on: ${flip_tenants_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
#     fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
#     view_label: "Customer Properties (Hubspot)"
#   }
# }

#### --- ChatGPT -------------------------------------------------

#### --- ATTACHMENTS ----------------------------------------------------------------------------

explore: flip_production_attachments {
  label: "Flip PROD Attachments"
  from: flip_attachments_unique_ext
  view_label: "Attachments"
  description: "Flip Core PRODUCTION data including all details on attachments. db_row_deleted = hard delete."

  persist_for: "4 hours"

  always_filter: {
    filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

  join: flip_tenants_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_production_attachments.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenants"
  }

  join: hubspot_customers_all_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_production_attachments.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }
}

#### --- TRANSLATIONS ----------------------------------------------------------------------------

#### --- TRANSLATION CHARACTER COUNTS ----------
explore: flip_production_translation_character_counts {
  from: flip_translations_character_count_unique_ext
  label: "Flip PROD Translations Character Counts"
  view_label: "Translation Character Counts"
  description: "Flip Core PRODUCTION data including all details on translation character counts. For details on translation languages etc. please use the 'Translations' Explore. db_row_deleted = hard delete."

  persist_for: "4 hours"

  always_filter: {
    filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

  join: flip_tenants_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_production_translation_character_counts.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenants"
    }

  join: hubspot_customers_all_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_production_translation_character_counts.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }
}

#### --- POSTS EXPLORE ------------------

explore: flip_production_posts {
  from: flip_post_seens_unique_ext
  label: "Flip PROD Posts"
  view_label: "Post Seens"
  description: "Flip Core PRODUCTION data including all relevant tables for Post Analytics (single tables, not 'interactions' table). db_row_deleted = hard delete."

  persist_for: "4 hours"

  always_filter: {
    filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

  fields: [ALL_FIELDS*,
    -flip_posts_unique_ext.exclude_for_privacy_protection*,
    -flip_posts_unique_ext.exclude_numeric_dimensions*]
    #-flip_post_groups_unique_ext.exclude_for_privacy_protection*,
    #-flip_post_group_memberships_unique_ext.exclude_for_privacy_protection*]

  join: flip_posts_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_production_posts.post_id} = ${flip_posts_unique_ext.post_id} ;;
    view_label: "Posts"
  }

  join: flip_attachments_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_posts_unique_ext.post_id} = ${flip_attachments_unique_ext.attachment_element_id} ;;
    #sql_where: ${flip_attachments_unique_ext.attachment_element_type} = "post" ;;
    view_label: "Post Attachments"
  }

  join: flip_reactions_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_posts_unique_ext.post_id} = ${flip_reactions_unique_ext.reaction_element_id}  ;;
    #sql_where: ${flip_reactions_unique_ext.reaction_element_type} = "post" ;;
    view_label: "Post Reactions"
  }

  join: flip_post_bookmarks_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_posts_unique_ext.post_id} = ${flip_post_bookmarks_unique_ext.post_id} ;;
    view_label: "Post Bookmarks"
  }

  join: flip_post_comments_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_posts_unique_ext.post_id} =  ${flip_post_comments_unique_ext.post_id};;
    view_label: "Post Comments"
  }

  join: flip_post_survey_choices_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_posts_unique_ext.post_id} = ${flip_post_survey_choices_unique_ext.post_id} ;;
    view_label: "Post Survey Choices"
  }

  join: flip_post_survey_votes_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_post_survey_choices_unique_ext.survey_choice_id} = ${flip_post_survey_votes_unique_ext.survey_choice_id} ;;
    view_label: "Post Survey Votes"
  }

  join: flip_translation_versions_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_posts_unique_ext.post_id} = ${flip_translation_versions_unique_ext.translation_element_id} ;;
    #sql_where: ${flip_translation_versions_unique_ext.translation_element_type} = "post" ;;
    view_label: "Post Translation Versions"
  }

  join: flip_tenants_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_posts_unique_ext.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenants"
  }

  join: hubspot_customers_all_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_tenants_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }

  join: flip_users_unique_ext_seens { # add field restrictions
    from: flip_users_unique_ext
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_production_posts.user_id} = ${flip_users_unique_ext_seens.user_id} ;;
    view_label: "Users: Seens (simple)"
  }

  join: flip_users_unique_ext_authors { # add field restrictions
    from: flip_users_unique_ext
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_posts_unique_ext.author_id} = ${flip_users_unique_ext_authors.user_id} ;;
    view_label: "Users: Seens (simple)"
  }

  join: flip_users_daily_aggregations_historized_ext {
    relationship: one_to_many
    type: left_outer
    sql_on: ${flip_production_posts.user_id} =  ${flip_users_daily_aggregations_historized_ext.user_id} ;;
    view_label: "Users (daily agg.) incl. AU"
  }

  join: flip_post_comment_mentions_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_post_comments_unique_ext.comment_id} =  ${flip_post_comment_mentions_unique_ext.comment_id};;
    view_label: "Post Comment Mentions"
  }

  join: flip_post_comment_reports_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_post_comments_unique_ext.comment_id} = ${flip_post_comment_reports_unique_ext.comment_id}  ;;
    view_label: "Post Comment Reports"
  }
}

#### --- LIVESTREAM EXPLORE ------------

explore: flip_production_livestreams {
  from: flip_livestreams_unique_ext
  label: "Flip PROD Livestreams"
  view_label: "Livestreams"
  description: "Flip Core PRODUCTION data including all relevant tables/features regarding livestreams. db_row_deleted = hard delete."

  fields: [ALL_FIELDS*]

  persist_for: "4 hours"

  always_filter: {
    filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

  join: flip_livestream_participants_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_production_livestreams.livestream_id} = ${flip_livestream_participants_unique_ext.livestream_id} ;;
    view_label: "Livestream Participants"
  }

  join: flip_tenants_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_production_livestreams.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenants"
  }

  join: hubspot_customers_all_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_tenants_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }

  join: flip_feature_tenant_unique_ext {
    type:  left_outer
    sql_on: ${flip_production_livestreams.tenant} = ${flip_feature_tenant_unique_ext.tenant} ;;
    relationship: one_to_many
    view_label: "Features per Tenant (Tenant Controller)"
  }

}

#### --- USER GROUPS EXPLORE ------------

explore: flip_production_user_groups {
  from: flip_user_groups_unique_ext
  label: "Flip PROD User Groups"
  view_label: "User Groups"
  description: "Flip Core PRODUCTION data including all relevant tables/features regarding user groups. db_row_deleted = hard delete."

  fields: [ALL_FIELDS*]

  persist_for: "4 hours"

  always_filter: {
    filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

  join: flip_tenants_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_production_user_groups.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenants"
  }

  join: hubspot_customers_all_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_production_user_groups.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }

  join: flip_feature_tenant_unique_ext {
    type:  left_outer
    sql_on: ${flip_production_user_groups.tenant} = ${flip_feature_tenant_unique_ext.tenant} ;;
    relationship: one_to_many
    view_label: "Features per Tenant (Tenant Controller)"
  }

}

#### ------- ASK AI Explore -------------------

explore: flip_production_ask_ai {
  from: flip_messages_ai_chat_user_questions_original_and_piis_unique_ext
  label: "Flip PROD AskAI"
  view_label: "AskAI"
  description: "Flip Core PRODUCTION data including all relevant tables/features regarding AskAI. db_row_deleted = hard delete."

  fields: [ALL_FIELDS*]

  persist_for: "4 hours"

  join: flip_ask_ai_feedback_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_production_ask_ai.trace_id} = ${flip_ask_ai_feedback_unique_ext.trace_id} ;;
    view_label: "AskAI Feedback"
  }

  join: flip_ask_ai_feedback_unique__tags {
    view_label: "Flip Ask Ai Feedback: Tags"
    sql: LEFT JOIN UNNEST(${flip_ask_ai_feedback_unique_ext.tags}) as flip_ask_ai_feedback_unique__tags ;;
    relationship: one_to_many
  }

  join: flip_tenants_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_production_ask_ai.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenant"
  }

  join: flip_tenants_daily_aggregations_historized_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_tenants_unique_ext.tenant} = ${flip_tenants_daily_aggregations_historized_ext.tenant} ;;
    view_label: "Tenant: Daily Aggregations (incl. daily agg)"
  }

  join: hubspot_customers_all_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_production_ask_ai.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }

}

########################################################################################################################
# ---- LEGACY Explores ------------ (built on "old" data, usually not used anymore)
########################################################################################################################

# ----- OLD NRR (via Hubspot) --------------------------------

 # -------- OINS --------------------------------------------------------------------------

# -------- BITS ----------------------------------------------------------------
#  activities missing

# -------- CIAM

explore: flip_usage_production_ciam {
  from: flip_user_absence_note_mentions_unique_ext
  label: "OLD / don't use - Flip PROD Team CIAM"
  hidden: yes
  view_label: "Absence Note Mentions"
  description: "Flip Core PRODUCTION data including all relevant tables/features for Dev Team CIAM. db_row_deleted = hard delete."

  fields: [ALL_FIELDS*, -flip_users_unique_ext.excluding_period_au_fields*]

  persist_for: "4 hours"

  join: flip_user_absence_notes_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_usage_production_ciam.absence_id} = ${flip_user_absence_notes_unique_ext.absence_id} ;;
    view_label: "Absence Notes"
  }

  join: flip_users_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_user_absence_notes_unique_ext.user_id} = ${flip_users_unique_ext.user_id} ;;
    view_label: "Users"
  }

  join: flip_tenants_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_users_unique_ext.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenants"
  }

  join: flip_tenants_daily_aggregations_historized_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_tenants_unique_ext.tenant} = ${flip_tenants_daily_aggregations_historized_ext.tenant} ;;
    view_label: "Tenant: Daily Aggregations"
  }

  join: hubspot_customers_all_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_tenants_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }

  # join: flip_users_au_activities_unique_ext {
  #   type: left_outer
  #   relationship: one_to_many
  #   sql_on: ${flip_users_unique_ext.user_id} = ${flip_users_au_activities_unique_ext.user_id} ;;
  #   view_label: "Active Users [Beta]"
  # }

  join: flip_feature_tenant_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_tenants_unique_ext.tenant} = ${flip_feature_tenant_unique_ext.tenant} ;;
    view_label: "Feature Toggles (Tenant)"
  }

  join: flip_channel_memberships_unique_ext { # needed for Felix (A&E) now until CS Explore is ready -> remove then
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_users_unique_ext.user_id} = ${flip_channel_memberships_unique_ext.user_id}  ;;
    view_label: "Channels"
    fields: [user_id, tenant, membership_role, is_channel_member_deleted, channel_name ]
  }

}
