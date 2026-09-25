view: rd_linear_issues_base {
  sql_table_name: `fl-bi-p-poc.source_google_sheets_poc.rd_linear_issues` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.ID ;;
  }
  dimension_group: archived {
    type: time
    description: "%m/%d/%Y %H:%M:%E*S"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.Archived ;;
  }
  dimension: assignee {
    type: string
    sql: ${TABLE}.Assignee ;;
  }
  dimension_group: canceled {
    type: time
    description: "%m/%d/%Y %H:%M:%E*S"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.Canceled ;;
  }
  dimension_group: completed {
    type: time
    description: "%m/%d/%Y %H:%M:%E*S"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.Completed ;;
  }
  dimension_group: created {
    type: time
    description: "%m/%d/%Y %H:%M:%E*S"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.Created ;;
  }
  dimension: creator {
    type: string
    sql: ${TABLE}.Creator ;;
  }
  dimension_group: cycle_end {
    type: time
    description: "%m/%d/%Y %H:%M:%E*S"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.Cycle_End ;;
  }
  dimension: cycle_name {
    type: string
    sql: ${TABLE}.Cycle_Name ;;
  }
  dimension: cycle_number {
    type: number
    sql: ${TABLE}.Cycle_Number ;;
  }
  dimension_group: cycle_start {
    type: time
    description: "%m/%d/%Y %H:%M:%E*S"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.Cycle_Start ;;
  }
  dimension: description {
    type: string
    sql: ${TABLE}.Description ;;
  }
  dimension_group: due {
    type: time
    description: "%m/%d/%E4Y"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Due_Date ;;
  }
  dimension: estimate {
    type: string
    sql: ${TABLE}.Estimate ;;
  }
  dimension: initiatives {
    type: string
    sql: ${TABLE}.Initiatives ;;
  }
  dimension: labels {
    type: string
    sql: ${TABLE}.Labels ;;
  }
  dimension: parent_issue {
    type: string
    sql: ${TABLE}.Parent_issue ;;
  }
  dimension: priority {
    type: string
    sql: ${TABLE}.Priority ;;
  }
  dimension: project {
    type: string
    sql: ${TABLE}.Project ;;
  }
  dimension: project_id {
    type: string
    sql: ${TABLE}.Project_ID ;;
  }
  dimension: project_milestone {
    type: string
    sql: ${TABLE}.Project_Milestone ;;
  }
  dimension: project_milestone_id {
    type: string
    sql: ${TABLE}.Project_Milestone_ID ;;
  }
  dimension: sla_status {
    type: string
    sql: ${TABLE}.SLA_Status ;;
  }
  dimension_group: started {
    type: time
    description: "%m/%d/%Y %H:%M:%E*S"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.Started ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.Status ;;
  }
  dimension: team {
    type: string
    sql: ${TABLE}.Team ;;
  }
  dimension: title {
    type: string
    sql: ${TABLE}.Title ;;
  }
  dimension_group: triaged {
    type: time
    description: "%m/%d/%Y %H:%M:%E*S"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.Triaged ;;
  }
  dimension_group: updated {
    type: time
    description: "%m/%d/%Y %H:%M:%E*S"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.Updated ;;
  }
  measure: count {
    type: count
    drill_fields: [id, cycle_name]
  }
}
