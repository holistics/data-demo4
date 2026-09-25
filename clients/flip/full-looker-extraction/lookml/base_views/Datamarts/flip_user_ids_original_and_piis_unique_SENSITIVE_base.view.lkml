view: flip_user_ids_original_and_piis_unique_SENSITIVE_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_user_ids_original_and_piis_unique` ;;

  dimension_group: db_row_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp ;;
  }
  dimension_group: db_row_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp_berlin ;;
  }
  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }
  dimension: external_id {
    type: string
    sql: ${TABLE}.external_id ;;
  }
  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }
  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }
  dimension: job_title {
    type: string
    sql: ${TABLE}.job_title ;;
  }
  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }
  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }
  dimension: reversed_ranking {
    type: number
    sql: ${TABLE}.reversed_ranking ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension: user_id_hashed {
    type: string
    sql: ${TABLE}.user_id_hashed ;;
  }
  dimension: user_id_original {
    type: string
    sql: ${TABLE}.user_id_original ;;
  }
  dimension: username {
    type: string
    sql: ${TABLE}.username ;;
  }
  dimension: about_me_text {
    type: string
    sql: ${TABLE}.about_me_text ;;
  }
  dimension: mobile_number {
    type: string
    sql: ${TABLE}.mobile_number ;;
  }
  dimension: phone_number {
    type: string
    sql: ${TABLE}.phone_number ;;
  }

  measure: count {
    type: count
    drill_fields: [last_name, first_name]
  }
}
