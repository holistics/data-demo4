view: ga4_events_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.GA4_events` ;;

  dimension: ads_storage {
    type: string
    sql: ${TABLE}.ads_storage ;;
  }
  dimension: analytics_storage {
    type: string
    sql: ${TABLE}.analytics_storage ;;
  }
  dimension: campaign {
    type: string
    sql: ${TABLE}.campaign ;;
  }
  dimension: device_browser {
    type: string
    sql: ${TABLE}.device_browser ;;
  }
  dimension: device_category {
    type: string
    sql: ${TABLE}.device_category ;;
  }
  dimension: device_is_limited_ad_tracking {
    type: string
    sql: ${TABLE}.device_is_limited_ad_tracking ;;
  }
  dimension: device_language {
    type: string
    sql: ${TABLE}.device_language ;;
  }
  dimension: device_mobile_brand_name {
    type: string
    sql: ${TABLE}.device_mobile_brand_name ;;
  }
  dimension: device_mobile_model_name {
    type: string
    sql: ${TABLE}.device_mobile_model_name ;;
  }
  dimension: device_operating_system {
    type: string
    sql: ${TABLE}.device_operating_system ;;
  }
  dimension: device_operating_system_version {
    type: string
    sql: ${TABLE}.device_operating_system_version ;;
  }
  dimension: device_time_zone_offset_seconds {
    type: number
    sql: ${TABLE}.device_time_zone_offset_seconds ;;
  }
  dimension: device_webinfo_hostname {
    type: string
    sql: ${TABLE}.device_webinfo_hostname ;;
  }
  dimension: engagement_time_sec {
    type: number
    sql: ${TABLE}.engagement_time_sec ;;
  }
  dimension: entrances {
    type: number
    sql: ${TABLE}.entrances ;;
  }
  dimension: event_category {
    type: string
    sql: ${TABLE}.event_category ;;
  }
  dimension_group: event {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.event_date ;;
  }
  dimension: event_name {
    type: string
    sql: ${TABLE}.event_name ;;
  }
  dimension_group: event_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.event_timestamp ;;
  }
  dimension: foreign_key {
    type: string
    sql: ${TABLE}.foreign_key ;;
  }
  dimension: ga_session_id {
    type: string
    sql: ${TABLE}.ga_session_id ;;
  }
  dimension: ga_session_number {
    type: number
    sql: ${TABLE}.ga_session_number ;;
  }
  dimension: gclid {
    type: string
    sql: ${TABLE}.gclid ;;
  }
  dimension: geo_city {
    type: string
    sql: ${TABLE}.geo_city ;;
  }
  dimension: geo_continent {
    type: string
    sql: ${TABLE}.geo_continent ;;
  }
  dimension: geo_country {
    type: string
    sql: ${TABLE}.geo_country ;;
  }
  dimension: geo_region {
    type: string
    sql: ${TABLE}.geo_region ;;
  }
  dimension: geo_state {
    type: string
    sql: ${TABLE}.geo_state ;;
  }
  dimension: geo_sub_continent {
    type: string
    sql: ${TABLE}.geo_sub_continent ;;
  }
  dimension: is_active_user {
    type: yesno
    sql: ${TABLE}.is_active_user ;;
  }
  dimension: medium {
    type: string
    sql: ${TABLE}.medium ;;
  }
  dimension: page_location_formatted {
    type: string
    sql: ${TABLE}.page_location_formatted ;;
  }
  dimension: page_location_raw {
    type: string
    sql: ${TABLE}.page_location_raw ;;
  }
  dimension: page_referrer {
    type: string
    sql: ${TABLE}.page_referrer ;;
  }
  dimension: page_title {
    type: string
    sql: ${TABLE}.page_title ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  dimension: session_engaged {
    type: string
    sql: ${TABLE}.session_engaged ;;
  }
  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }
  dimension: term {
    type: string
    sql: ${TABLE}.term ;;
  }
  dimension_group: user_first_touch_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.user_first_touch_timestamp ;;
  }
  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }
  dimension: user_pseudo_id {
    type: string
    sql: ${TABLE}.user_pseudo_id ;;
  }
  measure: count {
    type: count
    drill_fields: [device_mobile_model_name, device_webinfo_hostname, event_name, device_mobile_brand_name]
  }
}
