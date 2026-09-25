include: "/base_views/Reports/sales_aes_monthly_base.view"

view: sales_aes_monthly_ext {

  extends: [sales_aes_monthly_base]

# ------ BASE DIMENSIONS ----------------------------------------------------------------------------------------------

dimension: added_arr_running_sum_euros {
  type: number
}

dimension: ae_name {
  type: string
  label: "AE Name"
}

dimension_group: ae_start {
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
  label: "AE Start"
}
dimension: ae_team { # team name from google sheet
  type: string
  label: "AE Team"
}

dimension: ae_territory_id {
  type: string
  label: "Territory ID"
}

dimension_group: calendar {
  type: time
  timeframes: [
    raw,
    date,
    week,
    month,
    quarter,
    quarter_of_year,
    year,
    fiscal_year
  ]
  convert_tz: no
  datatype: date
}

dimension: days_since_last_happy_call {
  type: number
}

dimension_group: first_deal {
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
  label: "First Deal Date -"
}

dimension: has_ae_attained_100_percent_quota_running_sum {
  type: string
}

dimension: is_active_ae {
  type: string
}

dimension: is_ae_ramped_up {
  type: string
  description: "Indicates AEs with >= 100% quota attainment"
}

dimension: is_member_of_team {
  type: yesno
}

dimension: is_onboarding_finished {
  type: string
}

dimension: is_year_to_date {
  type: yesno
}

dimension_group: last_happy_call {
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

#dimension: maximum_capacity_quota {
  #type: number
#}

dimension: month_at_flip {
  type: number
}

dimension: monthly_added_arr_euros {
  type: number
}

dimension: monthly_quota {
  type: number
}

dimension: monthly_quota_teamlead {
  type: number
}

dimension: months_at_flip_max {
  type: number
}

dimension: months_to_first_deal {
  type: number
}

dimension: months_to_ramp {
  type: number
}

dimension: pipeline_open_euros {
  type: number
}

dimension: primary_key {
  type: string
  primary_key: yes
}

dimension: primary_team_name { # team from hubspot
  type: string
  label: "AE Team (Hubspot)"
  hidden: yes
}

dimension_group: quota_attainment_100_percent_first_month {
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

dimension: quota_attaintment_percentage {
  type: number
}

dimension: quota_running_sum {
  type: number
}

dimension: secondary_team_name {
  type: string
  label: "AE Segment"
}

dimension: team_region {
  type: string
  label: "Team Region"
}

dimension: upsell_percentage_from_yearly_quota {
  type: number
}

dimension: new_logo_percentage_from_yearly_quota {
  type: number
}

dimension: yearly_quota {
  type: number
}

# ------ MANUALLY ADDED DIMENSIONS ------------------------------------------------------------------------------------

  dimension: foreign_key_year_trunc {
    type: string
    sql: REPLACE(LOWER(CONCAT(DATE_TRUNC(${calendar_date}, YEAR),"_",${ae_name}))," ","_");;
  }

  dimension: ae_name_former_aes_grouped {
    type: string
    sql: CASE WHEN ${is_active_ae} = "no" THEN "Former AEs"
              ELSE ${ae_name} END;;
    label: "AE Name - former AEs grouped"
  }

# creating parameter for enabling glanularity in the timeseries charts
  parameter: date_granularity {
    type: unquoted
    allowed_value: {
      label: "Break down by Month"
      value: "month"
    }
    allowed_value: {
      label: "Break down by Quarter"
      value: "quarter"
    }
    allowed_value: {
      label: "Break down by Year"
      value: "year"
    }
    allowed_value: {
      label: "Overall period"
      value: "overall"
    }
  }

  dimension: dynamic_date {
    type: string
    label_from_parameter: date_granularity
    sql:
          {% if date_granularity._parameter_value == 'month' %}
            ${calendar_month}
          {% elsif date_granularity._parameter_value == 'quarter' %}
            CONCAT(${calendar_year},"-",${calendar_quarter_of_year})
          {% elsif date_granularity._parameter_value == 'year' %}
            LEFT(CAST(DATE_TRUNC(${calendar_date},YEAR) AS STRING),4)
          {% elsif date_granularity._parameter_value == 'overall' %}
            "Overall period"
          {% else %}
            ${calendar_date}
          {% endif %};;
  }

# creating parameter for enabling ae or team granularity
  parameter: granularity_team_or_individual {
    type: unquoted
    allowed_value: {
      label: "by Individual"
      value: "by_individual"
    }
    allowed_value: {
      label: "by Team"
      value: "by_team"
    }
  }

  dimension: dynamic_ae_label {
    type: string
    label_from_parameter: granularity_team_or_individual
    sql:
          {% if granularity_team_or_individual._parameter_value == 'by_individual' %}
            ${ae_name}
          {% elsif granularity_team_or_individual._parameter_value == 'by_team' %}
            ${primary_team_name}
          {% else %}
            NULL
          {% endif %};;
  }

# ------ MANUALLY ADDED MEASURES --------------------------------------------------------------------------------------

  measure: count {
    type: count
    hidden: yes
  }

  measure: aes_count {
    type: count_distinct
    sql: (${ae_name}) ;;
    label: "#AEs Total"
    description: "#AEs"
    drill_fields: [ae_name, team_region, secondary_team_name, ae_start_date]
  }

  measure: monthly_quota_sum_euros {
    type: sum
    sql: (${monthly_quota}) ;;
    # value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ Quota"
    drill_fields: [dynamic_date, ae_name, team_region, secondary_team_name, monthly_quota_sum_euros]
    description: "AE monthly quota in euros"
  }

  measure: monthly_quota_teamlead_sum_euros {
    type: sum
    sql: (${monthly_quota_teamlead}) ;;
    # value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ Quota Teamleads"
    drill_fields: [dynamic_date, ae_name, team_region, secondary_team_name, monthly_quota_sum_euros]
    description: "AE Teamleads monthly quota in euros"
  }

  # measure: maximum_capacity_quota_sum {
  #   type: sum
  #   sql: (${maximum_capacity_quota}) ;;
  #   value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  #   label: "Maximum Capacity Quota"
  #   drill_fields: [dynamic_date, ae_name, team_region, secondary_team_name, maximum_capacity_quota_sum]
  #   description: "The total quota if all the AEs are onboarded (>3 months)"
  # }

  measure: still_open_quota {
    type: sum
    sql:      CASE WHEN DATE_TRUNC(${calendar_date},MONTH) = DATE_TRUNC(CURRENT_DATE(),MONTH) THEN ${monthly_quota}-${monthly_added_arr_euros}
                   WHEN DATE_TRUNC(${calendar_date},MONTH) < DATE_TRUNC(CURRENT_DATE(),MONTH) THEN ${monthly_quota}-${monthly_added_arr_euros}
                   WHEN DATE_TRUNC(${calendar_date},MONTH) > DATE_TRUNC(CURRENT_DATE(),MONTH) THEN ${monthly_quota}
                   WHEN DATE_TRUNC(${calendar_date},QUARTER) = DATE_TRUNC(CURRENT_DATE(),QUARTER) THEN ${monthly_quota}-${monthly_added_arr_euros}
                   WHEN DATE_TRUNC(${calendar_date},QUARTER) < DATE_TRUNC(CURRENT_DATE(),QUARTER) THEN ${monthly_quota}-${monthly_added_arr_euros}
                   WHEN DATE_TRUNC(${calendar_date},QUARTER) > DATE_TRUNC(CURRENT_DATE(),QUARTER) THEN ${monthly_quota}
              END ;;
    # value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format: "€#,##0.00"
    label: "Quota - still open"
    description: "For pipeline coverage calculation"
  }

# ----- Added ARR

  measure: monthly_added_arr_sum_euros {
    type: sum
    sql: (${monthly_added_arr_euros}) ;;
    # value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format: "€#,##0.00"
    label: "Added ARR €"
    drill_fields: [dynamic_date, ae_name, team_region, secondary_team_name, monthly_added_arr_sum_euros]
    description: "AE monthly added ARR in euros"
  }

# ----- Pipeline Open

  measure: pipeline_open_sum_euros {
    type: sum
    sql: CASE WHEN DATE_TRUNC(${calendar_date},MONTH) = DATE_TRUNC(CURRENT_DATE(),MONTH) THEN ${pipeline_open_euros}
              WHEN DATE_TRUNC(${calendar_date},MONTH) < DATE_TRUNC(CURRENT_DATE(),MONTH) THEN 0
              WHEN DATE_TRUNC(${calendar_date},MONTH) > DATE_TRUNC(CURRENT_DATE(),MONTH) THEN ${pipeline_open_euros}
         END;;
    # value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    value_format: "€#,##0.00"
    label: "€ Forecasted Opportunities Volume"
  }

# if period is already closed, than 1, else 0
# for conditional formatting in the chart
  measure: pipeline_coverage_marker {
    type: sum
    sql: CASE
              WHEN '{% parameter date_granularity %}' = "month" AND DATE_TRUNC(${calendar_date},MONTH) < DATE_TRUNC(CURRENT_DATE(),MONTH) THEN 1
              WHEN '{% parameter date_granularity %}' = "quarter" AND DATE_TRUNC(${calendar_date},QUARTER) < DATE_TRUNC(CURRENT_DATE(),QUARTER) THEN 1
              WHEN '{% parameter date_granularity %}' = "year" AND DATE_TRUNC(${calendar_date},YEAR) < DATE_TRUNC(CURRENT_DATE(),YEAR) THEN 1
              ELSE 0
         END;;
  }

# ----- Quota Attainment

  measure: quota_attainment_running_total_percentage {
    type: average
    sql: (${quota_attaintment_percentage}) ;;
    value_format: "0.00%"
    label: "Quota Attainment - Running Total"
    description: "Running Added ARR divided by Running Quota"
  }

  measure: ae_quota_attainment_average_distinct_percentage {
    type: average_distinct
    sql_distinct_key: ${ae_name} ;;
    sql: CASE
          WHEN (${quota_running_sum}) = 0 THEN NULL
          ELSE (${added_arr_running_sum_euros})/(${quota_running_sum})
          END;;
    value_format: "0.00"
    label: "Quota Attainment - per AE"
    drill_fields: [ae_name, primary_team_name, ae_start_month, months_at_flip_max, ae_quota_attainment_average_distinct_percentage]
  }

  measure: quota_attainment_percentage {
    type: average
    sql: ${monthly_added_arr_euros}/IF(${monthly_quota}=0,NULL,${monthly_quota});;
    value_format: "0.00%"
    label: "Quota Attainment %"
    drill_fields: [dynamic_date, ae_name, team_region, secondary_team_name, quota_attainment_percentage, monthly_added_arr_sum_euros, monthly_quota_sum_euros]
  }

# ----- AE activity

  measure: months_to_first_deal_sum {
    type: sum_distinct
    sql_distinct_key: ${ae_name} ;;
    sql: (${months_to_first_deal}) ;;
    label: "Months to First Deal"
  }

  measure: days_since_last_happy_call_sum {
    type: sum_distinct
    sql_distinct_key: ${ae_name} ;;
    sql: (${days_since_last_happy_call}) ;;
    label: "Days since last Closed Won"
    description: "How many days passed from the AE last closed won deal"
  }

  measure: months_to_ramp_sum {
    type: average_distinct
    sql_distinct_key: ${ae_name} ;;
    sql: (${months_to_ramp}) ;;
    label: "Months to Ramp - 100%"
    value_format: "0"
    description: "Months to achieve 100% of the Quota Running Sum"
    drill_fields: [ae_name, primary_team_name, months_to_ramp_sum]
  }

  # ----- Sales Model - AE

  measure: yearly_quota_sum_distinct {
    type: sum_distinct
    sql_distinct_key: ${foreign_key_year_trunc} ;;
    sql: (${yearly_quota}) ;;
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "AE Yearly Quota €"
    description: "No AE start date logic applied - original quotas from Sales Ops"
  }

}
