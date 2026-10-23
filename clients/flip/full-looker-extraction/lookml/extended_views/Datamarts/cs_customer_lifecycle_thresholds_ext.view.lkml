include: "/base_views/Datamarts/cs_customer_lifecycle_thresholds_base.view"

view: cs_customer_lifecycle_thresholds_ext {
    extends: [cs_customer_lifecycle_thresholds_base]

  drill_fields: []
# test comment
# --- DRILL FIELDS -------------------------------
    dimension: company_id {
      type: string
      primary_key: yes
      hidden: yes # only used in combination with customers datamart so duplicate
    }

  dimension_group: contract_start {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

    dimension_group: current_journey_stage_last_entered_on_simple {
      type: time
      timeframes: [
        raw,
        date,
        week,
        month,
        quarter,
        year
      ]
      convert_tz: no
      datatype: date
    }

  dimension: days_in_current_stage {
    type: number
    hidden: yes
  }

    dimension: days_in_stage_1 {
      type: number
      hidden: yes
    }

    dimension: days_in_stage_2 {
      type: number
      hidden: yes
    }

    dimension: days_in_stage_3 {
      type: number
      hidden: yes
    }

    dimension: days_in_stage_4 {
      type: number
      hidden: yes
    }

    dimension_group: end_of_first_stage4 {
      type: time
      timeframes: [
        raw,
        date,
        week,
        month,
        quarter,
        year
      ]
      convert_tz: no
      datatype: date
    }

  dimension_group: first_1percent {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: first_2percent_act_rate {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

    dimension_group: first_5percent {
      type: time
      timeframes: [
        raw,
        date,
        week,
        month,
        quarter,
        year
      ]
      convert_tz: no
      datatype: date
    }

  dimension_group: first_30percent {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension_group: first_50percent {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

    dimension_group: first_80percent {
      type: time
      timeframes: [
        raw,
        date,
        week,
        month,
        quarter,
        year
      ]
      convert_tz: no
      datatype: date
    }

  dimension: has_ttfv {
    type: yesno
  }

    dimension: is_first_time_in_current_stage {
      type: yesno
    }

  dimension_group: newlogo_signed {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  dimension: rank_by_recent_ttfv {
    type: number
  }

  dimension: time_to_first_value {
    type: number
  }

  dimension_group: vitally_app_handover {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    hidden: yes # only used in combination with customers datamart so duplicate
  }

  dimension: vitally_customer_journey_stage {
    type: string
    hidden: yes # only used in combination with customers datamart so duplicate
  }

  # --- MEASURES -------------------------
    measure: count {
      type: count
      drill_fields: []
    }

    measure: days_in_stage_1_avg {
      type: average
      sql: ${days_in_stage_1} ;;
      value_format_name: decimal_0
    }

  measure: days_in_stage_2_avg {
    type: average
    sql: ${days_in_stage_2} ;;
    value_format_name: decimal_0
  }

  measure: days_in_stage_3_avg {
    type: average
    sql: ${days_in_stage_3} ;;
    value_format_name: decimal_0
  }

  measure: days_in_stage_4_avg {
    type: average
    sql: ${days_in_stage_4} ;;
    value_format_name: decimal_0
  }

  measure: days_in_current_stage_avg {
    type: average
    sql: ${days_in_current_stage} ;;
    value_format_name: decimal_0
  }

  measure: time_to_first_value_old { # Hannes new 22.5.23 // not used anymore
    type: average
    sql: CASE WHEN ${first_5percent_date} = "2022-04-27" THEN null ELSE DATE_DIFF(${first_5percent_date}, ${newlogo_signed_date}, DAY) END;;
    value_format_name: decimal_0
    label: "TTFV (OLD)"
    hidden: yes
    description: "Time from signed Contract to Customer hits the LSR 5% mark (for the first time). Defined with Hannes in May '23. For customers affected by Zabbix Data Loss (first 5% date = 27.4.22) the TTFV can't be computed as we're lacking information."
  }

  measure: time_to_first_value_average { # used from March 2024 on for both R&D & CS (Luke & Mathis) - not weighted, simple date diff
    type: average
    sql: ${time_to_first_value};;
    value_format_name: decimal_0
    label: "TTFV (unweighted)"
    description: "Time from Contract Start to Customer hits the LSR 5% mark (for the first time). For customers affected by Zabbix Data Loss (first 5% date = 27.4.22) the TTFV can't be computed as we're lacking information."
  }

  measure: time_to_first_value_by_licences_average { # weighted by lic. sold / used from March 2024 on for both R&D & CS (Luke & Mathis)
    type: average
    sql: ${time_to_first_value_by_licences};;
    value_format_name: decimal_0
    label: "TTFV by Licences (Sold)"
    description: "Time from Contract Start to Customer hits the LSR 5% mark (for the first time). For customers affected by Zabbix Data Loss (first 5% date = 27.4.22) the TTFV can't be computed as we're lacking information."
  }

  measure: time_to_first_value_by_licences_sum { # weighted by lic. sold / used from March 2024 on for both R&D & CS (Luke & Mathis)
    type: sum
    sql: ${time_to_first_value_by_licences};;
    value_format_name: decimal_0
    label: "TTFV by Licences (Sold)sum"
    description: "Time from Contract Start to Customer hits the LSR 5% mark (for the first time). For customers affected by Zabbix Data Loss (first 5% date = 27.4.22) the TTFV can't be computed as we're lacking information."
  }

  set: all_flipster_relevant {
    fields: [has_ttfv, rank_by_recent_ttfv, time_to_first_value_average, time_to_first_value_by_licences_average, time_to_first_value_by_licences_sum,
      first_5percent_date, days_in_stage_1_avg, days_in_stage_2_avg, days_in_stage_3_avg, days_in_stage_4_avg, days_in_current_stage_avg]
  }
  }
