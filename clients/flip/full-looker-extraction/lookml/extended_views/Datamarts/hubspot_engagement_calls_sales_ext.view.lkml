include: "/base_views/Datamarts/hubspot_engagement_calls_sales_base.view"

view: hubspot_engagement_calls_sales_ext {
  extends: [hubspot_engagement_calls_sales_base]

# ----- DIMENSIONS ----------------------------------------------------------------------------------------------------------------------------------------------

  dimension: associated_company_id {
    type: string
  }

  dimension: associated_company_name {
    type: string
  }

  dimension: associated_company_segment {
    type: string
  }

  dimension: associated_contact_id {
    type: string
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/contact/{{ associated_contact_id }}"
    }
  }

  dimension: associated_contact_name {
    type: string
  }

  dimension: call_activity_type {
    type: string
  }

  dimension: call_body {
    type: string
  }

  dimension_group: call_create {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  dimension: call_direction {
    type: string
  }

  dimension: call_duration_hours {
    type: number
  }

  dimension: call_from_number {
    type: string
  }

  dimension: call_id {
    type: string
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/contact/{{ associated_contact_id }}/view/1?engagement={{ call_id }}"
    }
    primary_key: yes
  }

  dimension: call_outcome {
    type: string
  }

  dimension: call_owner_name {
    type: string
  }

  dimension: call_owner_team {
    type: string
  }

  dimension: call_to_number {
    type: string
  }

  dimension: hs_call_callee_object_id {
    type: string
  }

  dimension: joining_key_date_owner {
    type: string
  }

  # ----- MANUALLY ADDED DIMENSIONS -----------------------------------------------------------------------------------------------------------------------------

  dimension: call_create_date_drilldown {
    type: string
    sql: ${call_create_date} ;;
    label: "Call Date"
    hidden: yes
  }

  dimension: foreign_key_old_report {
    type: string
    sql: REPLACE(LOWER(CONCAT(${call_create_date},"_",${call_owner_name},"_",${call_owner_team}))," ","_") ;;
    hidden: yes
  }

  # ----- MEASURES ----------------------------------------------------------------------------------------------------------------------------------------------

  # measure: count {
  #   type: count
  #   hidden: yes
  # }

  measure: duration_min {
    type: sum_distinct
    sql_distinct_key: ${call_id} ;;
    sql: ${call_duration_hours}*60 ;;
    label: "Call Duration (min)"
    value_format: "#0.0"
    hidden: yes
  }

  measure: calls_total_count {
    type: count_distinct
    sql: ${call_id} ;;
    drill_fields: [call_create_date_drilldown, call_id, call_owner_name, call_owner_team, call_activity_type, call_direction, call_outcome, duration_min, associated_contact_name, associated_company_name, associated_company_segment]
  }

  measure: calls_busy_count {
    type: count_distinct
    sql: ${call_id} ;;
    filters: [call_outcome: "Busy"]
    drill_fields: [call_create_date_drilldown, call_id, call_owner_name, call_owner_team, call_activity_type, call_direction, call_outcome, duration_min, associated_contact_name, associated_company_name, associated_company_segment]
  }

  measure: calls_left_voicemail_count {
    type: count_distinct
    sql: ${call_id} ;;
    filters: [call_outcome: "Left voicemail"]
    drill_fields: [call_create_date_drilldown, call_id, call_owner_name, call_owner_team, call_activity_type, call_direction, call_outcome, duration_min, associated_contact_name, associated_company_name, associated_company_segment]
  }

  measure: calls_left_livemessage_count {
    type: count_distinct
    sql: ${call_id} ;;
    filters: [call_outcome: "Left live message"]
    drill_fields: [call_create_date_drilldown, call_id, call_owner_name, call_owner_team, call_activity_type, call_direction, call_outcome, duration_min, associated_contact_name, associated_company_name, associated_company_segment]
  }

  measure: calls_connected_count {
    type: count_distinct
    sql: ${call_id} ;;
    filters: [call_outcome: "Connected"]
    drill_fields: [call_create_date_drilldown, call_id, call_owner_name, call_owner_team, call_activity_type, call_direction, call_outcome, duration_min, associated_contact_name, associated_company_name, associated_company_segment]
  }

  measure: calls_no_answer_count {
    type: count_distinct
    sql: ${call_id} ;;
    filters: [call_outcome: "No answer"]
    drill_fields: [call_create_date_drilldown, call_id, call_owner_name, call_owner_team, call_activity_type, call_direction, call_outcome, duration_min, associated_contact_name, associated_company_name, associated_company_segment]
  }

  measure: calls_wrong_number_count {
    type: count_distinct
    sql: ${call_id} ;;
    filters: [call_outcome: "Wrong number"]
    drill_fields: [call_create_date_drilldown, call_id, call_owner_name, call_owner_team, call_activity_type, call_direction, call_outcome, duration_min, associated_contact_name, associated_company_name, associated_company_segment]
  }

  measure: calls_missing_outcome_count {
    type: count_distinct
    sql: ${call_id} ;;
    filters: [call_outcome: "Missing Outcome"]
    drill_fields: [call_create_date_drilldown, call_id, call_owner_name, call_owner_team, call_activity_type, call_direction, call_outcome, duration_min, associated_contact_name, associated_company_name, associated_company_segment]
  }

  measure: calls_not_connected_count {
    type: count_distinct
    sql: ${call_id} ;;
    filters: [call_outcome: "-Connected"]
    drill_fields: [call_create_date_drilldown, call_id, call_owner_name, call_owner_team, call_activity_type, call_direction, call_outcome, duration_min, associated_contact_name, associated_company_name, associated_company_segment]
  }

  measure: duration_calls_connected_sum_hours {
    type: sum_distinct
    sql_distinct_key: ${call_id} ;;
    sql: ${call_duration_hours} ;;
    filters: [call_outcome: "Connected"]
    drill_fields: [call_create_date_drilldown, call_id, call_owner_name, call_owner_team, call_activity_type, call_direction, call_outcome, duration_min, associated_contact_name, associated_company_name, associated_company_segment]
    value_format: "#0.0"
  }

  measure: duration_calls_total_sum_hours {
    type: sum_distinct
    sql_distinct_key: ${call_id} ;;
    sql: ${call_duration_hours} ;;
    drill_fields: [call_create_date_drilldown, call_id, call_owner_name, call_owner_team, call_activity_type, call_direction, call_outcome, duration_min, associated_contact_name, associated_company_name, associated_company_segment]
    value_format: "#0.0"
  }

}
