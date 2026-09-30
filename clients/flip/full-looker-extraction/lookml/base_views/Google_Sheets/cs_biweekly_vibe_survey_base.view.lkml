view: cs_biweekly_vibe_survey_base {
  sql_table_name: `fl-bi-p-poc.source_google_sheets_poc.cs_biweekly_vibe_survey` ;;

  dimension: giving_high_five_to_ {
    type: string
    sql: ${TABLE}.Giving_high_five_to_ ;;
  }
  dimension: how_were_your_last_two_weeks_ {
    type: string
    sql: ${TABLE}.How_were_your_last_two_weeks_ ;;
  }
  dimension_group: timestamp {
    type: time
    description: "%m/%d/%Y %H:%M:%E*S"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.Timestamp ;;
  }
  dimension: what_went_not_so_well_ {
    type: string
    sql: ${TABLE}.What_went_not_so_well_ ;;
  }
  dimension: what_went_well_ {
    type: string
    sql: ${TABLE}.What_went_well_ ;;
  }
  measure: count {
    type: count
  }
}
