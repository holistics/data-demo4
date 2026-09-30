include: "/base_views/Datamarts/flip_post_survey_votes_unique_base.view"

view: flip_post_survey_votes_unique_ext {
  extends: [flip_post_survey_votes_unique_base]

  drill_fields: [user_vote_id, survey_choice_id, created_timestamp_date, tenant]

# --- BASE DIMENSIONS -------------------------------

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

  dimension: is_db_row_deleted {
    type: yesno

  }

  dimension: post_id {
    type: string
  }

  dimension: survey_choice_id {
    type: string

  }

  dimension: survey_choice_set_id {
    type: string

  }

  dimension: tenant {
    type: string

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

  }

  dimension: user_id {
    type: string

  }

  dimension: user_vote_id {
    type: string
    primary_key: yes
  }

#--------MANUALLY ADDED DIMENSIONS--------------------

#----------MEASURES------------------------------------

  measure: count {
    type: count
    label: "# User Votes"
    description: "Count of unique user_vote_id"
  }

  measure: survey_choice_id_count {
    type: count_distinct
    sql: ${survey_choice_id} ;;
    label: "# Survey Choices"
    description: "Count of unique survey_choice_id."
  }
}
