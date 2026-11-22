
include: "/base_views/Datamarts/flip_posts_unique_base.view"

view: flip_posts_unique_ext {
  extends: [flip_posts_unique_base]

  drill_fields: [post_id, created_timestamp_date, detected_language, post_body_word_count]

# --- BASE DIMENSIONS -------------------------------

  dimension: actor_id {
    type: string
  }

  dimension: attachment_count { # additional aggregation, better to pull it directly from attachments view
    type: number
    hidden: no # exclusion via set
  }
  dimension: author_id {
    type: string
  }

  dimension: bookmark_count {
    type: number
    hidden: no # exclusion via set
  }

  dimension: comment_count {
    type: number
    hidden: no # exclusion via set
  }

  dimension: comment_reaction_count {
    type: number
    hidden: no # exclusion via set
  }

  dimension_group: created_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      hour_of_day,
      minute30,
      date,
      day_of_week,
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
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension: detected_language {
    type: string
  }

  dimension: diff_scheduled_created_minutes {
    type: number
    hidden: no
  }

  dimension: diff_scheduled_published_minutes {
    type: number
    hidden: no
  }

  dimension_group: first_highlighted_at_timestamp {
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
    description: "Point in time when the highlight was created / highlighted_until timestamp was chosen."
  }

  dimension: has_post_attachment {
    type: yesno
  }

  dimension: has_post_survey {
    type: yesno
  }

  dimension: highlight_duration_hours {
    type: number
    hidden: no
  }

  dimension: highlighted_until_count {
    type: number
    hidden: no
  }

  dimension_group: highlighted_until_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      hour_of_day,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    description: "Max timestamp for the highlight to be shown."
  }

  dimension: is_db_row_deleted {
    type: yesno
    hidden: yes
  }

  dimension: is_posted_on_behalf {
    type: yesno
  }

  dimension:  is_post_comments_enabled {
    type: yesno
  }

  dimension: is_post_deleted {
    type: yesno
  }

  dimension: is_post_reactions_enabled {
    type: yesno
  }

  dimension: is_channel_open {
    type: yesno
  }

  dimension: is_was_highlight_removed {
    type: yesno
    description: "Highlight had been set but then was then removed by the user before it expired."
  }

  dimension: is_was_post_highlighted {
    type: yesno
  }

  dimension_group: latest_scheduled_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension: post_body_character_count {
    type: number
    hidden: no # exclusion via set

  }

  dimension: post_body_word_count {
    type: number
    hidden: no # exclusion via set
  }

  dimension: channel_id {
    type: string
    hidden: no
  }

  dimension: post_id {
    type: string
    primary_key: yes
    hidden: no
  }

  dimension: post_seen_count { # additional aggregation, better to pull it directly from post_seens view
    type: number
    hidden: no # exclusion via set

  }

  dimension_group: published_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension: reaction_count { # additional aggregation, better to pull it directly from reactions view
    type: number
    hidden: no # exclusion via set

  }

  dimension: scheduled_count {
    type: number
    hidden: no # exclusion via set
  }

  dimension: selected_language {
    type: string
  }

  dimension: survey_vote_count {
    type: number
    hidden: no # exclusion via set
  }

  dimension: survey_choice_count {
    type: number
    hidden: no
  }

  dimension: tenant {
    type: string
  }

  dimension: translated_languages_count { # additional aggregation, better to pull it directly from translation_versions view
    type: number
    hidden: no # exclusion via set

  }

  dimension: updated_count {
    type: number
    hidden: no # exclusion via set
  }

  dimension_group: updated_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension: was_post_translated {
    type: yesno
  }

  dimension: livestream_id {
    type: string
  }

  dimension: publication_status {
    type: string
  }

  dimension_group: last_status_change_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
  }

