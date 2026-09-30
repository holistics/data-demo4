view: flip_post_seens_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_post_seens_unique` ;;

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

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: post_id {
    type: string
    sql: ${TABLE}.post_id ;;
  }

  dimension_group: post_seen_timestamp {
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
    sql: ${TABLE}.post_seen_timestamp ;;
  }

  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: actor_id {
    type: string
    sql: ${TABLE}.actor_id ;;
  }

  dimension: is_triggered_by_other_user {
    type: yesno
    sql: ${TABLE}.is_triggered_by_other_user ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
