include: "/base_views/Datamarts/flip_page_user_assignments_unique_base.view"

view: flip_page_user_assignments_unique_ext {

  extends: [flip_page_user_assignments_unique_base]

# --- DIMENSIONS ------------------------------

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
    dimension: is_user_deleted {
      type: yesno
    }
    dimension: is_user_inactive {
      type: yesno
    }
    dimension: page_id {
      type: string
    }
    dimension: page_user_assignment_id {
      type: string
      primary_key: yes
    }
    dimension: role_id {
      type: string
    }
    dimension: source {
      type: string
    }
    dimension: tenant {
      type: string
    }
    dimension: user_id {
      type: string
    }

# --- MEASURES ------------------------------------------
    measure: count {
      type: count
      label: "# Page User Assignments"
    }

    measure: page_id_count_distict {
      type: count_distinct
      sql: ${page_id} ;;
      label: "# Pages"
    }

    measure: user_group_id_count_distict {
      type: count_distinct
      sql: ${user_id} ;;
      label: "# Users"
    }

  }
