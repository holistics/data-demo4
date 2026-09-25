view: rd_weekly_vibe_survey_base {
  sql_table_name: `fl-bi-p-poc.source_google_sheets_poc.rd_weekly_vibe_survey` ;;

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }
  dimension: giving_high_five {
    type: string
    sql: ${TABLE}.giving_high_five ;;
  }
  dimension_group: timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
  }
  dimension: week_rating {
    type: number
    sql: ${TABLE}.week_rating ;;
  }
  dimension: what_went_bad {
    type: string
    sql: ${TABLE}.what_went_bad ;;
  }
  dimension: what_went_well {
    type: string
    sql: ${TABLE}.what_went_well ;;
  }
  measure: count {
    type: count
  }
}
