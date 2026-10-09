include: "/base_views/Datamarts/flip_post_comments_unique_base.view"

view: flip_post_comments_unique_ext {
  extends: [flip_post_comments_unique_base]

  drill_fields: [comment_id, comment_language, created_timestamp_date, is_comment_deleted]

# --- BASE DIMENSIONS -------------------------------

  dimension: actor_id {
    type: string
  }

  dimension: author_id {
    type: string
  }

  dimension: comment_body_character_count {
    type: number
    hidden: yes
  }

  dimension: comment_body_word_count {
    type: number
    hidden: yes
  }

  dimension: comment_id {
    type: string
    primary_key: yes
  }

  dimension: comment_language {
    type: string

  }

  dimension_group: created_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      minute30,
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

  dimension_group: deleted_timestamp {
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

  dimension_group: edited_in_app_timestamp {
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

  dimension_group: edited_timestamp {
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

  dimension: is_comment_deleted {
    type: yesno
  }

  dimension: is_comment_edited {
    type: yesno
    description: "If the comment has an edited_date the comment is identified as edited. To exclude API updates additionally use the filter `is_user_action`."
  }

  dimension: is_comment_edited_in_app {
    type: yesno
    description: "If the comment has an edited_in_app_date the comment is identified as edited by the user in the app (instead of API). "
  }

  dimension: is_comment_reply_old {
    type: yesno
    description: "If the comment has a parent_comment_id the comment is identified as a comment reply."
    label: "Is Comment Reply (Yes / No)"
  }

  dimension: is_db_row_deleted {
    type: yesno
    hidden: yes
  }

  dimension: is_pinned {
    type: yesno
  }

  dimension: is_user_action {
    type: yesno
    description: "Used to identify whether the user itself or the API was the actor."
  }

  dimension: post_id {
    type: string
    hidden: yes
  }

  dimension: quoted_comment_id {
    type: string
    hidden: yes
    description: "Used to identify comment replies."
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

  dimension: tenant {
    type: string

  }

  dimension: contains_comment_mention {
    type: yesno

  }

#-------------MANUALLY ADDED DIMENSIONS-----------------------------

#--------------MEASURES---------------------------------------

  measure: count {
    type: count
    label: "# Comments"
  }

  measure: author_id_count {
    type: count_distinct
    sql: ${author_id} ;;
    label: "# Authors"
    description: "Count of unique author_ids."
  }

  measure: comment_body_character_sum {
    type: sum
    sql: ${comment_body_character_count} ;;
    label: "# Comment Body Character"
    description: "Count of distinct comment_body_character_count."
  }

  measure: comment_body_character_avg {
    type: average
    sql: ${comment_body_character_count} ;;
    label: "# Comment Body Character (Avg)"
    description: "Avg Count of distinct comment_body_character_count."
    value_format_name: decimal_1
  }

  measure: comment_body_word_sum {
    type: sum
    sql: ${comment_body_word_count} ;;
    label: "# Comment Body Word"
    description: "Count of distinct comment_body_word_count."
  }

  measure: comment_body_word_avg {
    type: average
    sql: ${comment_body_word_count} ;;
    label: "# Comment Body Word (Avg)"
    description: "Avg Count of distinct comment_body_word_count."
    value_format_name: decimal_1
  }

}
