include: "/base_views/Reports/marketing_filters_base.view"

view: marketing_filters_ext {

  extends: [marketing_filters_base]

# ----- DIMENSIONS -----------------------------------------

  dimension: asset_name {
    type: string
  }

  dimension: bdr_daily_calls_target {
    type: number
    hidden: yes
  }

  dimension: bdr_daily_emails_target {
    type: number
    hidden: yes
  }

  dimension: bdr_daily_meetings_target {
    type: number
    hidden: yes
  }

  dimension: bdr_daily_sao_target {
    type: number
    hidden: yes
  }

  dimension: channel_planned_quarterly_spend_euros {
    type: number
    hidden: yes
  }

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      quarter_of_year,
      year
    ]
    convert_tz: no
    datatype: date
    drill_fields: []
  }

  dimension: foreign_key_date_source_channel {
    type: string
    hidden: yes
  }

  dimension: foreign_key_date_trunc_month_source_channel {
    type: string
    hidden: yes
  }

  dimension: foreign_key_date_trunc_quarter_source_channel {
    type: string
    hidden: yes
  }

  dimension: foreign_key_targets {
    type: string
    hidden: yes
  }

  dimension: foreign_key_bdr_targets {
    type: string
    hidden: no
  }

  dimension: foreign_key_contacts_table {
    type: string
    hidden: yes
  }

  dimension: unique_key_targets_in_looker {
    type: string
    hidden: yes
  }

  # dimension: industry { \ not part of the data structure
  #   type: string
  # }

  dimension: is_active_ae {
    type: yesno
  }

  dimension: is_active_bdr {
    type: yesno
  }

  dimension: is_ae_onboarded {
    type: yesno
  }

  dimension: is_bdr_onboarded {
    type: yesno
  }

  dimension: is_official_ae {
    type: yesno
  }

  dimension: is_official_bdr {
    type: yesno
  }

  dimension: source_channel {
    type: string
  }

  dimension: partner_stage {
    type: string
  }

  dimension: primary_key {
    type: string
    primary_key: yes
    hidden: no
  }

  dimension: sales_region {
    type: string
  }

  dimension: segment {
    type: string
  }

  dimension: channel_daily_total_spend_euros {
    type: number
    hidden: yes
  }

  dimension: lead_count_base_target {
    type: number
    hidden: yes
  }

  dimension: lead_count_team_target {
    type: number
    hidden: yes
  }

  dimension: mql_count_base_target {
    type: number
    hidden: yes
  }

  dimension: mql_count_team_target {
    type: number
    hidden: yes
  }

  dimension: sql_count_base_target {
    type: number
    hidden: yes
  }

  dimension: sql_count_team_target {
    type: number
    hidden: yes
  }

  dimension: sal_count_base_target {
    type: number
    hidden: yes
  }

  dimension: sal_count_team_target {
    type: number
    hidden: yes
  }

  dimension: sao_count_base_target {
    type: number
    hidden: yes
  }

  dimension: sao_count_team_target {
    type: number
    hidden: yes
  }

  dimension: sao_volume_euros_base_target {
    type: number
    hidden: yes
  }

  dimension: sao_volume_euros_team_target {
    type: number
    hidden: yes
  }

  dimension: ae_official_quota_monthly_euros {
    type: number
    description: "Monthly € New Signed ARR Quotas per AE, assigned by RevOps"
    hidden: yes
  }

  dimension: ae_quota_on_the_street_monthly_euros {
    type: number
    description: "Considering (SaaS best practices) that AEs take 3 months to get fully onboarded, we assign no quotas for the AE in the first 3 months - as it's very unrealistic that an AE will add any New Signed ARR within this time period"
    hidden: yes
  }

  dimension: foreign_key_ae_targets {
    type: string
    hidden: yes
  }

