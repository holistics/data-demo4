# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
# explore: flip_users_daily_aggregations_historized {
#   hidden: yes
#     join: flip_users_daily_aggregations_historized__channel_ids {
#       view_label: "Flip Users Daily Aggregations Historized: Channel Ids"
#       sql: LEFT JOIN UNNEST(${flip_users_daily_aggregations_historized.channel_ids}) as flip_users_daily_aggregations_historized__channel_ids ;;
#       relationship: one_to_many
#     }
#     join: flip_users_daily_aggregations_historized__push_noti_resting_days {
#       view_label: "Flip Users Daily Aggregations Historized: Push Noti Resting Days"
#       sql: LEFT JOIN UNNEST(${flip_users_daily_aggregations_historized.push_noti_resting_days}) as flip_users_daily_aggregations_historized__push_noti_resting_days ;;
#       relationship: one_to_many
#     }

# more views below for channel_names, user_group_ids, user_group_titles
# }
view: flip_users_daily_aggregations_historized_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_users_daily_aggregations_historized` ;;

  dimension: activity_tiers {
    type: string
    sql: ${TABLE}.activity_tiers ;;
  }
  dimension: already_logged_in {
    type: yesno
    sql: ${TABLE}.already_logged_in ;;
  }
  dimension: already_logged_in_previous {
    type: yesno
    sql: ${TABLE}.already_logged_in_previous ;;
  }
  dimension: bookmarks_gross {
    type: number
    sql: ${TABLE}.bookmarks_gross ;;
  }
  dimension: calendar_event_participations {
    type: number
    sql: ${TABLE}.calendar_event_participations ;;
  }
  dimension: calendar_events {
    type: number
    sql: ${TABLE}.calendar_events ;;
  }
  dimension: channel_count {
    type: number
    sql: ${TABLE}.channel_count ;;
  }
  dimension: channel_ids {
    hidden: yes
    sql: ${TABLE}.channel_ids ;;
  }
  dimension: channel_names {
    hidden: yes
    sql: ${TABLE}.channel_names ;;
  }
  dimension: channel_names_string {
     type: string
    sql: ${TABLE}.channel_names_string ;;
  }
  dimension: channel_memberships_per_user {
    type:  number
    sql: ${TABLE}.channel_memberships_per_user ;;
  }
  dimension: channel_memberships_per_post_per_day {
    type:  number
    sql: ${TABLE}.channel_memberships_per_post_per_day ;;
  }
  dimension: chats {
    type: number
    sql: ${TABLE}.chats ;;
  }
  dimension: comment_reactions {
    type: number
    sql: ${TABLE}.comment_reactions ;;
  }
  dimension_group: created_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_timestamp ;;
  }
  dimension_group: created_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_timestamp_berlin ;;
  }
  dimension_group: date_berlin {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_berlin ;;
  }
  dimension: days_since_last_action {
    type: number
    sql: ${TABLE}.days_since_last_action ;;
  }
  dimension_group: db_row_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp ;;
  }
  dimension_group: db_row_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.db_row_timestamp_berlin ;;
  }
  dimension_group: first_login_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.first_login_timestamp_berlin ;;
  }
  dimension_group: first_login_timestamp_filled_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.first_login_timestamp_filled_berlin ;;
  }
  dimension: group_chat_count {
    type: number
    sql: ${TABLE}.group_chat_count ;;
  }
  dimension: has_about_me_text {
    type: yesno
    sql: ${TABLE}.has_about_me_text ;;
  }
  dimension: has_profile_picture {
    type: yesno
    sql: ${TABLE}.has_profile_picture ;;
  }
  dimension: has_push_noti_resting_days_activated {
    type: yesno
    sql: ${TABLE}.has_push_noti_resting_days_activated ;;
  }
  dimension: has_push_noti_resting_period_activated {
    type: yesno
    sql: ${TABLE}.has_push_noti_resting_period_activated ;;
  }
  dimension: is_daily_active {
    type: yesno
    sql: ${TABLE}.is_daily_active ;;
  }
  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }
  dimension: is_monthly_active {
    type: yesno
    sql: ${TABLE}.is_monthly_active ;;
  }
  dimension: is_user_deleted {
    type: yesno
    sql: ${TABLE}.is_user_deleted ;;
  }
  dimension: is_user_enabled {
    type: yesno
    sql: ${TABLE}.is_user_enabled ;;
  }
  dimension: is_weekly_active {
    type: yesno
    sql: ${TABLE}.is_weekly_active ;;
  }
  dimension_group: last_activity_date_berlin {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_activity_date_berlin ;;
  }
  dimension_group: last_modified_timestamp_berlin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.last_modified_timestamp_berlin ;;
  }
  dimension: message_reactions {
    type: number
    sql: ${TABLE}.message_reactions ;;
  }
  dimension: messages {
    type: number
    sql: ${TABLE}.messages ;;
  }
  dimension: missed_notification_count {
    type: number
    sql: ${TABLE}.missed_notification_count ;;
  }
  dimension: moving_average_dau_contribution_30d {
    type: number
    sql: ${TABLE}.moving_average_dau_contribution_30d ;;
  }
  dimension: moving_average_dau_contribution_7d {
    type: number
    sql: ${TABLE}.moving_average_dau_contribution_7d ;;
  }
  dimension: moving_average_mau_contribution_30d {
    type: number
    sql: ${TABLE}.moving_average_mau_contribution_30d ;;
  }
  dimension: moving_average_mau_contribution_7d {
    type: number
    sql: ${TABLE}.moving_average_mau_contribution_7d ;;
  }
  dimension: moving_average_wau_contribution_30d {
    type: number
    sql: ${TABLE}.moving_average_wau_contribution_30d ;;
  }
  dimension: moving_average_wau_contribution_7d {
    type: number
    sql: ${TABLE}.moving_average_wau_contribution_7d ;;
  }
  dimension: post_comments {
    type: number
    sql: ${TABLE}.post_comments ;;
  }
  dimension: post_reactions {
    type: number
    sql: ${TABLE}.post_reactions ;;
  }
  dimension: post_seens_per_post {
    type: number
    sql: ${TABLE}.post_seens_per_post ;;
  }
  dimension: post_seens_per_user {
    type: number
    sql: ${TABLE}.post_seens_per_user ;;
  }
  dimension: posts {
    type: number
    sql: ${TABLE}.posts ;;
  }
  dimension: posts_with_survey {
    type: number
    sql: ${TABLE}.posts_with_survey ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  dimension: private_chat_count {
    type: number
    sql: ${TABLE}.private_chat_count ;;
  }
  dimension: push_noti_resting_days {
    hidden: yes
    sql: ${TABLE}.push_noti_resting_days ;;
  }
  dimension: push_noti_resting_period_end_time {
    type: string
    sql: ${TABLE}.push_noti_resting_period_end_time ;;
  }
  dimension: push_noti_resting_period_start_time {
    type: string
    sql: ${TABLE}.push_noti_resting_period_start_time ;;
  }
  dimension: survey_votes {
    type: number
    sql: ${TABLE}.survey_votes ;;
  }
  dimension: system_role {
    type: string
    sql: ${TABLE}.system_role ;;
  }
  dimension: task_comment_reactions {
    type: number
    sql: ${TABLE}.task_comment_reactions ;;
  }
  dimension: tasks {
    type: number
    sql: ${TABLE}.tasks ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension: total_post_interactions {
    type: number
    sql: ${TABLE}.total_post_interactions ;;
  }
  dimension: total_post_reactions {
    type: number
    sql: ${TABLE}.total_post_reactions ;;
  }
  dimension: total_reactions {
    type: number
    sql: ${TABLE}.total_reactions ;;
  }
  dimension: translated_characters_per_author {
    type: number
    sql: ${TABLE}.translated_characters_per_author ;;
  }
  dimension: user_contribution_type {
    type: string
    sql: ${TABLE}.user_contribution_type ;;
  }
  dimension: user_group_ids {
    hidden: yes
    sql: ${TABLE}.user_group_ids ;;
  }
  dimension: user_group_titles {
    hidden: yes
    sql: ${TABLE}.user_group_titles ;;
  }
  dimension: user_group_titles_string {
    type: string
    sql: ${TABLE}.user_group_titles_string ;;
  }
  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }
  dimension: user_language {
    type: string
    sql: ${TABLE}.user_language ;;
  }
  dimension: user_status {
    type: string
    sql: ${TABLE}.user_status ;;
  }
  dimension: user_timezone {
    type: string
    sql: ${TABLE}.user_timezone ;;
  }
  measure: count {
    type: count
  }
}

view: flip_users_daily_aggregations_historized_base__channel_ids {

  dimension: flip_users_daily_aggregations_historized__channel_ids {
    type: string
    sql: flip_users_daily_aggregations_historized__channel_ids ;;
  }
}

view: flip_users_daily_aggregations_historized_base__channel_names {

  dimension: flip_users_daily_aggregations_historized__channel_names {
    type: string
    sql: flip_users_daily_aggregations_historized__channel_names ;;
  }
}

view: flip_users_daily_aggregations_historized__push_noti_resting_days {

  dimension: flip_users_daily_aggregations_historized__push_noti_resting_days {
    type: number
    sql: flip_users_daily_aggregations_historized__push_noti_resting_days ;;
  }
}

view: flip_users_daily_aggregations_historized_base__user_group_ids {
  dimension: flip_users_daily_aggregations_historized__user_group_ids {
    type: string
    sql: flip_users_daily_aggregations_historized__user_group_ids ;;
  }
}

view: flip_users_daily_aggregations_historized_base__user_group_titles {
  dimension: flip_users_daily_aggregations_historized__user_group_titles {
    type: string
    sql: flip_users_daily_aggregations_historized__user_group_titles ;;
  }
}
