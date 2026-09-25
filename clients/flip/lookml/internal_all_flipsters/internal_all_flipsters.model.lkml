connection: "fl-bi-p-looker-sa"

include: "/extended_views/Datamarts/*.view"

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
explore: hubspot_contacts_all {
  from: hubspot_contacts_all_ext
  label: "HS all Contacts"
  view_label: "HS Contacts"
  persist_for: "6 hours"
}

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

}

# ----- USER GROUPS (DAILY AGG.) -------------------------------

# ----- USERS (gross)
explore: flip_users_unique_ext { # no renaming of explore as chaning tiles would be too much effort
  label: "Flip PROD Users (incl. deleted users)"
  hidden:  yes
  description: "User dimensions. Deleted users INcluded."
  view_label: "Users"
}

# ----- APP MIGRATION & TENANTS --------------------------

# ----- USERS & USER GROUPS -------------------------------

# ----- USERS & CHANNELS -------------------------------

# # -----  CHANNELS AND POSTS  -------

explore: flip_channels {
  from: flip_channels_unique_ext
  label: "Flip PROD Channels"
  view_label: "Channels"

  always_filter: {
    filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

  fields: [ALL_FIELDS*,
    -flip_posts_unique_ext.exclude_for_privacy_protection*,
    -flip_posts_unique_ext.exclude_numeric_dimensions*]

  join: flip_posts_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_channels.channel_id} = ${flip_posts_unique_ext.channel_id} ;;
  }

  join: flip_tenants_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_channels.tenant} = ${flip_tenants_unique_ext.tenant} ;;
  }

  join: hubspot_customers_all_ext {
    type: left_outer
    relationship: one_to_one
    sql_on: ${flip_tenants_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
  }
}

# -----  CHANNELS AND USER GROUPS -------

# ----- PAGES --------------------------

# ---- ACTIVITIES PER USER -----------

# ---- R&D Server Costs ------------------------

# ----- R&D Weekly Vibe Survey ----------------

# ----- CS Bi-Weekly Vibe Survey ----------------

# ---- NET RETENTION --------------------------------------

## new NRR recognized, based on FIN data

# ----- LINEAR TICKETS (single) -------------------- (7/24)

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

# --- TASKS EXPLORE --- 12/23

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

#### --- TRANSLATIONS ----------------------------------------------------------------------------

#### --- TRANSLATION CHARACTER COUNTS ----------

#### --- POSTS EXPLORE ------------------

#### --- LIVESTREAM EXPLORE ------------

#### --- USER GROUPS EXPLORE ------------

#### ------- ASK AI Explore -------------------

########################################################################################################################
# ---- LEGACY Explores ------------ (built on "old" data, usually not used anymore)
########################################################################################################################

# ----- OLD NRR (via Hubspot) --------------------------------

 # -------- OINS --------------------------------------------------------------------------

# -------- BITS ----------------------------------------------------------------
#  activities missing

# -------- CIAM

