include: "/base_views/Google_Sheets/rd_linear_teams_base.view"

view: rd_linear_teams_ext {
  extends: [rd_linear_teams_base]

### DIMENSIONS ----------------

    dimension: department {
      type: string
    }
    dimension: team_name {
      type: string
    }
  dimension: sub_team_name {
    type:  string
    }
    measure: count {
      type: count
      drill_fields: [team_name]
    }
  }
