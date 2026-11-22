# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
explore: flip_s_channels_unique_base {
  hidden: yes

  join: flip_s_channels_unique__admin_permissions {
    view_label: "Flip Channels Unique: Admin Permissions"
    sql: LEFT JOIN UNNEST(${flip_s_channels_unique_base.admin_permissions}) as flip_channels_unique__admin_permissions ;;
    relationship: one_to_many
  }

  join: flip_s_channels_unique__member_permissions {
    view_label: "Flip Channels Unique: Member Permissions"
    sql: LEFT JOIN UNNEST(${flip_s_channels_unique_base.member_permissions}) as flip_channels_unique__member_permissions ;;
    relationship: one_to_many
  }

  join: flip_s_channels_unique__moderator_permissions {
    view_label: "Flip Channels Unique: Moderator Permissions"
    sql: LEFT JOIN UNNEST(${flip_s_channels_unique_base.moderator_permissions}) as flip_channels_unique__moderator_permissions ;;
    relationship: one_to_many
  }
}

view: flip_s_channels_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_staging_poc.flip_channels_unique` ;;

  dimension: admin_permissions {
    hidden: yes
    sql: ${TABLE}.admin_permissions ;;
  }

  dimension: banner_id {
    type:  string
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

  dimension: creator_type {
    type: string
    sql: ${TABLE}.creator_type ;;
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

  dimension: has_download_button_media {
    type: yesno
    sql: ${TABLE}.has_download_button_media ;;
  }

  dimension: has_download_button_pdf {
    type: yesno
    sql: ${TABLE}.has_download_button_pdf ;;
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

  dimension: is_post_interaction_enabled {
    type: yesno
    sql: ${TABLE}.is_post_interaction_enabled ;;
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

  dimension: member_permissions {
    hidden: yes
    sql: ${TABLE}.member_permissions ;;
  }

  dimension: moderator_permissions {
    hidden: yes
    sql: ${TABLE}.moderator_permissions ;;
  }

  dimension: channel_creator {
    type: string
    sql: ${TABLE}.channel_creator ;;
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

  dimension: channel_name {
    type: string
    sql: ${TABLE}.channel_name ;;
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

  measure: count {
    type: count
    drill_fields: [channel_name]
  }
}

view: flip_s_channels_unique__admin_permissions {
  dimension: flip_channels_unique__admin_permissions {
    type: string
    sql: flip_channels_unique__admin_permissions ;;
  }
}

view: flip_s_channels_unique__member_permissions {
  dimension: flip_channels_unique__member_permissions {
    type: string
    sql: flip_channels_unique__member_permissions ;;
  }
}

view: flip_s_channels_unique__moderator_permissions {
  dimension: flip_channels_unique__moderator_permissions {
    type: string
    sql: flip_channels_unique__moderator_permissions ;;
  }
}
