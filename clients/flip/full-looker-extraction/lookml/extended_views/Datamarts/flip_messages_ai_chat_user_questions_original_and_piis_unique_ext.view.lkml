include: "/base_views/Datamarts/flip_messages_ai_chat_user_questions_original_and_piis_unique_base.view"

view: flip_messages_ai_chat_user_questions_original_and_piis_unique_ext {

  extends: [flip_messages_ai_chat_user_questions_original_and_piis_unique_base]

# --- DIMENSIONS ---------------------------------------------------------

  dimension: author_id {
    type: string
  }
  dimension: chat_id {
    type: string
  }
  dimension_group: db_row_timestamp {
    type: time
    timeframes: [raw, time, date, week, day_of_week, month, quarter, year]
  }
  dimension_group: db_row_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension: message_body_character_count {
    type: number
    hidden: yes
  }
  dimension: message_body_word_count {
    type: number
    hidden: yes
  }
  dimension: messages_per_chat_count {
    type: number
    hidden: yes
  }
  dimension: message_id {
    type: string
    primary_key: yes
  }
  dimension: trace_id {
    type: string
  }
  dimension: message_language {
    type: string
  }
  dimension: sequence_number {
    type: number
  }
  dimension: tenant {
    type: string
  }
  dimension: user_group_id {
    type: string
  }
  dimension: time_since_previous_message_seconds {
    type: number
    hidden: yes
  }

# --- MANUALLY ADDED DIMENSIONS -------------------

# --- MEASURES -------------------------------

  measure: count {
    type: count
    label: "# Messages"
    description: "Count of unique message_id."
  }

  measure: message_body_word_count_sum {
    type: sum
    sql: ${message_body_character_count} ;;
    label: "# Message Words"
  }

  measure: message_body_word_count_avg {
    type: average
    sql: ${message_body_character_count} ;;
    label: "Avg Message Words"
  }

  measure: message_body_character_count_sum {
    type: sum
    sql: ${message_body_character_count} ;;
    label: "# Message Characters"
  }

  measure: message_body_character_count_avg {
    type: average
    sql: ${message_body_character_count} ;;
    label: "Avg Message Characters"
  }

  measure: users_count {
    type: count_distinct
    sql: ${author_id} ;;
    label: "# Users"
  }

  measure: chats_count {
    type: count_distinct
    sql: ${chat_id} ;;
    label: "# Chats"
  }

  measure: follow_up_questions_count {
    type: count_distinct
    sql: CASE WHEN ${sequence_number} > 1 THEN ${message_id} END ;;
    label: "# Follow-up questions"
  }

  measure: messages_per_chat_count_median {
    type: number
    sql:  (
      SELECT
        APPROX_QUANTILES(t.messages_per_chat_count, 100)[OFFSET(50)]
      FROM (
        SELECT
          ${chat_id},
          ${messages_per_chat_count}
        FROM
          fl-bi-p-poc.datamarts_poc.flip_messages_ai_chat_user_questions_original_and_piis_unique AS flip_production_ask_ai
        GROUP BY 1, 2
      ) AS t
    ) ;;
    label: "Median Messages per Chat"
  }

  measure: time_since_previous_message_seconds_avg {
    type: average
    sql: ${time_since_previous_message_seconds} ;;
    label: "Avg Time since previous message"
  }

  measure: time_since_previous_message_seconds_median {
    type: median
    sql: ${time_since_previous_message_seconds} ;;
    label: "Median Time since previous message"
  }

}