# --- MANUALLY ADDED DIMENSIONS

  # dimension: post_title_open_groups_only { # staging only
  #   type: string
  #   sql:
  #     CASE
  #     WHEN ${is_post_group_open} IS true THEN ${post_title}
  #     WHEN ${post_group_name} IN ("Flipship", "Flip Stars", "People News", "Won Deals", "Bugreports", "Weekly Updates", "OKRs") THEN ${post_title}
  #     ELSE "[Post in Private Group]" END ;;
  #   label: "Post Title (limited)"
  # }

  # dimension: post_group_name_open_groups_only { # staging only
  #   type: string
  #   sql:
  #     CASE
  #     WHEN ${is_post_group_open} IS true THEN ${post_group_name}
  #     WHEN ${post_group_name} IN ("Flipship", "Flip Stars", "People News", "Won Deals", "Bugreports", "Weekly Updates", "OKRs") THEN ${post_group_name}
  #     ELSE "[Private Group]" END ;;
  #   label: "Post Group Name (limited)"
  # }

  dimension: is_post_scheduled {
    type: yesno
    sql: ${latest_scheduled_timestamp_date} IS NOT NULL ;;
    label: "Is Post Scheduled"
  }

  dimension: has_post_survey_votes {
    type: yesno
    sql: ${survey_vote_count} > 0 ;;
    label: "Has Post Survey Votes"
  }

  dimension: is_post_updated {
    type: yesno
    sql: ${updated_count} > 0;;
    label: "Is Post Updated"
  }

  dimension: highlight_duration_days {
    type: number
    sql: ROUND(${highlight_duration_hours}/24,0) ;;
    #value_format_name: decimal_0
    hidden: no
  }

  dimension: is_language_detected {
    type: yesno
    sql: CASE WHEN ${detected_language} IS NULL OR ${detected_language} = "UNKNOWN" THEN false ELSE true END ;;
  }

  dimension_group: survey_end_date {
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

  dimension: survey_anonymity {
    type: string
  }

  dimension: is_survey_multiple_choice {
    type: yesno
  }

      # ------ TIERS -----------------------------

  dimension: post_body_word_count_tiers {
    type: tier
    sql: ${post_body_word_count} ;;
    style: integer
    tiers: [1,25,50,75,100,150,300]
    label: "Tier Body Word Count"
  }

  dimension: highlight_duration_hours_tiers {
    type: tier
    sql: ${highlight_duration_hours} ;;
    style: integer
    tiers: [1,6,12,24,48,72,96,120,240, 480,43200]
    label: "Tier Highlight Duration (h)"
  }

  dimension: highlight_duration_days_tiers {
    type: tier
    sql: ${highlight_duration_days} ;;
    style: integer
    tiers: [1,3,7,10,14,21,30,60,90,180]
    label: "Tier Highlight Duration (d)"
  }

  dimension: attachment_count_tier {
    type: tier
    sql: ${attachment_count} ;;
    style: integer
    tiers: [1,2,3,4,5,6,7,8,9,10,15,20]
    label: "Tier Attachment Count"
  }

  dimension: diff_scheduled_created_minutes_tier {
    type: tier
    sql: ${diff_scheduled_created_minutes} ;;
    style: integer
    tiers: [30, 60,120,180,480,1440,2880, 10080,43200]
    label: "Tier Created at -> Scheduled at (min)"
  }

  dimension: updated_count_tier {
    type: tier
    sql: ${updated_count} ;;
    style: integer
    tiers: [1,2,3,4,5,10]
    label: "Tier Post Update Count"
  }

  dimension: comment_count_tier {
    type: tier
    sql: ${comment_count} ;;
    style: integer
    tiers: [1,2,3,4,5,10,20,50,100]
    label: "Tier Comment Count"
  }

# ---- MEASURES ------------

  measure: count {
    type: count
    label: "# Posts"
    drill_fields: [post_id, created_timestamp_date, detected_language, post_body_word_count]
  }

  measure: count_cs { # different drill fields - CS only bc of GDPR
    type: count
    label: "# Posts"
    drill_fields: [post_id, created_timestamp_date, detected_language, post_body_word_count]
  }

  measure: posts_count {
    type: count_distinct
    sql: ${post_id} ;;
    label: "# Posts (distinct)"
  }

  measure: count_percent {
    type: percent_of_total
    sql: ${count} ;;
    label: "% Posts"
    drill_fields: [post_id, created_timestamp_date, detected_language, post_body_word_count]
    value_format_name: percent_1
    hidden: yes
  }

  measure: count_percent_cs {# different drill fields - CS only bc of GDPR!
    type: percent_of_total
    sql: ${count} ;;
    label: "% Posts"
    drill_fields: [post_id, created_timestamp_date, detected_language, post_body_word_count]
  }

  measure: author_id_count_distinct {
    type: count_distinct
    sql: ${author_id} ;;
    label: "# Authors"
    description: "Count of unique author_ids."
  }

  measure: updated_count_sum {
    type: sum
    sql: ${updated_count} ;;
    label: "# Post Updates"
    description: "Count of distinct updated_at timestamps."
  }

  measure: updated_count_avg {
    type: average
    sql: ${updated_count} ;;
    label: "# Post Updates (Avg)"
    description: "Avg Count of distinct updated_at timestamps."
    value_format_name: decimal_1
  }

  measure: updated_count_max {
    type: max
    sql: ${updated_count} ;;
    label: "# Post Updates (Max)"
    description: "Max Count of distinct updated_at timestamps."
  }

  measure: scheduled_count_sum {
    type: sum
    sql: ${scheduled_count} ;;
    label: "# Post (Re-) Schedules"
    description: "Count of distinct scheduled_at timestamps."
  }

  measure: scheduled_count_avg {
    type: average
    sql: ${scheduled_count} ;;
    label: "# Post (Re-) Schedules (Avg)"
    description: "Avg Count of distinct scheduled_at timestamps."
    value_format_name: decimal_1
  }

  # measure: reaction_count_avg { # post interactions all via interactions table
  #   type: average
  #   sql: ${reaction_count} ;;
  #   label: "# Reactions (Avg)"
  # }

  measure: post_body_word_count_sum {
    type: sum
    sql: ${post_body_word_count} ;;
    label: "# Post Body Words"
  }

  measure: post_body_word_count_avg {
    type: average
    sql: ${post_body_word_count} ;;
    label: "# Post Body Words (Avg)"
    value_format_name: decimal_0
  }

  measure: post_body_word_count_min {
    type: min
    sql: ${post_body_word_count} ;;
    label: "# Post Body Words (Min)"
    value_format_name: decimal_0
  }

  measure: post_body_word_count_max {
    type: max
    sql: ${post_body_word_count} ;;
    label: "# Post Body Words (Max)"
    value_format_name: decimal_0
  }

  measure: post_body_character_count_sum {
    type: sum
    sql: ${post_body_character_count} ;;
    label: "# Post Body Characters"
  }

  measure: post_body_character_count_avg {
    type: average
    sql: ${post_body_character_count} ;;
    label: "# Post Body Characters (Avg)"
    value_format_name: decimal_0
  }

  measure: diff_scheduled_created_minutes_avg {
    type: average
    sql: ${diff_scheduled_created_minutes} ;;
    label: "Duration Post Created -> Scheduled (minutes)"
    value_format_name: decimal_1
  }

  measure: attachment_count_sum {
    type: sum
    sql: ${attachment_count} ;;
    label: "# Post Attachments"
  }

  measure: attachment_count_avg {
    type: average
    sql: ${attachment_count} ;;
    label: "# Post Attachments (Avg)"
    value_format_name: decimal_1
  }

  measure: post_seen_count_sum {
    type: sum
    sql: ${post_seen_count};;
    label: "# Post Seens"
  }

  measure: post_seen_count_avg {
    type: average
    sql: ${post_seen_count};;
    label: "# Post Seens (Avg)"
    value_format_name: decimal_0
  }

  measure: post_seen_count_max {
    type: max
    sql: ${post_seen_count};;
    label: "# Post Seens (Max)"
  }

  measure: reaction_count_sum {
    type: sum
    sql: ${reaction_count};;
    label: "# Post Reactions"
  }

  measure: reaction_count_avg {
    type: average
    sql: ${reaction_count};;
    label: "# Post Reactions (Avg)"
    value_format_name: decimal_0
  }

  measure: bookmark_count_sum {
    type: sum
    sql: ${bookmark_count} ;;
    label: "# Post Bookmarks"
  }

  measure: bookmark_count_avg {
  type: average
  sql: ${bookmark_count} ;;
  label: "# Post Bookmarks (Avg)"
  value_format_name: decimal_0
}

  measure: comment_count_sum {
    type: sum
    sql: ${comment_count} ;;
    label: "# Post Comments"
  }

  measure: comment_count_avg {
    type: average
    sql: ${comment_count} ;;
    label: "# Post Comments (Avg)"
    value_format_name: decimal_0
  }

  measure: comment_reaction_count_sum {
    type: sum
    sql: ${comment_reaction_count} ;;
    label: "# Post Comment Reactions"
  }

  measure: survey_vote_count_sum {
    type: sum
    sql: ${survey_vote_count} ;;
    label: "# Survey Votes"
  }

  measure: survey_vote_count_avg {
    type: average
    sql: ${survey_vote_count} ;;
    label: "# Survey Votes (Avg)"
    value_format_name: decimal_1
  }

  measure: survey_vote_count_median {
    type: median
    sql: ${survey_vote_count} ;;
    label: "# Survey Votes (Median)"
  }

  measure: survey_choice_count_sum {
    type: sum
    sql: ${survey_choice_count} ;;
    label: "# Survey Choices"
  }

  measure: survey_choice_count_avg {
    type: average
    sql: ${survey_choice_count} ;;
    label: "# Survey Choices (Avg)"
    value_format_name: decimal_1
  }

  measure: survey_choice_count_median {
    type: median
    sql: ${survey_choice_count} ;;
    label: "# Survey Choices (Median)"
  }

  measure: translated_languages_count_sum {
    type: sum
    sql: ${translated_languages_count} ;;
    label: "# Translated Languages"
  }

  measure: highlighted_until_count_sum {
    type: sum
    sql: ${highlighted_until_count} ;;
    label: "# Highlighted Until Updates"
  }

  measure: highlight_duration_days_sum {
    type: sum
    sql: ${highlight_duration_days} ;;
    label: "Highlight Duration d"
    value_format_name: decimal_1
  }

  measure: highlight_duration_days_avg {
    type: average
    sql: ${highlight_duration_days} ;;
    label: "Highlight Duration d (Avg)"
    value_format_name: decimal_1
  }

  measure: posts_highlighted_count_percent {
    type: percent_of_total
    sql: ${count} ;;
    label: "% Posts with Highlight"
    filters: [is_was_post_highlighted: "Yes"]
    drill_fields: [post_id, created_timestamp_date, detected_language, post_body_word_count]
  }

  measure: time_published_to_highlighted_avg {
    type: average
    sql: TIMESTAMP_DIFF(${published_timestamp_raw}, ${first_highlighted_at_timestamp_raw}, DAY) ;;
  }

  measure: tenant_count {
    type: count_distinct
    sql: ${tenant} ;;
  }

# --- FIELDS -------

  set: all_date_fields { # not complete yet
    fields:
    [first_highlighted_at_timestamp_date, first_highlighted_at_timestamp_month, first_highlighted_at_timestamp_quarter, first_highlighted_at_timestamp_raw, first_highlighted_at_timestamp_time, first_highlighted_at_timestamp_week, first_highlighted_at_timestamp_year, highlighted_until_timestamp_date, highlighted_until_timestamp_day_of_week, highlighted_until_timestamp_hour_of_day, highlighted_until_timestamp_month, highlighted_until_timestamp_quarter, highlighted_until_timestamp_raw, highlighted_until_timestamp_time, highlighted_until_timestamp_week, highlighted_until_timestamp_year, updated_timestamp_date, updated_timestamp_day_of_week, updated_timestamp_month, updated_timestamp_quarter, updated_timestamp_raw, updated_timestamp_time, updated_timestamp_week, updated_timestamp_year, db_row_timestamp_date, db_row_timestamp_day_of_week, db_row_timestamp_month, db_row_timestamp_quarter, db_row_timestamp_raw, db_row_timestamp_time, db_row_timestamp_week, db_row_timestamp_year]
  }

  set: exclude_for_privacy_protection {
    fields: [count_cs, count_percent_cs]
  }

  set: exclude_numeric_dimensions {
    fields: [attachment_count, bookmark_count, comment_count, comment_reaction_count, diff_scheduled_created_minutes, diff_scheduled_published_minutes, highlight_duration_hours, highlight_duration_days, highlighted_until_count, post_body_character_count, post_seen_count, reaction_count, scheduled_count, survey_vote_count, translated_languages_count]
    #post_body_word_count, updated_count, survey_choice_count,
  }

  set: not_relevant_for_cs_explores {
    fields: [attachment_count, attachment_count_avg, count, count_percent, diff_scheduled_created_minutes, diff_scheduled_created_minutes_avg, diff_scheduled_created_minutes_tier, highlight_duration_days, highlight_duration_days_tiers, highlight_duration_hours, highlight_duration_hours_tiers, highlighted_until_count, highlighted_until_count_sum, is_was_highlight_removed, post_body_character_count, post_body_character_count_sum, post_body_word_count, post_body_word_count_max, post_body_word_count_min, post_body_word_count_tiers, post_body_word_count_sum, channel_id, post_seen_count, post_seen_count_avg, post_seen_count_max, post_seen_count_sum, scheduled_count, scheduled_count_sum, tenant, translated_languages_count, updated_count, updated_count_max, updated_count_tier, tenant, db_row_timestamp_date, db_row_timestamp_day_of_week, db_row_timestamp_month, db_row_timestamp_quarter, db_row_timestamp_raw, db_row_timestamp_time, db_row_timestamp_week, db_row_timestamp_year, first_highlighted_at_timestamp_date, first_highlighted_at_timestamp_month, first_highlighted_at_timestamp_quarter, first_highlighted_at_timestamp_raw, first_highlighted_at_timestamp_time, first_highlighted_at_timestamp_week, first_highlighted_at_timestamp_year, highlighted_until_timestamp_date, highlighted_until_timestamp_day_of_week, highlighted_until_timestamp_hour_of_day, highlighted_until_timestamp_month, highlighted_until_timestamp_quarter, highlighted_until_timestamp_raw, highlighted_until_timestamp_time, highlighted_until_timestamp_week, highlighted_until_timestamp_year, updated_timestamp_date, updated_timestamp_day_of_week, updated_timestamp_month, updated_timestamp_quarter, updated_timestamp_raw, updated_timestamp_time, updated_timestamp_week, updated_timestamp_year, db_row_timestamp_date, db_row_timestamp_month, db_row_timestamp_quarter, db_row_timestamp_raw, db_row_timestamp_time, db_row_timestamp_week, db_row_timestamp_year]
    #post_body_word_count, comment_reaction_count
    #  survey_vote_count,  bookmark_count,bookmark_count_sum,comment_count,comment_count_sum, reaction_count,reaction_count_sum, survey_vote_count_avg,survey_vote_count_sum,
  }

}
