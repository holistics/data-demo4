include: "/base_views/Datamarts/flip_feature_tenant_unique_base.view"

view: flip_feature_tenant_unique_ext {
  extends: [flip_feature_tenant_unique_base]

  drill_fields: [tenant, feature]

  # --- DIMENSIONS ----------------

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
    label: "last updated"
  }

  dimension: feature {
    type: string
  }

  dimension: feature_tenant_id {
    type: string
    primary_key: yes
    hidden: yes
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
  }

  dimension: tenant {
    type: string
  }

  dimension: tenant_id {
    type: number
    hidden: yes
  }

  # --- MEASURES ---------------------------------------

  measure: count {
    type: count
    label: "# Feature-Tenant Combinations"
    description: "Counts the primary key of the table (feature_tenant_id) and indicates the number of feature-tenant combinations."
  }

  measure: feature_count {
    type: count_distinct
    sql: ${feature} ;;
    label: "# Features (distinct)"
  }

  measure: tenant_count {
    type: count_distinct
    sql: ${tenant};;
    label: "# Tenants (distinct)"
  }
}
