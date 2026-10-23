view: product_deals_feature_matrix_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.product_deals_feature_matrix` ;;

  dimension: additional_6colour_concept {
    type: yesno
    sql: ${TABLE}.additional_6colour_concept ;;
  }
  dimension: additional_calendar {
    type: yesno
    sql: ${TABLE}.additional_calendar ;;
  }
  dimension: additional_calendar_appointments {
    type: yesno
    sql: ${TABLE}.additional_calendar_appointments ;;
  }
  dimension: additional_conference {
    type: yesno
    sql: ${TABLE}.additional_conference ;;
  }
  dimension: additional_directory {
    type: yesno
    sql: ${TABLE}.additional_directory ;;
  }
  dimension: additional_document_storage {
    type: yesno
    sql: ${TABLE}.additional_document_storage ;;
  }
  dimension: additional_employee_productivity_module {
    type: yesno
    sql: ${TABLE}.additional_employee_productivity_module ;;
  }
  dimension: additional_employee_worker_card {
    type: yesno
    sql: ${TABLE}.additional_employee_worker_card ;;
  }
  dimension: additional_forms_wix {
    type: yesno
    sql: ${TABLE}.additional_forms_wix ;;
  }
  dimension: additional_newscast {
    type: yesno
    sql: ${TABLE}.additional_newscast ;;
  }
  dimension: additional_none {
    type: yesno
    sql: ${TABLE}.additional_none ;;
  }
  dimension: additional_novalue {
    type: yesno
    sql: ${TABLE}.additional_novalue ;;
  }
  dimension: additional_page_builder {
    type: yesno
    sql: ${TABLE}.additional_page_builder ;;
  }
  dimension: additional_page_builder_and_forms {
    type: yesno
    sql: ${TABLE}.additional_page_builder_and_forms ;;
  }
  dimension: additional_search {
    type: yesno
    sql: ${TABLE}.additional_search ;;
  }
  dimension: additional_survey {
    type: yesno
    sql: ${TABLE}.additional_survey ;;
  }
  dimension: additional_tasks {
    type: yesno
    sql: ${TABLE}.additional_tasks ;;
  }
  dimension: additional_translation {
    type: yesno
    sql: ${TABLE}.additional_translation ;;
  }
  dimension: additional_translation_chat {
    type: yesno
    sql: ${TABLE}.additional_translation_chat ;;
  }
  dimension: basic_dashboard {
    type: yesno
    sql: ${TABLE}.basic_dashboard ;;
  }
  dimension: basic_deactivation_download {
    type: yesno
    sql: ${TABLE}.basic_deactivation_download ;;
  }
  dimension: basic_deactivation_upload {
    type: yesno
    sql: ${TABLE}.basic_deactivation_upload ;;
  }
  dimension: basic_group_chat {
    type: yesno
    sql: ${TABLE}.basic_group_chat ;;
  }
  dimension: basic_newsfeed {
    type: yesno
    sql: ${TABLE}.basic_newsfeed ;;
  }
  dimension: basic_post_seen {
    type: yesno
    sql: ${TABLE}.basic_post_seen ;;
  }
  dimension: basic_private_chat {
    type: yesno
    sql: ${TABLE}.basic_private_chat ;;
  }
  dimension: company_id {
    type: string
    sql: ${TABLE}.company_id ;;
  }
  dimension: custom_app {
    type: yesno
    sql: ${TABLE}.custom_app ;;
  }
  dimension: deal_id {
    type: string
    sql: ${TABLE}.deal_id ;;
  }
  dimension: employee_productivity_module {
    type: yesno
    sql: ${TABLE}.employee_productivity_module ;;
  }
  dimension: employee_resources_module {
    type: yesno
    sql: ${TABLE}.employee_resources_module ;;
  }
  dimension: flip_ai {
    type: yesno
    sql: ${TABLE}.flip_ai ;;
  }
  dimension: post_scheduling {
    type: yesno
    sql: ${TABLE}.post_scheduling ;;
  }
  dimension: sharepoint_integration {
    type: yesno
    sql: ${TABLE}.sharepoint_integration ;;
  }
  dimension: sync_integration {
    type: yesno
    sql: ${TABLE}.sync_integration ;;
  }
  dimension: voice_messages {
    type: yesno
    sql: ${TABLE}.voice_messages ;;
  }
  measure: count {
    type: count
  }
}
