view: flip_user_absence_notes_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_user_absence_notes_unique` ;;

  dimension: absence_description_character_count {
    type: number
    sql: ${TABLE}.absence_description_character_count ;;
  }

  dimension: absence_description_word_count {
    type: number
    sql: ${TABLE}.absence_description_word_count ;;
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
    sql: ${TABLE}.absence_end_timestamp ;;
  }

  dimension: absence_id {
    type: string
    sql: ${TABLE}.absence_id ;;
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
    sql: ${TABLE}.absence_start_timestamp ;;
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
    sql: ${TABLE}.created_timestamp_berlin ;;
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

  dimension: is_absence_note_active_now {
    type: yesno
    sql: ${TABLE}.is_absence_note_active_now ;;
  }

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  dimension: update_count {
    type: number
    sql: ${TABLE}.update_count ;;
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
    sql: ${TABLE}.updated_timestamp_berlin ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
