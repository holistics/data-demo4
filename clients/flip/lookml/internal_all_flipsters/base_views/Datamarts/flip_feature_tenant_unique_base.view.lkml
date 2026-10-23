view: flip_feature_tenant_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_feature_tenant_unique`
    ;;

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

  dimension: feature {
    type: string
    sql: ${TABLE}.feature ;;
  }

  dimension: feature_tenant_id {
    type: string
    sql: ${TABLE}.feature_tenant_id ;;
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

  dimension: tenant_id {
    type: number
    sql: ${TABLE}.tenant_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
