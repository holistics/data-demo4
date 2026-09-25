connection: "fl-bi-p-looker-sa"

include: "/extended_views/Datamarts/*.view"

include: "/extended_views/Reports/flip_user_core_device_group_counts_today_ext.view"
include: "/extended_views/Reports/product_deals_feature_matrix_ext.view"

include: "/extended_views/Google_Sheets/cs_nps_surveys_ext.view"
include: "/extended_views/Google_Sheets/fin_mrr_per_customer_group_normalized_nrr_ext.view"

# include: "/extended_views/Datamarts/flip_post_ids_original_unique_ext.view" # sensitive - CS only
# include: "/extended_views/Datamarts/flip_channel_ids_original_unique_ext.view" # sensitive - CS only

#************************
#***  Caching         ***
#************************
datagroup: model_refresh_morning {
  sql_trigger: SELECT FLOOR(((TIMESTAMP_DIFF(CURRENT_TIMESTAMP(),'1970-01-01 00:00:00',SECOND)) - 60*60*6)/(60*60*24)) ;;
  max_cache_age: "25 hours"
}

label: "Dpt. Customer Success"

# ---- Customers only ----------------------------------------------

explore: cs_customers {
  from: hubspot_customers_all_ext
  label: "CS Accounts ⚠️ sensitive data"
  fields: [ALL_FIELDS*
    ]

  description: "Includes all accounts taken care of by CS, including sub-structures such as daughters and multi-tenants."

   # -cs_flip_post_groups_ext.not_relevant_for_cs_explores*

  view_label: "Customers"
  persist_for: "3 hours"

join: hubspot_deals_all_ext {
  type: left_outer
  relationship: one_to_many
  sql_on: ${cs_customers.company_id} = ${hubspot_deals_all_ext.company_id} ;;
  view_label: "Deals"
  fields: [hubspot_deals_all_ext.all_cs_relevant_fields*, -all_net_retention_fields*]
}

  join: product_deals_feature_matrix_ext {
    type: left_outer
    relationship: one_to_one
    sql_on: ${hubspot_deals_all_ext.deal_id} = ${product_deals_feature_matrix_ext.deal_id} ;;

    view_label: "Features per Deal (Hubspot)"
  }

join: cs_measures_history_ext {
  type: left_outer
  relationship: one_to_many
  sql_on: ${cs_customers.company_id} = ${cs_measures_history_ext.company_id} ;;
  view_label: "Customers Metric History"
}

# join: flip_tenants_daily_aggregations_historized_ext { ## missing datapoints for days where cs_measures_history doesn't have entries
#   type: left_outer
#   relationship: one_to_one
#   sql_on: ${cs_measures_history_ext.tenant} = ${flip_tenants_daily_aggregations_historized_ext.tenant}
#         AND ${cs_measures_history_ext.date_date} = ${flip_tenants_daily_aggregations_historized_ext.date_berlin_date}  ;;
#   view_label: "Tenants historized"
# }

  join: flip_tenants_daily_aggregations_historized_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${cs_customers.tenant} = ${flip_tenants_daily_aggregations_historized_ext.tenant} ;;
      # AND ${cs_measures_history_ext.date_date} = ${flip_tenants_daily_aggregations_historized_ext.date_berlin_date}  ;;
    view_label: "Tenants historized"
  }

join: cs_customer_lifecycle_thresholds_ext {
  type: left_outer
  relationship: one_to_one
  sql_on: ${cs_customers.company_id} = ${cs_customer_lifecycle_thresholds_ext.company_id};;
  view_label: "Customers"
}

join: zendesk_tickets_all_ext {
  type: full_outer
  relationship: one_to_many
  sql_on: ${cs_customers.company_id} = ${zendesk_tickets_all_ext.hubspot_id} ;;
  view_label: "Tickets Zendesk"
}

join: cs_nps_surveys_ext {
  type: left_outer
  relationship: one_to_many
  sql_on:  ${cs_customers.company_id} = ${cs_nps_surveys_ext.hubspot_company_id} ;;
  view_label: "NPS"
}

  join: flip_feature_tenant_unique_ext {
    type:  left_outer
    sql_on: ${cs_customers.tenant} = ${flip_feature_tenant_unique_ext.tenant} ;;
    relationship: one_to_many
    view_label: "Features per Tenant (Tenant Controller)"
  }
}

# ----- APP MIGRATION & TENANTS --------------------------

# ----- USERS & USER GROUPS -------------------------------

explore: cs_users_tenant_and_user_groups_sensitive { # no renaming of explore as chaning tiles would be too much effort
  from: flip_users_daily_aggregations_historized_ext
  label: "CS Users & User Groups ⚠️ sensitive data"
  view_label: "Users (daily agg.) incl. AU"

  always_filter: {
    filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer"]
  }

  join: flip_users_daily_aggregations_historized_ext__user_group_ids {
    view_label: "User agg: User Group Ids"
    sql: left join unnest(${cs_users_tenant_and_user_groups_sensitive.user_group_ids}) as flip_users_daily_aggregations_historized__user_group_ids ;;
    relationship: one_to_many
  }

  join: flip_users_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${cs_users_tenant_and_user_groups_sensitive.user_id} = ${flip_users_unique_ext.user_id} ;;
    view_label: "Users (Dimensions)"
  }

