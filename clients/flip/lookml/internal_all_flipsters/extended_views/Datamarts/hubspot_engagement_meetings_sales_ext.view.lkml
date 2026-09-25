include: "/base_views/Datamarts/hubspot_engagement_meetings_sales_base.view"

view: hubspot_engagement_meetings_sales_ext {
  extends: [hubspot_engagement_meetings_sales_base]

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

  dimension_group: associated_deal_dmt_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  dimension: associated_deal_id {
    type: string
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/deal/{{ associated_deal_id }}"
    }
  }

  dimension: associated_deal_name {
    type: string
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/deal/{{ associated_deal_id }}"
    }
  }

  dimension: associated_deal_dmt_sao {
    type: string
    label: "Deal DMT SAO"
  }

  dimension: contact_source_channel_cluster_hubspot{
    type: string
  }

  dimension: contact_source_channel_inbound_vs_outbound_hubspot{
  type: string
}

  dimension: deal_source_channel {
    type: string
  }

  dimension: deal_source_channel_cluster_hubspot{
    type: string
  }

  dimension: is_meeting_created_after_associated_deal_in_sao {
    type: yesno
  }

  dimension: joining_key_date_owner {
    type: string
  }

  dimension: joining_key_create_date_owner {
    type: string
  }

  dimension: meeting_activity_type {
    type: string
  }

  dimension_group: meeting_create {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  dimension: meeting_duration_hours {
    type: number
  }

  dimension: meeting_id {
    type: string
    description: "Not the unique identifier of meetings - use Meeting Primary Key instead."
    # primary_key: yes -- semantically not the PK as some meetings are created twice w. diff. ids due to SL & MS integration
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/contact/{{ associated_contact_id }}/view/1?engagement={{ meeting_id }}"
    }
  }

  dimension: meeting_outcome {
    type: string
  }

  dimension: meeting_owner_name {
    type: string
  }

  dimension: meeting_owner_team {
    type: string
  }

  dimension: meeting_primary_key {
    type: string
    primary_key: yes
   }

  dimension_group: meeting {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }

  dimension: row_num {
    type: number
    hidden: yes
  }

# ----- MANUALLY ADDED DIMENSIONS -------------------------------------------------------------------------------------------------------------------------------

  dimension: meeting_date_drilldown {
    type: string
    sql: ${meeting_date} ;;
    label: "Meeting at Date"
    hidden: yes
  }

  dimension: foreign_key_old_report {
    type: string
    sql: REPLACE(LOWER(CONCAT(${meeting_date},"_",${meeting_owner_name},"_",${meeting_owner_team}))," ","_") ;;
    hidden: yes
  }

  dimension: create_date_drilldown {
    type: string
    sql: ${meeting_create_date} ;;
    label: "Meeting created at Date"
    hidden: yes
  }

  dimension: meeting_category {
    type: string
    sql: CASE
          WHEN ${meeting_activity_type} = "Qualification Call" THEN "initial meeting"
          WHEN ${meeting_activity_type} = "First Discovery Call" THEN "outbound"
          WHEN ${meeting_activity_type} = "Demo Call" THEN "inbound"
          WHEN ${meeting_activity_type} IN ("AE supporting BDR", "Value Proposition", "Fixed Phone Call", "Check-In/General Call", "Progression Call", "Negotiation Call")
          THEN "follow-up meetings"
          ELSE null END ;;
  }

  # dimension: inbound_outbound_bdr { # using HS source channel property instead
  #   type: string
  #   sql: CASE WHEN COALESCE(${deal_source_channel}, ${contact_source_channel}) IN ("bdr outbound") THEN "outbound" ELSE "inbound" END ;;
  #   description: "Distinction between BDR outbound and all other source channels as `inbound'. Takes Deal Source Channel over Contact Source Channel whenever available."
  # }

  # ----- MEASURES --------------------------------------------------------

  # measure: count {
  #   type: count
  #   drill_fields: [owner_name, user_name]
  #   hidden: yes
  # }

  measure: duration_min {
    type: sum_distinct
    sql_distinct_key: ${meeting_id} ;;
    sql: ${meeting_duration_hours}*60 ;;
    label: "Duration (min)"
    drill_fields: [meeting_date_drilldown, meeting_id, meeting_owner_name, meeting_owner_team, meeting_duration_hours, meeting_activity_type, meeting_outcome, associated_deal_name, associated_deal_dmt_sao, associated_company_name, associated_company_segment]
    value_format: "#0"
    hidden: yes
  }

}
