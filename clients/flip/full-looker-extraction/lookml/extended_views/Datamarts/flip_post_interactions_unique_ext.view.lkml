include: "/base_views/Datamarts/flip_post_interactions_unique_base.view"

view: flip_post_interactions_unique_ext {
  extends: [flip_post_interactions_unique_base]

  drill_fields: [post_id, interaction_type, reaction_type, translation_source_language, translation_target_language, reaction_count]

# --- DIMENSIONS -----------------------------------

  dimension: comment_body_character_count {
    type: number
    hidden: yes
  }

  dimension: comment_body_word_count {
    type: number
    hidden: yes
  }

  dimension: comment_language {
    type: string
  }

  dimension_group: db_row_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    label: "Last Interaction Update Timestamp"
    description: "Indicates when the interaction was last updated (e.g. deleted) (= latest db_row_timestamp)."
  }

  dimension: interaction_id {
    type: string
    primary_key: yes
  }

  dimension_group: interaction_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    label: "First Interaction Timestamp"
    description: "Indicates when the interaction was first created."
  }

  dimension: interaction_type {
    type: string
  }

  dimension: is_interaction_deleted {
    type: yesno
  }

  dimension: post_id {
    type: string
  }

  dimension: reaction_type {
    type: string
  }

  dimension: tenant {
    type: string
  }

  dimension: translation_source_language {
    type: string
  }

  dimension: translation_target_language {
    type: string
  }

  dimension: user_id {
    type: string
  }

# --- MEASURES -------------------------------------

  measure: count {
    type: count
    label: "# Interactions (all)"
    drill_fields: [post_id, interaction_type, reaction_type, translation_source_language, translation_target_language, reaction_count]
  }

  measure: count_wo_seens {
    type: count
    label: "# Interactions (w/o seens)"
    filters: [interaction_type: "-seen"]
    drill_fields: [post_id, interaction_type, reaction_type, translation_source_language, translation_target_language, reaction_count]
  }

  measure: count_wo_seens_and_translation {
    type: count
    label: "# Interactions (w/o seens, translations)"
    description: "Metabase pendant. Includes interactions: reaction, comment, bookmark, comment reaction, survey vote"
    filters: [interaction_type: "-seen, -translation"]
    drill_fields: [post_id, interaction_type, reaction_type, translation_source_language, translation_target_language, reaction_count]
  }

  measure: post_seen_count {
    type: count
    filters: [interaction_type: "seen"]
    label: "# Seens"
  }

  measure: reaction_count {
    type: count
    filters: [interaction_type: "reaction"]
    label: "# Reactions"
  }

  measure: comment_count {
    type: count
    filters: [interaction_type: "comment"]
    label: "# Comments"
  }

  measure: comment_reaction_count {
    type: count
    filters: [interaction_type: "comment reaction"]
    label: "# Comment Reactions"
  }

  measure: total_reaction_count {
    type: count
    filters: [interaction_type: "reaction, comment reaction"]
    label: "# Total Reactions"
    description: "Includes Both post and comment reaction."
  }

  measure: comment_body_word_count_sum {
    type: sum
    sql: ${comment_body_word_count} ;;
    label: "# Comment Words"
  }

  measure: comment_body_word_count_avg {
    type: average
    sql: ${comment_body_word_count} ;;
    label: "# Comment Words (Avg)"
    value_format_name: decimal_1
  }

  measure: comment_body_character_count_avg {
    type: average
    sql: ${comment_body_character_count} ;;
    label: "# Comment Characters (Avg)"
    value_format_name: decimal_1
  }

  measure: translation_count {
    type: count
    filters: [interaction_type: "translation"]
    label: "# Translation Versions"
    description: "# of translations into different languages - does not represent the single translation requests."
  }

  measure: survey_vote_count {
    type: count
    filters: [interaction_type: "survey vote"]
    label: "# Survey Votes"
  }

  measure: bookmark_count {
    type: count
    filters: [interaction_type: "bookmark"]
    label: "# Bookmarks"
  }

  measure: user_id_count_distinct {
    type: count_distinct
    sql: ${user_id} ;;
    label: "# Users"
  }

  measure: user_id_wo_seens_count_distinct {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [interaction_type: "-seen"]
    label: "# Users (w/o Seens)"
  }

  measure: interactions_per_user_number {
    type: number
    sql: ${count}/nullif(${user_id_count_distinct},0) ;;
    label: "# Interactions (all) / User (Avg)"
    value_format_name: decimal_0
  }

  measure: interactions_wo_seens_per_user_number {
    type: number
    sql: ${count_wo_seens}/nullif(${user_id_wo_seens_count_distinct},0) ;;
    label: "# Interactions (w/o Seens) / User (Avg)"
    value_format_name: decimal_0
  }

# --- SETS ----------------------------
set: date_fields {
  fields: [db_row_timestamp_date, db_row_timestamp_day_of_week, db_row_timestamp_month, db_row_timestamp_quarter,
    db_row_timestamp_raw, db_row_timestamp_time, db_row_timestamp_week, db_row_timestamp_year]
}

set: not_relevant_for_cs_explores {
  fields: [ user_id, interaction_id, -date_fields*] #post_id
}
}
