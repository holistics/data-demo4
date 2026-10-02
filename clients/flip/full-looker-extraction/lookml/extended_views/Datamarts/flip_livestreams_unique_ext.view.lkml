include: "/base_views/Datamarts/flip_livestreams_unique_base.view"
view: flip_livestreams_unique_ext {
  extends: [flip_livestreams_unique_base]

#---DIMENSIONS----------------------------

  dimension: livestream_id {
    type: string
    primary_key:  yes
  }
  dimension: actor_id {
    type: string
  }
  dimension_group: created_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension_group: db_row_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension: external_id {
    type: string
  }
  dimension: external_provider {
    type: string
  }
  dimension: is_db_row_deleted {
    type: yesno
  }
  dimension: is_livestream_deleted {
    type: yesno
  }
  dimension: livestream_status {
    type: string
  }
  dimension_group: scheduled_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension: tenant {
    type: string
  }
  dimension_group: updated_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension: viewer_count {
    type: number
    hidden: yes
  }

  #--------------MANUALLY ADDED DIMENSIONS---------------------

#------------MEASURES---------------------------

  measure: count {
    type: count
    label: "# livestreams"
  }
  measure: viewers_count {
    type: sum
    sql: ${viewer_count} ;;
    label: "# Viewers"
    description: "Count of viewers."
  }
}
