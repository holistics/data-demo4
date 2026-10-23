# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
explore: flip_user_groups_unique_base {
  hidden: yes
    join: flip_user_groups_unique__parent_path_ids {
      view_label: "Flip User Groups Unique: Parent Path Ids"
      sql: LEFT JOIN UNNEST(${flip_user_groups_unique_base.parent_path_ids}) as flip_user_groups_unique__parent_path_ids ;;
      relationship: one_to_many
    }
}
view: flip_user_groups_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_user_groups_unique` ;;

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
  dimension: group_title {
    type: string
    sql: ${TABLE}.group_title ;;
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
  dimension: parent_id {
    type: string
    sql: ${TABLE}.parent_id ;;
  }
  dimension: parent_path_ids {
    hidden: yes
    sql: ${TABLE}.parent_path_ids ;;
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
  dimension: user_group_id {
    type: string
    sql: ${TABLE}.user_group_id ;;
  }
  dimension: user_group_id_wo_tenant {
    type: string
    sql: ${TABLE}.user_group_id_wo_tenant ;;
  }
  dimension: is_dark_mode_set {
    type: yesno
    sql: ${TABLE}.is_dark_mode_set ;;
  }
  dimension: is_light_mode_set {
    type: yesno
    sql: ${TABLE}.is_light_mode_set ;;
  }
  dimension: is_banner_image_set {
    type: yesno
    sql: ${TABLE}.is_banner_image_set ;;
  }
  measure: count {
    type: count
  }
}

view: flip_user_groups_unique__parent_path_ids {

  dimension: flip_user_groups_unique__parent_path_ids {
    type: string
    sql: flip_user_groups_unique__parent_path_ids ;;
  }
}
