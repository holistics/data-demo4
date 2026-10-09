include: "/base_views/Google_Sheets/fin_mrr_per_customer_group_normalized_nrr_base.view"
include: "/extended_views/Datamarts/fin_customer_groups_lookup_ext.view"

view: fin_mrr_per_customer_group_normalized_nrr_ext {

extends: [fin_mrr_per_customer_group_normalized_nrr_base]

  drill_fields: [fin_customer_group_id, fin_customer_group_name, fin_customer_groups_lookup_ext.fin_customer_group_segment, fin_customer_groups_lookup_ext.fin_customer_group_cohort, mrr_sum, count]

# --- DIMENSIONS -------------
  dimension_group: fin_customer_group_cohort {
    type: time
    description: "Recognized Customer Group Cohort"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
    dimension: fin_customer_group_id {
      type: string
    }
    dimension: fin_customer_group_name {
      type: string
      hidden: yes
    }
    dimension_group: month {
      type: time
      timeframes: [raw, date, week, month, month_num, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension: month_string {
      type: string
      hidden: yes
    }
    dimension: mrr {
      type: number
      hidden: yes
    }
    dimension: mrr_string {
      type: string
      hidden: yes
    }
    dimension: primary_key {
      type: string
      primary_key: yes
      hidden: yes
    }

  # --- DIMENSIONS ----------

  dimension: mrr_month_flag {
    type: string
    sql: CASE
    WHEN DATE_TRUNC(${month_date}, MONTH) = DATE_TRUNC(DATE_ADD(CURRENT_DATE(), INTERVAL 0 MONTH), MONTH) THEN "this month"
    WHEN DATE_TRUNC(${month_date}, MONTH) = DATE_TRUNC(DATE_ADD(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH) THEN "last month"
    WHEN ${month_month_num} = 12 AND ${month_year} = EXTRACT(YEAR FROM current_date())-1 THEN "End of LY" END
    ;;
  }

  #from the customer group lookup sheet:

  # dimension_group: fin_customer_group_cohort {
  #   type: time
  #   sql: ${fin_customer_groups_lookup_ext.fin_customer_group_cohort_year} ;;
  #   timeframes: [raw, date, week, month, month_num, quarter, year]
  #   convert_tz: no
  #   datatype: date
  # }
  # dimension: fin_customer_group_cohort_year {
  #   sql: ${fin_customer_groups_lookup_ext.fin_customer_group_cohort_year} ;;
  #   type: date_year
  # }

  # dimension: fin_customer_group_cohort_quarter {
  #   sql: ${fin_customer_groups_lookup_ext.fin_customer_group_cohort_quarter} ;;
  #   type: date_quarter
  # }

  # dimension: fin_customer_group_cohort_month {
  #   sql: ${fin_customer_groups_lookup_ext.fin_customer_group_cohort_month} ;;
  #   type: date_month
  # }

  # --- PARAMETER ----------

# @Andrea this is the parameter that I'm trying to create - looker says 'Variable not found "parameter".':
# copied the code/tried to use the same logic as in extended_views/Datamarts/hubspot_deals_all_ext.view, Row 1525:

# # dynamic filter for parametrized NRR:
#   parameter: base_cohort { # filter the user can adapt in the UI
#     label: "Base Cohort"
#     type: date
#     description: "Choose the latestcustomer recognized month, i.e. contract start, you'd like to include in the base cohort."
#   }

# @Andrea: Filter trials (couldn't make any of them work):

  # filter: cohort_filter {
  #   hidden: yes
  #   sql:
  #   {% if parameter.base_cohort.value != null %}
  #     timestamp_trunc(${fin_customer_groups_hubspot_lookup_ext.fin_customer_group_cohort_date}, month) <= date_trunc(date({{ parameter.base_cohort.value }}), month)
  #   {% else %}
  #     true
  #   {% endif %};;
  # }

  # filter: cohort_filter { # make mandatory in explore
  #   hidden: yes
  #   sql:
  #     {% if base_cohort._parameter_value != null %}
  #     timestamp_trunc(${fin_customer_groups_hubspot_lookup_ext.fin_customer_group_cohort_date}, month) <= date_trunc(date({% parameter base_cohort %}), month)
  #     {% else %}
  #       true
  #     {% endif %};;
  # }

  # filter: cohort_filter {
  #   hidden: yes
  #   sql:
  #   {% if parameter.base_cohort.value != null %}
  #     timestamp_trunc(${fin_customer_groups_hubspot_lookup_ext.fin_customer_group_cohort_date}, month) <= date_trunc(date({{ parameter.base_cohort.value }}), month)
  #   {% else %}
  #     true
  #   {% endif %};;
  # }

  # --- MEASURES -----------
    measure: count {
      type: count
      label: "# Fields"
      drill_fields: [fin_customer_group_name]
      hidden: no

    }

    measure: count_customer_groups {
      type: count_distinct
      sql: ${fin_customer_group_id} ;;
      hidden: no # pull from customer lookup
      label: "# Customer Groups"
    }

    measure: mrr_sum {
      type: sum
      sql: ${mrr} ;;
      label: "MRR €"
      value_format_name: eur_0
    }

    measure: arr_sum {
      type: sum
      sql: ${mrr}*12 ;;
      label: "ARR €"
      value_format_name: eur_0
      drill_fields: [fin_customer_group_id, fin_customer_group_name, fin_customer_groups_lookup_ext.fin_customer_group_segment, arr_sum]
    }

    measure: arr_eoy_sum {
      type: sum
      sql:
      CASE WHEN ${month_month_num} = 12 AND ${month_year} = EXTRACT(YEAR FROM current_date())-1 THEN ${mrr}*12 END;;
      value_format_name: eur_0
      label: "ARR € EoLY"
      drill_fields: [fin_customer_group_id, fin_customer_group_name, fin_customer_groups_lookup_ext.fin_customer_group_segment, arr_eoy_sum]
      }

    measure: arr_current_sum {
      type: sum
      sql:
        CASE WHEN DATE_TRUNC(${month_date}, MONTH) = DATE_TRUNC(CURRENT_DATE(), MONTH) THEN ${mrr}*12 END;;
      value_format_name: eur_0
      label: "ARR € this month"
      drill_fields: [fin_customer_group_id, fin_customer_group_name, fin_customer_groups_lookup_ext.fin_customer_group_segment, arr_current_sum]
    }

    measure: net_arr_ytd_sum {
      type: number
      sql: ${arr_current_sum} - ${arr_eoy_sum};;
      value_format_name: eur_0
      label: "ARR € added YTD"
      drill_fields: [fin_customer_group_id, fin_customer_group_name, fin_customer_groups_lookup_ext.fin_customer_group_segment, net_arr_ytd_sum]
    }

    # measure: base_arr_eoy_previous_year_dynamic {
    #   type: number
    #   sql: COALESCE(
    #           MAX(CASE WHEN ${month_month} = DATE_TRUNC('month', DATE_SUB(DATE_TRUNC('year', ${month_month}), INTERVAL 1 DAY)) THEN ${arr_base_eoly_sum} ELSE NULL END) OVER (PARTITION BY DATE_TRUNC('year', ${month_month})),
    #           MAX(CASE WHEN ${month_month} = DATE_TRUNC('month', DATE_SUB(DATE_TRUNC('year', ${month_month}), INTERVAL 1 DAY)) THEN ${arr_base_eoly_sum} ELSE NULL END) OVER () -- Fallback für den Fall, dass es keine PARTITION gibt
    #         )
    #         ;;
    #   value_format_name: eur
    #   label: "Base ARR EOLY (filled) €"
    #   description: "Base ARR at the end of last year, filled for all months of this year."
    # }

  # measure: base_arr_eoy_previous_year_dynamic {
  #   type: number
  #   sql:
  #         MAX(
  #           CASE
  #             WHEN EXTRACT(YEAR FROM ${month_month}) = EXTRACT(YEAR FROM CURRENT_DATE()) -- For the current year
  #                 AND EXTRACT(MONTH FROM ${month_month}) = 1 -- Only consider the first month of the current year to pick up the previous year's EOY value
  #                 AND ${arr_base_eoly_sum} IS NOT NULL -- Make sure there is an actual base ARR value
  #                 AND EXTRACT(YEAR FROM ${month_month}) > EXTRACT(YEAR FROM DATE_TRUNC('year', DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR))) -- Ensure it's for the current reporting year, not previous
  #             THEN ${arr_base_eoly_sum}
  #             ELSE NULL
  #           END
  #         ) OVER (PARTITION BY EXTRACT(YEAR FROM ${month_month}))
  #         ;;
  #   value_format_name: eur
  #   label: "Base ARR Vorjahr (dynamisch)"
  #   description: "Der Base ARR vom Ende des Vorjahres, für alle Monate des aktuellen Jahres verfügbar."
  # }

  measure: base_arr_eoy_previous_year_dynamic { # not working yet #Andrea
    type: number
    sql:
          MAX(
            CASE
              WHEN
                -- Check if the current month is December of the previous year relative to the row's year
                ${month_month} = DATE_TRUNC(DATE_SUB(${month_date}, INTERVAL 1 YEAR), MONTH) + INTERVAL 11 MONTH
                -- This gets the 1st of January of the previous year for the current row, then adds 11 months to get 1st of December of previous year.
              THEN ${arr_base_eoly_sum}
              ELSE NULL
            END
          ) OVER (PARTITION BY EXTRACT(YEAR FROM ${month_month}))
          ;;
    value_format_name: eur
    label: "Base ARR Vorjahr (dynamisch)"
    description: "Der Base ARR vom Ende des Vorjahres, für alle Monate des aktuellen Jahres verfügbar."
  }

  # ---- NRR -----------------------------------------------------------------------------

    # --- End of last year EOLY Cohort:

    measure: arr_base_eoly_sum {
      type: sum
      sql: CASE WHEN ${fin_customer_groups_lookup_ext.is_group_cohort_eoy}
      AND ${month_month_num} = 12 AND ${month_year} = EXTRACT(YEAR FROM current_date())-1 THEN ${mrr}*12 END ;;
      value_format_name: eur_0
      label: "NRR EOLY: Base ARR €"
      description: "NRR: Base MRR € EoLY"
    }

    measure:  arr_current_month_eoly_cohort_sum {
      type: sum
      sql:
        CASE WHEN ${fin_customer_groups_lookup_ext.is_group_cohort_eoy}
        AND DATE_TRUNC(${month_date}, MONTH) = DATE_TRUNC(CURRENT_DATE(), MONTH)
        THEN ${mrr}*12 END ;;
      value_format_name: eur_0
      label: "NRR EOLY: ARR€ YTD (this month)"
      description: "// TBD MRR € of current month"
    }

    measure:  arr_eoty_eoly_cohort_sum {
      type: sum
      sql: CASE WHEN ${fin_customer_groups_lookup_ext.is_group_cohort_eoy}
      AND ${month_month_num} = 12 AND ${month_year} = EXTRACT(YEAR FROM current_date()) THEN ${mrr}*12 END ;;
      value_format_name: eur_0
      label: "NRR EOLY: ARR € EOTY (projection)"
      description: "NRR: Base MRR € EoLY"
    }

    measure:  arr_previous_month_eoly_cohort_sum {
      type: sum
      sql:
        CASE WHEN ${fin_customer_groups_lookup_ext.is_group_cohort_eoy}
        AND DATE_TRUNC(${month_date}, MONTH) = DATE_TRUNC(DATE_ADD(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH)
        THEN ${mrr}*12 END ;;
      value_format_name: eur_0
      label: "NRR EOLY: ARR€ YTLM (last month)"
      description: "// TBD MRR € of previous month"
    }

    measure: nrr_ytd_eoly_cohort_sum_percent {
      type: number
      sql: ${arr_current_month_eoly_cohort_sum}/NULLIF(${arr_base_eoly_sum},0) ;;
      value_format_name: percent_1
      label: "NRR EOLY: YTD %"
      drill_fields: [fin_customer_group_id, fin_customer_group_name, fin_customer_groups_lookup_ext.fin_customer_group_segment, arr_base_eoly_sum, nrr_ytd_eoly_cohort_sum_percent, nrr_ytd_eoly_cohort_sum_eur]
    }

    measure: nrr_ytd_eoly_cohort_sum_eur {
      type: number
      sql: ${arr_current_month_eoly_cohort_sum}-${arr_base_eoly_sum} ;;
      value_format_name: eur_0
      label: "NRR EOLY: YTD €"
      drill_fields: [fin_customer_group_id, fin_customer_group_name, fin_customer_groups_lookup_ext.fin_customer_group_segment, arr_base_eoly_sum, nrr_ytd_eoly_cohort_sum_percent, nrr_ytd_eoly_cohort_sum_eur]
    }

    measure: nrr_eoty_eoly_cohort_sum_percent {
      type: number
      sql: ${arr_eoty_eoly_cohort_sum}/NULLIF(${arr_base_eoly_sum},0) ;;
      value_format_name: percent_1
      label: "NRR EOLY: EOTY %"
      drill_fields: [fin_customer_group_id, fin_customer_group_name, fin_customer_groups_lookup_ext.fin_customer_group_segment, arr_base_eoly_sum, nrr_eoty_eoly_cohort_sum_percent, nrr_eoty_eoly_cohort_sum_eur]
    }

    measure: nrr_eoty_eoly_cohort_sum_eur {
      type: number
      sql: ${arr_eoty_eoly_cohort_sum}-${arr_base_eoly_sum} ;;
      value_format_name: eur_0
      label: "NRR EOLY: EOTY €"
      drill_fields: [fin_customer_group_id, fin_customer_group_name, fin_customer_groups_lookup_ext.fin_customer_group_segment, arr_base_eoly_sum, nrr_eoty_eoly_cohort_sum_percent, nrr_eoty_eoly_cohort_sum_eur]
    }

# --- YoY Cohort (this month vs same month last year):

    measure: arr_base_yoy_cohort_sum {
      type: sum
      sql:
          CASE WHEN ${fin_customer_groups_lookup_ext.is_group_cohort_yoy}
          AND ${month_month} = FORMAT_DATE("%Y-%m", DATE_ADD(CURRENT_DATE(), INTERVAL -12 MONTH))
          THEN ${mrr}*12 END ;;
      value_format_name: eur_0
      label: "NRR YoY: Base ARR €"
      description: "NRR: Base MRR € EoLY "
    }

  measure: arr_base_previous_month_yoy_cohort_sum {
    type: sum
    sql:
          CASE WHEN ${fin_customer_groups_lookup_ext.is_group_cohort_yoy}
          AND ${month_month} = FORMAT_DATE("%Y-%m", DATE_ADD(CURRENT_DATE(), INTERVAL -13 MONTH))
          THEN ${mrr}*12 END ;;
    value_format_name: eur_0
    label: "NRR YoY: Base ARR LM €"
    description: "NRR: Base MRR € EoLY "
  }

    measure:  arr_current_month_yoy_cohort_sum { ## cohort definition missing (only customers that are also part of the base)
      type: sum
      sql:
        CASE WHEN ${fin_customer_groups_lookup_ext.is_group_cohort_yoy}
        AND DATE_TRUNC(${month_date}, MONTH) = DATE_TRUNC(CURRENT_DATE(), MONTH)
        THEN ${mrr}*12 END ;;
      value_format_name: eur_0
      label: "NRR YoY: ARR€ this month"
      description: "// TBD MRR € of current month"
    }

  measure:  arr_previous_month_yoy_cohort_sum { ## cohort definition missing (only customers that are also part of the base)
    type: sum
    sql:
        CASE WHEN ${fin_customer_groups_lookup_ext.is_group_cohort_yoy}
        AND DATE_TRUNC(${month_date}, MONTH) = DATE_TRUNC(DATE_ADD(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH)
        THEN ${mrr}*12 END ;;
    value_format_name: eur_0
    label: "NRR YoY: ARR€ last month"
    description: "// TBD MRR € of last month"
  }

    measure: nrr_yoy_cohort_sum_percent {
      type: number
      sql: ${arr_current_month_yoy_cohort_sum}/NULLIF(${arr_base_yoy_cohort_sum},0) ;;
      value_format_name: percent_1
      label: "NRR YoY %"
      drill_fields: [fin_customer_group_id, fin_customer_group_name, fin_customer_groups_lookup_ext.fin_customer_group_segment, arr_base_yoy_cohort_sum, nrr_yoy_cohort_sum_percent, nrr_yoy_cohort_sum_eur]
    }

    measure: nrr_yoy_cohort_sum_eur {
      type: number
      sql: ${arr_current_month_yoy_cohort_sum}-${arr_base_yoy_cohort_sum} ;;
      value_format_name: eur_0
      label: "NRR YoY €"
      drill_fields: [fin_customer_group_id, fin_customer_group_name, fin_customer_groups_lookup_ext.fin_customer_group_segment, arr_base_yoy_cohort_sum, nrr_yoy_cohort_sum_percent, nrr_yoy_cohort_sum_eur]
    }

  measure: nrr_yoy_cohort_lastmonth_sum_percent {
    type: number
    sql: ${arr_previous_month_yoy_cohort_sum}/NULLIF(${arr_base_previous_month_yoy_cohort_sum},0) ;;
    value_format_name: percent_1
    label: "NRR YoY LM %"
    drill_fields: [fin_customer_group_id, fin_customer_group_name, fin_customer_groups_lookup_ext.fin_customer_group_segment, arr_base_yoy_cohort_sum, nrr_yoy_cohort_sum_percent, nrr_yoy_cohort_sum_eur]
  }

# --- End of NRR ---------------------

    # measure: gross_retention_logos_t12m {
    #   type: count_distinct
    #   sql: ${fin_customer_group_id} ;;
    #   filters: [fin_customer_groups_hubspot_lookup_ext.fin_customer_group_cohort_month: "before 11 months ago", month_month: "12 months ago"]
    # }

    # measure: gross_retention_logos_now {
    #   type: count_distinct
    #   sql: ${fin_customer_group_id} ;;
    #   filters: [fin_customer_groups_hubspot_lookup_ext.fin_customer_group_cohort_month: "this month"]
    # }

   # measure: gross_retention_euros {}

  }
