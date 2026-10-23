view: flip_post_interactions_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_post_interactions_unique` ;;

  dimension: comment_body_character_count {
    type: number
    sql: ${TABLE}.comment_body_character_count ;;
  }

  dimension: comment_body_word_count {
    type: number
    sql: ${TABLE}.comment_body_word_count ;;
  }

  dimension: comment_language {
    type: string
    sql: ${TABLE}.comment_language ;;
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

  dimension: interaction_id {
    type: string
    sql: ${TABLE}.interaction_id ;;
  }

  dimension_group: interaction_timestamp {
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
    sql: ${TABLE}.interaction_timestamp ;;
  }

  dimension: interaction_type {
    type: string
    sql: ${TABLE}.interaction_type ;;
  }

  dimension: is_interaction_deleted {
    type: yesno
    sql: ${TABLE}.is_interaction_deleted ;;
  }

  dimension: post_id {
    type: string
    sql: ${TABLE}.post_id ;;
  }

  dimension: reaction_type {
    type: string
    sql: ${TABLE}.reaction_type ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  dimension: translation_source_language {
    type: string
    sql: ${TABLE}.translation_source_language ;;
  }

  dimension: translation_target_language {
    type: string
    sql: ${TABLE}.translation_target_language ;;
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
