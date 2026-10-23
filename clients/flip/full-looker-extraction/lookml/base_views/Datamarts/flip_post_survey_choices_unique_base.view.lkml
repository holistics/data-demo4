view: flip_post_survey_choices_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_post_survey_choices_unique` ;;

  dimension: choice_order_no {
    type: number
    sql: ${TABLE}.choice_order_no ;;
  }

  dimension: choice_title_character_count {
    type: number
    sql: ${TABLE}.choice_title_character_count ;;
  }

  dimension: choice_title_word_count {
    type: number
    sql: ${TABLE}.choice_title_word_count ;;
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

  dimension: is_db_row_deleted_choice {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted_choice ;;
  }

  dimension: is_db_row_deleted_set {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted_set ;;
  }

  dimension: post_id {
    type: string
    sql: ${TABLE}.post_id ;;
  }

  dimension: survey_choice_id {
    type: string
    sql: ${TABLE}.survey_choice_id ;;
  }

  dimension: survey_choice_set_id {
    type: string
    sql: ${TABLE}.survey_choice_set_id ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  dimension: total_votes_per_survey {
    type: number
    sql: ${TABLE}.total_votes_per_survey ;;
  }

  dimension: vote_count {
    type: number
    sql: ${TABLE}.vote_count ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
