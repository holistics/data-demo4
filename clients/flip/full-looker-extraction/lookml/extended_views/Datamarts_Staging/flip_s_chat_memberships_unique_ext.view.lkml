include: "/base_views/Datamarts_Staging/flip_s_chat_memberships_unique_base.view"

view: flip_s_chat_memberships_unique_ext {

  extends: [flip_s_chat_memberships_unique_base]

  drill_fields: [chat_membership_id, membership_role, tenant, is_chat_member_deleted]

#--------------DIMENSIONS-----------------------------------------------------------

  dimension: chat_id {
    type: string
    hidden: yes
  }

  dimension: chat_membership_id {
    type: string
    primary_key: yes
    hidden: yes
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

  }

  dimension: is_chat_archived {
    type: yesno

  }

  dimension: is_chat_member_deleted {
    type: yesno

  }

  dimension: is_db_row_deleted {
    type: yesno
    hidden: yes
  }

  dimension: last_seen {
    type: number

  }

  dimension: membership_role {
    type: string

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

  }

  dimension: tenant {
    type: string

  }

  dimension: user_id {
    type: string

  }

  #----------------Manually ADDED DIMENSIONS-------------------------

  #----------------Measures------------------------------------------

  measure: count {
    type: count
    label: "# Chat Membership"
    description: "Count of unique chat_membership_id"
  }

  measure: admin_count {
    type: count
    filters: [membership_role: "ADMIN"]
    label: "# Admin"
  }

  measure: member_count {
    type: count
    filters: [membership_role: "MEMBER"]
    label: "# Member"
  }
}
