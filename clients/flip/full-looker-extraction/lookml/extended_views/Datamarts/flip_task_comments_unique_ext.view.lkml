include: "/base_views/Datamarts/flip_task_comments_unique_base.view"

view: flip_task_comments_unique_ext {
  extends: [flip_task_comments_unique_base]

  drill_fields: [task_comment_id, created_timestamp_date, author_id, is_task_comment_deleted,
    task_comment_language, tenant]

# --- DIMENSIONS ---------------------------------------

  dimension: author_id {
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
    hidden: yes
  }

  dimension: is_task_comment_deleted {
    type: yesno

  }

  dimension: task_comment_body_character_count {
    type: number
    hidden: yes
  }

  dimension: task_comment_body_word_count {
    type: number
    hidden: yes
  }

  dimension: task_comment_id {
    type: string
    primary_key:  yes
  }

  dimension: task_comment_language {
    type: string

  }

  dimension: task_id {
    type: string

  }

  dimension: tenant {
    type:  string
  }

#-----------MANUALLY ADDED DIMENSIONS--------------------------

#------------MEASURES----------------------------------

  measure: count {
    type: count
    label: "# Task Comments"
    description: "Count of unique task_comment_id"
  }

  measure: author_count {
    type: count_distinct
    sql: ${author_id} ;;
    label: "# Authors"
    description: " Count of unique author_id."
  }

  measure: task_comment_deleted_sum {
    type: count
    filters: [is_task_comment_deleted: "Yes"]
    label: "# Deleted Task Comments"
    description: "Count of unique task_comment_id which are deleted."
  }

  measure: task_comment_body_character_sum {
    type: sum
    sql: ${task_comment_body_character_count} ;;
    label: "# Task Comment Body Characters"
  }

  measure: task_comment_body_character_avg {
    type: average
    sql: ${task_comment_body_character_count} ;;
    label: "# Task Comment Body Character (Avg)"
    value_format_name: decimal_1
  }

  measure: task_comment_body_word_sum {
    type: sum
    sql: ${task_comment_body_word_count} ;;
    label: "# Task Comment Body Words"
  }

  measure: task_comment_body_word_avg {
    type: average
    sql: ${task_comment_body_word_count} ;;
    label: "# Task Comment Body Words (Avg)"
    value_format_name: decimal_1
  }

  measure: task_comment_language_count_distinct {
    type: count_distinct
    sql: ${task_comment_language} ;;
    label: "# Task Comment Languages"
    description: "Count of unique task comment languages."
  }
}
