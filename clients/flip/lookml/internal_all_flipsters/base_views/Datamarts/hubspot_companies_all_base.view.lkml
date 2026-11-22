view: hubspot_companies_all_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.hubspot_companies_all` ;;

  dimension: automatic_contract_renewal {
    type: yesno
    sql: ${TABLE}.automatic_contract_renewal ;;
  }
  dimension: bombora_intent_score {
    type: string
    sql: ${TABLE}.bombora_intent_score ;;
  }

  dimension_group: churn {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.churn_date ;;
  }

  dimension: company_allocation {
    type: string
    sql: ${TABLE}.company_allocation ;;
  }

  dimension_group: company_created_at_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.company_created_at_timestamp ;;
  }

  dimension: company_id {
    type: string
    sql: ${TABLE}.company_id ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
  }
  dimension: company_name_groups {
    type: string
    sql: ${TABLE}.company_name_groups ;;
  }

  dimension: company_partner_manager {
    type: string
    sql: ${TABLE}.company_partner_manager ;;
  }

  dimension: company_region {
    type: string
    sql: ${TABLE}.company_region ;;
  }

  dimension: cs_name {
    type: string
    sql: ${TABLE}.cs_name ;;
  }
  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }
  dimension: current_contract_term__in_months_ {
    type: number
    sql: ${TABLE}.current_contract_term__in_months_ ;;
  }
  dimension_group: customer_start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.customer_start_date ;;
  }
  dimension: days_from_initial_meeting_to_sao {
    type: number
    sql: ${TABLE}.days_from_initial_meeting_to_sao;;
  }
  dimension: days_from_booked_meeting_to_scheduled {
    type: number
    sql: ${TABLE}.days_from_booked_meeting_to_scheduled;;
  }
  dimension_group: deal_new_logo_dmt_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.deal_new_logo_dmt_sao ;;
  }

  dimension_group: go_live {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.go_live_date ;;
  }
  dimension: has_sales_nav_buyer_intent {
    type: yesno
    sql: ${TABLE}.has_sales_nav_buyer_intent ;;
  }
  dimension: industry {
    type: string
    sql: ${TABLE}.industry ;;
  }

  dimension: is_signed_partner {
    type: string
    sql: ${TABLE}.is_signed_partner ;;
  }
  dimension: is_tam {
    type: yesno
    sql: ${TABLE}.is_tam ;;
  }
  dimension: is_target_account {
    type: yesno
    sql: ${TABLE}.is_target_account ;;
  }
  dimension_group: last_activity {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_activity_date ;;
  }
  dimension_group: last_contacted {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_contacted_date ;;
  }
  dimension_group: last_engagement {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_engagement_date ;;
  }
  dimension_group: last_initial_meeting_booked_company {
    type: time
    datatype: date
    sql: ${TABLE}.last_initial_meeting_booked_company_date ;;
    timeframes: [raw, date, week, month, quarter, year]
  }
  dimension: last_initial_meeting_record_id {
    type: string
    sql: ${TABLE}.last_initial_meeting_record_id ;;
  }
  dimension_group: last_initial_meeting_scheduled_company {
    type: time
    datatype: date
    sql: ${TABLE}.last_initial_meeting_scheduled_company_date ;;
    timeframes: [raw, date, week, month, quarter, year]
  }
  dimension_group: last_modified_date_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.last_modified_date_timestamp ;;
  }
  dimension: life_cycle_stage {
    type: string
    sql: ${TABLE}.life_cycle_stage ;;
  }

  dimension: number_of_associated_deals {
    type: string
    sql: ${TABLE}.number_of_associated_deals ;;
  }
  dimension: number_of_employees {
    type: number
    sql: ${TABLE}.number_of_employees ;;
  }
  dimension: number_of_initial_meetings_company {
    type: number
    sql: ${TABLE}.number_of_initial_meetings_company ;;
  }
  dimension: number_of_licences {
    type: number
    sql: ${TABLE}.number_of_licences ;;
  }

  dimension: overall_health_score {
    type: number
    sql: ${TABLE}.overall_health_score ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }
  dimension_group: renewal {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.renewal_date ;;
  }
  dimension_group: row_imported_at_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.row_imported_at_timestamp ;;
  }

  dimension: scoped_licences {
    type: number
    sql: ${TABLE}.scoped_licences ;;
  }
  dimension: company_segment {
    type: string
    sql: ${TABLE}.company_segment ;;
  }

  dimension: support_level {
    type: string
    sql: ${TABLE}.support_level ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension: territory_id {
    type: string
    sql: ${TABLE}.territory_id ;;
  }
  dimension_group: vitally_app_handover {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.vitally_app_handover_date ;;
  }
  dimension_group: vitally_cse_kickoff {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.vitally_cse_kickoff_date ;;
  }
  dimension: vitally_customer_journey_stage {
    type: string
    sql: ${TABLE}.vitally_customer_journey_stage ;;
  }
  dimension_group: vitally_kickoff {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.vitally_kickoff_date ;;
  }
  dimension: vitally_lifecycle {
    type: string
    sql: ${TABLE}.vitally_lifecycle ;;
  }
  dimension: vitally_nps {
    type: number
    sql: ${TABLE}.vitally_nps ;;
  }

  dimension: workplace_partner {
    type: yesno
    sql: ${TABLE}.workplace_partner ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }
  measure: count {
    type: count
    drill_fields: [company_name, cs_name]
  }
}
