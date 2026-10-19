include: "/base_views/Datamarts/hubspot_engagement_emails_sales_base.view"

view: hubspot_engagement_emails_sales_ext {
  extends: [hubspot_engagement_emails_sales_base]

# ----- DIMENSIONS --------------------------------------------------------

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
    link: {
      label: "Open Contact in HubSpot"
      url: "https://app.hubspot.com/contacts/7401529/contact/{{ associated_contact_id }}"
      }
  }

  dimension_group: email {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  dimension: email_direction {
    type: string
  }

  dimension: email_id {
    type: string
    primary_key: yes
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/contact/{{ associated_contact_id }}/view/1?engagement={{ email_id }}"
    }
  }

  dimension: email_owner_name {
    type: string
  }

  dimension: email_owner_team {
    type: string
  }

  dimension: email_recipient {
    type: string
  }

  dimension: email_sender {
    type: string
  }

  dimension: email_status {
    type: string
  }

  dimension: email_subject {
    type: string
  }

  dimension: joining_key_date_owner {
    type: string
  }

# ----- MANUALLY ADDED DIMENSIONS ---------------------------------------

  dimension: email_sent_date_drilldown {
    type: string
    sql: ${email_date} ;;
    label: "Email Sent Date"
    hidden: yes
  }

  dimension: foreign_key_old_report {
    type: string
    sql: REPLACE(LOWER(CONCAT(${email_date},"_",${email_owner_name},"_",${email_owner_team}))," ","_") ;;
    hidden: yes
  }

# ----- MEASURES --------------------------------------------------------

  # measure: count {
  #   type: count
  #   drill_fields: [owner_name, user_name]
  #   hidden: yes
  # }

  measure: emails_sent_count {
    type: count_distinct
    sql: ${email_id} ;;
    filters: [email_status: "Sent", email_direction: "Email"]
    drill_fields: [email_sent_date_drilldown, email_id, associated_contact_id, associated_contact_name, associated_company_name, associated_company_segment]
    label: "Emails Sent"
  }

  measure: emails_failed_count {
    type: count_distinct
    sql: ${email_id} ;;
    filters: [email_status: "Failed", email_direction: "Email"]
    drill_fields: [email_sent_date_drilldown, email_id, associated_contact_id,associated_contact_name, associated_company_name, associated_company_segment]
    label: "Emails Failed"
  }

  measure: emails_bounced_count {
    type: count_distinct
    sql: ${email_id} ;;
    filters: [email_status: "Bounced", email_direction: "Email"]
    drill_fields: [email_sent_date_drilldown, email_id, associated_contact_id,associated_contact_name, associated_company_name, associated_company_segment]
    label: "Emails Bounced"
  }

  measure: emails_sending_count {
    type: count_distinct
    sql: ${email_id} ;;
    filters: [email_status: "Sending", email_direction: "Email"]
    drill_fields: [email_sent_date_drilldown, email_id, associated_contact_id,associated_contact_name, associated_company_name, associated_company_segment]
    label: "Emails Sending"
  }

# HubSpot Users can manually log emails in HubSpot, associating it to a company or contact. They could be either a sent or a received email
  measure: emails_logged_count {
    type: count_distinct
    sql: ${email_id} ;;
    filters: [email_status: "-Sent, -Failed, -Bounced, -Sending", email_direction: "Email"]
    drill_fields: [email_sent_date_drilldown, email_id, associated_contact_id,associated_contact_name, associated_company_name, associated_company_segment]
    label: "Emails Logged"
    description: "HubSpot Users can manually log emails in HubSpot, associating it to a company or contact. They could be either a sent or a received email."
  }

  measure: emails_total_count {
    type: count_distinct
    sql: ${email_id} ;;
    filters: [email_direction: "Email"]
    drill_fields: [email_sent_date_drilldown, email_id, email_sender, email_recipient, email_status, email_subject, associated_contact_id,associated_contact_name, associated_company_name, associated_company_segment]
    label: "Emails Total"
  }

}
