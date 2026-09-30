include: "/base_views/Datamarts/flip_tenants_unique_base.view"

view: flip_tenants_unique_ext {
  extends: [flip_tenants_unique_base]

  drill_fields: [tenant, region, created_timestamp_date, licences_tenant_controller]

# --- DIMENSIONS ---------------------------------------

  dimension: active_askai_users {
    type: number
    hidden: yes
  }

  dimension_group: created_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension: data_region {
    type: string
    description: "Indicates the region where the tenant is hosted on Flip BE/Core (not where the analytics data is hosted)."
  }

  dimension_group: db_row_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension_group: db_row_timestamp_domain {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension_group: db_row_timestamp_locale {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension_group: domain_created_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension_group: domain_updated_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension: environment {
    type: string
  }

  dimension: has_android_migration {
    type: yesno
  }
  dimension: has_ios_migration {
    type: yesno
  }
  dimension: is_ai_assistant_user_groups_activated {
    type: yesno
  }
  dimension: is_ai_assistant_activated {
    type: yesno
  }

  dimension: is_user_groups_enabled {
    type: yesno
  }

  dimension: is_menu_items_with_channels_disabled {
    type: yesno
  }

  dimension: is_db_row_deleted {
    type: yesno
  }

  dimension: is_db_row_deleted_domain {
    type: yesno
  }

  dimension: is_db_row_deleted_locale {
    type: yesno
  }

  dimension: licences_tenant_controller {
    type: number
    hidden: yes
  }

  dimension: licences_tenant_controller_raw {
    type: number
    hidden: yes
  }

  dimension_group: locale_created_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension_group: locale_updated_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension: menu_item_count {
    type: number
    hidden: yes
  }

  dimension: language_count {
    type: number
    hidden: yes
  }

  dimension: onboarded_users_with_askai_enabled {
    type: number
    hidden: yes
  }

  dimension: primary_key {
    type: string
    primary_key: yes
    description: "Making sure we use every tenant name once across all environments."
  }

  dimension: region {
    type: string
  }

  dimension_group: tc_last_synced_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    hidden: yes
  }

  dimension: tenant {
    type: string
  }

  dimension: tenant_id {
    type: number
    hidden: yes
  }
#--------MANUALLY ADDED DIMENSIONS-------------------------

  dimension: menu_items_tier {
    type: tier
    sql: ${menu_item_count} ;;
    tiers: [1,2,5,10,20,30]
    style: integer
  }

# --- MEASURES ---------------------------------------------------------

  measure: count {
    type: count
    label: "# Tenants"
    drill_fields: [tenant, region, created_timestamp_date]
  }

  measure: region_count_distinct {
    type: count_distinct
    sql: ${region} ;;
    label: "# Regions"
    drill_fields: [tenant, region, created_timestamp_date]
  }

  measure: licences_tenant_controller_sum {
    type: sum
    sql: ${licences_tenant_controller} ;;
    label: "# Licences TC"
    description: "# Licences (filled with users created for companies with company license)."
  }

  measure: licences_tenant_controller_avg {
    type: average
    sql: ${licences_tenant_controller} ;;
    label: "# Licences TC avg"
    description: "# Licences (filled with users created for companies with company license)."
  }

  measure: licences_tenant_controller_raw_sum {
    type: sum
    sql: ${licences_tenant_controller_raw} ;;
    label: "# Licences TC (raw)"
    description: "# Licences as entered in the tenant controller."
  }

  measure: licences_tenant_controller_raw_avg {
    type: average
    sql: ${licences_tenant_controller_raw} ;;
    label: "# Licences TC avg"
    description: "# Licences as entered in the tenant controller."
  }

  measure: language_count_sum {
    type: sum
    sql: ${language_count} ;;
    label: "# Languages"
  }

  measure: onboarded_users_with_askai_enabled_sum {
    type: sum
    sql: ${onboarded_users_with_askai_enabled} ;;
    label: "# Onboarded Users with AskAI enabled"
  }

  measure: active_askai_users_sum {
    type: sum
    sql: ${active_askai_users} ;;
    label: "# Non-deleted Users who used AskAI at least once and have access"
  }

  # --- SETS -----------

  set: tenant_fields_irrelevant_for_all_flip_explores {
    fields: [db_row_timestamp_date, db_row_timestamp_month, db_row_timestamp_quarter, db_row_timestamp_time, db_row_timestamp_raw, db_row_timestamp_year, db_row_timestamp_domain_date, db_row_timestamp_domain_month, db_row_timestamp_domain_quarter, db_row_timestamp_domain_time, db_row_timestamp_domain_raw, db_row_timestamp_domain_year, db_row_timestamp_locale_date, db_row_timestamp_locale_month, db_row_timestamp_locale_quarter, db_row_timestamp_locale_time, db_row_timestamp_locale_raw, db_row_timestamp_locale_year]
  }

}
