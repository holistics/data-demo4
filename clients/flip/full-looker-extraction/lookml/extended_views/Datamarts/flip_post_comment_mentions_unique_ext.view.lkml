include: "/base_views/Datamarts/flip_post_comment_mentions_unique_base.view"

view: flip_post_comment_mentions_unique_ext {
  extends: [flip_post_comment_mentions_unique_base]

  # --- BASE DIMENSIONS -------------------------------

  dimension: comment_id {
    type: string
  }
  dimension_group: created_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension_group: created_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension_group: db_row_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension_group: db_row_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension: is_db_row_deleted {
    type: yesno
  }
  dimension: is_deleted {
    type: yesno
  }
  dimension: mentioned_user_id {
    type: string

  }
  dimension: post_comment_mention_id {
    type: string
    primary_key: yes
  }
  dimension: tenant {
    type: string

# --- MANUALLY ADDED DIMENSIONS

# ---- MEASURES ------------

  }
  measure: count {
    type: count
    label: "# Post Comment Mentions"
  }
}
