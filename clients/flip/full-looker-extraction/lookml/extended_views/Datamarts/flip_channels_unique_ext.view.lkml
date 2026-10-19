include: "/base_views/Datamarts/flip_channels_unique_base.view"

view: flip_channels_unique_ext {

  extends: [flip_channels_unique_base]

  drill_fields: [channel_name, created_timestamp_date, creator_type, is_channel_open, is_channel_deleted, tenant]

  dimension: admin_permissions {
    hidden: yes
  }

  dimension: banner_id {
    type:  string
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

  dimension: creator_type {
    type: string
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

  dimension: external_id {
    type: string
  }
  dimension: has_any_post_interaction_enabled {
    type: yesno
  }
  dimension: has_comments_enabled {
    type: yesno
  }
  dimension: has_download_button_media {
    type: yesno
  }

  dimension: has_download_button_pdf {
    type: yesno
  }
  dimension: has_reactions_enabled {
    type: yesno
  }
  dimension: is_content_in_newsfeed {
    type: yesno
  }

  dimension: is_db_row_deleted {
    type: yesno
    hidden: yes
  }

  dimension: is_channel_deleted {
    type: yesno
  }

  dimension: is_channel_open {
    type: yesno
  }

  dimension: is_member_list_hidden {
    type: yesno
  }

  dimension: is_root {
    type: yesno
    label: "Is managing UG root"
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
    hidden: yes
  }

  dimension: managing_user_group_id {
    type: string
  }

  dimension: member_permissions {
    hidden: yes
  }

  dimension: moderator_permissions {
    hidden: yes
  }

  dimension: channel_creator {
    type: string
  }

  dimension:channel_description_character_count {
    type: number
    hidden:  yes
  }

  dimension: channel_description_word_count {
    type: number
    hidden: yes
  }

  dimension: channel_id {
    type: string
    primary_key: yes
  }

  dimension: channel_name {
    type: string
    hidden: no # staging only
  }

  dimension: tenant {
    type: string
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

  dimension: is_approval_needed {
    type: yesno
  }

# --- MANUALLY ADDED DIMENSIONS -----------------------------

  # dimension: post_group_name_open_only { # only needed for staging
  #   type: string
  #   sql:
  #     CASE WHEN ${is_group_open} IS true THEN ${post_group_name}
  #     WHEN ${post_group_name} IN ("Flipship", "Flip Stars", "People News", "Won Deals", "Bugreports", "Weekly Updates", "OKRs") THEN ${post_group_name}
  #     ELSE "[Private Group]" END ;;
  #   label: "Post Group Name (limited)"
  # }

dimension: is_managed_by_user_group {
  type: yesno
  sql: CASE WHEN ${managing_user_group_id} IS null THEN false ELSE true END ;;
}

# --- MEASURES ------------------------------------
  measure: count {
    type: count
    drill_fields: [channel_name]
    label: "# Channels"
  }

  measure: channel_description_character_sum {
    type: sum
    sql: ${channel_description_character_count} ;;
    label: "# Channel Description Characters"
  }

  measure: channel_description_character_avg {
    type: average
    sql: ${channel_description_character_count} ;;
    label: "# Channel Description Characters (Avg)"
    value_format_name: decimal_1
  }

  measure: channel_description_word_sum {
    type: sum
    sql: ${channel_description_word_count} ;;
    label: "# Channel Description Words"
  }

  measure: channel_description_word_avg {
    type: average
    sql: ${channel_description_word_count} ;;
    label: "# Channel Description Words (Avg)"
    value_format_name: decimal_1
  }

# --- FIELDS -------

  set: exclude_for_privacy_protection {
    fields: [channel_name]
  }

}
