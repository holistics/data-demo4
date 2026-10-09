include: "/base_views/Google_Sheets/cs_biweekly_vibe_survey_base.view"

view: cs_biweekly_vibe_survey_ext {
  extends: [cs_biweekly_vibe_survey_base]

# ---- DIMENSIONS ------------------

  dimension: giving_high_five_to_ {
    type: string
    label: "Giving high five to 💯"
  }
  dimension: rating {
    type: number
  }
  dimension_group: timestamp {
    type: time
    description: "%m/%d/%Y %H:%M:%E*S"
    timeframes: [raw, time, date, week, week_of_year, month, quarter, year]
  }
  dimension: what_went_not_so_well_ {
    type: string
    description: "What went not so well 😥"
  }
  dimension: what_went_well_ {
    type: string
    description: "What went well 🙌"
  }

  dimension: timestamp_pk {
    sql: ${timestamp_raw} ;;
    primary_key: yes
    hidden: yes
  }

# ---- MEASURES
  measure: count {
    type: count
    label: "# Survey Responses"
  }

  measure: rating_avg {
    type: average
    sql: ${rating} ;;
    value_format_name: decimal_1
    drill_fields: [timestamp_week, rating_avg, rating_max, rating_min]
  }

  measure: rating_max {
    type: max
    sql: ${rating} ;;
  }

  measure: rating_min {
    type: min
    sql: ${rating} ;;
  }
  }
