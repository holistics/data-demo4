view: flip_tenants_daily_aggregations_historized_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_tenants_daily_aggregations_historized` ;;

  dimension: au_active_30d {
    type: number
    sql: ${TABLE}.au_active_30d ;;
  }
  dimension: au_active_7d {
    type: number
    sql: ${TABLE}.au_active_7d ;;
  }
  dimension: au_active_90d {
    type: number
    sql: ${TABLE}.au_active_90d ;;
  }
  dimension: au_active_today {
    type: number
    sql: ${TABLE}.au_active_today ;;
  }
  dimension: au_inactive {
    type: number
    sql: ${TABLE}.au_inactive ;;
  }
  dimension: calendar_event_participations {
    type: number
    sql: ${TABLE}.calendar_event_participations ;;
  }
  dimension: calendar_events {
    type: number
    sql: ${TABLE}.calendar_events ;;
  }
  dimension: chats {
    type: number
    sql: ${TABLE}.chats ;;
  }
  dimension: comment_reactions {
    type: number
    sql: ${TABLE}.comment_reactions ;;
  }
  # dimension: created_users {
  #   type: number
  #   sql: ${TABLE}.created_users ;;
  # }
  # dimension: created_users_gross {
  #   type: number
  #   sql: ${TABLE}.created_users_gross ;;
  # }
  dimension_group: date_berlin {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_berlin ;;
  }
  dimension: dau {
    type: number
    sql: ${TABLE}.dau ;;
  }
  dimension: dau_30d_avg {
    type: number
    sql: ${TABLE}.dau_30d_avg ;;
  }
  dimension: dau_30d_avg_percentage_onboarded {
    type: number
    sql: ${TABLE}.dau_30d_avg_percentage_onboarded ;;
  }
  dimension: dau_percentage_onboarded {
    type: number
    sql: ${TABLE}.dau_percentage_onboarded ;;
  }
  dimension: is_tenant_deleted {
    type: yesno
    sql: ${TABLE}.is_tenant_deleted ;;
  }
  dimension: licences_sold {
    type: number
    sql: ${TABLE}.licences_sold ;;
  }
  dimension: licence_success_rate_sold {
    type: number
    sql: ${TABLE}.licence_success_rate_sold ;;
  }
  dimension: mau_percentage_onboarded {
    type: number
    sql: ${TABLE}.mau_percentage_onboarded ;;
  }
  dimension: mau {
    type: number
    sql: ${TABLE}.mau ;;
  }
  dimension: mau_30d_avg {
    type: number
    sql: ${TABLE}.mau_30d_avg ;;
  }
  dimension: message_reactions {
    type: number
    sql: ${TABLE}.message_reactions ;;
  }
  dimension: messages {
    type: number
    sql: ${TABLE}.messages ;;
  }
  dimension: parent_user_groups {
    type: number
    sql: ${TABLE}.parent_user_groups ;;
  }
  # dimension: new_onboarded_users_today {
  #   type: number
  #   sql: ${TABLE}.new_onboarded_users_today ;;
  # }
  # dimension: new_onboarded_users_today_added {
  #   type: number
  #   sql: ${TABLE}.new_onboarded_users_today_added ;;
  # }
  # dimension: onboarded_users {
  #   type: number
  #   sql: ${TABLE}.onboarded_users ;;
  # }
  dimension: post_comments {
    type: number
    sql: ${TABLE}.post_comments ;;
  }
  dimension: post_reactions {
    type: number
    sql: ${TABLE}.post_reactions ;;
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
  dimension: pages_published {
    type: number
    sql: ${TABLE}.pages_published ;;
  }
  dimension: running_total_pages_published {
    type: number
    sql: ${TABLE}.running_total_pages_published ;;
  }
  dimension: user_groups {
    type: number
    sql: ${TABLE}.user_groups ;;
  }
  dimension: users_created {
    type: number
    sql: ${TABLE}.users_created ;;
  }
  dimension: users_created_gross {
    type: number
    sql: ${TABLE}.users_created_gross ;;
  }
  dimension: users_created_active {
    type: number
    sql: ${TABLE}.users_created_active ;;
  }
  dimension: users_onboarded {
    type: number
    sql: ${TABLE}.users_onboarded ;;
  }
  dimension: users_onboarded_added_today { # non-negative amount
    type: number
    sql: ${TABLE}.users_onboarded_added_today ;;
  }
  dimension: users_onboarded_change_today {
    type: number
    sql: ${TABLE}.users_onboarded_change_today;;
  }
  dimension: users_status_deleted {
    type: number
    sql: ${TABLE}.users_status_deleted;;
  }
  dimension: users_status_pending_deletion {
    type: number
    sql: ${TABLE}.users_status_pending_deletion;;
  }
  dimension: wau {
    type: number
    sql: ${TABLE}.wau ;;
  }
  dimension: wau_30d_avg {
    type: number
    sql: ${TABLE}.wau_30d_avg ;;
  }
  dimension: wau_percentage_onboarded {
    type: number
    sql: ${TABLE}.wau_percentage_onboarded ;;
  }
  measure: count {
    type: count
  }
}
