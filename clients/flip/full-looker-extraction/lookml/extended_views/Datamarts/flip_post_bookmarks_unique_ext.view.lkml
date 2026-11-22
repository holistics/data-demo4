include: "/base_views/Datamarts/flip_post_bookmarks_unique_base.view"

view: flip_post_bookmarks_unique_ext {
  extends: [flip_post_bookmarks_unique_base]

  drill_fields: [bookmark_id, group_id, tenant]

# --- BASE DIMENSIONS -------------------------------

  dimension: bookmark_id {
    type: string
    primary_key: yes
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

  dimension: group_id {
    type: string

  }

  dimension: is_db_row_deleted {
    type: yesno

  }

  dimension: post_id {
    type: string

  }

  dimension: tenant {
    type: string

  }

  dimension: user_id {
    type: string

  }

#------------MANUALLY ADDED DIMENSIONS------------------------------

#-----------MEASURES-----------------------------

  measure: count {
    type: count
    label: "# Bookmarks"
  }

  measure: post_id_count_distinct {
    type: count_distinct
    sql: ${post_id} ;;
    label: "# Posts"
    description: "Count of unique post_ids."
  }

  measure: user_id_count_distinct {
    type: count_distinct
    sql: ${user_id} ;;
    label: "# Users"
    description: "Count of unique user_ids."
  }
}
