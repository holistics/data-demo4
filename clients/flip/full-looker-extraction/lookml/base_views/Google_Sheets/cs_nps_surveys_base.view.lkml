view: cs_nps_surveys_base {
  sql_table_name: `fl-bi-p-poc.source_google_sheets_poc.cs_nps_surveys` ;;

  dimension: hubspot_company_id {
    type: string
    sql: ${TABLE}.hubspot_company_id ;;
  }

  dimension: hubspot_contact_id {
    type: string
    sql: ${TABLE}.hubspot_contact_id ;;
  }

  dimension: nps_value {
    type: number
    sql: ${TABLE}.nps_value ;;
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
    sql: ${TABLE}.survey_start_date ;;
  }

  dimension: survey_quarter {
    type: string
    sql: ${TABLE}.survey_quarter ;;
  }

  dimension: response_id {
    type: string
    sql: ${TABLE}.response_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
