include: "/base_views/Datamarts/flip_translation_versions_unique_base.view"

view: flip_translation_versions_unique_ext {

  extends: [flip_translation_versions_unique_base]

  drill_fields: [translation_version_id, tenant, created_timestamp_date, translation_element_type, source_language, target_language  ]

# --- DIMENSIONS ---------------------------------

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

  dimension: is_db_row_deleted {
    type: yesno
  }

  dimension: source_language {
    type: string
  }

  dimension: target_language {
    type: string
  }

  dimension: target_language_count {
    type: number
    hidden: yes
  }

  dimension: tenant {
    type: string
  }

  dimension: translated_content_character_count {
    type: number
    hidden: yes
  }

  dimension: translated_content_word_count {
    type: number
    hidden: yes
  }

  dimension: translation_element_id {
    type: string
  }

  dimension: translation_element_type {
    type: string
  }

  dimension: translation_id {
    type: string
  }

  dimension: translation_version_count {
    type: number
    hidden: yes
  }

  dimension: translation_version_failure_code {
    type: number
  }

  dimension: translation_version_failure_reason {
    type: string
  }

  dimension: translation_version_id {
    type: string
    primary_key: yes
  }

  dimension: translation_version_status {
    type: string
  }

  dimension: translation_version_status_ordered {
    type: string
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

  # --- MANUALLY ADDED DIMENSIONS ----------------------------------------

  # --- MEASURES ----------------------------------------

  measure: count {
    type: count
    label: "# Translation Versions"
    description: "A translation version is one unique version of one Target Language translation for one Translation Element.
    There may be multiple Translation Versions per Translation and mulitple Translations (one per Target Language) per Translation Element. Count of distinct translation_version_ids."
  }

  measure: translation_id_count_distinct {
    type: count_distinct
    sql: ${translation_id} ;;
    label: "# Translations"
    description: "A translation is a combination of a Translation Element and a Target Language. If the Translation Element is altered after publishing there may be multiple
    Translation Versions per Translation. Count of distinct translation_ids."
  }

  measure: translation_element_id_count_distinct {
    type: count_distinct
    sql: ${translation_element_id} ;;
    label: "# Translation Elements"
  }

  measure: target_language_count_distinct {
    type: count_distinct
    sql: ${target_language} ;;
    label: "# Target Languages"
    description: "Count of distinct translation Target Languages (per Translation Element)."
  }

# --deprecated value
  measure: translated_content_word_count_sum {
    type: sum
    sql: ${translated_content_word_count} ;;
    label: "# Words Translated"
    hidden:  yes
  }
# --deprecated value
  measure: translated_content_word_count_avg {
    type: average
    sql: ${translated_content_word_count} ;;
    label: "# Words Translated (Avg)"
    value_format_name: decimal_1
    hidden:  yes
  }
# --deprecated value
  measure: translated_content_character_count_sum {
    type: sum
    sql: ${translated_content_character_count} ;;
    label: "# Characters Translated "
    hidden:  yes
  }
# --deprecated value
  measure: translated_content_character_count_avg {
    type: average
    sql: ${translated_content_character_count} ;;
    label: "# Characters Translated (Avg)"
    value_format_name: decimal_1
    hidden:  yes
  }

  # --- SETS -----------------------------------------------------------------

  set: translations_irrelevant_for_all_flip {
    fields: [tenant, db_row_timestamp_date, db_row_timestamp_month, db_row_timestamp_quarter, db_row_timestamp_raw, db_row_timestamp_time, db_row_timestamp_week, db_row_timestamp_year
    ]
  }
}
