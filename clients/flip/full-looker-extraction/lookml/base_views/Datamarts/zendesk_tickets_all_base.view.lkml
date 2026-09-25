view: zendesk_tickets_all_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.zendesk_tickets_all` ;;

  dimension: assignee_name {
    type: string
    sql: ${TABLE}.assignee_name ;;
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
    sql: ${TABLE}.created_timestamp ;;
  }

  dimension: cs_name {
    type: string
    sql: ${TABLE}.cs_name ;;
  }

  dimension_group: company_go_live {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      day_of_week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.company_go_live_date ;;
  }

  dimension: hours_to_solved {
    type: number
    sql: ${TABLE}.hours_to_solved ;;
  }

  dimension: hubspot_id {
    type: string
    sql: ${TABLE}.hubspot_id ;;
  }

  dimension: is_reopened {
    type: yesno
    sql: ${TABLE}.is_reopened ;;
  }

  dimension_group: last_event_timestamp {
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
    sql: ${TABLE}.last_event_timestamp ;;
  }

  dimension_group: last_updated_timestamp {
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
    sql: ${TABLE}.last_updated_timestamp ;;
  }

  dimension_group: new_timestamp {
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
    sql: ${TABLE}.new_timestamp ;;
  }

  dimension: organization_id {
    type: string
    sql: ${TABLE}.organization_id ;;
  }

  dimension: organization_name {
    type: string
    sql: ${TABLE}.organization_name ;;
  }

  dimension: requester_id {
    type: string
    sql: ${TABLE}.requester_id ;;
  }

  dimension: satisfaction_rating_comment {
    type: string
    sql: ${TABLE}.satisfaction_rating_comment ;;
  }

  dimension: satisfaction_rating_score {
    type: string
    sql: ${TABLE}.satisfaction_rating_score ;;
  }

  dimension_group: solved_timestamp {
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
    sql: ${TABLE}.solved_timestamp ;;
  }

  dimension: submitter_id {
    type: string
    sql: ${TABLE}.submitter_id ;;
  }

  dimension: tenant_id {
    type: string
    sql: ${TABLE}.tenant_id ;;
  }

  dimension: ticket_category {
    type: string
    sql: ${TABLE}.ticket_category ;;
  }

  dimension: ticket_form_type {
    type: string
    sql: ${TABLE}.ticket_form_type ;;
  }

  dimension: ticket_id {
    type: string
    sql: ${TABLE}.ticket_id ;;
  }

  dimension: ticket_priority {
    type: string
    sql: ${TABLE}.ticket_priority ;;
  }

  dimension: ticket_status {
    type: string
    sql: ${TABLE}.ticket_status ;;
  }

  dimension: ticket_status_current {
    type: string
    sql: ${TABLE}.ticket_status_current ;;
  }

  dimension: ticket_status_previous {
    type: string
    sql: ${TABLE}.ticket_status_previous ;;
  }

  dimension: ticket_submission_channel {
    type: string
    sql: ${TABLE}.ticket_submission_channel ;;
  }

  dimension: ticket_topic {
    type: string
    sql: ${TABLE}.ticket_topic ;;
  }

  dimension: ticket_url {
    type: string
    sql: ${TABLE}.ticket_url ;;
  }

  dimension: user_browser {
    type: string
    sql: ${TABLE}.user_browser ;;
  }

  dimension: user_device {
    type: string
    sql: ${TABLE}.user_device ;;
  }

  dimension: user_os {
    type: string
    sql: ${TABLE}.user_os ;;
  }

  dimension: user_type {
    type: string
    sql: ${TABLE}.user_type ;;
  }

  measure: count {
    type: count
    drill_fields: [cs_name, assignee_name, organization_name]
  }
}
