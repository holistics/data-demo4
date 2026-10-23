view: flip_attachments_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_attachments_unique` ;;

  dimension: attachment_element_id {
    type: string
    sql: ${TABLE}.attachment_element_id ;;
  }

  dimension: attachment_element_type {
    type: string
    sql: ${TABLE}.attachment_element_type ;;
  }

  dimension: attachment_file_size {
    type: number
    sql: ${TABLE}.attachment_file_size ;;
  }

  dimension: attachment_file_type {
    type: string
    sql: ${TABLE}.attachment_file_type ;;
  }

  dimension: attachment_id {
    type: string
    sql: ${TABLE}.attachment_id ;;
  }

  dimension: attachment_image_height {
    type: number
    sql: ${TABLE}.attachment_image_height ;;
  }

  dimension: attachment_image_width {
    type: number
    sql: ${TABLE}.attachment_image_width ;;
  }

  dimension: attachment_media_type {
    type: string
    sql: ${TABLE}.attachment_media_type ;;
  }

  dimension: attachment_order_number {
    type: number
    sql: ${TABLE}.attachment_order_number ;;
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

  dimension: file_name_character_count {
    type: number
    sql: ${TABLE}.file_name_character_count ;;
  }

  dimension: file_name_word_count {
    type: number
    sql: ${TABLE}.file_name_word_count ;;
  }

  dimension: is_attachment_deleted {
    type: yesno
    sql: ${TABLE}.is_attachment_deleted ;;
  }

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: is_streamable_video {
    type: yesno
    sql: ${TABLE}.is_streamable_video ;;
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
