# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
explore: flip_ask_ai_feedback_unique_base {
  hidden: yes
    join: flip_ask_ai_feedback_unique__tags {
      view_label: "Flip Ask Ai Feedback Unique: Tags"
      sql: LEFT JOIN UNNEST(${flip_ask_ai_feedback_unique_base.tags}) as flip_ask_ai_feedback_unique__tags ;;
      relationship: one_to_many
    }
}
view: flip_ask_ai_feedback_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_ask_ai_feedback_unique` ;;

  dimension: ai_feedback_id {
    type: string
    sql: ${TABLE}.ai_feedback_id ;;
  }
  dimension: ai_service {
    type: string
    sql: ${TABLE}.ai_service ;;
  }
  dimension: chat_id {
    type: string
    sql: ${TABLE}.chat_id ;;
  }
  dimension_group: created_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_timestamp ;;
  }
  dimension_group: created_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_timestamp_berlin ;;
  }
  dimension_group: db_row_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp ;;
  }
  dimension_group: db_row_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp_berlin ;;
  }
  dimension: feedback {
    type: string
    sql: ${TABLE}.feedback ;;
  }
  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }
  dimension: message_id {
    type: string
    sql: ${TABLE}.message_id ;;
  }
  dimension: trace_id {
    type: string
    sql: ${TABLE}.trace_id ;;
  }
  dimension: sentiment {
    type: string
    sql: ${TABLE}.sentiment ;;
  }
  dimension: tags {
    sql: ${TABLE}.tags ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension_group: updated_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_timestamp ;;
  }
  dimension_group: updated_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_timestamp_berlin ;;
  }
  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
  }
}

view: flip_ask_ai_feedback_unique__tags {

  dimension: flip_ask_ai_feedback_unique__tags {
    type: string
    sql: flip_ask_ai_feedback_unique__tags ;;
  }
}
