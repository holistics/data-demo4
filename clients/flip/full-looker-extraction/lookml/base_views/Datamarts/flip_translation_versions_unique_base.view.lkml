view: flip_translation_versions_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_translation_versions_unique` ;;

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

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: source_language {
    type: string
    sql: ${TABLE}.source_language ;;
  }

  dimension: target_language {
    type: string
    sql: ${TABLE}.target_language ;;
  }

  dimension: target_language_count {
    type: number
    sql: ${TABLE}.target_language_count ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  dimension: translated_content_character_count {
    type: number
    sql: ${TABLE}.translated_content_character_count ;;
  }

  dimension: translated_content_word_count {
    type: number
    sql: ${TABLE}.translated_content_word_count ;;
  }

  dimension: translation_element_id {
    type: string
    sql: ${TABLE}.translation_element_id ;;
  }

  dimension: translation_element_type {
    type: string
    sql: ${TABLE}.translation_element_type ;;
  }

  dimension: translation_id {
    type: string
    sql: ${TABLE}.translation_id ;;
  }

  dimension: translation_version_count {
    type: number
    sql: ${TABLE}.translation_version_count ;;
  }

  dimension: translation_version_failure_code {
    type: number
    sql: ${TABLE}.translation_version_failure_code ;;
  }

  dimension: translation_version_failure_reason {
    type: string
    sql: ${TABLE}.translation_version_failure_reason ;;
  }

  dimension: translation_version_id {
    type: string
    sql: ${TABLE}.translation_version_id ;;
  }

  dimension: translation_version_status {
    type: string
    sql: ${TABLE}.translation_version_status ;;
  }

  dimension: translation_version_status_ordered {
    type: string
    sql: ${TABLE}.translation_version_status_ordered ;;
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

  measure: count {
    type: count
    drill_fields: []
  }
}
