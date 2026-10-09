view: flip_users_au_activities_historized_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_users_au_activities_historized` ;;

  dimension: activity_id {
    type: string
    sql: ${TABLE}.activity_id ;;
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

  dimension: partition_id {
    type: string
    sql: ${TABLE}.partition_id ;;
  }

  dimension: ranking_first_activity {
    type: number
    sql: ${TABLE}.ranking_first_activity ;;
  }

  dimension: ranking_last_activity {
    type: number
    sql: ${TABLE}.ranking_last_activity ;;
  }

  dimension: source_table {
    type: string
    sql: ${TABLE}.source_table ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
