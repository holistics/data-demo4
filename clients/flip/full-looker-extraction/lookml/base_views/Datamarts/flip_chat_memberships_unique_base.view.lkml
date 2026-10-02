view: flip_chat_memberships_unique_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.flip_chat_memberships_unique` ;;

  dimension: chat_id {
    type: string
    sql: ${TABLE}.chat_id ;;
  }

  dimension: chat_membership_id {
    type: string
    sql: ${TABLE}.chat_membership_id ;;
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

  dimension: is_chat_archived {
    type: yesno
    sql: ${TABLE}.is_chat_archived ;;
  }

  dimension: is_chat_member_deleted {
    type: yesno
    sql: ${TABLE}.is_chat_member_deleted ;;
  }

  dimension: is_db_row_deleted {
    type: yesno
    sql: ${TABLE}.is_db_row_deleted ;;
  }

  dimension: is_user_inactive {
    type: yesno
    sql: ${TABLE}.is_user_inactive ;;
  }

  dimension: is_user_joined {
    type: yesno
    sql: ${TABLE}.is_user_joined ;;
  }

  dimension: is_user_left {
    type: yesno
    sql: ${TABLE}.is_user_left ;;
  }

  dimension: last_seen {
    type: number
    sql: ${TABLE}.last_seen ;;
  }

  dimension: marked_unread {
    type: yesno
    sql: ${TABLE}.marked_unread ;;
  }

  dimension: membership_role {
    type: string
    sql: ${TABLE}.membership_role ;;
  }

  dimension_group: muted_until_timestamp_berlin {
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
    sql: ${TABLE}.muted_until_timestamp_berlin ;;
  }

  dimension: tenant {
    type: string
    sql: ${TABLE}.tenant ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: is_chat_pinned {
    type: yesno
    sql: ${TABLE}.is_chat_pinned ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
