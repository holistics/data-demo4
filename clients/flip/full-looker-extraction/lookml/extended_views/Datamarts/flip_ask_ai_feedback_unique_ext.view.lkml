include: "/base_views/Datamarts/flip_ask_ai_feedback_unique_base.view"

view: flip_ask_ai_feedback_unique_ext__tags {

  extends: [flip_ask_ai_feedback_unique__tags]
  fields_hidden_by_default: yes
  }

view: flip_ask_ai_feedback_unique_ext {

  extends: [flip_ask_ai_feedback_unique_base]

# --- DIMENSIONS ---------------------------------------------------------

  dimension: ai_feedback_id {
    type: string
    primary_key: yes
  }

  dimension: ai_service {
    type: string
  }

  dimension: chat_id {
    type: string
  }

  dimension_group: created_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }

  dimension_group: created_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }

  dimension_group: db_row_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }

  dimension_group: db_row_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }

  dimension: feedback {
    type: string
  }

  dimension: is_db_row_deleted {
    type: yesno
  }

  dimension: message_id {
    type: string
  }

  dimension: trace_id {
    type: string
  }

  dimension: sentiment {
    type: string
  }

  dimension: tags {
    hidden: yes
  }

  dimension: tenant {
    type: string
  }

  dimension_group: updated_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }

  dimension_group: updated_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }

  dimension: user_id {
    type: string
  }

# --- MANUALLY ADDED DIMENSIONS -------------------

# --- MEASURES -------------------------------

  measure: count {
    type: count
    label: "# Feedback"
    description: "Count of unique ai_message_id."
  }

  measure: feedback_positive {
    type: sum
    sql: CASE WHEN ${sentiment} = 'POSITIVE' THEN 1 ELSE 0 END ;;
    label: "# Positive Feedback"
  }

  measure: feedback_negative {
    type: sum
    sql: CASE WHEN ${sentiment} = 'NEGATIVE' THEN 1 ELSE 0 END ;;
    label: "# Negative Feedback"
  }

}
