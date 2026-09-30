include: "/base_views/Datamarts/ga4_events_base.view"

view: ga4_events_ext {
  extends: [ga4_events_base]

# ----- ORIGINAL DIMENSIONS ---------------------------------------------------------------------------------------------------------------------------------------

  dimension: ads_storage {
    type: string
  }
  dimension: analytics_storage {
    type: string
  }
  dimension: campaign {
    type: string
  }
  dimension: device_browser {
    type: string
  }
  dimension: device_category {
    type: string
  }
  dimension: device_is_limited_ad_tracking {
    type: string
  }
  dimension: device_language {
    type: string
  }
  dimension: device_mobile_brand_name {
    type: string
  }
  dimension: device_mobile_model_name {
    type: string
  }
  dimension: device_operating_system {
    type: string
  }
  dimension: device_operating_system_version {
    type: string
  }
  dimension: device_time_zone_offset_seconds {
    type: number
  }
  dimension: device_webinfo_hostname {
    type: string
  }
  dimension: engagement_time_sec {
    type: number
  }
  dimension: entrances {
    type: number
  }
  dimension: event_category {
    type: string
  }
  dimension_group: event {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: event_name {
    type: string
  }
  dimension_group: event_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension: foreign_key {
    type: string
  }
  dimension: ga_session_id {
    type: string
  }
  dimension: ga_session_number {
    type: number
  }
  dimension: gclid {
    type: string
  }
  dimension: geo_city {
    type: string
  }
  dimension: geo_continent {
    type: string
  }
  dimension: geo_country {
    type: string
  }
  dimension: geo_region {
    type: string
  }
  dimension: geo_state {
    type: string
  }
  dimension: geo_sub_continent {
    type: string
  }
  dimension: is_active_user {
    type: yesno
  }
  dimension: is_new_user {
    type: yesno
  }
  dimension: medium {
    type: string
  }
  dimension: page_location_formatted {
    type: string
    link: {
      label: "Page URL"
      url: "{{ page_location_formatted }}"
    }
  }
  dimension: page_location_raw {
    type: string
  }
  dimension: page_referrer {
    type: string
  }
  dimension: page_title {
    type: string
  }
  dimension: primary_key {
    type: string
    primary_key: yes
  }
  dimension: session_engaged {
    type: string
  }
  dimension: source {
    type: string
  }
  dimension: term {
    type: string
  }
  dimension_group: user_first_touch_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension: user_id {
    type: string
  }
  dimension: user_pseudo_id {
    type: string
  }

# ----- MANUALLY CREATED DIMENSIONS -------------------------------------------------------------------------------------------------------------------------------

  dimension: is_today {
    type: yesno
    sql: IF(CURRENT_DATE()=${event_date},TRUE,FALSE) ;;
  }

# ----- MEASURES --------------------------------------------------------------------------------------------------------------------------------------------------

  measure: count {
    type: count
    hidden: yes
    drill_fields: [device_mobile_model_name, device_webinfo_hostname, event_name, device_mobile_brand_name]
  }

  # ----- THE MEASURES BELOW FOLLOW THE OFFICIAL METRICS DEFINITION FROM GOOGLE ANALYTICS 4 -----
  # https://support.google.com/analytics/answer/9143382?sjid=157639072609364927-EU#engaged-sessions&zippy=%2Cattribution%2Cdemographics%2Cecommerce%2Cevent%2Cgaming%2Cgeneral%2Cgeography%2Clink%2Cpage-screen%2Cplatform-device%2Cpublisher%2Ctime%2Ctraffic-source%2Cuser%2Cuser-lifetime%2Cvideo%2Cadvertising%2Cpredictive%2Crevenue%2Csearch-console%2Csession

  # ------------------ USER MEASURES ------------------ #

  measure: total_unique_users_count {
    type: count_distinct
    sql: ${user_pseudo_id};;
    filters: [user_pseudo_id: "-NULL"]
    label: "# Users (total)"
    description: "Number of unique user IDs that triggered any events. The metric allows you to measure the number of unique users who logged an event."
    drill_fields: []
  }

  measure: total_unique_active_users_count {
    type: count_distinct
    sql: ${user_pseudo_id};;
    filters: [user_pseudo_id: "-NULL", is_active_user: "yes"]
    label: "# Users (active)"
    description: "Number of unique users who visited your website. An active user is any user who has an engaged session or when Analytics collects the first_visit event or engagement_time_msec parameter from a website. Note: The active users metric appears as 'users' in GA4 reports."
    drill_fields: []
  }

  measure: new_unique_users_count {
    type: count_distinct
    sql: ${user_pseudo_id} ;;
    filters: [user_pseudo_id: "-NULL", is_active_user: "yes", is_new_user: "yes"]
    label: "# Users (new)"
    description: "Number of new unique user IDs that logged the first_open or first_visit event. The metric allows you to measure the number of users who interacted with your site for the first time."
    drill_fields: []
  }

  measure: returning_unique_users_count {
    type: number
    sql: ${total_unique_active_users_count} - ${new_unique_users_count} ;;
    label: "# Users (returning)"
    description: "Number of users who have initiated at least one previous session, regardless of whether or not the previous sessions were engaged sessions."
    drill_fields: []
  }

  measure: total_unique_users_with_form_submissions_count {
    type: count_distinct
    sql: ${user_pseudo_id} ;;
    filters: [event_name: "typeform_submitted", is_active_user: "yes"]
    label: "# Users (with form submission)"
    description: "Number of unique active users who submitted a website form."
    drill_fields: []
  }

    # ------------------ ENGAGEMENT MEASURES ------------------ #

  measure: page_views_count {
    type: count
    filters: [event_name: "3. page_view", user_pseudo_id: "-NULL"]
    label: "# Page Views"
    description: "Number of web pages our users saw. Repeated views of a single page are counted."
    drill_fields: []
  }

  measure: page_views_per_active_user_average {
    type: number
    sql:  ${page_views_count} / IF(${total_unique_active_users_count}=0,NULL,${total_unique_active_users_count}) ;;
    label: "# Avg page views / user"
    description: "Avg number of web pages each user has seen. Repeated views of a single page are counted."
    value_format: "0.00"
    drill_fields: []
  }

  measure: engagement_time_sec_avg {
    type: number
    sql: SUM(IF(${user_pseudo_id} IS NOT NULL AND ${is_active_user} IS TRUE,${engagement_time_sec},NULL))/IF(COUNT(DISTINCT(CASE WHEN ${is_active_user} IS TRUE AND ${user_pseudo_id} IS NOT NULL THEN ${user_pseudo_id} ELSE NULL END))=0,NULL,COUNT(DISTINCT(CASE WHEN ${is_active_user} IS TRUE AND ${user_pseudo_id} IS NOT NULL THEN ${user_pseudo_id} ELSE NULL END)));;
    label: "# Avg Engagement Time (sec)"
    description: "Avg time the website was in focus in a user's browser (total user engagement durations / number of active users)."
    value_format: "0"
    drill_fields: []
  }

  # measure: user_conversion_rate_percent {
  #   type: number
  #   sql: ${total_unique_users_with_form_submissions_count} / IF(${total_unique_active_users_count}=0,NULL,${total_unique_active_users_count});;
  #   label: "User Conversion Rate %"
  #   description: "The percentage of unique users who submitted a form. This metric is calculated as the number of unique users who submitted a form divided by the total number of active users."
  #   value_format: "0.00%"
  #   drill_fields: []
  # }

}
