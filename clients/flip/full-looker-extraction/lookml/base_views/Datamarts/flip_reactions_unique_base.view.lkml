view: flip_reactions_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_reactions_unique` ;;

  dimension: actor_id {
    type: string
    sql: ${TABLE}.actor_id ;;
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

  dimension_group: published_timestamp {
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
    sql: ${TABLE}.published_timestamp ;;
  }

  dimension: reaction_element_id {
    type: string
    sql: ${TABLE}.reaction_element_id ;;
  }

  dimension: reaction_element_type {
    type: string
    sql: ${TABLE}.reaction_element_type ;;
  }

  dimension: reaction_id {
    type: string
    sql: ${TABLE}.reaction_id ;;
  }

  dimension: reaction_type {
    type: string
    sql: ${TABLE}.reaction_type ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  dimension: updated_count {
    type: number
    sql: ${TABLE}.updated_count ;;
  }

  dimension: updated_distinct_count {
    type: number
    sql: ${TABLE}.updated_distinct_count ;;
  }

  dimension_group: updated_timestamp {
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
    sql: ${TABLE}.updated_timestamp ;;
  }

  dimension: user_element_id {
    type: string
    sql: ${TABLE}.user_element_id ;;
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