# ----- MANUALLY CREATED DIMENSIONS -------------------------------------------------------------------------------------------------------------------------------

  # indicating what rows from the reports.marketing_filters table won't be showing in the BDR Leaderboard dashboard
  dimension: to_be_filtered_out_from_bdr_leaderboard{
    type: yesno
    sql: CASE WHEN ${asset_name} = "Amelie Wernick" AND ${date_date} > "2023-10-31" THEN TRUE
              WHEN ${asset_name} = "w/o" THEN TRUE
              WHEN LOWER(${source_channel}) = "bdr outbound" THEN FALSE
              ELSE TRUE END ;;
    label: "BDR Leaderboard filter"
  }

  # creating parameter for enabling glanularity in the timeseries charts
  parameter: date_granularity {
    type: unquoted
    allowed_value: {
      label: "Break down by Day"
      value: "daily"
    }
    allowed_value: {
      label: "Break down by Week"
      value: "week"
    }
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
      label: "Break down by Overall"
      value: "overall"
    }
  }

# dynamic date
  dimension: dynamic_date_funnel {
    type: string
    label_from_parameter: date_granularity
    sql:
          {% if date_granularity._parameter_value == 'week' %}
            ${date_week}
          {% elsif date_granularity._parameter_value == 'daily' %}
            ${date_date}
          {% elsif date_granularity._parameter_value == 'month' %}
            ${date_month}
          {% elsif date_granularity._parameter_value == 'quarter' %}
            CONCAT(${date_year},"-",${date_quarter_of_year})
          {% elsif date_granularity._parameter_value == 'year' %}
            LEFT(CAST(DATE_TRUNC(${date_date},YEAR) AS STRING),4)
          {% elsif date_granularity._parameter_value == 'overall' %}
            "Overall"
          {% else %}
            ${date_date}
          {% endif %};;
  }

  # generating parameter for comparison vs previous date
  parameter: date_selection {
    type: unquoted
    label: "Date Selection"
    allowed_value: {
      label: "Today"
      value: "today"
    }
    allowed_value: {
      label: "Yesterday"
      value: "yesterday"
    }
    allowed_value: {
      label: "Last 7 complete days"
      value: "last_7_days"
    }
    allowed_value: {
      label: "Last 14 complete days"
      value: "last_14_days"
    }
    allowed_value: {
      label: "Last 30 complete days"
      value: "last_30_days"
    }
    allowed_value: {
      label: "This Week"
      value: "this_week"
    }
    allowed_value: {
      label: "Last Week"
      value: "last_week"
    }
    allowed_value: {
      label: "This Year"
      value: "this_year"
    }
    allowed_value: {
      label: "Last Year"
      value: "last_year"
    }
    allowed_value: {
      label: "Last 2 Months (current + last)"
      value: "last_2_months"
    }
    allowed_value: {
      label: "January this Year"
      value: "january_this_year"
    }
    allowed_value: {
      label: "February this Year"
      value: "february_this_year"
    }
    allowed_value: {
      label: "March this Year"
      value: "march_this_year"
    }
    allowed_value: {
      label: "April this Year"
      value: "april_this_year"
    }
    allowed_value: {
      label: "May this Year"
      value: "may_this_year"
    }
    allowed_value: {
      label: "June this Year"
      value: "june_this_year"
    }
    allowed_value: {
      label: "July this Year"
      value: "july_this_year"
    }
    allowed_value: {
      label: "August this Year"
      value: "august_this_year"
    }
    allowed_value: {
      label: "September this Year"
      value: "september_this_year"
    }
    allowed_value: {
      label: "October this Year"
      value: "october_this_year"
    }
    allowed_value: {
      label: "November this Year"
      value: "november_this_year"
    }
    allowed_value: {
      label: "December this Year"
      value: "december_this_year"
    }
    allowed_value: {
      label: "Q1 this Year"
      value: "q1_this_year"
    }
    allowed_value: {
      label: "Q2 this Year"
      value: "q2_this_year"
    }
    allowed_value: {
      label: "Q3 this Year"
      value: "q3_this_year"
    }
    allowed_value: {
      label: "Q4 this Year"
      value: "q4_this_year"
    }
  }

  dimension: flag_for_first_date_comparison {
    type: string
    label_from_parameter: date_selection
    sql:
          {% if date_selection._parameter_value == 'today' %}
            CASE WHEN ${date_date} = CURRENT_DATE() THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'yesterday' %}
            CASE WHEN ${date_date} = DATE_SUB(CURRENT_DATE(),INTERVAL 1 DAY)THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'last_7_days' %}
            CASE WHEN ${date_date} BETWEEN (CURRENT_DATE()-7) AND (CURRENT_DATE()-1) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'last_14_days' %}
            CASE WHEN ${date_date} BETWEEN (CURRENT_DATE()-14) AND (CURRENT_DATE()-1) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'last_30_days' %}
            CASE WHEN ${date_date} BETWEEN (CURRENT_DATE()-30) AND (CURRENT_DATE()-1) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'this_week' %}
            CASE WHEN DATE_TRUNC(${date_date},WEEK) = DATE_TRUNC(CURRENT_DATE(),WEEK) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'last_week' %}
            CASE WHEN DATE_TRUNC(${date_date},WEEK) = DATE_SUB(DATE_TRUNC(CURRENT_DATE(),WEEK),INTERVAL 1 WEEK) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},YEAR) = DATE_TRUNC(CURRENT_DATE(),YEAR) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'last_year' %}
            CASE WHEN DATE_TRUNC(${date_date},YEAR) = DATE_SUB(DATE_TRUNC(CURRENT_DATE(),YEAR),INTERVAL 1 YEAR) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'last_2_months' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) = DATE_TRUNC(CURRENT_DATE(),MONTH)
                   OR DATE_TRUNC(${date_date},MONTH) = DATE_SUB(DATE_TRUNC(CURRENT_DATE(),MONTH),INTERVAL 1 MONTH) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'january_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-01-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'february_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-02-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'march_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-03-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'april_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-04-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'may_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-05-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'june_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-06-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'july_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-07-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'august_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-08-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'september_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-09-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'october_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-10-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'november_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-11-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'december_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-12-01")) THEN "yes"
            ELSE NULL END
            {% elsif date_selection._parameter_value == 'q1_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},QUARTER) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-01-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'q2_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},QUARTER) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-04-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'q3_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},QUARTER) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-07-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'q4_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},QUARTER) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-10-01")) THEN "yes"
            ELSE NULL END
          {% else %}
            NULL
          {% endif %};;
  }

  dimension: flag_for_second_date_comparison {
    type: string
    label_from_parameter: date_selection
    sql:
          {% if date_selection._parameter_value == 'today' %}
            CASE WHEN ${date_date} = DATE_SUB(CURRENT_DATE(),INTERVAL 1 DAY) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'yesterday' %}
            CASE WHEN ${date_date} = DATE_SUB(CURRENT_DATE(),INTERVAL 2 DAY) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'last_7_days' %}
            CASE WHEN ${date_date} BETWEEN (CURRENT_DATE()-14) AND (CURRENT_DATE()-8) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'last_14_days' %}
            CASE WHEN ${date_date} BETWEEN (CURRENT_DATE()-28) AND (CURRENT_DATE()-15) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'last_30_days' %}
            CASE WHEN ${date_date} BETWEEN (CURRENT_DATE()-60) AND (CURRENT_DATE()-31) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'this_week' %}
            CASE WHEN DATE_TRUNC(${date_date},WEEK) = DATE_SUB(DATE_TRUNC(CURRENT_DATE(),WEEK),INTERVAL 1 WEEK) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'last_week' %}
            CASE WHEN DATE_TRUNC(${date_date},WEEK) = DATE_SUB(DATE_TRUNC(CURRENT_DATE(),WEEK),INTERVAL 2 WEEK) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},YEAR) = DATE_SUB(DATE_TRUNC(CURRENT_DATE(),YEAR),INTERVAL 1 YEAR) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'last_year' %}
            CASE WHEN DATE_TRUNC(${date_date},YEAR) = DATE_SUB(DATE_TRUNC(CURRENT_DATE(),YEAR),INTERVAL 2 YEAR) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'last_2_months' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) = DATE_SUB(DATE_TRUNC(CURRENT_DATE(),MONTH),INTERVAL 2 MONTH)
                   OR DATE_TRUNC(${date_date},MONTH) = DATE_SUB(DATE_TRUNC(CURRENT_DATE(),MONTH),INTERVAL 3 MONTH) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'january_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE())-1,"-12-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'february_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-01-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'march_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-02-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'april_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-03-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'may_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-04-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'june_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-05-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'july_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-06-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'august_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-07-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'september_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-08-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'october_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-09-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'november_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-10-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'december_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},MONTH) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-11-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'q1_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},QUARTER) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE())-1,"-10-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'q2_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},QUARTER) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-01-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'q3_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},QUARTER) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-04-01")) THEN "yes"
            ELSE NULL END
          {% elsif date_selection._parameter_value == 'q4_this_year' %}
            CASE WHEN DATE_TRUNC(${date_date},QUARTER) =  DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()),"-07-01")) THEN "yes"
            ELSE NULL END
          {% else %}
            NULL
          {% endif %};;
  }

  # creating parameter for enabling user to report Region/Country more granular
  parameter: dynamic_channel_parameter {
    type: unquoted
    allowed_value: {
      label: "Source Channel Department"
      value: "super_category"
    }
    allowed_value: {
      label: "Source Channel Cluster"
      value: "sub_category"
    }
  }

