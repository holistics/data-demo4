include: "/base_views/Reports/product_deals_feature_matrix_base.view"

view: product_deals_feature_matrix_ext {

extends: [product_deals_feature_matrix_base]

# --- DIMENSIONS

    dimension: additional_6colour_concept {
      type: yesno
    }
    dimension: additional_calendar {
      type: yesno
    }
    dimension: additional_calendar_appointments {
      type: yesno
    }
    dimension: additional_conference {
      type: yesno
    }
    dimension: additional_directory {
      type: yesno
    }
    dimension: additional_document_storage {
      type: yesno
    }
    dimension: additional_employee_productivity_module {
      type: yesno
    }
    dimension: additional_employee_worker_card {
      type: yesno
    }
    dimension: additional_forms_wix {
      type: yesno
    }
    dimension: additional_newscast {
      type: yesno
    }
    dimension: additional_none {
      type: yesno
    }
    dimension: additional_novalue {
      type: yesno
    }
    dimension: additional_page_builder {
      type: yesno
    }
    dimension: additional_page_builder_and_forms {
      type: yesno
    }
    dimension: additional_search {
      type: yesno
    }
    dimension: additional_survey {
      type: yesno
    }
    dimension: additional_tasks {
      type: yesno
    }
    dimension: additional_translation {
      type: yesno
    }
    dimension: additional_translation_chat {
      type: yesno
    }
    dimension: basic_dashboard {
      type: yesno
    }
    dimension: basic_deactivation_download {
      type: yesno
    }
    dimension: basic_deactivation_upload {
      type: yesno
    }
    dimension: basic_group_chat {
      type: yesno
    }
    dimension: basic_newsfeed {
      type: yesno
    }
    dimension: basic_post_seen {
      type: yesno
    }
    dimension: basic_private_chat {
      type: yesno
    }
    dimension: company_id {
      type: string
    }
    dimension: custom_app {
      type: yesno
    }
    dimension: deal_id {
      type: string
      primary_key: yes
    }
    dimension: employee_productivity_module {
      type: yesno
    }
    dimension: employee_resources_module {
      type: yesno
    }
    dimension: flip_ai {
      type: yesno
    }
    dimension: post_scheduling {
      type: yesno
    }
    dimension: sharepoint_integration {
      type: yesno
    }
    dimension: sync_integration {
      type: yesno
    }
    dimension: voice_messages {
      type: yesno
    }

# --- MEASURES ------------
    measure: count {
      type: count
      label: "# Deals"
    }

    measure: company_count_distinct {
      type: count_distinct
      label: "# Customers"
      sql: ${company_id} ;;
    }
  }
