include: "/base_views/Datamarts/flip_task_comment_reactions_unique_base.view"

view: flip_task_comment_reactions_unique_ext {
  extends: [flip_task_comment_reactions_unique_base]

  drill_fields: [task_comment_reaction_id, created_timestamp, reaction_type, updated_count]

# --- DIMENSIONS ---------------------------------------

  dimension: comment_id {
    type: string

  }

  dimension: created_timestamp {
    type: number

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

  dimension: is_db_row_deleted {
    type: yesno

  }

  dimension: reaction_type {
    type: string

  }

  dimension: task_comment_reaction_id {
    type: string
    primary_key: yes
  }

  dimension: updated_count {
    type: number
    hidden: yes
  }

  dimension: updated_distinct_count {
    type: number
    hidden: yes
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

  dimension: user_comment_id {
    type: string
  }

  dimension: user_id {
    type: string

  }

#--------------MANUALLY ADDED DIMENSIONS---------------------

#-----------------MEASURES-----------------------------------

  measure: count {
    type: count
    label: "# Comment Reactions"
    description: "Count of unique task_comment_reaction_ids."
  }

  measure: comment_count {
    type: count_distinct
    sql: ${comment_id} ;;
    label: "# Comments"
    description: " Count of unique comment_ids."
  }

  measure: happy_reaction_count {
    type: count
    filters: [reaction_type: "HAPPY"]
    label: "# Comment Reactions Happy"
  }

  measure: heart_reaction_count {
    type: count
    filters: [reaction_type: "HEART"]
    label: "# Comment Reactions Heart"
  }

  measure: clapping_reaction_count {
    type: count
    filters: [reaction_type: "CLAPPING"]
    label: "# Comment Reactions Clapping"
  }

  measure: inspiring_reaction_count {
    type: count
    filters: [reaction_type: "INSPIRING"]
    label: "# Comment Reactions Inspiring"
  }

  measure: thumbsup_reaction_count {
    type: count
    filters: [reaction_type: "THUMBS_UP"]
    label: "# Comment Reactions Thumbs_up"
  }

  measure: sad_reaction_count {
    type: count
    filters: [reaction_type: "SAD"]
    label: "# Comment Reactions Sad"
  }

  measure: updated_count_sum {
    type: sum
    sql: ${updated_count} ;;
    label: "# Updates"
    description: "Count of reaction type changes."
  }

  measure: updated_count_average {
    type: average
    sql: ${updated_count} ;;
    label: "# Updates (Avg)"
    description: "Count of reaction type changes."
    value_format_name: decimal_1
  }
}