dimension: source_super_channel {
  type:  string
  sql:   (CASE WHEN LOWER(${source_channel}) IN ("management/investor referral") THEN "Mgmt/Inv"
              WHEN LOWER(${source_channel}) IN ("cs referral") THEN "CS"
              WHEN LOWER(${source_channel}) IN ("partner") THEN "Partner"
              WHEN LOWER(${source_channel}) IN ("bdr outbound") THEN "BDR Out"
              WHEN LOWER(${source_channel}) IN ("ae outbound") THEN "AE Out"
              WHEN (LOWER(${source_channel}) IS NULL OR LOWER(${source_channel}) IN ("w/o","-")) AND deal_type IN ("Upsell", "Upsell EDEKA") THEN "CS" -- upsells CS (only of no other channel applies)
              WHEN LOWER(${source_channel}) IS NULL OR LOWER(${source_channel}) IN ("w/o","-") THEN "w/o"
              ELSE "Marketing" END
        );;
        label: "OLD Source super channel (Department)"
}

  dimension: dynamic_channel {
    type: string
    label: "OLD source channel"
    label_from_parameter: dynamic_channel_parameter
    sql: {% if dynamic_channel_parameter._parameter_value == 'sub_category' %}
        (${source_channel})
        {% else %}
        (CASE WHEN LOWER(${source_channel}) IN ("management/investor referral") THEN "Mgmt/Inv"
              WHEN LOWER(${source_channel}) IN ("cs referral") THEN "CS"
              WHEN LOWER(${source_channel}) IN ("partner") THEN "Partner"
              WHEN LOWER(${source_channel}) IN ("bdr outbound") THEN "BDR Out"
              WHEN LOWER(${source_channel}) IN ("ae outbound") THEN "AE Out"
              WHEN LOWER(${source_channel}) IS NULL OR LOWER(${source_channel}) IN ("w/o","-") THEN "w/o"
              ELSE "Marketing" END
        )
        {% endif %};;
  }

  # creating parameter for enabling user to switch between BASE and TEAM targets
  parameter: dynamic_target_parameter {
    type: unquoted
    allowed_value: {
      label: "BASE"
      value: "base"
    }
    allowed_value: {
      label: "TEAM"
      value: "team"
    }
    allowed_value: {
      label: "META"
      value: "meta"
    }
  }

  dimension: targets_to_date_filter {
    type: string
    sql:  IF(${date_date}<=CURRENT_DATE(),"yes",NULL);;
    label: "To-Date targets"
  }

