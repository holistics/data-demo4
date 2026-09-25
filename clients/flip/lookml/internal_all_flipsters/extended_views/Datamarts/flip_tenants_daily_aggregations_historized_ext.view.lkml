include: "/base_views/Datamarts/flip_tenants_daily_aggregations_historized_base.view"
#include: "/extended_views/Datamarts/hubspot_customers_all_ext.view"

view: flip_tenants_daily_aggregations_historized_ext {

extends: [flip_tenants_daily_aggregations_historized_base]

drill_fields: [tenant, users_created_sum, users_onboarded_sum]

# --- DIMENSIONS

    dimension: au_active_30d {
      type: number
      hidden: yes
    }
    dimension: au_active_7d {
      type: number
      hidden: yes
    }
    dimension: au_active_90d {
      type: number
      hidden: yes
    }
    dimension: au_active_today {
      type: number
      hidden: yes
    }
    dimension: au_inactive {
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
    dimension: chats {
      type: number
      hidden: yes
    }
    dimension: comment_reactions {
      type: number
      hidden: yes
    }
    dimension_group: date_berlin {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension: dau {
      type: number
      hidden: yes
    }
    dimension: dau_30d_avg {
      type: number
      hidden: yes
    }
    dimension: dau_30d_avg_percentage_onboarded {
      type: number
      hidden: yes
    }
    dimension: dau_percentage_onboarded {
      type: number
    }
    dimension: is_tenant_deleted {
      type: yesno
    }
  dimension: licences_sold {
    type: number
    hidden: yes
  }
  dimension: licence_success_rate_sold {
    type: number
    hidden: yes
  }
    dimension: mau {
      type: number
      hidden: yes
    }
    dimension: mau_30d_avg {
      type: number
      hidden: yes
    }
  dimension: mau_percentage_onboarded {
    type: number
    hidden: no
  }
    dimension: message_reactions {
      type: number
      hidden: yes
    }
    dimension: messages {
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
    dimension: posts {
      type: number
      hidden: yes
    }
    dimension: posts_with_survey {
      type: number
      hidden: yes
    }
    dimension: primary_key {
      type: string
      primary_key: yes
      hidden: yes
    }

    dimension: task_comment_reactions {
      type: number
      hidden: yes
    }
    dimension: tasks {
      type: number
      hidden: yes
    }
    dimension: tenant {
      type: string

    }
    dimension: total_post_reactions {
      type: number
      hidden: yes
    }
    dimension: total_reactions {
      type: number
      hidden: yes
    }
    dimension: translated_characters_per_author {
      type: number
      hidden: yes
    }
    dimension: pages_published {
    type: number
    hidden: yes
    }
    dimension: running_total_pages_published {
    type: number
    hidden: yes
    }
    dimension: user_groups {
      type: number
      hidden: no
    }
    dimension: parent_user_groups {
      type: number
      hidden: no
    }
    dimension: users_created {
      type: number
      hidden: yes
    }
    dimension: users_created_gross {
      type: number
      hidden: yes
    }
    dimension: users_created_active {
    type: number
    hidden: yes
    }
    dimension: users_onboarded {
      type: number
      hidden: yes
    }
    dimension: users_onboarded_added_today { # non-negative amount
      type: number
      hidden: yes
    }
    dimension: users_onboarded_change_today {
      type: number
      hidden: yes
    }
    dimension: users_status_deleted {
      type: number
      hidden: yes
    }
    dimension: users_status_pending_deletion {
      type: number
      hidden: yes
    }
    dimension: wau {
      type: number
      hidden: yes
    }
    dimension: wau_30d_avg {
      type: number
      hidden: yes
    }
    dimension: wau_percentage_onboarded {
      type: number
      hidden: yes
    }

# ---- MANUALLY ADDED DIMENSIONS --------

  dimension: now_vs_30d_ago {
    type: yesno
    sql: DATE_DIFF(current_date(), ${date_berlin_date},  DAY) IN (0,30)  ;;
  }

  dimension: yesterday_vs_30d_ago {
    type: yesno
    sql: DATE_DIFF(current_date(), ${date_berlin_date},  DAY) IN (1,30)  ;;
  }

  dimension: now_vs_14d_ago {
    type: yesno
    sql: DATE_DIFF(current_date(), ${date_berlin_date},  DAY) IN (0,14)  ;;
  }

  dimension: now_vs_7d_ago {
    type: yesno
    sql: DATE_DIFF(current_date(), ${date_berlin_date},  DAY) IN (0,7)  ;;
  }

  dimension: is_last_day_of_month {
    type: yesno
    sql: date(${date_berlin_date}) = last_day(date(${date_berlin_date}), month)
      OR DATE(${date_berlin_date}) = CURRENT_DATE();;
    description: "Filters for the last day of each month. Current month: today"
  }

  dimension: is_last_day_of_quarter {
    type: yesno
    sql: date(${date_berlin_date}) = last_day(date(${date_berlin_date}), quarter)
      OR DATE(${date_berlin_date}) = CURRENT_DATE();;
    description: "Filters for the last day of each quarter. Current quarter: today"
  }

  dimension: last_30d_dimension {
    type: string
    sql: CASE
            WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 29 THEN "last 30d"
            WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 59 THEN "last 31d-60d"
            END ;;
  }

  dimension: last_14d_dimension_run {
    type: string
    sql: CASE
            WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 13 THEN "last 14d"
            ELSE "before" END ;;
  }

  dimension: last_14d_dimension {
    type: string
    sql: CASE
            WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 13 THEN "last 14d"
            WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 27 THEN "last 15d-28d"
            END ;;
  }

  dimension: last_7d_dimension {
    type: string
    sql: CASE
          WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 6 THEN "last 7d"
          WHEN DATE_DIFF(current_date(), ${date_berlin_date}, DAY) <= 13 THEN "last 8d-14d"
          END ;;
  }

    dimension: dau_30davg_tier {
      type: tier
      sql: ${dau_30d_avg_percentage_onboarded} ;;
      tiers: [0.25,0.5,0.75,1]
      style: relational
      label: "DAU % Onboarded (30d Avg) Tier"
    }

  dimension: has_more_than_5_pages_published {
    type: yesno
    sql: ${running_total_pages_published} > 5 ;;
    description: "Boolean if tenant published more than 5 pages."
  }

# --- MEASURES ------------
  measure: count {
    type: count
    hidden: no # number of entries not relevant
    label: "# entries"
  }

  measure: tenants_count {
    type: count_distinct
    sql: ${tenant} ;;
    label: "# Tenants"
  }

  measure: users_created_sum {
    type: sum
    sql: ${users_created} ;;
    label: "# Created Users"
    description: "Important: historized table - always add a date-dimension on daily level to make the numbers work."
  }

  measure: activation_rate_number {
    type: number
    sql: ${users_created_sum}/NULLIF(${licences_sold_sum},0) ;;
    label: "% Activation Rate"
    value_format_name: percent_1
    description: "% Users created of licences sold"
  }

  measure: users_created_active_sum {
    type: sum
    sql: ${users_created_active} ;;
    label: "# Active Users"
    description: "Important: historized table - always add a date-dimension on daily level to make the numbers work."
  }

  measure: users_onboarded_sum {
    type: sum
    sql: ${users_onboarded} ;;
    label: "# Onboarded Users"
    description: "Important: historized table - always add a date-dimension on daily level to make the numbers work."
  }

  measure: users_status_deleted_sum {
    type: sum
    sql: ${users_status_deleted} ;;
    label: "# Users w. Status DELETED"
    description: "Important: historized table - always add a date-dimension on daily level to make the numbers work."
  }

  measure: users_status_pending_deletion_sum {
    type: sum
    sql: ${users_status_pending_deletion} ;;
    label: "# Users w. Status PENDING DELETION"
    description: "Important: historized table - always add a date-dimension on daily level to make the numbers work."
  }

  measure: onboarding_rate_number {
    type: number
    sql: ${users_onboarded_sum}/NULLIF(${users_created_sum},0) ;;
    label: "Onboarding Rate %"
    description: "% Users onboarded of all created users"
    value_format_name: percent_1
  }

  measure: dau_sum {
    type: sum
    sql: ${dau} ;;
    value_format_name: decimal_0
    label: "DAU (avg)"
    description: "Important: historized table - always add a date-dimension on daily level to make the numbers work."
  }

  measure: dau_30d_avg_sum {
    type: sum
    sql: ${dau_30d_avg} ;;
    value_format_name: decimal_0
    label: "DAU 30d Avg"
    description: "Important: historized table - always add a date-dimension on daily level to make User numbers work."
  }

  # measure: dau_30d_avg_percentage_onboarded_avg { # can't use dau_percent_onboarded for overall numbers -> use custom measure in explore
  #   type: average
  #   sql: ${dau_30d_avg_percentage_onboarded} ;;
  #   value_format_name: percent_0
  #   label: "DAU % Onboarded (30d Avg) (avg)"
  #   description: "Important: always use tenant dimension & add a date-dimension on daily level to make numbers work."
  # }

  measure: dau_30d_avg_percentage_onboarded_avg { # can't use dau_percent_onboarded for overall numbers -> use custom measure in explore
    type: number
    sql: ${dau_30d_avg_sum}/nullif(${users_onboarded_sum},0);;
    value_format_name: percent_0
    label: "DAU % Onboarded (30d Avg) (avg)"
  }

  measure: dau_30d_avg_percentage_licences_num {  # can't use dau_percent_onboarded for overall numbers -> use custom measure in explore
    type: number
    sql: ${dau_30d_avg_sum}/nullif(${licences_sold_sum},0) ;;
    value_format_name: percent_0
    label: "DAU % (30d avg) Licences Sold (avg)"
  }

  measure: wau_sum {
    type: sum
    sql: ${wau} ;;
    value_format_name: decimal_0
    label: "WAU"
    description: "Important: historized table - always add a date-dimension on daily level to make User numbers work."
  }

  # measure: wau_percentage_onboarded_avg {  # can't use dau_percent_onboarded for overall numbers -> use custom measure in explore
  #   type: average
  #   sql: ${wau_percentage_onboarded} ;;
  #   value_format_name: percent_0
  #   label: "WAU % Onboarded (avg)"
  #   description: "Important: always use tenant dimension & add a date-dimension on daily level to make numbers work."
  # }

  measure: wau_percentage_onboarded_avg {  # can't use dau_percent_onboarded for overall numbers -> use custom measure in explore
    type: number
    sql: ${wau_sum}/nullif(${users_onboarded_sum},0) ;;
    value_format_name: percent_0
    label: "WAU % Onboarded (avg)"
  }

  measure: wau_percentage_licences_num {  # can't use dau_percent_onboarded for overall numbers -> use custom measure in explore
    type: number
    sql: ${wau_sum}/nullif(${licences_sold_sum},0) ;;
    value_format_name: percent_0
    label: "WAU % Licences Sold (avg)"
  }

  measure: mau_sum {
    type: sum
    sql: ${mau} ;;
    value_format_name: decimal_0
    label: "MAU"
    description: "Important: historized table - always add a date-dimension on daily level to make User numbers work."
  }

  # measure: mau_percentage_onboarded_avg {  # can't use dau_percent_onboarded for overall numbers -> use custom measure in explore
  #   type: average
  #   sql: ${mau_percentage_onboarded} ;;
  #   value_format_name: percent_0
  #   label: "MAU % Onboarded (avg)"
  #   description: "Important: always use tenant dimension & add a date-dimension on daily level to make numbers work."
  # }

  measure: mau_percentage_onboarded_avg {  # can't use dau_percent_onboarded for overall numbers -> use custom measure in explore
    type: number
    sql: ${mau_sum}/nullif(${users_onboarded_sum},0) ;;
    value_format_name: percent_0
    label: "MAU % Onboarded (avg)"
  }

  measure: mau_percentage_licences_num {  # can't use dau_percent_onboarded for overall numbers -> use custom measure in explore
    type: number
    sql: ${mau_sum}/nullif(${licences_sold_sum},0) ;;
    value_format_name: percent_0
    label: "MAU % Licences Sold (avg)"
  }

  measure: licences_sold_sum {
    type: sum
    sql: ${licences_sold} ;;
    label: "Licences sold"
  }

  measure: licence_success_rate_sold_number {
    type: number
    sql: ${users_onboarded_sum}/NULLIF(${licences_sold_sum},0) ;;
    label: "% LSR (sold)"
    value_format_name: percent_1
    description: "% Users Onboarded of Licences sold. -> insight on value for the customer"
  }

  measure: messages_sum {
    type: sum
    sql: ${messages} ;;
    label: "# Messages"
  }

  measure: user_groups_sum {
    type: sum
    sql: ${user_groups} ;;
    label: "# User Groups"
  }

  measure: parent_user_groups_sum {
    type: sum
    sql: ${parent_user_groups} ;;
    label: "# User Groups (Parents)"
  }

  measure: posts_sum {
    type: sum
    sql: ${posts} ;;
    label: "# Posts"
    drill_fields: [date_berlin_date, tenant, posts, posts_sum, posts_avg]
  }

  measure: posts_avg {
    type: average
    sql: ${posts} ;;
    label: "# Posts (avg)"
    drill_fields: [date_berlin_date, tenant, posts, posts_sum, posts_avg]
  }

  measure: stickiness_dau_mau {
    type: number
    sql: ${dau_30d_avg_sum}/nullif(${mau_sum},0) ;;
    label: "Stickiness % (DAU/MAU)"
    value_format_name: percent_0
  }

  measure: stickiness_wau_mau {
    type: number
    sql: ${wau_sum}/nullif(${mau_sum},0) ;;
    label: "Stickiness % (WAU/MAU)"
    value_format_name: percent_0
  }

  measure: count_wau_more_than_65_percent{
    type: sum
    sql: if(${wau}/nullif(${licences_sold},0)>0.65,1,0) ;;
    label: "# WAU > 65%"
    }

  measure: pages_published_sum {
    type: sum
    sql: ${pages_published} ;;
    label: "# Pages Published"
  }

  measure: running_total_pages_published_sum {
    type: sum
    sql: ${running_total_pages_published} ;;
    label: "# Total Pages Published"
  }

  #   calendar_event_participations
  #   calendar_events chats
  # comment_reactions

  #   message_reactions
  #   messages
  #   post_comments
  #   post_reactions
  #     posts
  #   posts_with_survey
  #   task_comment_reactions
  #   tasks total_post_reactions
  #   total_reactions
  #   translated_characters_per_author

  }
