include: "/base_views/Datamarts/flip_user_group_assignments_unique_base.view"

view: flip_user_group_assignments_unique_ext {

  extends: [flip_user_group_assignments_unique_base]

# ----- DIMENSIONS ------------------------
    dimension: assignment_source {
      type: string
    }
    dimension_group: created_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: created_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }
    dimension_group: db_row_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: db_row_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }
    dimension: is_db_row_deleted {
      type: yesno
    }
    dimension: role_id {
      type: string
    }
    dimension: tenant {
      type: string
    }
    dimension_group: updated_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: updated_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }
    dimension: user_group_assignment_id {
      type: string
      primary_key: yes
    }
    dimension: user_group_id {
      type: string
    }
    dimension: user_id {
      type: string
      hidden: yes
    }

# ----- MEASURES ------------------
    measure: count {
      type: count
      label: "# User Group Assignments"
    }
  }
