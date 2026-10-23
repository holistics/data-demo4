include: "/base_views/Datamarts/flip_chats_unique_base.view"
view: flip_chats_unique_ext {
  extends: [flip_chats_unique_base]

  drill_fields: [chat_id, created_timestamp_date,tenant, is_chat_deleted, chat_type]

#---DIMENSIONS----------------------------

  dimension: chat_id {
    type: string
    primary_key: yes
  }

  dimension: tenant {
    type: string

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

  dimension: chat_members_count {
    type: number

  }

  dimension: is_chat_deleted {
    type: yesno

  }

  dimension: is_private_chat {
    type: yesno

  }

  dimension: is_db_row_deleted {
    type: yesno
    hidden: yes
  }

  dimension: chat_type {
    type: string
  }

#--------MANUALLY ADDED DIMENSIONS-----

  dimension: chat_members_tiers {
    type: tier
    sql: ${chat_members_count} ;;
    tiers: [0,1,2,10,20,30]
    style: integer
  }

  #---MEASURES------------------
  measure: count {
    type: count
    label: "# Chats"
    description: "Count of unique chat_id. "
  }

  measure: chat_members_sum {
    type: sum
    sql: ${chat_members_count} ;;
    label: "# Chat Members"
  }

  measure: chat_members_avg {
    type: average
    sql: ${chat_members_count} ;;
    label: "# Chat Members (Avg)"
    value_format_name: decimal_1
  }
}
