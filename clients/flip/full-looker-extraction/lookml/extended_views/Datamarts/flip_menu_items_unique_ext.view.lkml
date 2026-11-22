include: "/base_views/Datamarts/flip_menu_items_unique_base.view"

view: flip_menu_items_unique_ext {

  extends: [flip_menu_items_unique_base]

  drill_fields: [menu_item_id, icon, created_timestamp_date, tenant, is_only_visible_to_group_members]

# --- BASE DIMENSIONS -------------------------------

  dimension: background_file_id {
    type: string

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
    timeframes: [raw, time, date, week, month, quarter, year]
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

  dimension: display_option {
    type: string

  }

  dimension: icon {
    type: string

  }

  dimension: is_db_row_deleted {
    type: yesno

  }

  dimension: is_managed_by_user_group {
    type: yesno
  }

  dimension: is_only_visible_to_group_members {
    type: yesno
  }

  dimension: is_root {
    type: yesno
    label: "Is managing UG root"
  }

  dimension_group: lifetime_start_timestamp {
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

  dimension: menu_item_id {
    type: string
    primary_key: yes
  }

  dimension: name {
    type: string
    label: "Name (original)"
    description: "Always shows the latest version of the name (which can be empty)."
  }

  dimension: name_filled {
    type: string
    label: "Name (filled)"
    description: "In case the latest version of the name is empty, the value is filled from a previous version."
  }

  dimension: position {
    type: number
  }

  dimension_group: published_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }

  dimension: ranking {
    type: number

  }

  dimension: status {
    type: string
  }

  dimension: tenant {
    type: string
  }

  dimension: text_style {
    type: string
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

  dimension: url {
    type: string
  }

  dimension: user_group_id {
    type: string
  }
  dimension: version {
    type: string
  }

#-----------------MANUALLY ADDED DIMENSIONS-----------------------

#------------------MEASURES--------------------------
  measure: count {
    type: count
    label: "# Menu Items"
    description: "Count of unique menu_items_id."
  }

  measure: icon_count {
    type: count_distinct
    sql: ${icon} ;;
    label: "# Icons"
    description: "Count of icons."
  }
}
