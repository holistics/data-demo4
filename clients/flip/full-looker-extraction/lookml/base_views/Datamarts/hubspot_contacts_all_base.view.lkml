view: hubspot_contacts_all_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.hubspot_contacts_all` ;;

  dimension_group: associated_deal_first_dmt_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.associated_deal_first_dmt_sao ;;
  }
  dimension: bombora_intent_score {
    type: string
    sql: ${TABLE}.bombora_intent_score ;;
  }
  dimension: bombora_research_stage {
    type: string
    sql: ${TABLE}.bombora_research_stage ;;
  }
  dimension: buying_role {
    type: string
    sql: ${TABLE}.buying_role ;;
  }
  dimension: campaign_or_event {
    type: string
    sql: ${TABLE}.campaign_or_event ;;
  }
  dimension: company_country {
    type: string
    sql: ${TABLE}.company_country ;;
  }
  dimension_group: company_created_at {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.company_created_at_date ;;
  }
  dimension: company_id {
    type: string
    sql: ${TABLE}.company_id ;;
  }
  dimension: company_industry {
    type: string
    sql: ${TABLE}.company_industry ;;
  }
  dimension: company_is_edeka {
    type: yesno
    sql: ${TABLE}.company_is_edeka ;;
  }
  dimension: company_is_workplace_partner {
    type: yesno
    sql: ${TABLE}.company_is_workplace_partner ;;
  }
  dimension: company_marketing_campaigns_memberships {
    type: string
    sql: ${TABLE}.company_marketing_campaigns_memberships ;;
  }
  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
  }
  dimension: company_other_technologies {
    type: string
    sql: ${TABLE}.company_other_technologies ;;
  }
  dimension: company_owner {
    type: string
    sql: ${TABLE}.company_owner ;;
  }
  dimension: company_partner_marker {
    type: string
    sql: ${TABLE}.company_partner_marker ;;
  }
  dimension: company_region {
    type: string
    sql: ${TABLE}.company_region ;;
  }
  dimension: company_segment {
    type: string
    sql: ${TABLE}.company_segment ;;
  }
  dimension: company_workplace_list_region {
    type: string
    sql: ${TABLE}.company_workplace_list_region ;;
  }
  dimension: company_workplace_source {
    type: string
    sql: ${TABLE}.company_workplace_source ;;
  }
  dimension: contact_allocation {
    type: string
    sql: ${TABLE}.contact_allocation ;;
  }
  dimension: contact_id {
    type: string
    sql: ${TABLE}.contact_id ;;
  }
  dimension: contact_linkedin_campaign_name {
    type: string
    sql: ${TABLE}.contact_linkedin_campaign_name ;;
  }
  dimension: contact_marketing_campaigns_memberships {
    type: string
    sql: ${TABLE}.contact_marketing_campaigns_memberships ;;
  }
  dimension: contact_name {
    type: string
    sql: ${TABLE}.contact_name ;;
  }
  dimension: contact_owner {
    type: string
    sql: ${TABLE}.contact_owner ;;
  }
  dimension: contact_source_channel_cluster_hubspot {
    type: string
    sql: ${TABLE}.contact_source_channel_cluster_hubspot ;;
  }
  dimension: contact_source_channel_department_hubspot {
    type: string
    sql: ${TABLE}.contact_source_channel_department_hubspot ;;
  }
  dimension: contact_source_channel_drilldown_hubspot {
    type: string
    sql: ${TABLE}.contact_source_channel_drilldown_hubspot ;;
  }
  dimension: contact_source_channel_hubspot {
    type: string
    sql: ${TABLE}.contact_source_channel_hubspot ;;
  }
  dimension: contact_source_channel_inbound_vs_outbound_hubspot {
    type: string
    sql: ${TABLE}.contact_source_channel_inbound_vs_outbound_hubspot ;;
  }
  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }
  dimension_group: create {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.create_date ;;
  }
  dimension: days_from_lead_to_mql {
    type: number
    sql: ${TABLE}.days_from_lead_to_mql ;;
  }
  dimension: days_from_mql_to_sql {
    type: number
    sql: ${TABLE}.days_from_mql_to_sql ;;
  }
  dimension: days_from_sql_to_opportunity {
    type: number
    sql: ${TABLE}.days_from_sql_to_opportunity ;;
  }
  dimension: days_from_sql_to_sao {
    type: number
    sql: ${TABLE}.days_from_sql_to_sao ;;
  }
  dimension: days_in_mql {
    type: number
    sql: ${TABLE}.days_in_mql ;;
  }
  dimension: days_in_sql {
    type: number
    sql: ${TABLE}.days_in_sql ;;
  }
  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }
  dimension_group: dmt_customer {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_customer ;;
  }
  dimension_group: dmt_lead {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_lead ;;
  }
  dimension_group: dmt_mql {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_mql ;;
  }
  dimension_group: dmt_opportunity {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_opportunity ;;
  }
  dimension_group: dmt_sql {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_sql ;;
  }
  dimension_group: dmt_subscriber {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dmt_subscriber ;;
  }
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }
  dimension: email_domain {
    type: string
    sql: ${TABLE}.email_domain ;;
  }
  dimension: email_from_form_submission_static {
    type: string
    sql: ${TABLE}.email_from_form_submission_static ;;
  }
  dimension: engagement_score {
    type: number
    sql: ${TABLE}.engagement_score ;;
  }
  dimension_group: first_conversion {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_conversion_date ;;
  }
  dimension: foreign_key_created_at_date_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_created_at_date_marketing_filters ;;
  }
  dimension: foreign_key_created_at_date_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_created_at_date_marketing_filters_allocation ;;
  }
  dimension: foreign_key_lead_campaign_management {
    type: string
    sql: ${TABLE}.foreign_key_lead_campaign_management ;;
  }
  dimension: foreign_key_lead_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_lead_marketing_filters ;;
  }
  dimension: foreign_key_lead_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_lead_marketing_filters_allocation ;;
  }
  dimension: foreign_key_mql_bdr_dashboard {
    type: string
    sql: ${TABLE}.foreign_key_mql_bdr_dashboard ;;
  }
  dimension: foreign_key_mql_campaign_management {
    type: string
    sql: ${TABLE}.foreign_key_mql_campaign_management ;;
  }
  dimension: foreign_key_mql_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_mql_marketing_filters ;;
  }
  dimension: foreign_key_mql_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_mql_marketing_filters_allocation ;;
  }
  dimension: foreign_key_opportunity_campaign_management {
    type: string
    sql: ${TABLE}.foreign_key_opportunity_campaign_management ;;
  }
  dimension: foreign_key_opportunity_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_opportunity_marketing_filters ;;
  }
  dimension: foreign_key_opportunity_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_opportunity_marketing_filters_allocation ;;
  }
  dimension: foreign_key_rd_lead {
    type: string
    sql: ${TABLE}.foreign_key_rd_lead ;;
  }
  dimension: foreign_key_rd_mql {
    type: string
    sql: ${TABLE}.foreign_key_rd_mql ;;
  }
  dimension: foreign_key_sql_bdr_dashboard {
    type: string
    sql: ${TABLE}.foreign_key_sql_bdr_dashboard ;;
  }
  dimension: foreign_key_sql_campaign_management {
    type: string
    sql: ${TABLE}.foreign_key_sql_campaign_management ;;
  }
  dimension: foreign_key_sql_marketing_filters {
    type: string
    sql: ${TABLE}.foreign_key_sql_marketing_filters ;;
  }
  dimension: foreign_key_sql_marketing_filters_allocation {
    type: string
    sql: ${TABLE}.foreign_key_sql_marketing_filters_allocation ;;
  }
  dimension: good_to_know {
    type: string
    sql: ${TABLE}.good_to_know ;;
  }
  dimension: grouped_campaign {
    type: string
    sql: ${TABLE}.grouped_campaign ;;
  }
  dimension: has_contact_converted_from_lead_to_mql {
    type: yesno
    sql: ${TABLE}.has_contact_converted_from_lead_to_mql ;;
  }
  dimension: has_contact_converted_from_mql_to_sql {
    type: yesno
    sql: ${TABLE}.has_contact_converted_from_mql_to_sql ;;
  }
  dimension: has_contact_converted_from_sql_to_opportunity {
    type: yesno
    sql: ${TABLE}.has_contact_converted_from_sql_to_opportunity ;;
  }
  dimension: has_contact_ever_been_lead {
    type: yesno
    sql: ${TABLE}.has_contact_ever_been_lead ;;
  }
  dimension: has_contact_ever_been_mql {
    type: yesno
    sql: ${TABLE}.has_contact_ever_been_mql ;;
  }
  dimension: has_contact_ever_been_opportunity {
    type: yesno
    sql: ${TABLE}.has_contact_ever_been_opportunity ;;
  }
  dimension: has_contact_ever_been_sql {
    type: yesno
    sql: ${TABLE}.has_contact_ever_been_sql ;;
  }
  dimension: hubspot_score {
    type: number
    sql: ${TABLE}.hubspot_score ;;
  }
  dimension: intent_score {
    type: number
    sql: ${TABLE}.intent_score ;;
  }
  dimension: is_already_customer_since_the_creation_date {
    type: yesno
    sql: ${TABLE}.is_already_customer_since_the_creation_date ;;
  }
  dimension: job_title {
    type: string
    sql: ${TABLE}.job_title ;;
  }
  dimension_group: last_activity {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_activity_date ;;
  }
  dimension_group: last_contacted {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_contacted_date ;;
  }
  dimension_group: last_engagement {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_engagement_date ;;
  }
  dimension_group: last_modified {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_modified_date ;;
  }
  dimension: latest_utm_campaign {
    type: string
    sql: ${TABLE}.latest_utm_campaign ;;
  }
  dimension: latest_utm_term {
    type: string
    sql: ${TABLE}.latest_utm_term ;;
  }
  dimension: lead_project_status {
    type: string
    sql: ${TABLE}.lead_project_status ;;
  }
  dimension: lead_rating {
    type: string
    sql: ${TABLE}.lead_rating ;;
  }
  dimension: lead_rating_comment {
    type: string
    sql: ${TABLE}.lead_rating_comment ;;
  }
  dimension: lead_score {
    type: number
    sql: ${TABLE}.lead_score ;;
  }
  dimension: lead_status {
    type: string
    sql: ${TABLE}.lead_status ;;
  }
  dimension: life_cycle_stage {
    type: string
    sql: ${TABLE}.life_cycle_stage ;;
  }
  dimension_group: lifecyclestage_customer {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.lifecyclestage_customer_date ;;
  }
  dimension_group: lifecyclestage_evangelist {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.lifecyclestage_evangelist_date ;;
  }
  dimension_group: lifecyclestage_lead {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.lifecyclestage_lead_date ;;
  }
  dimension_group: lifecyclestage_mql {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.lifecyclestage_mql_date ;;
  }
  dimension_group: lifecyclestage_opportunity {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.lifecyclestage_opportunity_date ;;
  }
  dimension_group: lifecyclestage_sql {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.lifecyclestage_sql_date ;;
  }
  dimension_group: lifecyclestage_subscriber {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.lifecyclestage_subscriber_date ;;
  }
  dimension: marketing_emails_clicked {
    type: string
    sql: ${TABLE}.marketing_emails_clicked ;;
  }
  dimension: marketing_emails_delivered {
    type: string
    sql: ${TABLE}.marketing_emails_delivered ;;
  }
  dimension: marketing_emails_open {
    type: string
    sql: ${TABLE}.marketing_emails_open ;;
  }
  dimension: marketing_emails_replied {
    type: string
    sql: ${TABLE}.marketing_emails_replied ;;
  }
  dimension: number_of_form_submissions {
    type: string
    sql: ${TABLE}.number_of_form_submissions ;;
  }
  dimension: number_of_page_views {
    type: string
    sql: ${TABLE}.number_of_page_views ;;
  }
  dimension: number_of_sessions {
    type: string
    sql: ${TABLE}.number_of_sessions ;;
  }
  dimension: original_source {
    type: string
    sql: ${TABLE}.original_source ;;
  }
  dimension: original_source_1 {
    type: string
    sql: ${TABLE}.original_source_1 ;;
  }
  dimension: original_source_2 {
    type: string
    sql: ${TABLE}.original_source_2 ;;
  }
  dimension: paid_search_channel {
    type: string
    sql: ${TABLE}.paid_search_channel ;;
  }
  dimension: partner_marketing_campaign {
    type: string
    sql: ${TABLE}.partner_marketing_campaign ;;
  }
  dimension: has_partner_marketing_influence {
    type: string
    sql: ${TABLE}.has_partner_marketing_influence ;;
  }
  dimension: preferred_language {
    type: string
    sql: ${TABLE}.preferred_language ;;
  }
  dimension: role_bc {
    type: string
    sql: ${TABLE}.role_BC ;;
  }
  dimension: seniority {
    type: string
    sql: ${TABLE}.seniority ;;
  }
  dimension: source_channel {
    type: string
    sql: ${TABLE}.source_channel ;;
  }
  dimension_group: source_channel_attribution {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.source_channel_attribution_date ;;
  }
  dimension: source_channel_drilldown {
    type: string
    sql: ${TABLE}.source_channel_drilldown ;;
  }
  dimension_group: time_last_seen {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.time_last_seen ;;
  }
  dimension_group: time_of_last_session {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.time_of_last_session ;;
  }
  dimension: trade_show {
    type: string
    sql: ${TABLE}.trade_show ;;
  }
  dimension: trade_show_contact_owner {
    type: string
    sql: ${TABLE}.trade_show_contact_owner ;;
  }
  dimension: workplace_comments {
    type: string
    sql: ${TABLE}.workplace_comments ;;
  }
  dimension: workplace_community_membership {
    type: string
    sql: ${TABLE}.workplace_community_membership ;;
  }
  dimension: workplace_customer {
    type: yesno
    sql: ${TABLE}.workplace_customer ;;
  }
  dimension: workplace_user {
    type: yesno
    sql: ${TABLE}.workplace_user ;;
  }
  measure: count {
    type: count
    drill_fields: [company_name, contact_linkedin_campaign_name, contact_name]
  }
}
