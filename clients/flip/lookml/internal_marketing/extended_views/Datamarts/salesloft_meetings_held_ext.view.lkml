include: "/base_views/Datamarts/salesloft_meetings_held_base.view"

view: salesloft_meetings_held_ext {
  extends: [salesloft_meetings_held_base]

# ----- ORIGINAL DIMENSIONS ---------------------------------------------------------------------------------------------------------------------------------------

  dimension: foreign_key_date_name {
    type: string
  }
  dimension: hs_meeting_activity_type {
    type: string
  }
  dimension: hs_associated_company_id {
    type: string
  }
  dimension: hs_associated_company_name {
    type: string
    label: "Associated Company"
  }
  dimension: hs_associated_company_segment {
    type: string
    label: "Associated Company Segment"
  }
  dimension: hs_associated_contact_id {
    type: string
  }

  dimension_group: hs_associated_deal_dmt_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: hs_associated_deal_id {
    type: string
  }
  dimension: hs_associated_deal_name {
    type: string
    label: "Associated Deal"
  }

  dimension: hs_meeting_held_id {
    type: string
  }

  dimension: hs_meeting_outcome {
    type: string
  }
  dimension: hs_meeting_owner_team {
    type: string
    label: "Meeting Owner"
  }
  dimension_group: sl_canceled_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension_group: sl_created_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension: sl_created_via {
    type: string
    label: "Created via"
  }
  dimension_group: sl_ended_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension_group: sl_imported_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension: sl_meeting_duration_min {
    type: number
    label: "Meeting Duration (min)"
  }
  dimension: sl_meeting_held_id {
    type: string
    primary_key: yes
  }
  dimension: sl_meeting_owner {
    type: string
    label: "User Name"
  }

  dimension_group: sl_occurred_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension_group: sl_pinned_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension_group: sl_started_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    label: "Started at Berlin"
  }
  dimension_group: sl_updated_at_berlin_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }

# ----- MANUALLY CREATED DIMENSIONS -------------------------------------------------------------------------------------------------------------------------------

  dimension: hs_meeting_category {
    type: string
    sql: CASE
          WHEN ${hs_meeting_activity_type} = "Qualification Call" THEN "initial meeting"
          WHEN ${hs_meeting_activity_type} = "First Discovery Call" THEN "outbound"
          WHEN ${hs_meeting_activity_type} = "Demo Call" THEN "inbound"
          WHEN ${hs_meeting_activity_type} IN ("AE supporting BDR", "Value Proposition", "Fixed Phone Call", "Check-In/General Call", "Progression Call", "Negotiation Call")
          THEN "follow-up meetings"
          ELSE null END ;;
  }

# ----- MEASURES --------------------------------------------------------------------------------------------------------------------------------------------------

  measure: count {
    type: count
    hidden: yes
  }

  # sum_distinct because of the join many_to_many performed in the internal_marketing model
  measure: meetings_held_count {
    type: count
    filters: [sl_meeting_held_id: "-NULL"]
    description: "Count of Meetings Held - Meetings that SL was able to identify that they took place"
    label: "# Meetings Held"
    drill_fields: [sl_started_at_berlin_timestamp_time, sl_meeting_owner, sl_meeting_duration_min, sl_created_via, hs_associated_company_name, hs_associated_company_segment, hs_associated_deal_name]
  }

}
