include: "/base_views/Datamarts/flip_post_survey_choices_unique_base.view"

view: flip_post_survey_choices_unique_ext {
  extends: [flip_post_survey_choices_unique_base]

  drill_fields: [survey_choice_id, post_id, created_timestamp_date, total_votes_per_survey, tenant]

# --- BASE DIMENSIONS -------------------------------

  dimension: choice_order_no {
    type: number
    hidden: yes
  }

  dimension: choice_title_character_count {
    type: number
    hidden:  yes

  }

  dimension: choice_title_word_count {
    type: number
    hidden:  yes
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

  dimension: is_db_row_deleted_choice {
    type: yesno

  }

  dimension: is_db_row_deleted_set {
    type: yesno

  }

  dimension: post_id {
    type: string

  }

  dimension: survey_choice_id {
    type: string
    primary_key: yes
  }

  dimension: survey_choice_set_id {
    type: string

  }

  dimension: tenant {
    type: string

  }

  dimension: total_votes_per_survey {
    type: number
    hidden: yes
  }

  dimension: vote_count {
    type: number
    hidden: yes
  }

#-----------MANUALLY ADDED DIMENSIONS-------------------

dimension: choice_order_no_numbers {
  type: number
  sql: CASE WHEN
  ${choice_order_no} = 0 THEN 1
  ${choice_order_no} = 1 THEN 2
  ${choice_order_no} = 2 THEN 3
  ${choice_order_no} = 3 THEN 4
  ${choice_order_no} = 4 THEN 5 ;;
  label: "Choice Order No"

}

#-------------MEASURES-------------------------

  measure: count {
    type: count
    label: "# Survey Choices"
    description: "Count of unique survey_choice_id"
  }

  measure: survey_choice_set_count {
    type: count_distinct
    sql: ${survey_choice_set_id} ;;
    label: "# Surveys"
    description: "Count of unique survey_choice_set_id"
  }

  measure: survey_choice_title_character_sum {
    type: sum
    sql: ${choice_title_character_count} ;;
    label: "# Survey Choice Characters"
  }

  measure: survey_choice_title_character_avg {
    type: average
    sql: ${choice_title_character_count} ;;
    label: "# Survey Choice Characters (Avg)"
    value_format_name: decimal_1
  }

  dimension: survey_choice_character_tier {
    type: tier
    sql: ${choice_title_character_count} ;;
    tiers: [10,20,30,40,50,60,70,80,90,100]
    style: integer
  }

  measure: survey_choice_title_word_sum {
    type: sum
    sql: ${choice_title_word_count} ;;
    label: "# Survey Choice Words"
  }

  measure: survey_choice_title_word_avg {
    type: average
    sql: ${choice_title_word_count} ;;
    label: "# Survey Choice Words (Avg)"
    value_format_name: decimal_1
  }

  measure: vote_count_sum {
    type: sum
    sql: ${vote_count} ;;
    label: "# Votes"
  }

  measure: vote_count_avg {
    type: average
    sql: ${vote_count} ;;
    label: "# Votes (Avg)"
    value_format_name: decimal_1
  }

  measure: vote_count_max {
    type: max
    sql: ${vote_count} ;;
    label: "# Votes (Max)"
  }

  measure: total_votes_per_survey_sum {
    type: sum
    sql: ${total_votes_per_survey} ;;
    label: "# Votes per Survey"
  }

  measure: total_votes_per_survey_avg {
    type: average
    sql: ${total_votes_per_survey} ;;
    label: "# Votes per Survey (Avg)"
    value_format_name: decimal_1
  }
}
