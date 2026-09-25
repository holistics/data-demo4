view: flip_menu_items_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_menu_items_unique` ;;

  dimension: background_file_id {
    type: string
    sql: ${TABLE}.background_file_id ;;
  }
  dimension_group: created_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_timestamp ;;
  }
  dimension_group: created_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_timestamp_berlin ;;
  }
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
  dimension: display_option {
    type: string
    sql: ${TABLE}.display_option ;;
  }
  dimension: icon {
    type: string
    sql: ${TABLE}.icon ;;
  }
  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }
  dimension: is_managed_by_user_group {
    type: yesno
    sql: ${TABLE}.is_managed_by_user_group ;;
  }
  dimension: is_only_visible_to_group_members {
    type: yesno
    sql: ${TABLE}.is_only_visible_to_group_members ;;
  }
  dimension: is_root {
    type: yesno
    sql: ${TABLE}.is_root ;;
  }
  dimension_group: lifetime_start_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.lifetime_start_timestamp ;;
  }
  dimension_group: lifetime_start_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.lifetime_start_timestamp_berlin ;;
  }
  dimension: menu_item_id {
    type: string
    sql: ${TABLE}.menu_item_id ;;
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
  dimension: name_filled {
    type: string
    sql: ${TABLE}.name_filled ;;
  }
  dimension: position {
    type: number
    sql: ${TABLE}.position ;;
  }
  dimension_group: published_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.published_timestamp ;;
  }
  dimension_group: published_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.published_timestamp_berlin ;;
  }
  dimension: ranking {
    type: number
    sql: ${TABLE}.ranking ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension: text_style {
    type: string
    sql: ${TABLE}.text_style ;;
  }
  dimension_group: updated_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_timestamp ;;
  }
  dimension_group: updated_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_timestamp_berlin ;;
  }
  dimension: url {
    type: string
    sql: ${TABLE}.url ;;
  }
  dimension: user_group_id {
    type: string
    sql: ${TABLE}.user_group_id ;;
  }
  dimension: version {
    type: string
    sql: ${TABLE}.version ;;
  }
  measure: count {
    type: count
    drill_fields: [name]
  }
}
