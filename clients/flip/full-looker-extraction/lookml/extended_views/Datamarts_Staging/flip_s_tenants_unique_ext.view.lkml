include: "/base_views/Datamarts_Staging/flip_s_tenants_unique_base.view"

view: flip_s_tenants_unique_ext {
  extends: [flip_s_tenants_unique_base]

  drill_fields: [tenant, created_timestamp_date]

# --- DIMENSIONS ---------------------------------------

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

  dimension: domain {
    type: string
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

    dimension: enabled_feature_keys {
      hidden: yes
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

  dimension: locale {
    type: string
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

  dimension: locale_status {
    type: string
  }

    dimension: tenant {
      type: string
      primary_key: yes
    }

  dimension: tenant_domain_type {
    type: string
  }

    dimension: tenant_id {
      type: number
      hidden: yes
    }

# --- MEASURES ---------------------------------------------------------

  measure: count {
    type: count
    label: "# Tenants"
  }

  measure: licences_tenant_controller_sum {
    type: sum
    sql: ${licences_tenant_controller} ;;
    label: "# Licences TC"
    description: "# Licences as entered in the tenant controller."
  }

  measure: licences_tenant_controller_avg {
    type: average
    sql: ${licences_tenant_controller} ;;
    label: "# Licences TC (Avg)"
    description: "# Licences as entered in the tenant controller."
  }

  }
