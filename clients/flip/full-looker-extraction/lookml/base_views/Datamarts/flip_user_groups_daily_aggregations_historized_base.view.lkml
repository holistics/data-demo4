view: flip_user_groups_daily_aggregations_historized_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_user_groups_daily_aggregations_historized` ;;

  dimension_group: date_berlin {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_berlin ;;
  }
  dimension: dau_30d_avg {
    type: number
    sql: ${TABLE}.dau_30d_avg ;;
  }
  dimension: dau_daily {
    type: number
    sql: ${TABLE}.dau_daily ;;
  }
  dimension: mau_daily {
    type: number
    sql: ${TABLE}.mau_daily ;;
  }
  dimension: message_reactions {
    type: number
    sql: ${TABLE}.message_reactions ;;
  }
  dimension: new_onboarded_users {
    type: number
    sql: ${TABLE}.new_onboarded_users ;;
  }
  dimension: posts {
    type: number
    sql: ${TABLE}.posts ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }
  dimension: total_created_users {
    type: number
    sql: ${TABLE}.total_created_users ;;
  }
  dimension: total_onboarded_users {
    type: number
    sql: ${TABLE}.total_onboarded_users ;;
  }
  dimension: total_post_interactions {
    type: number
    sql: ${TABLE}.total_post_interactions ;;
  }
  dimension: total_reactions {
    type: number
    sql: ${TABLE}.total_reactions ;;
  }
  dimension: user_group_id {
    type: string
    sql: ${TABLE}.user_group_id ;;
  }
  dimension: wau_daily {
    type: number
    sql: ${TABLE}.wau_daily ;;
  }
  measure: count {
    type: count
  }
}
