include: "/base_views/Datamarts/flip_user_absence_notes_unique_base.view"

view: flip_user_absence_notes_unique_ext {

  extends: [flip_user_absence_notes_unique_base]

  drill_fields: [absence_id, tenant, is_absence_note_active_now]

#------------DIMENSIONS--------------------------------------

  dimension: absence_description_character_count {
    type: number
    hidden: yes
  }

  dimension: absence_description_word_count {
    type: number
    hidden: yes
  }

  dimension_group: absence_end_timestamp {
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

  dimension: absence_id {
    type: string
    primary_key: yes
  }

  dimension_group: absence_start_timestamp {
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

  dimension_group: created_timestamp_berlin {
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

  dimension: is_absence_note_active_now {
    type: yesno

  }

  dimension: is_db_row_deleted {
    type: yesno

  }

  dimension: tenant {
    type: string

  }

  dimension: update_count {
    type: number

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

  dimension_group: updated_timestamp_berlin {
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

  dimension: user_id {
    type: string

  }

#-------MANUALLY ADDED DIMENSIONS---------------------------------

  dimension: absence_status {
    type: string
    sql: CASE WHEN ${is_absence_note_active_now} IS TRUE THEN "Absent" ELSE "Present" END ;;
    description: "Absence Status for Absent or Present."
  }

#--------MEASURES---------------------------------
  measure: count {
    type: count
    label: "# Absence Notes"
    description: "Count of unique absence_id"
  }

  measure: now_active_absence_notes_sum {
    type: count
    filters: [is_absence_note_active_now: "Yes"]
    label: "# Absence Notes (active now)"
    description: "Count of unique absence_ids which are currently shown/active."
  }

  measure: user_id_count_distinct {
    type: count_distinct
    sql: ${user_id} ;;
    label: "# Users"
  }

  measure: absence_description_word_count_sum {
    type: sum
    sql: ${absence_description_word_count} ;;
    label: "# Words"
  }

  measure: absence_description_word_count_avg {
    type: average
    sql: ${absence_description_word_count} ;;
    label: "# Words (Avg)"
    value_format_name: decimal_1
  }

  measure: absence_description_character_count_sum {
    type: sum
    sql: ${absence_description_character_count} ;;
    label: "# Characters"
  }
  measure: absence_description_character_count_avg {
    type: average
    sql: ${absence_description_character_count} ;;
    label: "# Characters (Avg)"
    value_format_name: decimal_1
  }
}
