include: "/base_views/Datamarts/flip_post_comment_reports_unique_base.view"

view: flip_post_comment_reports_unique_ext {

  extends: [flip_post_comment_reports_unique_base]

    dimension: channel_id {
      type: string
    }

    dimension: comment_author_id {
      type: string
    }

    dimension: comment_id {
      type: string
    }

    dimension: comment_report_id {
      type: string
      primary_key: yes
    }

    dimension_group: created_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }

    dimension_group: created_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }

    dimension_group: db_row_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }

    dimension: is_db_row_deleted {
      type: yesno
    }

    dimension: post_id {
      type: string
    }

    dimension: reporter_id {
      type: string
    }

    dimension: tenant {
      type: string
    }

  # --- MEASURES --------------

    measure: count {
      type: count
      label: "# Comment Reports"
    }

    measure: reporter_id_count {
      type: count_distinct
      sql: ${reporter_id} ;;
      label: "# Reporters"
    }

  measure: post_id_count {
    type: count_distinct
    sql: ${post_id} ;;
    label: "# Posts with Comment Reports"
  }

  measure: channel_id_count {
    type: count_distinct
    sql: ${channel_id} ;;
    label: "# Channels with Comment Reports"
  }

  measure: tenant_count {
    type: count_distinct
    sql: ${tenant} ;;
    label: "# Tenants with Comment Reports"
  }
  }
