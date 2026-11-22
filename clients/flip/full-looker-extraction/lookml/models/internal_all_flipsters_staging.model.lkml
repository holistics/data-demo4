connection: "fl-bi-s-looker-sa"

include: "/extended_views/Datamarts_Staging/*.view"
# for testing

label: "All Flipsters [STAGING]"

# #---------- ACTIVE USERS --------------------------------------

# -------- CHATS & MESSAGES -----------------------------

explore: flip_staging_chats {
  from: flip_s_chat_messages_unique_ext
  label: "Flip STAGING Chats & Messages"
  view_label: "Messages"
  description: "Flip Core STAGING data including all relevant information on chats. db_row_deleted = hard delete."

  fields: [ALL_FIELDS*]

  persist_for: "4 hours"

  join: flip_s_chat_message_mentions_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_staging_chats.message_id} = ${flip_s_chat_message_mentions_unique_ext.message_id} ;;
    view_label: "Message Mentions"
  }

  join: flip_s_chats_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_staging_chats.chat_id} = ${flip_s_chats_unique_ext.chat_id};;
    view_label: "Chats"
  }

  join: flip_s_chat_memberships_unique_ext {
    type: left_outer
    relationship: one_to_many
    sql_on: ${flip_s_chats_unique_ext.chat_id} = ${flip_s_chat_memberships_unique_ext.chat_id} ;;
    view_label: "Chat Membership"
  }

  join: flip_s_attachments_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_staging_chats.message_id} = ${flip_s_attachments_unique_ext.attachment_element_id} ;;
    #sql_where: ${flip_s_attachments_unique_ext.attachment_element_type} = "message" ;;
    view_label: "Message Attachments (incl. Voice Msgs)"
  }

  join: flip_s_users_unique_ext_membership {
    from: flip_s_users_unique_ext
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_s_chat_memberships_unique_ext.user_id} = ${flip_s_users_unique_ext_membership.user_id} ;;
    view_label: "Users: Chat Members (join on membership user_id)"
  }

  join: flip_s_users_unique_ext_messages {
    from: flip_s_users_unique_ext
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_staging_chats.author_id} = ${flip_s_users_unique_ext_messages.user_id} ;;
    view_label: "Users: Chat Members (join on message user_id)"
  }

  join: flip_s_tenants_unique_ext {
    type: full_outer
    relationship: many_to_one
    sql_on: ${flip_s_chats_unique_ext.tenant} = ${flip_s_tenants_unique_ext.tenant} ;;
    view_label: "Tenants"
  }
}

# -------------- ATTACHMENTS -------------------------------

# -------------- ChatGPT ----------------------------------

# -------- OINS -------------------------------

# -------- BITS ----------------------------------------------------------------
# activities missing

# -------- CIAM

# explore: cs_mcdonalds_competition_260129_ext {

# }
