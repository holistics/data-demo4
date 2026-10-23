# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
explore: flip_s_tenants_unique_base {
  hidden: yes

  join: flip_s_tenants_unique__enabled_feature_keys {
    view_label: "Flip S Tenants Unique: Enabled Feature Keys"
    sql: LEFT JOIN UNNEST(${flip_s_tenants_unique_base.enabled_feature_keys}) as flip_s_tenants_unique__enabled_feature_keys ;;
    relationship: one_to_many
  }
}

view: flip_s_tenants_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_staging_poc.flip_tenants_unique` ;;

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
    sql: ${TABLE}.created_timestamp ;;
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
    sql: ${TABLE}.db_row_timestamp ;;
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
    sql: ${TABLE}.db_row_timestamp_domain ;;
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
    sql: ${TABLE}.db_row_timestamp_locale ;;
  }

  dimension: domain {
    type: string
    sql: ${TABLE}.domain ;;
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
    sql: ${TABLE}.domain_created_timestamp ;;
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
    sql: ${TABLE}.domain_updated_timestamp ;;
  }

  dimension: enabled_feature_keys {
    hidden: yes
    sql: ${TABLE}.enabled_feature_keys ;;
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

  dimension: locale {
    type: string
    sql: ${TABLE}.locale ;;
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
    sql: ${TABLE}.locale_created_timestamp ;;
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
    sql: ${TABLE}.locale_updated_timestamp ;;
  }

  dimension: locale_status {
    type: string
    sql: ${TABLE}.locale_status ;;
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
    drill_fields: []
  }
}

view: flip_s_tenants_unique__enabled_feature_keys {
  dimension: flip_s_tenants_unique__enabled_feature_keys {
    type: string
    sql: flip_s_tenants_unique__enabled_feature_keys ;;
  }
}
