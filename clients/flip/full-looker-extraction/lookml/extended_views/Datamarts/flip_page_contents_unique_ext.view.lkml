include: "/base_views/Datamarts/flip_page_contents_unique_base.view"

view: flip_page_contents_unique_ext {
  extends: [flip_page_contents_unique_base]

# --- DIMENSIONS ------------------------

    dimension: body_character_count {
      type: number
      hidden: yes
    }
    dimension: body_word_count {
      type: number
      hidden: yes
    }
    dimension_group: created_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: created_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }
    dimension_group: db_row_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: db_row_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }
    dimension: is_db_row_deleted {
      type: yesno
    }
    dimension: locale {
      type: string
    }
    dimension: locale_ranking_desc {
      type: number
    }
    dimension: page_id {
      type: string
    }
    dimension: primary_key {
      type: string
      primary_key: yes
    }
    dimension: tenant {
      type: string
    }
    dimension: title {
      type: string
      hidden: yes # pii / not per default for PMs
    }
    dimension_group: updated_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: updated_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }

# --- MEASURES -----------------------------------------------
    measure: count {
      type: count
      label: "# Content Versions per Page"
    }

    measure: body_character_count_sum {
      type: sum
      sql: ${body_character_count} ;;
      label: "# Body Characters"
    }

    measure: body_character_count_avg {
      type: average
      sql: ${body_character_count} ;;
      label: "# Body Characters (avg)"
    }

  measure: body_word_count_sum {
    type: sum
    sql: ${body_word_count} ;;
    label: "# Body Words"
  }

  measure: body_word_count_avg {
    type: average
    sql: ${body_word_count} ;;
    label: "# Body Words (avg)"
  }
  }
