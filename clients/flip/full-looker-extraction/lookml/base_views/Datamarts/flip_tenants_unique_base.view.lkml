# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
explore: flip_tenants_unique_base {
  hidden: yes
    join: flip_tenants_unique__enabled_feature_keys {
      view_label: "Flip Tenants Unique: Enabled Feature Keys"
      sql: LEFT JOIN UNNEST(${flip_tenants_unique_base.enabled_feature_keys}) as flip_tenants_unique__enabled_feature_keys ;;
      relationship: one_to_many
    }
}
view: flip_tenants_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_tenants_unique` ;;

  dimension: active_askai_users {
    type: number
    sql: ${TABLE}.active_askai_users ;;
  }
  dimension_group: created_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_timestamp ;;
  }
  dimension_group: created_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_timestamp_berlin ;;
  }
  dimension_group: db_row_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp ;;
  }
  dimension_group: db_row_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp_berlin ;;
  }
  dimension_group: db_row_timestamp_domain {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp_domain ;;
  }
  dimension_group: db_row_timestamp_domain_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp_domain_berlin ;;
  }
  dimension_group: db_row_timestamp_locale {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp_locale ;;
  }
  dimension_group: db_row_timestamp_locale_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp_locale_berlin ;;
  }
  dimension: default_locale {
    type: string
    sql: ${TABLE}.default_locale ;;
  }
  dimension_group: deleted_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.deleted_timestamp ;;
  }
  dimension_group: deleted_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.deleted_timestamp_berlin ;;
  }
  dimension: domain {
    type: string
    sql: ${TABLE}.domain ;;
  }
  dimension_group: domain_created_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.domain_created_timestamp ;;
  }
  dimension_group: domain_updated_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.domain_updated_timestamp ;;
  }
  dimension: enabled_feature_keys {
    hidden: yes
    sql: ${TABLE}.enabled_feature_keys ;;
  }
  dimension: environment {
    type: string
    sql: ${TABLE}.environment ;;
  }
  dimension: has_android_migration {
    type: yesno
    sql: ${TABLE}.has_android_migration ;;
  }
  dimension: has_ios_migration {
    type: yesno
    sql: ${TABLE}.has_ios_migration ;;
  }
  dimension: is_ai_assistant_user_groups_activated {
    type: yesno
    sql: ${TABLE}.is_ai_assistant_user_groups_activated ;;
  }
  dimension: is_ai_assistant_activated {
    type: yesno
    sql: ${TABLE}.is_ai_assistant_activated ;;
  }
  dimension: is_user_groups_enabled {
    type: yesno
    sql: ${TABLE}.is_user_groups_enabled ;;
  }
  dimension: is_menu_items_with_channels_disabled {
    type: yesno
    sql: ${TABLE}.is_menu_items_with_channels_disabled ;;
  }
  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }
  dimension: is_db_row_deleted_domain {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted_domain ;;
  }
  dimension: is_db_row_deleted_locale {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted_locale ;;
  }
  dimension: licences_tenant_controller {
    type: number
    sql: ${TABLE}.licences_tenant_controller ;;
  }
  dimension: licences_tenant_controller_raw {
    type: number
    sql: ${TABLE}.licences_tenant_controller_raw ;;
  }
  dimension_group: locale_created_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.locale_created_timestamp ;;
  }
  dimension_group: locale_updated_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.locale_updated_timestamp ;;
  }
  dimension: menu_item_count {
    type: number
    sql: ${TABLE}.menu_item_count ;;
  }
  dimension: language_count {
    type: number
    sql: ${TABLE}.language_count ;;
  }
  dimension: onboarded_users_with_askai_enabled {
    type: number
    sql: ${TABLE}.onboarded_users_with_askai_enabled ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }
  dimension_group: tc_last_synced_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.tc_last_synced_timestamp ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension: tenant_domain_type {
    type: string
    sql: ${TABLE}.tenant_domain_type ;;
  }
  dimension: tenant_id {
    type: number
    sql: ${TABLE}.tenant_id ;;
  }
  measure: count {
    type: count
  }
}

view: flip_tenants_unique__enabled_feature_keys {

  dimension: flip_tenants_unique__enabled_feature_keys {
    type: string
    sql: flip_tenants_unique__enabled_feature_keys ;;
  }
}
