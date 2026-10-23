view: flip_post_survey_votes_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_post_survey_votes_unique` ;;

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

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: user_vote_id {
    type: string
    sql: ${TABLE}.user_vote_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
