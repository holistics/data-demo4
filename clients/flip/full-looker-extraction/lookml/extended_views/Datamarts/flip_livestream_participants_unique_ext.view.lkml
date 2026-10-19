include: "/base_views/Datamarts/flip_livestream_participants_unique_base.view"

view: flip_livestream_participants_unique_ext {
  extends: [flip_livestream_participants_unique_base]

# --- DIMENSIONS ------------------------

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
  dimension: livestream_id {
    type: string
  }
  dimension: livestream_participant_id {
    type: string
    primary_key: yes
  }
  dimension: livestream_participant_type {
    type: string
  }
  dimension: tenant {
    type: string
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
  dimension: user_id {
    type: string
  }

  # --- MANUALLY ADDED DIMENSIONS

  # ---- MEASURES ------------

  measure: count {
    type: count
    label: "# Livestream Participants"
  }
}
