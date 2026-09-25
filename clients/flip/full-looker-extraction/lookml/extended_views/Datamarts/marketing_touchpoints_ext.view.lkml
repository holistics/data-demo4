  include: "/base_views/Datamarts/marketing_touchpoints_base.view"

  view: marketing_touchpoints_ext {
    extends: [marketing_touchpoints_base]

# ----- ORIGINAL DIMENSIONS ---------------------------------------------------------------------------------------------------------------------------------------

  dimension: awareness_dash_foreign_key {
    type: string
  }
  dimension: company_id {
    type: string
  }
  dimension: company_region {
    type: string
  }
  dimension: company_segment {
    type: string
  }
  dimension: contact_email {
    type: string
  }
  dimension: contact_id {
    type: string
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/contact/{{ contact_id }}"
    }
  }
  dimension: contact_source_channel {
    type: string
    label: "Contact Source Channel OLD"
  }
    dimension: contact_source_channel_cluster_hubspot {
      type: string
    }
  dimension: dmt_lead {
    type: string
  }
  dimension: dmt_mql {
    type: string
  }
  dimension: dmt_sql {
    type: string
  }
  dimension: dmt_opportunity {
    type: string
  }
  dimension: form_name {
    type: string
  }
  dimension: page_url {
    type: string
  }
  dimension: touchpoint_id {
    type: string
    primary_key: yes
  }
  dimension_group: touchpoint_inserted_at_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension_group: touchpoint_occured_at_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
  }
  dimension: touchpoint_source {
    type: string
  }
  dimension: touchpoint_title {
    type: string
  }
  dimension: touchpoint_type {
    type: string
  }

# ----- MEASURES --------------------------------------------------------------------------------------------------------------------------------------------------

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }

# ------------------ AWARENESS DASHBOARD MEASURES ------------------ #

  measure: distinct_users_with_demo_and_contact_submissions_count {
    type: count_distinct
    sql: ${contact_id} ;;
    # filters: [contact_id: "-NULL", touchpoint_type: "demo request, other form submission", touchpoint_title: "de_demo, en_demo, Kontakt - Wir helfen gerne bei Ihrem Anliegen | Flip: Kontakt DE, Contact - We are happy to help with your request | Flip | Flip: Contact EN"]
    filters: [contact_id: "-NULL", touchpoint_type: "demo request"]
    label: "# Users (with demo form submission)"
    description: "Count of unique users who submitted a Demo or a Contact form. This metric allows us to calculate the % of the distinct Website Users which submitted a Demo/Contact form (known as 'Conversion Rate')."
    value_format: "#,##0"
    drill_fields: [touchpoint_occured_at_timestamp_time, contact_id, contact_email, contact_source_channel_cluster_hubspot, company_region, company_segment, dmt_lead, dmt_mql, dmt_sql, dmt_opportunity, touchpoint_type, touchpoint_title, page_url]
  }

  measure: distinct_users_with_any_non_demo_submissions_count {
    type: count_distinct
    sql: ${contact_id} ;;
    # filters: [contact_id: "-NULL", touchpoint_type: "other form submission, savings calculator submission, whitepaper submission, newsletter sign-up, webinar sign-up", touchpoint_title: "-de_demo, -en_demo, -Kontakt - Wir helfen gerne bei Ihrem Anliegen | Flip: Kontakt DE, -Contact - We are happy to help with your request | Flip | Flip: Contact EN"]
    # 2024 Jul 15 — we have deleted other form submission from touchpoint types
    filters: [contact_id: "-NULL", touchpoint_type: "contact form submission, savings calculator submission, whitepaper submission, newsletter sign-up, webinar sign-up", touchpoint_title: "-de_demo, -en_demo"]
    label: "# Users (with non-demo form submission)"
    description: "Count of unique users who submitted any form. This metric allows us to calculate the % of the distinct Website Users which submitted a form (known as 'Conversion Rate')."
    value_format: "#,##0"
    drill_fields: [touchpoint_occured_at_timestamp_time, contact_id, contact_email, contact_source_channel_cluster_hubspot, company_region, company_segment, dmt_lead, dmt_mql, dmt_sql, dmt_opportunity, touchpoint_type, touchpoint_title, page_url]
  }

}
