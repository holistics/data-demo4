include: "/base_views/Datamarts/flip_reactions_unique_base.view"

view: flip_reactions_unique_ext {

  extends: [flip_reactions_unique_base]

  # drill_fields: [reaction_id, reaction_element_type, created_timestamp_date, tenant]

# --- DIMENSIONS ----------------------------------------------------------------------------
  dimension: actor_id {
    type: string
  }

  dimension_group: created_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      minute30,
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

  dimension_group: published_timestamp {
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

  dimension: reaction_element_id {
    type: string
    hidden: no
  }

  dimension: reaction_element_type {
    type: string
  }

  dimension: reaction_id {
    type: string
    primary_key: yes
  }

  dimension: reaction_type {
    type: string
  }

  dimension: tenant {
    type: string
    hidden: no
  }

  dimension: updated_count {
    type: number
    hidden: yes
  }

  dimension: updated_distinct_count {
    type: number
  }

  dimension_group: updated_timestamp {
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

  dimension: user_element_id {
    type: string
  }

  dimension: user_id {
    type: string
  }

  # --- MEASURES -----------------------------
  measure: count {
    type: count
    label: "# Reactions"
    description: "Count of unique reaction_ids."
  }

  measure: user_id_count {
    type: count_distinct
    sql: ${user_id} ;;
    label: "# Users"
  }

  measure: reaction_thumbs_up_count {
    type: count
    filters: [reaction_type: "THUMBS_UP"]
    label: "# Reactions Thumbs-Up"
  }

  measure: reaction_heart_count {
    type: count
    filters: [reaction_type: "HEART"]
    label: "# Reactions Heart"
  }

  measure: reaction_clapping_count {
    type: count
    filters: [reaction_type: "CLAPPING"]
    label: "# Reactions Clapping"
  }

  measure: reaction_happy_count {
    type: count
    filters: [reaction_type: "HAPPY"]
    label: "# Reactions Happy"
  }

  measure: reaction_inspring_count {
    type: count
    filters: [reaction_type: "INSPIRING"]
    label: "# Reactions Inspriring"
  }

  measure: reaction_sad_count {
    type: count
    filters: [reaction_type: "SAD"]
    label: "# Reactions Sad"
  }

  measure: updated_count_sum {
    type: sum
    sql: ${updated_count} ;;
    label: "# Updates"
    description: "Count of reaction type changes."
  }

  measure: updated_count_avg {
    type: average
    sql: ${updated_count} ;;
    label: "# Updates (Avg)"
    description: "Count of reaction type changes."
    value_format_name: decimal_1
  }
}
