include: "/base_views/Datamarts/flip_channel_memberships_unique_base.view"

view: flip_channel_memberships_unique_ext {

  extends: [flip_channel_memberships_unique_base]

  drill_fields: [channel_membership_id, user_id, channel_name, tenant, membership_role]

# --- BASE DIMENSIONS -------------------------------

  dimension_group: created_at_timestamp {
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

  dimension: creator_type {
    type: string
  }

  dimension: creating_service_type {
    type: string
    description: "Service Type that created the membership. In case of SYNC can be overwritten by APP as managing service type."
  }

  dimension: managing_service_type {
    type: string
    description: "Service Type that now manages the membership. In case of creating_service_type = SYNC can be overwritten WITH APP if changes to the membership were made in-app."
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

  dimension: deletion_status {
    type: string
    description: "Values: NOT_DELETED, DELETED, USER_DELETED, CHANNEL_DELETED."
  }

  dimension: is_db_row_deleted {
    type: yesno
    hidden: no
  }

  dimension: is_channel_member_deleted {
    type: yesno

  }

  dimension: is_channel_muted {
    type: yesno

  }

  dimension_group: last_modified_by_sync_api_timestamp {
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

  dimension: left_open_channel {
    type: yesno
  }

  dimension: membership_role {
    type: string

  }

  dimension: channel_id {
    type: string
    hidden: no
  }

  dimension: channel_membership_creator {
    type: string

  }

  dimension: channel_membership_id {
    type: string
    primary_key: yes
  }

  dimension_group: channel_muted_until_timestamp {
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

  dimension: channel_name {
    type: string
    hidden: no # only hidden in staging
  }

  dimension: tenant {
    type: string
  }

  dimension: user_id {
    type: string
    hidden: yes
  }

#-----------------MANUALLY ADDED DIMENSIONS--------------------------------------

#--------------------MEASURES--------------------------------------------------

  measure: count {
    type: count
    label: "# Channel Memberships (all)"
    description: "Count of primary key channel_membership_id."

  }

  measure: count_members {
    type: count
    filters: [membership_role: "MEMBER"]
    label: "# Channel Memberships Member"
    description: "Count of primary key channel_membership_id where membership_role = 'member'."
  }

  measure: count_admins {
    type: count
    filters: [membership_role: "ADMIN"]
    label: "# Channel Memberships Admins"
    description: "Count of primary key channel_membership_id where membership_role = 'admin'."
  }

  measure: user_id_count {
    type: count_distinct
    sql: ${user_id} ;;
    label: "# Users (distinct)"
    description: "Count of unique user_id."
  }

  measure: user_id_count_admin {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [membership_role: "ADMIN"]
    label: "# Admin Users"
    description: "Count of user_ids with admin permission."
  }

  measure: user_id_count_member {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [membership_role: "MEMBER"]
    label: "# Member Users"
    description: "Count of user_ids with member permission."
  }

  # measure: test {
  #   type: median, percentile -> tiers
  #   sql: ${count} ;;
  # }

# --- SETS --------------------------------------
  set: date_fields {
    fields: [
      created_at_timestamp_date, created_at_timestamp_month, created_at_timestamp_quarter, created_at_timestamp_week, created_at_timestamp_raw, created_at_timestamp_time,
      last_modified_by_sync_api_timestamp_date, last_modified_by_sync_api_timestamp_month, last_modified_by_sync_api_timestamp_quarter, last_modified_by_sync_api_timestamp_raw,
      last_modified_by_sync_api_timestamp_time, last_modified_by_sync_api_timestamp_week, last_modified_by_sync_api_timestamp_year,
      channel_muted_until_timestamp_date, channel_muted_until_timestamp_month, channel_muted_until_timestamp_quarter, channel_muted_until_timestamp_raw,
      channel_muted_until_timestamp_time, channel_muted_until_timestamp_week, channel_muted_until_timestamp_year
      ]
  }

  set: exclude_for_privacy_protection {
    fields: [channel_name]
  }

  set: not_relevant_for_cs_explores {
    fields: [creator_type, last_modified_by_sync_api_timestamp_date, last_modified_by_sync_api_timestamp_month, last_modified_by_sync_api_timestamp_quarter, last_modified_by_sync_api_timestamp_raw,
      last_modified_by_sync_api_timestamp_time, last_modified_by_sync_api_timestamp_week, last_modified_by_sync_api_timestamp_year, channel_membership_creator, channel_membership_id,
      tenant]
  }
}
