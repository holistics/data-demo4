include: "/base_views/Datamarts_Staging/flip_s_chat_messages_unique_base.view"

view: flip_s_chat_messages_unique_ext {

  extends: [flip_s_chat_messages_unique_base]

  drill_fields: [message_id, created_timestamp_date, is_message_reply, is_message_deleted, tenant]

# --- DIMENSIONS ------------------------------------

    dimension: author_id {
      type: string
      hidden: yes
    }

    dimension: chat_id {
      type: string
      hidden: yes
    }

    dimension: client_content_id {
      type: string
      hidden: yes
    }

    dimension_group: created_timestamp {
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

  dimension: is_active_chat {
    type: yesno
  }

    dimension: is_db_row_deleted {
      type: yesno
      hidden: yes
    }

  dimension: is_group_first_message {
    type: yesno
  }
  dimension: is_group_last_message {
    type: yesno
  }

    dimension: is_message_deleted {
      type: yesno
    }

  dimension: is_message_translated {
    type: yesno
  }
  dimension: is_private_first_message {
    type: yesno
  }
  dimension: is_private_last_message {
    type: yesno
  }

    dimension: message_attachments_count {
      type: number
      hidden: yes
    }

    dimension: message_body_character_count {
      type: number
      hidden: yes
    }

    dimension: message_body_word_count {
      type: number
      hidden: yes
    }

    dimension: message_id {
      type: string
      primary_key: yes
      hidden: no
    }

    dimension: message_language {
      type: string
    }

  dimension: message_language_count {
    type: number
  }

    dimension: message_reactions_count {
      type: number
    }

    dimension: quoted_message_id {
      type: string
    }

    dimension: sequence_number {
      type: number
    }

    dimension: tenant {
      type: string
      hidden: no
    }

# --- MANUALLY CREATED DIMENSIONS -----------------------------------

dimension: is_message_reply {
  type: yesno
  sql: ${quoted_message_id} IS NOT NULL ;;
  description: "A message is considered a 'reply' if the quoted_message_is is filled."
}

# --- MEASURES ------------------------------------------------------
    measure: count {
      type: count
      label: "# Messages"
      description: "Count of unique message_ids."
    }

    measure: count_distinct_days {
      type: count_distinct
      sql: ${created_timestamp_date} ;;
      label: "#days"
    }

    measure: message_reply_count {
      type: count
      filters: [is_message_reply: "Yes"]
      label: "# Message Replies"
      description: "Count of unique message_ids where quuoted_message_id is filled."
    }

    measure: message_attachments_count_sum {
      type: sum
      sql: ${message_attachments_count} ;;
      label: "# Message Attachments"
    }

    measure: message_body_character_count_sum {
      type: sum
      sql: ${message_body_character_count} ;;
      label: "# Message Characters"
    }

    measure: message_body_character_count_avg {
      type: average
      sql: ${message_body_character_count} ;;
      label: "# Message Characters (Avg)"
      value_format_name: decimal_0
   }

  measure: message_body_character_count_min {
    type: min
    sql: ${message_body_character_count} ;;
    label: "# Message Characters (Min)"
  }

  measure: message_body_character_count_max {
    type: max
    sql: ${message_body_character_count} ;;
    label: "# Message Characters (Max)"
  }

  measure: message_body_word_count_sum {
    type: sum
    sql: ${message_body_word_count} ;;
    label: "# Message word"
  }

  measure: message_body_word_count_avg {
    type: average
    sql: ${message_body_word_count} ;;
    label: "# Message Words (Avg)"
    value_format_name: decimal_0
  }

  measure: message_body_word_count_min {
    type: min
    sql: ${message_body_word_count} ;;
    label: "# Message Words (Min)"
  }

  measure: message_body_word_count_max {
    type: max
    sql: ${message_body_word_count} ;;
    label: "# Message Words (Max)"
  }

    measure: author_id_count_distinct {
      type: count_distinct
      sql: ${author_id} ;;
      label: "# Authors"
    }

    measure: chat_id_count_distinct {
      type: count_distinct
      sql: ${chat_id} ;;
      label: "# Chats"
  }
  }
