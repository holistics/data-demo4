include: "/base_views/Datamarts/flip_tasks_unique_base.view"

view: flip_tasks_unique_ext {
  extends: [flip_tasks_unique_base]

  drill_fields: [task_id, created_timestamp_date, due_date_timestamp_date, task_assignee_count, tenant]

# --- DIMENSIONS --------------------------------------------

  dimension: author_id {
    type: string
  }

  dimension: client_content_id {
    type: string
    hidden: yes
  }

  dimension_group: created_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      minute30,
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

  dimension_group: due_date_timestamp {
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

  dimension: due_days {
    type: number

  }

  dimension: has_due_time {
    type: yesno
  }

  dimension: is_comment_enabled {
    type: yesno
  }

  dimension: is_db_row_deleted {
    type: yesno
    hidden: yes
  }

  dimension: is_first_personal {
    type: yesno

  }

  dimension: is_last_personal {
    type: yesno

  }

  dimension: is_first_distributed {
    type: yesno

  }

  dimension: is_last_distributed {
    type: yesno

  }

  dimension: is_task_deleted {
    type: yesno
  }

  dimension: is_task_overdue {
    type: yesno
  }

  dimension: is_task_personal {
    type: yesno
  }

  dimension: task_assignee_count {
    type: number
    hidden: yes
  }

  dimension: task_attachments_count {
    type: number
    hidden: yes
  }

  dimension: task_body_character_count {
    type: number
    hidden: yes
  }

  dimension: task_body_word_count {
    type: number
    hidden: yes
  }

  dimension: task_id {
    type: string
    primary_key: yes
  }

  dimension: task_language {
    type: string
  }

  dimension: task_processing_time_min {
    type: number
    hidden: yes
  }

  dimension: task_times_updated_count {
    type: number
    hidden: yes
  }

  dimension: task_title { # should remain hidden per default, can be seen by CS in special cases
    type: string
    hidden: yes
  }

  dimension: tenant {
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

  #-------MANUALLY ADDED DIMENSIONS--------------------

  dimension: task_assignee_tier {
    type: tier
    sql: ${task_assignee_count} ;;
    tiers: [2,5,10,30,50,100]
    style: relational
  }

  dimension: due_days_tier {
    type: tier
    sql: ${due_days} ;;
    tiers: [2,7,31]
    style: relational

  }

  # --- MEASURES -------------------------------------------

  measure: count {
    type: count
    label: "# Tasks"
    description: "Count of unique task_ids."
  }

  measure: author_id_count_distinct {
    type: count_distinct
    sql: ${author_id} ;;
    label: "# Task Authors"
  }

  measure: task_assignee_count_sum {
    type: sum
    sql: ${task_assignee_count} ;;
    label: "# Task Assignees"
  }

  measure: task_assignee_count_avg {
    type: average
    sql: ${task_assignee_count} ;;
    label: "# Task Assignees (Avg)"
    value_format_name: decimal_1
  }

  measure: task_attachments_count_sum {
    type: sum
    sql: ${task_attachments_count} ;;
    label: "# Task Attachments"
  }

  measure: task_attachments_count_avg {
    type: average
    sql: ${task_attachments_count} ;;
    label: "# Task Attachments (Avg)"
    value_format_name: decimal_1
  }

  measure: task_body_character_count_sum {
    type: sum
    sql: ${task_body_character_count} ;;
    label: "# Task Body Characters"
  }

  measure: task_body_character_count_avg {
    type: average
    sql: ${task_body_character_count} ;;
    label: "# Task Body Characters (Avg)"
    value_format_name: decimal_1
  }

  measure: task_body_word_count_sum {
    type: sum
    sql: ${task_body_word_count} ;;
    label: "# Task Body Words"
  }

  measure: task_body_word_count_avg {
    type: average
    sql: ${task_body_word_count} ;;
    label: "# Task Body Words (Avg)"
    value_format_name: decimal_1
  }

  measure: task_times_updated_count_sum {
    type: sum
    sql: ${task_times_updated_count} ;;
    label: "# Task Updates"
  }

  measure: task_times_updated_count_avg {
    type: average
    sql: ${task_times_updated_count} ;;
    label: "# Task Updates (Avg)"
    value_format_name: decimal_1
  }

  measure: task_processing_time_min_sum {
    type: sum
    sql: ${task_processing_time_min} ;;
    label: "# Task Processing Time"
  }

  measure: task_processing_time_min_avg {
    type: average
    sql: ${task_processing_time_min} ;;
    label: "# Task Processing Time (Avg)"
    value_format_name: decimal_1
  }

}
