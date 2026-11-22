explore: flip_channels_unique_base {
  hidden: yes

  join: flip_channels_unique__admin_permissions {
    view_label: "Flip Channel Unique: Admin Permissions"
    sql: LEFT JOIN UNNEST(${flip_channels_unique_base.admin_permissions}) as flip_channels_unique__admin_permissions ;;
    relationship: one_to_many
  }

  join: flip_channels_unique__member_permissions {
    view_label: "Flip Post Groups Unique: Member Permissions"
    sql: LEFT JOIN UNNEST(${flip_channels_unique_base.member_permissions}) as flip_channels_unique__member_permissions ;;
    relationship: one_to_many
  }

  join: flip_channels_unique__moderator_permissions {
    view_label: "Flip Channels Unique: Moderator Permissions"
    sql: LEFT JOIN UNNEST(${flip_channels_unique_base.moderator_permissions}) as flip_channels_unique__moderator_permissions ;;
    relationship: one_to_many
  }
}

view: flip_channels_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_channels_unique`
    ;;

  dimension: admin_permissions {
    hidden: yes
    sql: ${TABLE}.admin_permissions ;;
  }

  dimension: banner_id {
    type: string
    sql: ${TABLE}.banner_id ;;
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
    sql: ${TABLE}.created_timestamp ;;
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
    sql: ${TABLE}.db_row_timestamp ;;
  }

  dimension: has_any_post_interaction_enabled {
    type: yesno
    sql: ${TABLE}.has_any_post_interaction_enabled ;;
  }
  dimension: has_comments_enabled {
    type: yesno
    sql: ${TABLE}.has_comments_enabled ;;
  }
  dimension: has_download_button_media {
    type: yesno
    sql: ${TABLE}.has_download_button_media ;;
  }

  dimension: has_download_button_pdf {
    type: yesno
    sql: ${TABLE}.has_download_button_pdf ;;
  }
  dimension: has_reactions_enabled {
    type: yesno
    sql: ${TABLE}.has_reactions_enabled ;;
  }
  dimension: is_content_in_newsfeed {
    type: yesno
    sql: ${TABLE}.is_content_in_newsfeed ;;
  }

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: is_channel_deleted {
    type: yesno
    sql: ${TABLE}.is_channel_deleted ;;
  }

  dimension: is_channel_open {
    type: yesno
    sql: ${TABLE}.is_channel_open ;;
  }

  dimension: is_member_list_hidden {
    type: yesno
    sql: ${TABLE}.is_member_list_hidden ;;
  }
  dimension: is_root {
    type: yesno
    sql: ${TABLE}.is_root ;;
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
    sql: ${TABLE}.last_modified_by_sync_api_timestamp ;;
  }

  dimension: managing_user_group_id {
    type: string
    sql: ${TABLE}.managing_user_group_id ;;
  }

  dimension: member_permissions {
    hidden: yes
    sql: ${TABLE}.member_permissions ;;
  }

  dimension: moderator_permissions {
    hidden: yes
    sql: ${TABLE}.moderator_permissions ;;
  }

  dimension: channel_description_character_count {
    type: number
    sql: ${TABLE}.channel_description_character_count ;;
  }

  dimension: channel_description_word_count {
    type: number
    sql: ${TABLE}.channel_description_word_count ;;
  }

  dimension: channel_id {
    type: string
    sql: ${TABLE}.channel_id ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
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
    sql: ${TABLE}.updated_timestamp ;;
  }

  dimension: is_approval_needed {
    type: yesno
    sql: ${TABLE}.is_approval_needed ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

view: flip_channels_unique__admin_permissions {
  dimension: flip_channels_unique__admin_permissions {
    type: string
    sql: flip_channels_unique__admin_permissions ;;
  }
}

view: flip_channels_unique__member_permissions {
  dimension: flip_channels_unique__member_permissions {
    type: string
    sql: flip_channels_unique__member_permissions ;;
  }
}

view: flip_channels_unique__moderator_permissions {
  dimension: flip_channels_unique__moderator_permissions {
    type: string
    sql: flip_channels_unique__moderator_permissions ;;
  }
}
