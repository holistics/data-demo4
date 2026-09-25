  include: "/base_views/Datamarts/flip_users_au_activities_historized_base.view"

  view: flip_users_au_activities_historized_ext {

    extends: [flip_users_au_activities_historized_base]

    drill_fields: [source_table, tenant, user_id]

# --- MEASURES ---------------------------------------------------------

    dimension: activity_id { # also PK in this table
      type: string
      primary_key: yes
    }

    dimension_group: db_row_timestamp {
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        day_of_week,
        month,
        quarter,
        year
      ]

    }

    dimension: partition_id {
      type: string
    }

    dimension: ranking_first_activity {
      type: number

    }

    dimension: ranking_last_activity {
      type: number
      hidden: yes
    }

    dimension: source_table {
      type: string
      label: "Activity Type"
    }

    dimension: tenant {
      type: string

    }

    dimension: user_id {
      type: string
      #primary_key: yes
    }

#-------------MANUALLY ADDED DIMENSIONS

    dimension: is_first_activity {
      type: yesno
      sql: ${ranking_first_activity} = 1 ;;
    }

    dimension: is_last_activity {
      type: yesno
      sql: ${ranking_last_activity} = 1 ;;
    }

    dimension: yesterday_vs_30d_ago {
      type: yesno
      sql: DATE_DIFF(current_date(), ${db_row_timestamp_date},  DAY) IN (1,31)  ;;
    }

    dimension: yesterday_vs_14d_ago {
      type: yesno
      sql: DATE_DIFF(current_date(), ${db_row_timestamp_date},  DAY) IN (1,15)  ;;
    }

    dimension: yesterday_vs_7d_ago {
      type: yesno
      sql: DATE_DIFF(current_date(), ${db_row_timestamp_date},  DAY) IN (1,8)  ;;
    }

    dimension: is_last_day_of_month {
      type: yesno
      sql: date(${db_row_timestamp_date}) = last_day(date(${db_row_timestamp_date}), month)
        OR DATE(${db_row_timestamp_date}) = CURRENT_DATE();;
      description: "Filters for the last day of each month. Current month: today"
    }

#______________MEASURES-------------------

    measure: count {
      type: count
      label: "# Activities"
      description: "Count of distinct activity_ids (single activities)."
    }

    measure: count_post_activities {
      type: count
      label: "# Activities: Post Interaction "
      filters: [source_table: "bookmark, post, post comment, post seen, post survey vote, reaction"]
      description: "# Post interaction activities: bookmark, posting, post comment, post seen, post survey vote, reaction."
    }

    measure: user_count {
      type: count_distinct
      sql: ${user_id} ;;
      label: "# Active Users (daily)"
      description: "Count of unique user_ids. IMPORTANT: always use this measure in combination with a date dimension (daily breakdown) or filter for a single day to get a valid result."
    }

    measure: count_l30d {
      type: count
      label: "# Activities (l30d)"
      filters: [db_row_timestamp_date: "30 days"]
      description: "Count of distinct activity_ids of the last 30 days."
    }

    measure: activities_l30d_num {
      type: number
      sql: ${count_l30d}/30;;
      label: "Avg Activities (l30d)"
    }

    measure: user_count_post_interactions {
      type: count_distinct
      sql: ${user_id} ;;
      filters: [source_table: "bookmark, post, post comment, post seen, post survey vote, reaction"]
      label: "# Active Users with post interaction"
      description: "# Active Users who made at least one post interaction: bookmark, post, post comment, post seen, post survey vote, reaction."
    }

    measure: user_count_chat_interactions {
      type: count_distinct
      sql: ${user_id} ;;
      filters: [source_table: "message, chat membership"]
      label: "# Active Users with chat interaction"
      description: "# Active Users who made at least one interaction as a message or chat membership."
    }

    # measure: user_count_today {
    #   type: count_distinct
    #   sql: ${user_id} ;;
    #   filters: [db_row_timestamp_date: "yesterday"]
    #   label: "# Active Users (daily) today"
    #   description: "Count of unique user_ids. IMPORTANT: always use this measure in combination with a date dimension (daily breakdown) or filter for a single day to get a valid result."
    # }

    # measure: weekly_active_users_today {
    #   type: count_distinct
    #   sql: ${user_id} ;;
    #   # where date(db_row_timestamp) >= current_date()-6;;
    #   filters: [db_row_timestamp_date: "7 days"]
    # }

    measure: tenant_count_distinct {
      type: count_distinct
      sql: ${tenant} ;;
      label: "# Tenants"
      description: "Count of unique tenants."
    }

  }
