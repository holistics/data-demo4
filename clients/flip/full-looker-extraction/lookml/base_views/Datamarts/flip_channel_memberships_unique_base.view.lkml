view: flip_channel_memberships_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_channel_memberships_unique` ;;

  dimension_group: created_at_timestamp {
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
    sql: ${TABLE}.created_at_timestamp ;;
  }

  dimension: creator_type {
    type: string
    sql: ${TABLE}.creator_type ;;
  }

  dimension: creating_service_type {
    type: string
    sql: ${TABLE}.creating_service_type ;;
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

  dimension: deletion_status {
    type: string
    sql: ${TABLE}.deletion_status ;;
  }

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: is_channel_member_deleted {
    type: yesno
    sql: ${TABLE}.is_channel_member_deleted ;;
  }

  dimension: is_channel_muted {
    type: yesno
    sql: ${TABLE}.is_channel_muted ;;
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

  dimension: left_open_channel {
    type: yesno
    sql: ${TABLE}.left_open_channel ;;
  }

  dimension: managing_service_type {
    type: string
    sql: ${TABLE}.managing_service_type ;;
  }

  dimension: membership_role {
    type: string
    sql: ${TABLE}.membership_role ;;
  }

  dimension: channel_id {
    type: string
    sql: ${TABLE}.channel_id ;;
  }

  dimension: channel_membership_creator {
    type: string
    sql: ${TABLE}.channel_membership_creator ;;
  }

  dimension: channel_membership_id {
    type: string
    sql: ${TABLE}.channel_membership_id ;;
  }

  dimension_group: channel_muted_until_timestamp {
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
    sql: ${TABLE}.channel_muted_until_timestamp ;;
  }

  dimension: channel_name {
    type: string
    sql: ${TABLE}.channel_name ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [channel_name]
  }
}
