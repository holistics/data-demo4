include: "/base_views/Datamarts/flip_users_daily_aggregations_historized_base.view"

# --- ARRAY VIEWS -------------------------
view: flip_users_daily_aggregations_historized_ext__channel_ids {
    extends: [flip_users_daily_aggregations_historized_base__channel_ids]
    fields_hidden_by_default: yes
  }

view: flip_users_daily_aggregations_historized_ext__channel_names {
  extends: [flip_users_daily_aggregations_historized_base__channel_names]
  fields_hidden_by_default: yes
}

view: flip_users_daily_aggregations_historized_ext__user_group_ids {
  extends: [flip_users_daily_aggregations_historized_base__user_group_ids]
  fields_hidden_by_default: yes
}

view: flip_users_daily_aggregations_historized_ext__user_group_titles {
  extends: [flip_users_daily_aggregations_historized_base__user_group_titles]
  fields_hidden_by_default: yes
}
  view: flip_users_daily_aggregations_historized_ext {
    extends: [flip_users_daily_aggregations_historized_base]

   # label: "Users Report"

    drill_fields: [user_id, already_logged_in, first_login_timestamp_berlin_date, is_user_enabled, is_user_deleted, tenant]

    # --- DIMENSIONS ---------------------------------------------------------

    dimension: activity_tiers {
      type: string
    }

    dimension: already_logged_in {
      type: yesno
      label: "Is User Onboarded"
      description: "Indicates whether a User has logged in at least once already."
    }

    dimension: already_logged_in_previous {
      type: yesno
      hidden: yes
    }

    dimension: bookmarks_gross {
      type: number
      hidden: yes
    }

    dimension: calendar_event_participations {
      type: number
      hidden: yes
    }

    dimension: calendar_events {
      type: number
      hidden: yes
    }

    dimension: channel_count {
      type: number
      hidden: yes
    }

    dimension: channel_ids {
      hidden: yes
    }

    dimension: channel_names {
      hidden: yes
    }

    dimension: channel_names_string { # used for customer exports
      type: string
    }

    dimension: channel_memberships_per_user {
      type:  number
      hidden: yes
    }

    dimension: channel_memberships_per_post_per_day {
      type:  number
      hidden: yes
    }

    dimension: chats {
      type: number
      hidden: yes
    }

    dimension: comment_reactions {
      type: number
      hidden: yes
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
      hidden: yes
    }

    dimension_group: created_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }

    dimension_group: date_berlin {
      label: "Report"
      type: time
      timeframes: [
        raw,
        time,
        date,
        day_of_week,
        week,
        week_of_year,
        month,
        quarter,
        year
      ]
      convert_tz: no
      datatype: date
    }

    dimension: days_since_last_action {
      type: number
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
      hidden: yes
    }

    dimension_group: db_row_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }

    dimension_group: first_login_timestamp_berlin {
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

    dimension_group: first_login_timestamp_filled_berlin {
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

    dimension: group_chat_count {
      type: number
      hidden: yes
    }

    dimension: has_about_me_text {
      type: yesno
      hidden: yes
    }

    dimension: has_profile_picture {
      type: yesno
      hidden: yes
    }

    dimension: has_push_noti_resting_days_activated {
      type: yesno
      hidden: yes
    }

    dimension: has_push_noti_resting_period_activated {
      type: yesno
      hidden: yes
    }

    dimension: is_daily_active {
      type: yesno
    }

    dimension: is_db_row_deleted {
      type: yesno
      hidden: yes
    }

    dimension: is_monthly_active {
      type: yesno
    }

    dimension: is_user_deleted {
      type: yesno
    }

    dimension: is_user_enabled {
      type: yesno
    }

    dimension: is_weekly_active {
      type: yesno
    }

    dimension_group: last_activity_timestamp_berlin {
      type: time
      timeframes: [
        raw,
        date,
        week,
        month,
        quarter,
        year
      ]
      convert_tz: no
      datatype: date
      hidden:  yes
    }

    dimension_group: last_modified_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }

    dimension: message_reactions {
      type: number
      hidden:  yes
    }

    dimension: messages {
      type: number
      hidden: yes
    }

    dimension: missed_notification_count {
      type: number
      hidden: yes
    }

    dimension: moving_average_dau_contribution_30d {
      type: number
      hidden: yes
    }

    dimension: moving_average_dau_contribution_7d {
      type: number
      hidden: yes
    }

    dimension: moving_average_mau_contribution_30d {
      type: number
      hidden: yes
    }

    dimension: moving_average_mau_contribution_7d {
      type: number
      hidden: yes
    }

    dimension: moving_average_wau_contribution_30d {
      type: number
      hidden: yes
    }

    dimension: moving_average_wau_contribution_7d {
      type: number
      hidden: yes
    }

    dimension: post_comments {
      type: number
      hidden: yes
    }
    dimension: post_reactions {
      type: number
      hidden: yes
    }

    dimension: post_seens_per_post { # agg on post-published date
      type: number
      hidden: yes
    }

    dimension: post_seens_per_user { # agg per user_id
      type: number
      hidden: yes
    }

    dimension: posts {
      type: number
      hidden: yes
    }
    dimension: posts_with_survey {
      type: number
      hidden: yes
    }

    # dimension: post_group_count {
    #   type: number
    #   hidden: yes
    # }

    dimension: primary_key {
      type: string
      primary_key: yes
      hidden: yes
    }

    dimension: private_chat_count {
      type: number
      hidden: yes
    }

    dimension: push_noti_resting_days {
      type: number
      hidden: yes
    }

    dimension: push_noti_resting_period_end_time {
      type: string
      hidden: yes
    }

    dimension: push_noti_resting_period_start_time {
      type: string
      hidden: yes
    }

    dimension: survey_votes {
      type: number
      hidden: yes
    }

    dimension: system_role {
      type: string
    }

    dimension: task_comment_reactions {
      type: number
      hidden:  yes
    }

    dimension: tasks {
      type: number
      hidden:  yes
    }

    dimension: tenant {
      type: string
    }

    dimension: total_post_interactions {
      type: number
      hidden:  yes
    }

    dimension: total_post_reactions {
      type: number
      hidden:  yes
    }

    dimension: total_reactions {
      type: number
      hidden:  yes
    }

    dimension: translated_characters_per_author {
      type: number
      hidden:  yes
    }

    dimension: user_contribution_type {
      type: string
      hidden:  yes
    }

    dimension: user_group_ids {
      hidden: yes
    }

    dimension: user_group_titles {
      hidden: yes
    }

    dimension: user_group_titles_string {
      type: string
    }

    dimension: user_id {
      type: string
      hidden: no
    }

    dimension: user_language {
      type: string
      hidden: yes
    }

    dimension: user_status {
      type: string
    }

    dimension: user_timezone {
      type: string
      hidden: yes
    }

# ----- MANUALLY ADDED DIMENSIONS ----------------------------------------------------

    dimension: now_vs_30d_ago {
      type: yesno
      sql: DATE_DIFF(current_date(), ${date_berlin_date},  DAY) IN (0,30)  ;;
    }

    dimension: now_vs_14d_ago {
      type: yesno
      sql: DATE_DIFF(current_date(), ${date_berlin_date},  DAY) IN (0,14)  ;;
    }

    dimension: now_vs_7d_ago {
      type: yesno
      sql: DATE_DIFF(current_date(), ${date_berlin_date},  DAY) IN (0,7)  ;;
    }

    dimension: yesterday_vs_30d_ago {
      type: yesno
      sql: DATE_DIFF(current_date(), ${date_berlin_date},  DAY) IN (1,31)  ;;
    }

    dimension: yesterday_vs_14d_ago {
      type: yesno
      sql: DATE_DIFF(current_date(), ${date_berlin_date},  DAY) IN (1,15)  ;;
    }

    dimension: yesterday_vs_7d_ago {
      type: yesno
      sql: DATE_DIFF(current_date(), ${date_berlin_date},  DAY) IN (1,8)  ;;
    }

    dimension: is_last_day_of_month {
      type: yesno
      sql: date(${date_berlin_date}) = last_day(date(${date_berlin_date}), month)
        OR DATE(${date_berlin_date}) = CURRENT_DATE();;
      description: "Filters for the last day of each month. Current month: today"
    }

    dimension: last_30d_dimension {
      type: string
      sql: CASE
            WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 29 THEN "last 30d"
            WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 59 THEN "last 31-60d"
            END ;;
    }

    dimension: last_14d_dimension {
      type: string
      sql: CASE
            WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 13 THEN "last 14d"
            WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 27 THEN "last 15-28d"
            END ;;
    }

    dimension: last_7d_dimension {
      type: string
      sql: CASE
          WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 6 THEN "last 7d"
          WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 14 THEN "last 8-14d"
          END ;;
    }

    dimension: yesterday_last_30d_dimension {
      type: string
      sql: CASE
            WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) BETWEEN 1 AND 30 THEN "last 30d"
            WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) BETWEEN 31 AND 60 THEN "last 31-60d"
            END ;;
    }

    dimension: yesterday_last_14d_dimension {
      type: string
      sql: CASE
            WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) BETWEEN 1 AND 14 THEN "last 14d"
            WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) BETWEEN 15 AND 28 THEN "last 15-28d"
            END ;;
    }

    dimension: yesterday_last_7d_dimension {
      type: string
      sql: CASE
          WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) BETWEEN 1 AND 7 THEN "last 7d"
          WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) BETWEEN 8 AND 14 THEN "last 8-14d"
          END ;;
    }

    # dimension: channel_memberships_tier {
    #   label: "Channel Memberships Tier"
    #   type: tier
    #   sql: ${channel_memberships_per_user} ;;
    #   tiers: [1, 2, 3, 4, 6, 11, 21]
    # }

    dimension: channel_memberships_tier {
      label: "Channel Memberships Tier"
      type: string
      case: {
        # Individual Buckets
        when: {
          sql: ${channel_memberships_per_user} = 1 ;;
          label: "01 membership"
        }
        when: {
          sql: ${channel_memberships_per_user} = 2 ;;
          label: "02 memberships"
        }
        when: {
          sql: ${channel_memberships_per_user} = 3 ;;
          label: "03 memberships"
        }
        # Range Buckets (4-5)
        when: {
          sql: ${channel_memberships_per_user} >= 4 AND ${channel_memberships_per_user} <= 5 ;;
          label: "04-05 memberships"
        }
        # Larger Range Buckets (6-10)
        when: {
          sql: ${channel_memberships_per_user} >= 6 AND ${channel_memberships_per_user} <= 10 ;;
          label: "06-10 memberships"
        }
        # Larger Range Buckets (11-20)
        when: {
          sql: ${channel_memberships_per_user} >= 11 AND ${channel_memberships_per_user} <= 20 ;;
          label: "11-20 memberships"
        }
        # Top Bucket (>20)
        when: {
          sql: ${channel_memberships_per_user} > 20 ;;
          label: "21+ memberships"
        }
        else: "0 or Unclassified"
      }
    }

    # --- MEASURES -------------------------------

    measure: count { # counts the total number of rows (days * users) - no biz meaning
      type: count
      hidden: no
      label: "# Users"
    }

    measure: users_created_gross_count_distinct {
      type: count_distinct
      sql: ${user_id} ;;
      drill_fields: [user_id, already_logged_in, is_user_enabled, is_user_deleted, tenant]
      label: "# Users created Gross"
      description: "Count of unique user_ids. Includes all users that were created in the system (gross)."
    }

    measure: users_created_net_count_distinct {
      type: count_distinct
      sql: ${user_id} ;;
      drill_fields: [user_id, already_logged_in, is_user_enabled, is_user_deleted, tenant]
      filters: [is_user_deleted: "No"]
      label: "# Users created"
      description: "Count of unique user_ids that were not deleted."
    }

    measure: users_enabled_net_count_distinct {
      type: count_distinct
      sql: ${user_id} ;;
      label: "# Users enabled"
      filters: [is_user_enabled: "Yes", is_user_deleted: "No"]
      description: "Count of unique user_ids where is_user_enabled is true and is_user_deleted is false. Per default every user is enabled."
    }

    measure: users_disabled_net_count_distinct {
      type: count_distinct
      sql: ${user_id} ;;
      label: "# Users disabled"
      filters: [is_user_enabled: "No", is_user_deleted: "No"]
      description: "Count of unique user_ids where is_user_enabled is false and is_user_deleted is false."
    }

    measure: users_deleted_count_distinct {
      type: count_distinct
      sql: ${user_id} ;;
      label: "# Users deleted"
      filters: [is_user_deleted: "Yes"]
      description: "Count of unique user_ids where is_user_deleted is true."
    }

    measure: users_onboarded_net_count_distinct {
      type: count_distinct
      sql: ${user_id} ;;
      label: "# Users onboarded"
      filters: [already_logged_in: "Yes", is_user_deleted: "No"]
    }

    measure: users_onboarded_gross_count_distinct {
      type: count_distinct
      sql: ${user_id} ;;
      label: "# Users onboarded Gross"
      filters: [already_logged_in: "Yes"]
    }

    measure: daily_active_users_count_distinct {
      type: count_distinct
      sql: ${user_id} ;;
      filters: [is_daily_active: "yes"]
      label: "DAU"
    }

    measure: moving_average_dau_contribution_30d_sum {
      type: sum
      sql: ${moving_average_dau_contribution_30d} ;;
      value_format_name: decimal_2
      label: "DAU (30d avg)"
    }

    measure: weekly_active_users_count_distinct {
      type: count_distinct
      sql: ${user_id} ;;
      filters: [is_weekly_active: "yes"]
      label: "WAU"
    }

    measure: moving_average_wau_contribution_30d_sum {
      type: sum
      sql: ${moving_average_wau_contribution_30d} ;;
      value_format_name: decimal_0
      label: "WAU (30d avg)"
    }

    measure: monthly_active_users_count_distinct {
      type: count_distinct
      sql: ${user_id} ;;
      filters: [is_monthly_active: "yes"]
      label: "MAU"
    }

    measure: moving_average_mau_contribution_30d_sum {
      type: sum
      sql: ${moving_average_mau_contribution_30d} ;;
      value_format_name: decimal_0
      label: "MAU (30d avg)"
    }

    measure: posts_sum {
      type: sum
      sql: ${posts} ;;
      label: "# Posts"
    }

    measure: total_post_interactions_sum {
      type: sum
      sql: ${total_post_interactions} ;;
      label: "# Post Interactions"
      description: "All interactions a User can do with a Post on this channel: Post Reactions, Post Comments, Post Comment Reactions, Survey Votes, Bookmarks."
    }

    measure: post_seens_per_user_sum {
      type: sum
      sql: ${post_seens_per_user} ;;
      label: "# Post Seens (per User)"
    }

    measure: post_seens_per_post_sum {
      type: sum
      sql: ${post_seens_per_post} ;;
      label: "# Post Seens (per Post)"
    }

    measure: channel_memberships_sum {
      type: sum
      sql: ${channel_memberships_per_user} ;;
      label: "# Channel Memberships"
    }

    measure: channel_memberships_per_post_per_day_sum {
      type: sum
      sql: ${channel_memberships_per_post_per_day} ;;
      label: "# Channel Memberships (per Post per Day)"
    }

    measure: channel_memberships_per_post_per_day2_sum {
      type: sum
      sql: ${channel_memberships_per_post_per_day} ;;
      label: "# Channel Memberships onb (per Post per Day)"
      filters: [already_logged_in: "Yes"]
    }

    measure: stickiness_days {
      type: number
      sql: (${moving_average_dau_contribution_30d_sum}/NULLIF(${monthly_active_users_count_distinct},0)) * 30 ;;
      label: "Stickiness (days)"
      value_format_name: decimal_1
    }

    # measure: reach_average {
    #   type: average
    #   sql: ${post_seens}/NULLIF(users_on ;;
    # }

  }
