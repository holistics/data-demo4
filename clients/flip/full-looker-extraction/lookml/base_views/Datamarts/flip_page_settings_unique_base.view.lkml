# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
explore: flip_page_settings_unique_base {
  hidden: yes
    join: flip_page_settings_unique__parent_path_ids {
      view_label: "Flip Page Settings Unique: Parent Path Ids"
      sql: LEFT JOIN UNNEST(${flip_page_settings_unique_base.parent_path_ids}) as flip_page_settings_unique__parent_path_ids ;;
      relationship: one_to_many
    }
}
view: flip_page_settings_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_page_settings_unique` ;;

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
  dimension: external_id {
    type: string
    sql: ${TABLE}.external_id ;;
  }
  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }
  dimension: is_leaf {
    type: yesno
    sql: ${TABLE}.is_leaf ;;
  }
  dimension: is_parent {
    type: yesno
    sql: ${TABLE}.is_parent ;;
  }
  dimension: is_root {
    type: yesno
    sql: ${TABLE}.is_root ;;
  }
  dimension: managing_user_group_id {
    type: string
    sql: ${TABLE}.managing_user_group_id ;;
  }
  dimension: order_number {
    type: number
    sql: ${TABLE}.order_number ;;
  }
  dimension: page_id {
    type: string
    sql: ${TABLE}.page_id ;;
  }
  dimension: parent_page_id {
    type: string
    sql: ${TABLE}.parent_page_id ;;
  }
  dimension: parent_path_ids {
    hidden: yes
    sql: ${TABLE}.parent_path_ids ;;
  }
  dimension: publication_status {
    type: string
    sql: ${TABLE}.publication_status ;;
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
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
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
  measure: count {
    type: count
  }
}

view: flip_page_settings_unique__parent_path_ids {

  dimension: flip_page_settings_unique__parent_path_ids {
    type: string
    sql: flip_page_settings_unique__parent_path_ids ;;
  }
}
