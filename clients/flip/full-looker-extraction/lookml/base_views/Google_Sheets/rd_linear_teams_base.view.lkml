view: rd_linear_teams_base {
  sql_table_name: `fl-bi-p-poc.source_google_sheets_poc.rd_linear_teams` ;;

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }
  dimension: team_name {
    type: string
    sql: ${TABLE}.team_name ;;
  }
  dimension: sub_team_name {
    type:  string
    sql: ${TABLE}.sub_team_name ;;
  }
  measure: count {
    type: count
    drill_fields: [team_name]
  }
}