# used in BDR Leaderboard
  measure: max_date {
    type: string
    sql: MAX(${date_date}) ;;
  }

# used in BDR Leaderboard
  measure: min_date {
    type: string
    sql: MIN(${date_date}) ;;
  }

# ----- MEASURES --------------------------------------------------------------------------------------------------------------------------------------------------

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }

  measure: channel_planned_spend_euros_sum {
    type: sum_distinct
    filters: [channel_planned_quarterly_spend_euros: ">0"]
    sql_distinct_key: ${foreign_key_date_trunc_quarter_source_channel} ;;
    sql: ${channel_planned_quarterly_spend_euros} ;;
    hidden: yes
  }

  measure: spend_sum_euros { ## not reliable anymore -> use allocation table
    type: sum_distinct
    sql:  ${channel_daily_total_spend_euros};;
    sql_distinct_key: ${foreign_key_date_source_channel}  ;;
    #sql_distinct_key: ${unique_key_targets_in_looker} ;;
    label: "€ Spend (outdated!) -> use allocation table instead"
    drill_fields: [dynamic_date_funnel, source_channel, spend_sum_euros]
    description: "Marketing Spend on Ads, Trade Shows, Dinners, Webinars & Content synd "
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  # -- Marketing targets

  measure: dynamic_target_lead_count {
    type: sum_distinct
    sql_distinct_key: ${unique_key_targets_in_looker} ;;
    label_from_parameter: dynamic_target_parameter
    sql: {% if dynamic_target_parameter._parameter_value == 'base' %}
        (${lead_count_base_target})
        {% elsif dynamic_target_parameter._parameter_value == 'meta' %}
        ${lead_count_meta_target}
        {% else %}
        (${lead_count_team_target})
        {% endif %};;
    label: "Dynamic Target: 1. Lead"
    value_format: "#,##0"
  }

  measure: dynamic_target_cplead {
    type: number
    label_from_parameter: dynamic_target_parameter
    sql: {% if dynamic_target_parameter._parameter_value == 'base' %}
          ${channel_planned_spend_euros_sum}/SUM(${lead_count_base_target})
        {% elsif dynamic_target_parameter._parameter_value == 'meta' %}
          ${channel_planned_spend_euros_sum}/SUM(${lead_count_meta_target})
         {% else %}
          ${channel_planned_spend_euros_sum}/SUM(${lead_count_team_target})
        {% endif %};;
    label: "Dynamic Target: 1.1 CPLead"
    value_format: "€ #.#0"
  }

  measure: dynamic_target_lead_to_mql_cr {
    type: number
    label_from_parameter: dynamic_target_parameter
    sql: {% if dynamic_target_parameter._parameter_value == 'base' %}
        SUM(${mql_count_base_target})/IF(SUM(${lead_count_base_target})=0,NULL,SUM(${lead_count_base_target}))
        {% elsif dynamic_target_parameter._parameter_value == 'meta' %}
        SUM(${mql_count_meta_target})/IF(SUM(${lead_count_meta_target})=0,NULL,SUM(${lead_count_meta_target}))
        {% else %}
        SUM(${mql_count_team_target})/IF(SUM(${lead_count_team_target})=0,NULL,SUM(${lead_count_team_target}))
        {% endif %};;
    value_format: "0.00"
    label: "Dynamic Target: 1.2 Lead to MQL CR"
  }

  measure: dynamic_target_mql_count {
    type: sum_distinct
    sql_distinct_key: ${unique_key_targets_in_looker} ;;
    label_from_parameter: dynamic_target_parameter
    sql: {% if dynamic_target_parameter._parameter_value == 'base' %}
        (${mql_count_base_target})
        {% elsif dynamic_target_parameter._parameter_value == 'meta' %}
        (${mql_count_meta_target})
        {% else %}
        (${mql_count_team_target})
        {% endif %};;
    label: "Dynamic Target: 2. MQL"
    value_format: "#,##0"
  }

  measure: dynamic_target_cpmql {
    type: number
    label_from_parameter: dynamic_target_parameter
    sql: {% if dynamic_target_parameter._parameter_value == 'base' %}
          ${channel_planned_spend_euros_sum}/SUM(${mql_count_base_target})
          {% elsif dynamic_target_parameter._parameter_value == 'meta' %}
          ${channel_planned_spend_euros_sum}/SUM(${mql_count_meta_target})
          {% else %}
          ${channel_planned_spend_euros_sum}/SUM(${mql_count_team_target})
          {% endif %};;
    label: "Dynamic Target: 2.1 CPMQL"
    value_format: "€ #.#0"
  }

  measure: dynamic_target_mql_to_sql_cr {
    type: number
    label_from_parameter: dynamic_target_parameter
    sql: {% if dynamic_target_parameter._parameter_value == 'base' %}
        SUM(${sql_count_base_target})/IF(SUM(${mql_count_base_target})=0,NULL,SUM(${mql_count_base_target}))
          {% elsif dynamic_target_parameter._parameter_value == 'meta' %}
        SUM(${sql_count_meta_target})/IF(SUM(${mql_count_meta_target})=0,NULL,SUM(${mql_count_meta_target}))
        {% else %}
        SUM(${sql_count_team_target})/IF(SUM(${mql_count_team_target})=0,NULL,SUM(${mql_count_team_target}))
        {% endif %};;
    value_format: "0.00"
    label: "Dynamic Target: 2.2 MQL to SQL CR"
  }

  measure: dynamic_target_sql_count {
    type: sum_distinct
    sql_distinct_key: ${unique_key_targets_in_looker} ;;
    label_from_parameter: dynamic_target_parameter
    sql: {% if dynamic_target_parameter._parameter_value == 'base' %}
        (${sql_count_base_target})
        {% elsif dynamic_target_parameter._parameter_value == 'meta' %}
        (${sql_count_meta_target})
        {% else %}
        (${sql_count_team_target})
        {% endif %};;
    label: "Dynamic Target: 3. SQL"
    value_format: "€ #.#0"
  }

  measure: dynamic_target_cpsql {
    type: number
    label_from_parameter: dynamic_target_parameter
    sql: {% if dynamic_target_parameter._parameter_value == 'base' %}
          ${channel_planned_spend_euros_sum}/SUM(${sql_count_base_target})
         {% elsif dynamic_target_parameter._parameter_value == 'meta' %}
          ${channel_planned_spend_euros_sum}/SUM(${sql_count_meta_target})
          {% else %}
          ${channel_planned_spend_euros_sum}/SUM(${sql_count_team_target})
          {% endif %};;
    label: "Dynamic Target: 3.1 CPSQL"
    value_format: "€ #,##0"
  }

  measure: dynamic_target_sql_to_sal_cr {
    type: number
    label_from_parameter: dynamic_target_parameter
    sql: {% if dynamic_target_parameter._parameter_value == 'base' %}
        SUM(${sal_count_base_target})/IF(SUM(${sql_count_base_target})=0,NULL,SUM(${sql_count_base_target}))
                 {% elsif dynamic_target_parameter._parameter_value == 'meta' %}
        SUM(${sal_count_meta_target})/IF(SUM(${sql_count_meta_target})=0,NULL,SUM(${sql_count_meta_target}))
        {% else %}
        SUM(${sal_count_team_target})/IF(SUM(${sql_count_team_target})=0,NULL,SUM(${sql_count_team_target}))
        {% endif %};;
    value_format: "0.00"
    label: "Dynamic Target: 3.2 SQL to SAL CR"
  }

  measure: dynamic_target_sal_count {
    type: sum_distinct
    sql_distinct_key: ${unique_key_targets_in_looker} ;;
    label_from_parameter: dynamic_target_parameter
    sql: {% if dynamic_target_parameter._parameter_value == 'base' %}
        (${sal_count_base_target})
                 {% elsif dynamic_target_parameter._parameter_value == 'meta' %}
        (${sal_count_meta_target})
        {% else %}
        (${sal_count_team_target})
        {% endif %};;
    label: "Dynamic Target: 4. SAL"
    value_format: "#,##0"
  }

  measure: dynamic_target_sal_to_sao_cr {
    type: number
    label_from_parameter: dynamic_target_parameter
    sql: {% if dynamic_target_parameter._parameter_value == 'base' %}
        SUM(${sao_count_base_target})/IF(SUM(${sal_count_base_target})=0,NULL,SUM(${sal_count_base_target}))
                         {% elsif dynamic_target_parameter._parameter_value == 'meta' %}
        SUM(${sao_count_meta_target})/IF(SUM(${sal_count_meta_target})=0,NULL,SUM(${sal_count_meta_target}))

      {% else %}
      SUM(${sao_count_team_target})/IF(SUM(${sal_count_team_target})=0,NULL,SUM(${sal_count_team_target}))
      {% endif %};;
    value_format: "0.00"
    label: "Dynamic Target: 4.2 SAL to SAO CR"
  }

  measure: dynamic_target_sao_count {
    type: sum_distinct
    sql_distinct_key: ${unique_key_targets_in_looker} ;;
    label_from_parameter: dynamic_target_parameter
    sql: {% if dynamic_target_parameter._parameter_value == 'base' %}
        (${sao_count_base_target})
                                 {% elsif dynamic_target_parameter._parameter_value == 'meta' %}
        (${sao_count_meta_target})

      {% else %}
      (${sao_count_team_target})
      {% endif %};;
    label: "Dynamic Target: 5. SAO"
    value_format: "#,##0"
  }

  measure: dynamic_target_sao_volume_sum {
    type: sum_distinct
    sql_distinct_key: ${unique_key_targets_in_looker} ;;
    label_from_parameter: dynamic_target_parameter
    sql: {% if dynamic_target_parameter._parameter_value == 'base' %}
        (${sao_volume_euros_base_target})
                                         {% elsif dynamic_target_parameter._parameter_value == 'meta' %}
        (${sao_volume_euros_meta_target})
        {% else %}
        (${sao_volume_euros_team_target})
        {% endif %};;
    label: "Dynamic Target: 6. SAO Volume"
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
  }

  # -- BDR targets

  measure: bdr_daily_calls_target_sum {
    type: sum_distinct
    sql:  ${bdr_daily_calls_target};;
    sql_distinct_key: ${foreign_key_bdr_targets}  ;;
    label: "BDR Daily Target # Calls"
    drill_fields: [date_date, bdr_daily_calls_target_sum]
    value_format: "0"
  }

  measure: bdr_daily_emails_target_sum {
    type: sum_distinct
    sql:  ${bdr_daily_emails_target};;
    sql_distinct_key: ${foreign_key_bdr_targets}  ;;
    label: "BDR Daily Target # Emails"
    drill_fields: [date_date, bdr_daily_emails_target_sum]
    value_format: "0"
  }

  measure: bdr_daily_meetings_target_sum {
    type: sum_distinct
    sql:  ${bdr_daily_meetings_target};;
    sql_distinct_key: ${foreign_key_bdr_targets}  ;;
    label: "BDR Daily Target # Meetings"
    drill_fields: [date_date, bdr_daily_meetings_target_sum]
    value_format: "0"
  }

  measure: bdr_daily_saos_target_sum {
    type: sum_distinct
    sql:  ${bdr_daily_sao_target};;
    sql_distinct_key: ${foreign_key_bdr_targets}  ;;
    label: "BDR Daily Target # SAOs"
    drill_fields: [date_date, bdr_daily_saos_target_sum]
    value_format_name: decimal_0
  }

  # -- AE targets

  measure: ae_official_quota_monthly_euros_sum {
    type: sum_distinct
    sql:  ${ae_official_quota_monthly_euros};;
    sql_distinct_key: ${foreign_key_ae_targets}  ;;
    filters: [ae_official_quota_monthly_euros: ">0"]
    label: "AE € New Signed ARR Quota"
    description: "Sum of the monthly € New Signed ARR quotas assigned by RevOps"
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    drill_fields: [date_quarter, asset_name, ae_official_quota_monthly_euros_sum]
  }

}
