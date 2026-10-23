include: "/base_views/Google_Sheets/rd_weekly_vibe_survey_base.view"

view: rd_weekly_vibe_survey_ext {
 extends: [rd_weekly_vibe_survey_base]

    dimension: department {
      type: string
    }
    dimension: giving_high_five {
      type: string
      label: "Giving high five to🫸🫷"
    }
    dimension_group: timestamp {
      type: time
      timeframes: [raw, time, date, week, week_of_year, month, quarter, year]
    }
    dimension: week_rating {
      type: number
      hidden: yes
    }
    dimension: what_went_bad {
      type: string
      label: "What went not so well 🫠"
    }
    dimension: what_went_well {
      type: string
      label: "What went well 🙌"
    }

    dimension: timestamp_pk {
      sql: ${timestamp_raw} ;;
      primary_key: yes
      hidden: yes
    }

    dimension: week_starting_wednesdays {
      sql:
       EXTRACT(WEEK(WEDNESDAY) FROM ${timestamp_date});;
      label: "Calendar Week (Wed)"
    }

  # --- MEASURES
    measure: count {
      type: count
      label: "# Survey Responses"
    }

    measure: weekly_rating_avg {
      type: average
      sql: ${week_rating} ;;
      value_format_name: decimal_1
      drill_fields: [timestamp_week, department, weekly_rating_avg, weekly_rating_max, weekly_rating_min]
    }

    measure: weekly_rating_max {
      type: max
      sql: ${week_rating} ;;
    }

  measure: weekly_rating_min {
    type: min
    sql: ${week_rating} ;;
  }
  }
