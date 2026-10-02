view: flip_channel_menu_items_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_channel_menu_items_unique` ;;

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

  dimension: channel_id {
    type: string
    sql: ${TABLE}.channel_id ;;
  }

  dimension: channel_menu_item_id {
    type: string
    sql: ${TABLE}.channel_menu_item_id ;;
  }

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: menu_item_id {
    type: string
    sql: ${TABLE}.menu_item_id ;;
  }

  dimension: ranking {
    type: number
    sql: ${TABLE}.ranking ;;
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
