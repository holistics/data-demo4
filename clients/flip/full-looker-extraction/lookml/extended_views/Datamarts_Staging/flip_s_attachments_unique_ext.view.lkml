include: "/base_views/Datamarts_Staging/flip_s_attachments_unique_base.view"

view: flip_s_attachments_unique_ext {

extends: [flip_s_attachments_unique_base]

drill_fields: [attachment_id, attachment_element_type, created_timestamp_date,tenant, is_attachment_deleted ]

#-------DIMENSION------------------------------------------------

  dimension: attachment_element_id {
    type: string

  }

  dimension: attachment_element_type {
    type: string

  }

  dimension: attachment_file_size {
    type: number
    hidden: yes
  }

  dimension: attachment_file_type {
    type: string
  }

  dimension: attachment_id {
    type: string
    primary_key: yes
  }

  dimension: attachment_image_height {
    type: number

  }

  dimension: attachment_image_width {
    type: number

  }

  dimension: attachment_media_type {
    type: string
  }

  dimension: attachment_order_number {
    type: number

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

  dimension: file_name_character_count {
    type: number
    hidden: yes
  }

  dimension: file_name_word_count {
    type: number
    hidden: yes
  }

  dimension: is_attachment_deleted {
    type: yesno

  }

  dimension: is_db_row_deleted {
    type: yesno
    hidden: yes
  }

  dimension: is_streamable_video {
    type: yesno

  }

  dimension: tenant {
    type: string
  }

#--------------MANUALLY ADDED DIMENSIONS------------

#--------------MEASURES------------------------

  measure: count {
    type: count
    label: "# Attachments"
    description: "Count of attachment_id."
  }

  measure: attachment_file_size_sum_test {
    type: sum
    label: "File Size (Total)"
    sql: ${attachment_file_size};;
    #value_format_name: decimal_1
    value_format: "[>=1000000000]#0.0,,\" GB\";[>=1000000]#0.0,,\" MB\";#0.00,\" B\""
  }

  measure: attachment_file_size_avg {
    type: average
    label: "File Size (Avg)"
    sql: ${attachment_file_size} ;;
    description: "File Size in Bytes."
    value_format: "[>=1000000000]#0.0,,\" GB\";[>=1000000]#0.0,,\" MB\";#0.00,\" B\""
    }

  measure: attachment_file_size_min {
    type: min
    label: "File Size (Min)"
    sql: ${attachment_file_size} ;;
    value_format: "[>=1000000000]#0.0,,\" GB\";[>=1000000]#0.0,,\" MB\";#0.00,\" B\""
  }

  measure: attachment_file_size_max {
    type: max
    label: "File Size (Max)"
    sql: ${attachment_file_size} ;;
    value_format: "[>=1000000000]#0.0,,\" GB\";[>=1000000]#0.0,,\" MB\";#0.00,\" B\""
  }

  measure: file_name_character_sum {
    type: sum
    label: "# File Name Characters"
    sql: ${file_name_character_count};;

  }

  measure: file_name_character_avg {
    type: average
    label: "# File Name Characters (Avg)"
    sql: ${file_name_character_count} ;;

  }

  measure: file_name_word_sum {
    type: sum
    label: "# File Name Words"
    sql: ${file_name_word_count};;

  }

  measure: file_name_word_avg {
    type: average
    label: "# File Name Words (Avg)"
    sql: ${file_name_word_count} ;;

  }

  measure: attachment_message_count {
    type: count
    filters: [attachment_element_type: "message"]
    label: "# Message with Attachments"
  }

  measure: attachment_post_count {
    type: count
    filters: [attachment_element_type: "post"]
    label: "# Posts with Attachments"
  }

  measure: attachment_task_count {
    type: count
    filters: [attachment_element_type: "task"]
    label: "# Tasks with Attachments"
  }

  measure: attachment_calendar_event_count {
    type: count
    filters: [attachment_element_type: "calendar event"]
    label: "# Calendar Events with Attachments"
  }

  measure: attachment_task_comment_count {
    type: count
    filters: [attachment_element_type: "task comment"]
    label: "# Task Comments with Attachments"
  }

  measure: voice_messages_count {
    type: count
    filters: [attachment_media_type: "VOICE"]
    label: "# Voice Messages"
  }

  }
