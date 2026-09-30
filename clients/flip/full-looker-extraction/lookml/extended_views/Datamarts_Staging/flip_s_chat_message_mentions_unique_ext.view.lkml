include: "/base_views/Datamarts_Staging/flip_s_chat_message_mentions_unique_base.view"

view: flip_s_chat_message_mentions_unique_ext {

  extends: [flip_s_chat_message_mentions_unique_base]

  drill_fields: [message_mention_id, message_id, tenant, created_timestamp, is_mention_deleted]

#--------------DIMENSIONS-----------------------------------------------------------

  dimension: created_timestamp {
    type: number

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
    hidden: yes
  }

  dimension: is_mention_deleted {
    type: yesno

  }

  dimension: mentioned_user_id {
    type: string
    hidden: yes
  }

  dimension: message_id {
    type: string
    hidden: yes
  }

  dimension: message_mention_id {
    type: string
    primary_key: yes
  }

  dimension: tenant {
    type: string

  }

#------------MANUALLY ADDED DIMENSIONS-----------------------------------

#-------------MEASURES-----------------------------------------

  measure: count {
    type: count
    label: "# Message Mentions"
    description: "Count of unique message_mention_id"
  }

  measure: message_count {
    type: count_distinct
    sql: ${message_id} ;;
    label: "# Messages with Mention"
    description: "Number of messages with at least one mention. Count of unique message_id."
  }

  measure: mentioned_user_count {
    type: count_distinct
    sql: ${mentioned_user_id} ;;
    label: "# Mentioned Users"
    description: "Number of users mentioned. Count of unique mentioned_user_id."
  }

}