## sensitive information!! ##
  join: flip_user_ids_original_and_piis_unique_sensitive_ext {
    type: left_outer
    relationship: one_to_one
    sql_on: ${flip_users_unique_ext.user_id} = ${flip_user_ids_original_and_piis_unique_sensitive_ext.user_id_hashed} ;;
    view_label: "Users (Dimensions)"
  }

  join: flip_user_groups_daily_aggregations_historized_ext {
    sql_on: ${flip_user_groups_unique_ext.user_group_id} = ${flip_user_groups_daily_aggregations_historized_ext.user_group_id} ;;
    relationship: one_to_many
    view_label: "User Groups (historized)"
  }

  join: flip_user_groups_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_user_group_assignments_unique_ext.user_group_id} = ${flip_user_groups_unique_ext.user_group_id} ;;
    # sql_on: ${flip_users_daily_aggregations_historized_ext__user_group_ids.flip_users_daily_aggregations_historized__user_group_ids} = ${flip_user_groups_unique_ext.user_group_id} ;;
    view_label: "User Groups (Dimensions)"
  }

  join: flip_user_group_assignments_unique_ext {

    relationship: one_to_many
    sql_on: ${flip_users_unique_ext.user_id} = ${flip_user_group_assignments_unique_ext.user_id} ;;
    #sql_on: ${flip_users_daily_aggregations_historized_ext__user_group_ids.flip_users_daily_aggregations_historized__user_group_ids} = ${flip_user_group_assignments_unique_ext.user_group_id}
    # AND ${flip_users_daily_aggregations_historized_ext__user_group_ids.flip_users_daily_aggregations_historized__user_group_ids};;

    # old:
    # type: left_outer
    # relationship: one_to_many
    # sql_on: ${flip_user_groups_unique_ext.user_group_id} = ${flip_user_group_assignments_unique_ext.user_group_id} ;; # always join on user_id, joins on post_group_id cause fanouts in user measures
    view_label: "User Group Assignments"
  }

  join: flip_tenants_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${cs_users_tenant_and_user_groups_sensitive.tenant} = ${flip_tenants_unique_ext.tenant} ;;
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
    relationship: one_to_many
    sql_on: ${flip_users_unique_ext.user_id} = ${flip_user_devices_unique_ext.user_id} ;;
    view_label: "User Devices"
  }
}

# ----- USERS (+ Tenant & Channel) -------------------------------

explore: cs_users_tenant_and_channel_ext { # no renaming of explore as chaning tiles would be too much effort
  from: flip_users_daily_aggregations_historized_ext
  label: "CS Users & Channels ⚠️ sensitive data"
  view_label: "Users (daily agg.) incl. AU"
# always_filter: {
  # filters: [hubspot_customers_all_ext.vitally_lifecycle: "Customer, PoV"]
  # }

  join: flip_users_daily_aggregations_historized_ext__channel_ids {
    view_label: "Users Explore Andrea: Channel Ids"
    sql: left join unnest(${cs_users_tenant_and_channel_ext.channel_ids}) as flip_users_daily_aggregations_historized__channel_ids ;;
    relationship: one_to_many
  }

  join: flip_users_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${cs_users_tenant_and_channel_ext.user_id} = ${flip_users_unique_ext.user_id} ;;
    view_label: "Users (Dimensions)"
  }

## sensitive information!! ##
  join: flip_user_ids_original_and_piis_unique_sensitive_ext {
    type: left_outer
    relationship: one_to_one
    sql_on: ${flip_users_unique_ext.user_id} = ${flip_user_ids_original_and_piis_unique_sensitive_ext.user_id_hashed} ;;
    view_label: "Users (Dimensions)"
  }

  join: flip_channels_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_users_daily_aggregations_historized_ext__channel_ids.flip_users_daily_aggregations_historized__channel_ids} = ${flip_channels_unique_ext.channel_id} ;;
    view_label: "Channels (Dimensions)"
  }

  # join: flip_channel_ids_original_unique_ext {
  #   type: left_outer
  #   relationship: one_to_one
  #   sql_on: ${flip_channels_unique_ext.channel_id} = ${flip_channel_ids_original_unique_ext.channel_id_hashed};;
  #   fields: [channel_id_original]
  #   view_label: "Channels (Dimensions)"
  # }

  join: flip_channels_daily_aggregations_historized_ext {
    sql_on: ${flip_channels_unique_ext.channel_id} = ${flip_channels_daily_aggregations_historized_ext.channel_id} ;;
    relationship: one_to_many
    view_label: "Channels (historized)"
  }
  join: flip_channels_unique__admin_permissions {
    view_label: "Flip Channel Unique: Admin Permissions"
    sql: LEFT JOIN UNNEST(${flip_channels_unique_ext.admin_permissions}) as flip_channels_unique__admin_permissions ;;
    relationship: one_to_many
  }

  join: flip_channels_unique__member_permissions {
    view_label: "Flip Channels Unique: Member Permissions"
    sql: LEFT JOIN UNNEST(${flip_channels_unique_ext.member_permissions}) as flip_channels_unique__member_permissions ;;
    relationship: one_to_many
  }

  join: flip_channels_unique__moderator_permissions {
    view_label: "Flip Channels Unique: Moderator Permissions"
    sql: LEFT JOIN UNNEST(${flip_channels_unique_ext.moderator_permissions}) as flip_channels_unique__moderator_permissions ;;
    relationship: one_to_many
  }

  join: flip_channel_memberships_unique_ext_channels {
    from: flip_channel_memberships_unique_ext
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_channels_unique_ext.channel_id} = ${flip_channel_memberships_unique_ext_channels.channel_id} ;; # always join on user_id, joins on post_group_id cause fanouts in user measures
    view_label: "Channel Memberships (Channels)"
  }

  join: flip_channel_memberships_unique_ext_users {
    from: flip_channel_memberships_unique_ext
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_users_unique_ext.user_id} = ${flip_channel_memberships_unique_ext_users.user_id} ;;
    view_label: "Channel Memberships (Users)"
  }

  join: flip_tenants_unique_ext {
    type: left_outer
    relationship: many_to_one
    sql_on: ${cs_users_tenant_and_channel_ext.tenant} = ${flip_tenants_unique_ext.tenant} ;;
    view_label: "Tenant"
  }

  join: hubspot_customers_all_ext { # for production only
    type: left_outer
    relationship: one_to_one
    sql_on: ${flip_tenants_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
    #fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
    view_label: "Customer Properties (Hubspot)"
  }
}

