view: cs_customer_lifecycle_thresholds_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.cs_customer_lifecycle_thresholds` ;;

  dimension: company_id {
    type: string
    sql: ${TABLE}.company_id ;;
  }
  dimension_group: contract_start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.contract_start_date ;;
  }
  dimension_group: current_journey_stage_last_entered_on_simple {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.current_journey_stage_last_entered_on_simple_date ;;
  }
  dimension: days_in_current_stage {
    type: number
    sql: ${TABLE}.days_in_current_stage ;;
  }
  dimension: days_in_stage_1 {
    type: number
    sql: ${TABLE}.days_in_stage_1 ;;
  }
  dimension: days_in_stage_2 {
    type: number
    sql: ${TABLE}.days_in_stage_2 ;;
  }
  dimension: days_in_stage_3 {
    type: number
    sql: ${TABLE}.days_in_stage_3 ;;
  }
  dimension: days_in_stage_4 {
    type: number
    sql: ${TABLE}.days_in_stage_4 ;;
  }
  dimension_group: end_of_first_stage4 {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.end_of_first_stage4_date ;;
  }
  dimension_group: first_1percent {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_1percent_date ;;
  }
  dimension_group: first_2percent_act_rate {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_2percent_act_rate_date ;;
  }
  dimension_group: first_30percent {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_30percent_date ;;
  }
  dimension_group: first_50percent {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_50percent_date ;;
  }
  dimension_group: first_5percent {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_5percent_date ;;
  }
  dimension_group: first_80percent {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_80percent_date ;;
  }
  dimension: has_ttfv {
    type: yesno
    sql: ${TABLE}.has_ttfv ;;
  }
  dimension: is_first_time_in_current_stage {
    type: yesno
    sql: ${TABLE}.is_first_time_in_current_stage ;;
  }
  dimension_group: newlogo_signed {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.newlogo_signed_date ;;
  }
  dimension: rank_by_recent_ttfv {
    type: number
    sql: ${TABLE}.rank_by_recent_ttfv ;;
  }
  dimension: time_to_first_value {
    type: number
    sql: ${TABLE}.time_to_first_value ;;
  }
  dimension: time_to_first_value_by_licences {
    type: number
    sql: ${TABLE}.time_to_first_value_by_licences ;;
  }
  dimension_group: vitally_app_handover {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.vitally_app_handover_date ;;
  }
  dimension: vitally_customer_journey_stage {
    type: string
    sql: ${TABLE}.vitally_customer_journey_stage ;;
  }
  measure: count {
    type: count
  }
}
