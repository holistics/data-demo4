view: flip_translations_character_count_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_translations_character_count_unique` ;;

  dimension: author_id {
    type: string
    sql: ${TABLE}.author_id ;;
  }

  dimension: created_timestamp {
    type: number
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

  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }

  dimension: ranking {
    type: number
    sql: ${TABLE}.ranking ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  dimension: translation_character_count {
    type: number
    sql: ${TABLE}.translation_character_count ;;
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

  measure: count {
    type: count
    drill_fields: []
  }
}
