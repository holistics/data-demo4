include: "/base_views/Datamarts/hubspot_companies_all_base.view"

view: hubspot_companies_all_ext {
  extends: [hubspot_companies_all_base]

### -- DIMENSIONS -------------------------

  dimension_group: churn {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
  }

  dimension: company_id {
    type: string
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/company/{{ company_id }}"
    }
    primary_key: yes
  }

  dimension: company_name {
    type: string
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/company/{{ company_id }}"
    }
  }

  dimension: company_allocation {
    type: string
  }

  dimension_group: company_created_at_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }

  dimension: company_name_groups {
    type: string
  }

  dimension: company_partner_manager {
    type: string
  }

  dimension: company_region {
    type: string
  }

  dimension: cs_name {
    type: string
  }

  dimension: currency {
    type: string
  }
  dimension: current_contract_term__in_months_ {
    type: number
  }
  dimension_group: customer_start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: days_from_initial_meeting_to_sao {
    type: number
    hidden: yes
  }
  dimension: days_from_booked_meeting_to_scheduled {
    type: number
    hidden: yes
  }
  dimension_group: deal_new_logo_dmt_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  dimension_group: last_initial_meeting_booked_company {
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Last Initial Meeting booked (Company)"
  }
  dimension: last_initial_meeting_record_id {
    type: string
    label: "Last Initial Meeting Id"
  }
  dimension_group: last_initial_meeting_scheduled_company {
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Last Initial Meeting scheduled (Company)"
  }
  dimension: life_cycle_stage {
    type: string
  }

  dimension: number_of_associated_deals {
    type: string
  }
  dimension: number_of_employees {
    type: number
    hidden: yes
  }
  dimension: number_of_initial_meetings_company {
    type: number
    hidden: yes
  }
  dimension: number_of_licences {
    type: number
  }

  dimension: overall_health_score {
    type: number
  }

  dimension: partner_marker {
    type: string
  }

  dimension: region {
    type: string
  }
  dimension_group: renewal {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension_group: row_imported_at_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }

  dimension: scoped_licences {
    type: number
  }
  dimension: company_segment {
    type: string
  }

  dimension: support_level {
    type: string
  }
  dimension: tenant {
    type: string
  }
  dimension: territory_id {
    type: string
  }
  dimension_group: vitally_app_handover {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension_group: vitally_cse_kickoff {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: vitally_customer_journey_stage {
    type: string
  }
  dimension_group: vitally_kickoff {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: vitally_lifecycle {
    type: string
  }
  dimension: vitally_nps {
    type: number
  }

  dimension: workplace_partner {
    type: yesno
  }

  dimension: zip {
    type: zipcode
  }

# ----- MANUAL DIMENSIONS ----------

  dimension: is_initial_meeting_scheduled_within_28d {
    sql: CASE WHEN ${days_from_booked_meeting_to_scheduled} > 28 THEN false ELSE true END  ;;
  }
# ------- MEASURES ------------

  measure: count {
    type: count
    label: "# Companies"
    drill_fields: [company_id, company_name, company_allocation, last_initial_meeting_booked_company_date, last_initial_meeting_scheduled_company_date, last_initial_meeting_record_id]
  }

  measure: number_of_employees_sum {
    type: sum
    sql: CASE WHEN ${number_of_employees} > 25000 THEN 25000
              ELSE ${number_of_employees} END ;;
    label: "Number of Employees (capped)"
  }

  measure: number_of_initial_meetings_company_avg {
    type: average
    sql: ${number_of_initial_meetings_company} ;;
    value_format_name: decimal_0
    label: "# Initial Meetings (multiple per Company) avg"
    description: " If a lead didn't make any progress after six months (got cold), another meeting is considered a new initial meeting. "
    drill_fields: [company_id, company_allocation, days_from_initial_meeting_to_sao, last_initial_meeting_booked_company_date, deal_new_logo_dmt_sao_date, last_initial_meeting_record_id]
  }

  measure: last_initial_meeting_record_id_count { # 1:1 with company_id (PK) BUT Record ID is not always being filled yet. Work in progress with Louis 2025-06-20
    type: count_distinct
    sql: ${last_initial_meeting_record_id} ;;
    label: "# Initial Meetings (Company)"
    hidden: yes # see comment above
    drill_fields: [company_id, company_name, company_allocation, last_initial_meeting_record_id, last_initial_meeting_booked_company_date, last_initial_meeting_scheduled_company_date]
  }

  measure: days_from_initial_meeting_to_sao_avg {
    type: average
    sql: ${days_from_initial_meeting_to_sao}  ;;
    label: "# Days from initial Meeting to SAO (avg)"
    drill_fields: [company_id, company_allocation, days_from_initial_meeting_to_sao, last_initial_meeting_booked_company_date, deal_new_logo_dmt_sao_date, last_initial_meeting_record_id]
    value_format_name: decimal_0
  }

  measure: days_from_booked_meeting_to_scheduled_avg {
    type: average
    sql: ${days_from_booked_meeting_to_scheduled}  ;;
    label: "# Days from Booked Meeting to Scheduled (avg)"
    drill_fields: [company_id, company_allocation, days_from_booked_meeting_to_scheduled, last_initial_meeting_booked_company_date, last_initial_meeting_scheduled_company_date, last_initial_meeting_record_id]
    value_format_name: decimal_0
  }

  measure: days_from_booked_meeting_to_scheduled_median {
    type: median
    sql: ${days_from_booked_meeting_to_scheduled}  ;;
    label: "# Days from Booked Meeting to Scheduled (median)"
    drill_fields: [company_id, company_allocation, days_from_booked_meeting_to_scheduled, last_initial_meeting_booked_company_date, last_initial_meeting_scheduled_company_date, last_initial_meeting_record_id]
    value_format_name: decimal_0
  }

  measure: days_from_booked_meeting_to_scheduled_max {
    type: max
    sql: ${days_from_booked_meeting_to_scheduled}  ;;
    label: "# Days from Booked Meeting to Scheduled (max)"
    drill_fields: [company_id, company_allocation, days_from_booked_meeting_to_scheduled, last_initial_meeting_booked_company_date, last_initial_meeting_scheduled_company_date, last_initial_meeting_record_id]
    value_format_name: decimal_0
  }

}