# ----- CS Chats & Messages -------------------------------------------

# ----- CS Posts -------------------------------------------

  explore: cs_posts {
    from: flip_post_interactions_unique_ext

    persist_for: "3 hours"

    label: "CS Posts ⚠️ sensitive data"
    view_label: "Posts Interactions "
    description: "Go-To Explore for all Post-related questions. Channel Memberships on Channel level, not users.
    Includes information from the Core (Backend) Hubspot, Vitally."

    fields:
    [ALL_FIELDS*,
      -flip_posts_unique_ext.not_relevant_for_cs_explores*,
      -flip_posts_unique_ext.exclude_numeric_dimensions*, -cs_posts.not_relevant_for_cs_explores*]

    # join: flip_users_unique_ext {
    #   type: full_outer
    #   relationship: many_to_one
    #   sql_on: ${flip_post_group_memberships_unique_ext.user_id} = ${flip_users_unique_ext.user_id} ;;

    #   view_label: "Users"
    # }

    join: hubspot_customers_all_ext { # for production only
      type: left_outer
      relationship: many_to_one
      sql_on: ${flip_posts_unique_ext.tenant} = ${hubspot_customers_all_ext.tenant} ;;
      fields: [hubspot_customers_all_ext.all_flipsters_usage_relevant*]
      view_label: "Customer Properties (Hubspot)"
    }

    join: flip_posts_unique_ext {
      type: full_outer
      ## type: left_outer
      relationship: many_to_one # correct like this m:1
      sql_on: ${cs_posts.post_id} = ${flip_posts_unique_ext.post_id} ;;
      view_label: "Posts"
    }

    join: flip_reactions_unique_ext {
      type: left_outer
      ##relationship: many_to_one
      relationship: one_to_many ## changed, as this led to dupliates
      sql_on: ${flip_posts_unique_ext.post_id} = ${flip_reactions_unique_ext.reaction_element_id}  ;;
      view_label: "Reactions"
    }

    join: flip_channels_unique_ext {
      type: left_outer
      relationship: one_to_one
      sql_on: ${flip_posts_unique_ext.channel_id} = ${flip_channels_unique_ext.channel_id};;
      view_label: "Channels (Dimensions)"
    }
    join: channels_daily_aggregations_on_post_published_date {
      from: flip_channels_daily_aggregations_historized_ext
      type: left_outer
      relationship: one_to_one
      sql_on: ${flip_posts_unique_ext.channel_id} = ${channels_daily_aggregations_on_post_published_date.channel_id}
      and ${flip_posts_unique_ext.published_timestamp_date} = ${channels_daily_aggregations_on_post_published_date.date_berlin_date};;
      view_label: "Channels Measures (on Post publ. date)"
    }

    join: channels_agg_today {
      from: flip_channels_daily_aggregations_historized_ext
      type: left_outer
      relationship: one_to_one
      sql_on: ${flip_channels_unique_ext.channel_id} = ${channels_agg_today.channel_id} ;;
      sql_where: ${channels_agg_today.date_berlin_date} = current_date() ;;
      view_label: "Channels Measures (today)"
    }

    join: flip_channel_memberships_unique_ext {
      type: left_outer
      relationship: one_to_many
      sql_on: ${flip_channels_unique_ext.channel_id} = ${flip_channel_memberships_unique_ext.channel_id} ;;
      view_label: "Channel Memberships (on Channel)"
    }
  }

# ---- CS Net Retention --------------------------------------

#### NEW NRR reconized ####

# ----- CS on Dates (CSE) -------------------------------------------

