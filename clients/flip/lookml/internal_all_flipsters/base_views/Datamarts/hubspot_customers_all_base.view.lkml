view: hubspot_customers_all_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.hubspot_customers_all` ;;

  dimension: ae_name {
    type: string
    sql: ${TABLE}.ae_name ;;
  }
  dimension: automatic_contract_renewal {
    type: yesno
    sql: ${TABLE}.automatic_contract_renewal ;;
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

  dimension_group: contract_start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contract_start_date ;;
  }

  dimension_group: created_at_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at_timestamp ;;
  }
  dimension: cs_name {
    type: string
    sql: ${TABLE}.cs_name ;;
  }
  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }
  dimension: current_arr_euros {
    type: number
    sql: ${TABLE}.current_arr_euros ;;
  }
  dimension: current_arr_in_record_currency {
    type: number
    sql: ${TABLE}.current_arr_in_record_currency ;;
  }
  dimension: current_contract_term__in_months_ {
    type: number
    sql: ${TABLE}.current_contract_term__in_months_ ;;
  }
  dimension: dau_30d_avg {
    type: number
    sql: ${TABLE}.dau_30d_avg ;;
  }
  dimension: dau_onboarded {
    type: number
    sql: ${TABLE}.dau_onboarded ;;
  }

  dimension_group: domain_created {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.domain_created_date ;;
  }

  dimension: expansion_potential {
    type: number
    sql: ${TABLE}.expansion_potential ;;
  }
  dimension: fin_customer_group_id {
    type: string
    sql: ${TABLE}.fin_customer_group_id ;;
  }

  dimension: fin_customer_group_segment_investor {
    type: string
    sql: ${TABLE}.fin_customer_group_segment_investor ;;
  }

  dimension_group: go_live {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.go_live_date ;;
  }
  dimension: industry {
    type: string
    sql: ${TABLE}.industry ;;
  }
  dimension: industry_simplified_investors {
    type: string
    sql: ${TABLE}.industry_simplified_investors ;;
  }

  dimension: is_ai_assistant_user_groups_activated {
    type: yesno
    sql: ${TABLE}.is_ai_assistant_user_groups_activated ;;
  }
  dimension: is_ai_assistant_activated {
    type: yesno
    sql: ${TABLE}.is_ai_assistant_activated ;;
  }
  dimension: is_affected_by_zabbix_data_loss {
    type: yesno
    sql: ${TABLE}.is_affected_by_zabbix_data_loss ;;
  }
  dimension: is_company_licence {
    type: yesno
    sql: ${TABLE}.is_company_licence ;;
  }

  dimension_group: last_modified_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.last_modified_timestamp ;;
  }

  dimension: licence_activation_rate {
    type: number
    sql: ${TABLE}.licence_activation_rate ;;
  }
  dimension: licence_success_rate {
    type: number
    sql: ${TABLE}.licence_success_rate ;;
  }
  dimension: licence_success_rate_sold {
    type: number
    sql: ${TABLE}.licence_success_rate_sold ;;
  }
  dimension: licences_sold {
    type: number
    sql: ${TABLE}.licences_sold ;;
  }
  dimension: licences_sold_raw {
    type: number
    sql: ${TABLE}.licences_sold_raw ;;
  }
  dimension: licences_tenant_controller {
    type: number
    sql: ${TABLE}.licences_tenant_controller ;;
  }
  dimension: licences_tenant_controller_raw {
    type: number
    sql: ${TABLE}.licences_tenant_controller_raw ;;
  }
  dimension: life_cycle_stage {
    type: string
    sql: ${TABLE}.life_cycle_stage ;;
  }
  dimension: lifetime_net_retention_rate {
    type: number
    sql: ${TABLE}.lifetime_net_retention_rate ;;
  }
  dimension: mau_count {
    type: number
    sql: ${TABLE}.mau_count ;;
  }
  dimension: mau_onboarded {
    type: number
    sql: ${TABLE}.mau_onboarded ;;
  }
  dimension: new_logo_arr_euros {
    type: number
    sql: ${TABLE}.new_logo_arr_euros ;;
  }
  dimension: new_logo_arr_in_record_currency {
    type: number
    sql: ${TABLE}.new_logo_arr_in_record_currency ;;
  }
  dimension_group: newlogo_renewal {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.newlogo_renewal_date ;;
  }
  dimension_group: newlogo_signed {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.newlogo_signed_date ;;
  }
  dimension: number_of_associated_deals {
    type: number
    sql: ${TABLE}.number_of_associated_deals ;;
  }
  dimension: number_of_employees {
    type: number
    sql: ${TABLE}.number_of_employees ;;
  }
  dimension: onboarding_rate {
    type: number
    sql: ${TABLE}.onboarding_rate ;;
  }

  dimension: pricing_module {
    type: string
    sql: ${TABLE}.pricing_module ;;
  }
  dimension: pricing_package_estimated {
    type: string
    sql: ${TABLE}.pricing_package_estimated ;;
  }
  dimension_group: renewal_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.renewal_date ;;
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
  dimension_group: tenant_created {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.tenant_created_date ;;
  }
  dimension: tenant_level {
    type: string
    sql: ${TABLE}.tenant_level ;;
  }

  dimension: users_created_net {
    type: number
    sql: ${TABLE}.users_created_net ;;
  }
  dimension: users_onboarded_net {
    type: number
    sql: ${TABLE}.users_onboarded_net ;;
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
  dimension: vitally_overall_health_score {
    type: number
    sql: ${TABLE}.vitally_overall_health_score ;;
  }
  dimension: wau_count {
    type: number
    sql: ${TABLE}.wau_count ;;
  }
  dimension: wau_licence_rate {
    type: number
    sql: ${TABLE}.wau_licence_rate ;;
  }
  dimension: wau_onboarded {
    type: number
    sql: ${TABLE}.wau_onboarded ;;
  }
  dimension: zabbix_host_id {
    type: string
    sql: ${TABLE}.zabbix_host_id ;;
  }
  dimension: has_active_flows {
    type: yesno
    sql: ${TABLE}.has_active_flows ;;
  }
  measure: count {
    type: count
    drill_fields: [company_name, ae_name, cs_name]
  }
}
