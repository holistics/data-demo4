include: "/base_views/Google_Sheets/rd_linear_issues_base.view"

view: rd_linear_issues_ext {
  extends: [rd_linear_issues_base]

# --- DIMENSIONS -------------

    dimension: id {
      primary_key: yes
      type: string
    }
    dimension_group: archived {
      type: time
      description: "%m/%d/%Y %H:%M:%E*S"
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension: assignee {
      type: string
    }
    dimension_group: canceled {
      type: time
      description: "%m/%d/%Y %H:%M:%E*S"
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: completed {
      type: time
      description: "%m/%d/%Y %H:%M:%E*S"
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: created {
      type: time
      description: "%m/%d/%Y %H:%M:%E*S"
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension: creator {
      type: string
    }
    dimension_group: cycle_end {
      type: time
      description: "%m/%d/%Y %H:%M:%E*S"
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension: cycle_name {
      type: string
    }
    dimension: cycle_number {
      type: number
    }
    dimension_group: cycle_start {
      type: time
      description: "%m/%d/%Y %H:%M:%E*S"
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension: description {
      type: string
    }
    dimension_group: due {
      type: time
      description: "%m/%d/%E4Y"
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension: estimate {
      type: string
    }
    dimension: initiatives {
      type: string
    }
    dimension: labels {
      type: string
    }
    dimension: parent_issue {
      type: string
    }
    dimension: priority {
      type: string
    }
    dimension: project {
      type: string
    }
    dimension: project_id {
      type: string
    }
    dimension: project_milestone {
      type: string
    }
    dimension: project_milestone_id {
      type: string
    }
    dimension: sla_status {
      type: string
    }
    dimension_group: started {
      type: time
      description: "%m/%d/%Y %H:%M:%E*S"
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension: status {
      type: string
    }
    dimension: team {
      type: string
    }
    dimension: title {
      type: string
    }
    dimension_group: triaged {
      type: time
      description: "%m/%d/%Y %H:%M:%E*S"
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: updated {
      type: time
      description: "%m/%d/%Y %H:%M:%E*S"
      timeframes: [raw, time, date, week, month, quarter, year]
    }

# --- MANUAL DIMENSIONS -----------------------------------

  dimension: started_date_yesterday_vs_30d_ago {
    type: yesno
    sql: DATE_DIFF(current_date(), ${started_date},  DAY) IN (1,31)  ;;
    label: "Started Date: yesterday vs 30d ago"
  }

  dimension: started_date_yesterday_vs_14d_ago {
    type: yesno
    sql: DATE_DIFF(current_date(), ${started_date},  DAY) IN (1,15)  ;;
    label: "Started Date: yesterday vs 14d ago"
  }

  dimension: completed_date_yesterday_vs_30d_ago {
    type: yesno
    sql: DATE_DIFF(current_date(), ${completed_date},  DAY) IN (1,31)  ;;
    label: "Completed Date: yesterday vs 30d ago"
  }

  dimension: completed_date_yesterday_vs_14d_ago {
    type: yesno
    sql: DATE_DIFF(current_date(), ${completed_date},  DAY) IN (1,15)  ;;
    label: "Completed Date: yesterday vs 14d ago"
  }

  dimension: is_ticket_open {
    type:  yesno
    sql:  CASE WHEN ${created_raw} IS NOT NULL AND ${completed_raw} IS NULL AND ${canceled_raw} IS NULL AND ${archived_raw} IS NULL THEN true ELSE false END ;;
  }

  dimension: is_design_ticket {
    type: yesno
    sql: CASE WHEN ${labels} LIKE '%Design%' THEN true ELSE false END ;;
    description: "Flag to filter out design tickets"
  }

  dimension: is_cycle_time_below_24h {
    type: yesno
    sql: CASE WHEN DATE_DIFF(${completed_raw},${started_raw}, HOUR) < 24 THEN true ELSE false END ;;
    description: "Flag to filter tickets completed below 24 hours"
  }

  # --- MEASURES
    measure: count {
      type: count
      drill_fields: [id, cycle_name]
      label: "# Tickets"
    }

  measure: cycle_time_avg_h {
    type: average
    sql: DATE_DIFF(${completed_raw},${started_raw}, HOUR) ;;
    value_format_name: decimal_1
    label: "Cycle Time in h (avg)"
    description: "Cycle time indicates how long a ticket is worked on (started -> completed), measured in hours."
  }

  measure: cycle_time_median_h {
    type: median
    sql: DATE_DIFF(${completed_raw},${started_raw}, HOUR) ;;
    value_format_name: decimal_1
    label: "Cycle Time in h (median)"
    description: "Cycle time indicates how long a ticket is worked on (started -> completed), measured in hours."
  }

  measure: cycle_time_percentile_h {
    type: percentile
    percentile: 95
    sql: DATE_DIFF(${completed_raw},${started_raw}, HOUR) ;;
    value_format_name: decimal_1
    label: "Cycle Time in h (percentile)"
    description: "Cycle time indicates how long a ticket is worked on (started -> completed), measured in hours."
  }

  measure: cycle_time_avg_d {
    type: average
    sql: DATE_DIFF(${completed_raw},${started_raw}, DAY) ;;
    value_format_name: decimal_1
    label: "Cycle Time in d (avg)"
    description: "Cycle time indicates how long a ticket is worked on (started -> completed), measured in days (24h)."
  }

    measure: processing_time_avg {
      type: average
      sql: DATE_DIFF(${completed_raw},${created_raw}, HOUR);;
      value_format_name: decimal_1
      description: "Processing time from ticket creation to ticket completion measured in hours."
    }

    measure: processing_time_sum {
      type: sum
      sql: DATE_DIFF(${completed_raw},${created_raw}, HOUR);;
      description: "Processing time from ticket creation to ticket completion measured in hours."
    }

    measure: triage_time_avg {
      type: average
      sql: DATE_DIFF(${triaged_raw}_raw},${created_raw}, HOUR);;
      value_format_name: decimal_1
      description: "Processing time from ticket creation to ticket triage measured in hours."
    }

    measure: triage_time_sum {
      type: sum
      sql: DATE_DIFF(${triaged_raw},${created_raw}, HOUR);;
      description: "Processing time from ticket creation to ticket triage measured in hours."
    }

    measure: bugs_sum {
      type: sum
      sql: CASE WHEN ${labels} LIKE '%Bug%' THEN 1 ELSE 0 END;;
      label: "# Bug Tickets"
    }
  }
