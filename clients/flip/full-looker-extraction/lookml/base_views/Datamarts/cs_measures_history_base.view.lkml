view: cs_measures_history_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.cs_measures_history` ;;

  dimension: company_id {
    type: string
    sql: ${TABLE}.company_id ;;
  }
  dimension_group: date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }
  dimension: licences_sold {
    type: number
    sql: ${TABLE}.licences_sold ;;
  }
  dimension: licences_tenant_controller {
    type: number
    sql: ${TABLE}.licences_tenant_controller ;;
  }
  dimension: overall_health_score {
    type: number
    sql: ${TABLE}.overall_health_score ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  dimension: scoped_licences {
    type: number
    sql: ${TABLE}.scoped_licences ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension: users_created_net {
    type: number
    sql: ${TABLE}.users_created_net ;;
  }
  dimension: users_onboarded_net {
    type: number
    sql: ${TABLE}.users_onboarded_net ;;
  }
  dimension: vitally_customer_journey_stage {
    type: string
    sql: ${TABLE}.vitally_customer_journey_stage ;;
  }
  dimension: vitally_customer_journey_stage_number {
    type: string
    sql: ${TABLE}.vitally_customer_journey_stage_number ;;
  }
  dimension: vitally_customer_journey_stage_number_yesterday {
    type: string
    sql: ${TABLE}.vitally_customer_journey_stage_number_yesterday ;;
  }
  dimension: vitally_customer_journey_switch {
    type: string
    sql: ${TABLE}.vitally_customer_journey_switch ;;
  }
  dimension: vitally_customer_journey_switch_order {
    type: number
    sql: ${TABLE}.vitally_customer_journey_switch_order ;;
  }
  dimension: vitally_nps {
    type: number
    sql: ${TABLE}.vitally_nps ;;
  }
  measure: count {
    type: count
  }
}
