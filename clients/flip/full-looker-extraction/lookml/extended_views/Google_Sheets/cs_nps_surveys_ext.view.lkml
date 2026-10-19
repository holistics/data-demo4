include: "/base_views/Google_Sheets/cs_nps_surveys_base.view"

view: cs_nps_surveys_ext {
    extends: [cs_nps_surveys_base]

# ----- DIMENSIONS ---------------------------------------------------
    dimension: hubspot_company_id {
      type: string
      hidden: yes
    }

  dimension: hubspot_contact_id {
    type: string
  }

    dimension: nps_value {
      type: number
      hidden: yes
    }

  dimension: response_id {
    type: string
    primary_key: yes
  }

  dimension_group: survey_start_date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension: survey_quarter {
    type: string
  }

    dimension: unique_id {
      type: string
      hidden: yes
    }

# ----- MEASURES ---------------------------------------------------

    measure: count {
      type: count
      label: "# Survey Responses"
      drill_fields: []
    }

  measure: avg_nps_value {
    type: average
    sql: ${nps_value} ;;
    value_format_name: decimal_1
  }

  measure: max_nps_value {
    type: max
    sql: ${nps_value} ;;
  }

  measure: min_nps_value {
    type: min
    sql: ${nps_value} ;;
  }
  }
