include: "/base_views/Datamarts/flip_task_assignees_unique_base.view"

view: flip_task_assignees_unique_ext {
  extends: [flip_task_assignees_unique_base]

  drill_fields: [task_assignee_id, created_timestamp_date, tenant, is_task_assignee_deleted]

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

  dimension: id {
    type: string
    hidden: yes
  }

  dimension: is_db_row_deleted {
    type: yesno
    hidden: yes
  }

  dimension: is_task_assignee_deleted {
    type: yesno

  }

  dimension: is_user_inactive {
    type: yesno

  }

  dimension: status {
    type: string

  }

  dimension: task_assignee_id {
    type: string
    primary_key: yes
  }

  dimension: task_assigned_to_personal_id {
    type: string
  }

  dimension: task_assigneed_to_user_id {
    type: string
  }

  dimension: task_id {
    type: string

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

  dimension: user_id {
    type: string

  }

#-------------MANUALLY ADDED DIMENSIONS------------------------------

#-------------MEASURES-------------------------------------------

  measure: count {
    type: count
    label: "# Task Assignees"
    description: "Count of unique task_assignee_ids."
  }

  measure: task_assined_to_personal_count {
    type: count_distinct
    sql: ${task_assigned_to_personal_id} ;;
    label: "# Tasks Assigned to Personal"
  }

  measure: task_assineed_to_user_count {
    type: count_distinct
    sql: ${task_assigneed_to_user_id} ;;
    label: "# Tasks Assigned to User"
  }

  measure: author_count_distinct {
    type: count_distinct
    sql: ${author_id} ;;
    label: "# Authors"
    description: "Count of unique author_ids."
  }

  measure: new_task_count {
    type: count
    label: "# Tasks new (per Assignee)"
    filters: [status: "NEW"]
    description: "Count of unique status where status is NEW."
  }

  measure: open_task_count {
    type: count
    label: "# Tasks open (per Assignee)"
    filters: [status: "OPEN"]
    description: "Count of unique status where status is OPEN."
  }

  measure: Finished_task_count {
    type: count
    label: "# Tasks finished (per Assignee)"
    filters: [status: "FINISHED"]
    description: "Count of unique status where status is FINISHED."
  }
}
