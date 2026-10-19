include: "/base_views/Datamarts/flip_post_seens_unique_base.view"

view: flip_post_seens_unique_ext {
  extends: [flip_post_seens_unique_base]

  drill_fields: [primary_key, post_id, created_timestamp_date, tenant]

# --- DIMENSIONS -----------------------------------

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
    label: "First Post-Seen Timestamp (BE)" # might lead to confusion
    description: "Indicates when the post was seen for the first time (BE-timestamp - delay to FE timestamp possible)"
    hidden: yes # due to possible technical delay better use post_seen_timestamp
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
    label: "Latest Post-Seen Timestamp" # might lead to confusion as we're only tracking seens once
    description: "Indicates when the latest post-seen has happened (latest db_row_timestamp)."
    hidden: yes
  }

  dimension: is_db_row_deleted {
    type: yesno

  }

  dimension: post_id {
    type: string

  }

  dimension_group: post_seen_timestamp {
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
    label: "Post-Seen Timestamp"
    description: "Indicates when the post was seen for the first time (FE-timestamp)"
  }

  dimension: primary_key {
    type: string
    primary_key: yes
  }

  dimension: tenant {
    type: string

  }

  dimension: user_id {
    type: string

  }

  dimension: actor_id {
    type: string

  }

  dimension: is_triggered_by_other_user {
    type: yesno

  }

#--------------MANUALLY ADDED DIMENSIONS---------------------

#------------MEASURES---------------------------

  measure: count {
    type: count
    label: "# Post Seens"
  }

  measure: post_id_count {
    type: count_distinct
    sql: ${post_id} ;;
    label: "# Posts"
    description: "Count of unique post_ids."
  }

  measure: user_id_count {
    type: count_distinct
    sql: ${user_id} ;;
    label: "# Users"
    description: "Count of unique user_ids."
  }
}
