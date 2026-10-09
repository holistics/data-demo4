include: "/base_views/Datamarts/flip_user_absence_note_mentions_unique_base.view"

view: flip_user_absence_note_mentions_unique_ext {

  extends: [flip_user_absence_note_mentions_unique_base]

  drill_fields: [absence_id, tenant, created_timestamp_date]

#------------DIMENSIONS--------------------------------------

  dimension: absence_id {
    type: string
    hidden: yes
  }

  dimension: absence_mention_id {
    type: string
    primary_key: yes
  }

  dimension_group: created_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]

  }

  dimension_group: db_row_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]

  }

  dimension: is_db_row_deleted {
    type: yesno

  }

  dimension: mentioned_user_id {
    type: string

  }

  dimension: tenant {
    type: string
  }

#-----------MANUALLY ADDED DIMENSIONS-------------------------------------

#------------MEASURES---------------------------------------------

  measure: count {
    type: count
    label: "# Absence Note Mentions"
    description: "Count of unique absence_mention_id"
  }
}
