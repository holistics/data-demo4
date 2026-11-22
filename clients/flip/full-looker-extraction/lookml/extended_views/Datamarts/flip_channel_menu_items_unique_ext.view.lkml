include: "/base_views/Datamarts/flip_channel_menu_items_unique_base.view"

view: flip_channel_menu_items_unique_ext {

  extends: [flip_channel_menu_items_unique_base]

  drill_fields: [channel_menu_item_id, menu_item_id, tenant]

# --- BASE DIMENSIONS -------------------------------

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

  dimension: channel_id {
    type: string

  }

  dimension: channel_menu_item_id {
    type: string
    primary_key: yes
  }

  dimension: is_db_row_deleted {
    type: yesno

  }

  dimension: menu_item_id {
    type: string

  }

  dimension: ranking {
    type: number

  }

  dimension: tenant {
    type: string

  }

#------------MANUALLY ADDED DIMENSIONS------------------------

#----------------MEASURES-----------------------------

  measure: count {
    type: count
    label: "# Channel Menu Items"
    description: "Count of unique channel_menu_item_id."
  }

  measure: channel_id_count {
    type: count_distinct
    sql: ${menu_item_id} ;;
    label: "# Menu Items"
    description: "Count of unique menu_item_ids"

  }

}
