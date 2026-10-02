view: flip_posts_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_posts_unique` ;;

  dimension: actor_id {
    type: string
    sql: ${TABLE}.actor_id ;;
  }

  dimension: attachment_count {
    type: number
    sql: ${TABLE}.attachment_count ;;
  }

  dimension: author_id {
    type: string
    sql: ${TABLE}.author_id ;;
  }

  dimension: bookmark_count {
    type: number
    sql: ${TABLE}.bookmark_count ;;
  }

  dimension: comment_count {
    type: number
    sql: ${TABLE}.comment_count ;;
  }

  dimension: comment_reaction_count {
    type: number
    sql: ${TABLE}.comment_reaction_count ;;
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

  dimension: detected_language {
    type: string
    sql: ${TABLE}.detected_language ;;
  }

  dimension: diff_scheduled_created_minutes {
    type: number
    sql: ${TABLE}.diff_scheduled_created_minutes ;;
  }

  dimension: diff_scheduled_published_minutes {
    type: number
    sql: ${TABLE}.diff_scheduled_published_minutes ;;
    }

  dimension_group: first_highlighted_at_timestamp {
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
    sql: ${TABLE}.first_highlighted_at_timestamp ;;
  }

  dimension: has_post_attachment {
    type: yesno
    sql: ${TABLE}.has_post_attachment ;;
  }

  dimension: has_post_survey {
    type: yesno
    sql: ${TABLE}.has_post_survey ;;
  }

  dimension: highlight_duration_hours {
    type: number
    sql: ${TABLE}.highlight_duration_hours ;;
  }

  dimension: highlighted_until_count {
    type: number
    sql: ${TABLE}.highlighted_until_count ;;
  }

  dimension_group: highlighted_until_timestamp {
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
    sql: ${TABLE}.highlighted_until_timestamp ;;
  }

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: is_posted_on_behalf {
    type: yesno
    sql: ${TABLE}.is_posted_on_behalf ;;
  }

  dimension: is_post_comments_enabled {
    type: yesno
    sql: ${TABLE}.is_post_comments_enabled ;;
  }

  dimension: is_post_deleted {
    type: yesno
    sql: ${TABLE}.is_post_deleted ;;
  }

  dimension: is_post_reactions_enabled {
    type: yesno
    sql: ${TABLE}.is_post_reactions_enabled ;;
  }

  dimension: is_channel_open {
    type: yesno
    sql: ${TABLE}.is_channel_open ;;
  }

  dimension: is_was_highlight_removed {
    type: yesno
    sql: ${TABLE}.is_was_highlight_removed ;;
  }

  dimension: is_was_post_highlighted {
    type: yesno
    sql: ${TABLE}.is_was_post_highlighted ;;
  }

  dimension_group: latest_scheduled_timestamp {
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
    sql: ${TABLE}.latest_scheduled_timestamp ;;
  }

  dimension: post_body_character_count {
    type: number
    sql: ${TABLE}.post_body_character_count ;;
  }

  dimension: post_body_word_count {
    type: number
    sql: ${TABLE}.post_body_word_count ;;
  }

  dimension: channel_id {
    type: string
    sql: ${TABLE}.channel_id ;;
  }

  dimension: channel_name {
    type: string
    sql: ${TABLE}.channel_name ;;
  }

  dimension: post_id {
    type: string
    sql: ${TABLE}.post_id ;;
  }

  dimension: post_seen_count {
    type: number
    sql: ${TABLE}.post_seen_count ;;
  }

  dimension: post_title {
    type: string
    sql: ${TABLE}.post_title ;;
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

  dimension: reaction_count {
    type: number
    sql: ${TABLE}.reaction_count ;;
  }

  dimension: scheduled_count {
    type: number
    sql: ${TABLE}.scheduled_count ;;
  }

  dimension: selected_language {
    type: string
    sql: ${TABLE}.selected_language ;;
  }

  dimension: survey_vote_count {
    type: number
    sql: ${TABLE}.survey_vote_count ;;
  }

  dimension: survey_choice_count {
    type: number
    sql: ${TABLE}.survey_choice_count ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  dimension: translated_languages_count {
    type: number
    sql: ${TABLE}.translated_languages_count ;;
  }

  dimension: updated_count {
    type: number
    sql: ${TABLE}.updated_count ;;
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

  dimension: was_post_translated {
    type: yesno
    sql: ${TABLE}.was_post_translated ;;
  }

  dimension: livestream_id {
    type: string
    sql: ${TABLE}.livestream_id ;;
  }

  dimension: publication_status {
    type: string
    sql: ${TABLE}.publication_status ;;
  }

  dimension_group: last_status_change_timestamp {
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
    sql: ${TABLE}.last_status_change_timestamp ;;
  }

  dimension_group: survey_end_date {
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
    sql: ${TABLE}.survey_end_date ;;
  }

  dimension: survey_anonymity {
    type: string
    sql: ${TABLE}.survey_anonymity ;;
  }

  dimension: is_survey_multiple_choice {
    type: yesno
    sql: ${TABLE}.is_survey_multiple_choice ;;
  }

  measure: count {
    type: count
    drill_fields: [channel_name]
  }
}
