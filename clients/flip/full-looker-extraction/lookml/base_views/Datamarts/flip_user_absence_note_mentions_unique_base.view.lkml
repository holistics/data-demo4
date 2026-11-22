view: flip_user_absence_note_mentions_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_user_absence_note_mentions_unique` ;;

  dimension: absence_id {
    type: string
    sql: ${TABLE}.absence_id ;;
  }

  dimension: absence_mention_id {
    type: string
    sql: ${TABLE}.absence_mention_id ;;
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

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: mentioned_user_id {
    type: string
    sql: ${TABLE}.mentioned_user_id ;;
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
