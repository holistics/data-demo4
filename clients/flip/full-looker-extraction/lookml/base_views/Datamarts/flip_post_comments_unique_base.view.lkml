view: flip_post_comments_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_post_comments_unique` ;;

  dimension: actor_id {
    type: string
    sql: ${TABLE}.actor_id ;;
  }

  dimension: author_id {
    type: string
    sql: ${TABLE}.author_id ;;
  }

  dimension: comment_body_character_count {
    type: number
    sql: ${TABLE}.comment_body_character_count ;;
  }

  dimension: comment_body_word_count {
    type: number
    sql: ${TABLE}.comment_body_word_count ;;
  }

  dimension: comment_id {
    type: string
    sql: ${TABLE}.comment_id ;;
  }

  dimension: comment_language {
    type: string
    sql: ${TABLE}.comment_language ;;
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
    sql: ${TABLE}.deleted_timestamp ;;
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
    sql: ${TABLE}.edited_in_app_timestamp ;;
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
    sql: ${TABLE}.edited_timestamp ;;
  }

  dimension: is_comment_deleted {
    type: yesno
    sql: ${TABLE}.is_comment_deleted ;;
  }

  dimension: is_comment_edited {
    type: yesno
    sql: ${TABLE}.is_comment_edited ;;
  }

  dimension: is_comment_edited_in_app {
    type: yesno
    sql: ${TABLE}.is_comment_edited_in_app ;;
    }

  dimension: is_comment_reply_old {
    type: yesno
    sql: ${TABLE}.is_comment_reply_old ;;
  }

  dimension: is_pinned {
    type: yesno
    sql: ${TABLE}.is_pinned ;;
  }

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: is_user_action {
    type: yesno
    sql: ${TABLE}.is_user_action ;;
  }

  dimension: contains_comment_mention {
    type: yesno
    sql: ${TABLE}.contains_comment_mention ;;
  }

  dimension: post_id {
    type: string
    sql: ${TABLE}.post_id ;;
  }

  dimension: quoted_comment_id {
    type: string
    sql: ${TABLE}.quoted_comment_id ;;
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

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
