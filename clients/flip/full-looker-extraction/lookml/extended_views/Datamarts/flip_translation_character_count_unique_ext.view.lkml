include: "/base_views/Datamarts/flip_translations_character_count_unique_base.view"

view: flip_translations_character_count_unique_ext {

  extends: [flip_translations_character_count_unique_base]

  drill_fields: []

# --- DIMENSIONS -----------------------------------------------------------------------------------------------------------

  dimension: author_id {
    type: string
    hidden: yes
  }

  dimension_group: created_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      minute30,
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

  dimension: primary_key {
    type: string
    primary_key: yes
  }

  dimension: ranking {
    type: number
  }

  dimension: tenant {
    type: string
  }

  dimension: translation_character_count {
    type: number
    hidden: yes
  }

  dimension: translation_element_id {
    type: string
  }

  dimension: translation_element_type {
    type: string
  }

  dimension: character_count_id {
    type: string
  }

  # --- MEASURES -----------------------------------------------------------------
  measure: count {
    type: count
    label: "# Translation"
  }

  measure: translation_element_id_count {
    type: count_distinct
    sql: ${translation_element_id} ;;
    label: "# Translation Elements"
    description: "Count of distinct translation_element_id."
  }

  measure: translation_character_count_sum {
    type: sum
    sql: ${translation_character_count} ;;
    label: "# Translated Characters"
  }

  measure: translation_character_count_avg {
    type: average
    sql: ${translation_character_count} ;;
    label: "# Translated Characters (Avg)"
    value_format_name: decimal_1
  }

  # --- SETS -----------------------------------------------------------------

  set: translation_characters_irrelevant_for_all_flip {
    fields: [tenant, db_row_timestamp_date, db_row_timestamp_month, db_row_timestamp_quarter, db_row_timestamp_raw, db_row_timestamp_time, db_row_timestamp_week, db_row_timestamp_year, is_db_row_deleted
      ]
  }

}
