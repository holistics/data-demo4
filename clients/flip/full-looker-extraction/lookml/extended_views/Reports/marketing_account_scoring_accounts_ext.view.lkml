include: "/base_views/Reports/marketing_account_scoring_accounts_base.view"

view: marketing_account_scoring_accounts_ext {

  extends: [marketing_account_scoring_accounts_base]

  drill_fields: [contact_id, contact_name, account_name, account_allocation, contact_source_channel_cluster_hubspot, contact_source_channel_hubspot, contact_lifecycle_stage, account_bdr]

# ----- DIMENSIONS ---------------------------------------------------------------------------------------------------------

  dimension: account_allocation {
    type: string
  }

  dimension: account_bdr {
    type: string
  }

  dimension: account_classification {
    type: string
  }

  dimension: account_contact_foreign_key {
    type: string
  }

  dimension: account_deal_foreign_key {
    type: string
  }

  dimension: account_id {
    type: string
  }

  dimension: account_last_activity_date {
    type: string
  }
  dimension: account_last_contacted_date {
    type: string
  }
  dimension: account_last_engagement_date {
    type: string
  }

  # dimension_group: account_last_activity { # seems to be redefined as string ? // 7-2025
  #   type: time
  #   timeframes: [raw, date, week, month, quarter, year]
  #   convert_tz: no
  #   datatype: date
  # }

  # dimension_group: account_last_contacted { # seems to be redefined as string ? // 7-2025
  #   type: time
  #   timeframes: [raw, date, week, month, quarter, year]
  #   convert_tz: no
  #   datatype: date
  #   description: "Refers to the date when the Account was last contacted by a HubSpot user"
  # }

  # dimension_group: account_last_engagement { # seems to be redefined as string ? // 7-2025
  #   type: time
  #   timeframes: [raw, date, week, month, quarter, year]
  #   convert_tz: no
  #   datatype: date
  # }

  dimension: account_linkedin_page {
    type: string
    link: {
      label: "LinkedIn Page"
      url: "{{ account_linkedin_page }}"
    }
  }

  dimension: account_marketing_campaigns_memberships {
    type: string
    label: "Account Marketing Campaigns Memberships"
    description: "Indicates whether an Account is or was targeted in specific Marketing Campaigns (multiple selection enabled)"
  }

  dimension: account_name {
    type: string
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/company/{{ account_id }}"
    }
  }
  dimension: account_other_technologies {
    type: string
  }

  dimension: account_owner {
    type: string
  }

  dimension: account_industry {
    type: string
  }

  dimension: account_region {
    type: string
  }

  dimension: account_segment {
    type: string
  }

  dimension: account_source_system {
    type: string
  }

  dimension: account_territory {
    type: string
  }

  dimension: contact_department_categorised {
    type: string
  }

  dimension: contact_department_raw {
    type: string
  }

  dimension: contact_email {
    type: string
  }

  dimension: contact_id {
    type: string
  }

  dimension: contact_job_title_raw {
    type: string
  }

  dimension_group: contact_dmt_lead {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    label: "Became Lead"
  }

  dimension_group: contact_dmt_mql {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    label: "Became MQL"
  }

  dimension_group: contact_dmt_sql {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    label: "Became SQL"
  }

  dimension_group: contact_dmt_opportunity {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    label: "Became Opportunity"
  }

  dimension_group: contact_dmt_sal {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    label: "Became SAL"
  }

  dimension_group: contact_dmt_sao {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    label: "Became SAO"
  }

  dimension_group: contact_last_activity {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  dimension_group: contact_last_contacted {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    description: "Refers to the date when the Contact was last contacted by a HubSpot user"
  }

  dimension_group: contact_last_engagement {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  dimension: contact_lifecycle_stage {
    type: string
    description: "Indicates the current lifecycle stage of the Contact in the Sales Pipeline"
  }

  dimension: contact_marketing_campaigns_memberships {
    type: string
    label: "Contact Marketing Campaigns Memberships"
    description: "Indicates whether a Contact is or was targeted in specific Marketing Campaigns (multiple selection enabled)"
  }

  dimension: contact_name {
    type: string
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/contact/{{ contact_id }}"
    }
    label: "Contact Name"
    description: "Session ID is shown for anonymous contacts"
  }

  dimension: contact_project_status {
    type: string
  }

  dimension: contact_seniority_categorised {
    type: string
  }

  dimension: contact_source_channel_hubspot {
    type: string
  }

  dimension: contact_source_channel_cluster_hubspot {
    type: string
  }
  dimension: contact_source_channel_department_hubspot {
    type: string
  }

  dimension: contact_source_channel_drilldown_hubspot {
    type: string
  }

  dimension: contact_source_super_channel { # replace with department
    type:  string
    sql:   (CASE WHEN LOWER(${contact_source_channel_cluster_hubspot}) IN ("management/investor referral") THEN "Mgmt/Inv"
              WHEN LOWER(${contact_source_channel_cluster_hubspot}) IN ("cs referral") THEN "CS"
              WHEN LOWER(${contact_source_channel_cluster_hubspot}) IN ("partner mngt") THEN "Partner"
              WHEN LOWER(${contact_source_channel_cluster_hubspot}) IN ("bdr outbound") THEN "BDR Out"
              WHEN LOWER(${contact_source_channel_cluster_hubspot}) IN ("ae outbound") THEN "AE Out"
              WHEN LOWER(${contact_source_channel_cluster_hubspot}) IS NULL OR LOWER(${contact_source_channel_cluster_hubspot}) IN ("w/o","-") THEN "w/o"
              ELSE "Marketing" END
        );;
    label: "Contact first-touch Super Channel OLD"
  }

  dimension: contact_source_channel { # replace with cluster
    type: string
    description: "Indicates the first GTM asset that an user had an interaction with"
    label: "Contact first-touch Channel OLD"
  }

  dimension: contact_source_channel_drilldown { #replace with drilldown
    type: string
    description: "Drilling down on the asset of the Source Channel"
    label: "Contact first-touch Channel Asset OLD"
  }

  dimension: contact_trade_show_owner {
    type: string
    label: "Contact Trade Show Owner"
    description: "Flip GTM colleague which owns the contact sourced at the trade show"
  }

  dimension_group: deal_created_at {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  dimension: deal_current_amount_euros {
    type: number
    description: "Indicates the € Deal Size of the current Opportunity open in the Sales Pipeline."
  }

  dimension: deal_current_amount_in_record_currency {
    type: number
    description: "Indicates the Deal Size of the current Opportunity open in the Sales Pipeline in the deal's currency."
  }

  dimension: deal_initial_sao_amount_euros {
    type: number
    description: "Indicates the € Deal Size when the Opportunity became a SAO/was accepted by the AE"
  }

  dimension: deal_initial_sao_amount_in_record_currency {
    type: number
    description: "Indicates the Deal Size in the deal's currency when the Opportunity became a SAO/was accepted by the AE"
  }

  dimension: deal_id {
    type: string
  }

  dimension: deal_name {
    type: string
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/deal/{{ deal_id }}"
    }
  }

  dimension: deal_owner_name {
    type: string
  }

  dimension: deal_source_channel_cluster_hubspot {
    type: string
  }
  dimension: deal_source_channel_department_hubspot {
    type: string
  }
  dimension: deal_source_channel_drilldown_hubspot {
    type: string
  }

  dimension: deal_source_channel { # replace
    type: string
    label: "Deal first-touch Channel OLD"
  }
  dimension: deal_source_channel_drilldown { # replace
    type: string
    label: "Deal first-touch Channel Asset OLD"
  }
  dimension: deal_source_channel_for_contacts { # replace
    type: string
    label: "Deal first-touch Channel for Contact to Opportunity OLD"
  }

  dimension_group: dmt_discovery {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  dimension: is_account_in_crm {
    type: yesno
    description: "Indicates wether Account exists in HubSpot or not"
  }

  dimension: is_account_tam {
    type: yesno
    label: "Account is TAM"
    description: "Indicates if Account is part of the Total Addressable Market list"
  }

  dimension: is_contact_in_crm {
    type: yesno
    description: "Indicates if Contacts exists in HubSpot"
  }

  dimension: primary_key {
    type: string
    primary_key: yes
  }

  dimension: stage_label {
    type: string
    description: "Indicates the current stage of the Account in the Sales Pipeline"
  }
# ----- DIMENSIONS ---------------------------------------------------------------------------------------------------------

  dimension: account_linkedin_page_short {
    type: string
    sql: REPLACE(${account_linkedin_page},"https://www.linkedin.com/company/","") ;;
    label: "LinkedIn Page"
    link: {
      label: "URL"
      url: "{{ account_linkedin_page }}"
    }
  }

# ----- MEASURES -----------------------------------------------------------------------------------------------------------

  measure: count {
    type: count
  }

  measure: new_signed_arr_sum_euros {
    type: sum_distinct
    sql_distinct_key: ${account_deal_foreign_key} ;;
    sql: ${deal_current_amount_euros} ;;
    filters: [deal_current_amount_euros: ">0", stage_label: "S8. Closed Won"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ New signed ARR"
    description: "Sum of the Deal Amount from the Deals which were moved to Closed Won"
    drill_fields: [deal_name, stage_label, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, new_signed_arr_sum_euros]
  }

  measure: current_pipeline_volume_sum_euros {
    type: sum_distinct
    sql_distinct_key: ${account_deal_foreign_key} ;;
    sql: ${deal_current_amount_euros} ;;
    filters: [deal_current_amount_euros: ">0", stage_label: "-S9. Closed Lost, -S8. Closed Won, -S1. SAL"]
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    label: "€ Current Pipeline Volume"
    description: "Sum of the Current Deal Amount from Deals which entered the SAO stage (static value)"
    drill_fields: [deal_name, stage_label, deal_owner_name, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, current_pipeline_volume_sum_euros]
  }

  measure: unique_accounts_count {
    type: count_distinct
    sql: ${account_id} ;;
    drill_fields: [account_name, account_owner, account_bdr, account_allocation, is_account_tam, contact_name, contact_source_channel_cluster_hubspot, contact_source_channel_hubspot]
    label: "# unique Accounts engaged"
  }

  measure: unique_tam_accounts_count {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [is_account_tam: "Yes"]
    drill_fields: [account_name, account_owner, account_bdr, account_allocation, is_account_tam, contact_name, contact_source_channel_cluster_hubspot, contact_source_channel_hubspot]
    label: "# unique Accounts (TAM) engaged"
  }

  measure: unique_contacts_count {
    type: count_distinct
    sql: ${contact_id} ;;
    drill_fields: [contact_id, account_name, contact_name, contact_source_channel_cluster_hubspot, contact_source_channel_hubspot, contact_lifecycle_stage, account_bdr]
    label: "# unique Contacts engaged"
  }

  measure: unique_tam_contacts_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [is_account_tam: "Yes"]
    drill_fields: [contact_id, account_name, contact_name, contact_source_channel_cluster_hubspot, contact_source_channel_hubspot, contact_lifecycle_stage, account_bdr]
    label: "# unique Contacts (TAM) engaged"
  }

  measure: contact_became_lead_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [contact_dmt_lead_date: "-NULL"]
    label: "# Contacts to 1. Lead"
  }

  measure: cr_lead_to_mql {
    type: number
    sql: ${contact_became_mql_count}/IF(${contact_became_lead_count} = 0, NULL, ${contact_became_lead_count}) ;;
    label: "CR Lead-MQL"
    value_format: "0%"
  }

  measure: contact_became_mql_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [contact_dmt_mql_date: "-NULL"]
    label: "# Contacts to 2. MQL"
  }

  measure: cr_mql_to_sql {
    type: number
    sql: ${contact_became_sql_count}/IF(${contact_became_mql_count} = 0, NULL, ${contact_became_mql_count}) ;;
    label: "CR MQL-SQL"
    value_format: "0%"
  }

  measure: contact_became_sql_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [contact_dmt_sql_date: "-NULL"]
    label: "# Contacts to 3. SQL"
  }

  measure: cr_sql_to_sal {
    type: number
    sql: ${contact_became_opportunity_count}/IF(${contact_became_sql_count} = 0, NULL, ${contact_became_sql_count}) ;;
    label: "CR SQL-SAL"
    value_format: "0%"
  }

  measure: contact_became_opportunity_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [contact_dmt_opportunity_date: "-NULL"]
    label: "# Contacts to 4. SAL"
  }

  measure: cr_sal_to_sao {
    type: number
    sql: ${contact_became_sao_count}/IF(${contact_became_opportunity_count} = 0, NULL, ${contact_became_opportunity_count}) ;;
    label: "CR SAL-SAO"
    value_format: "0%"
  }

  measure: contact_became_sao_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: [contact_dmt_sao_date: "-NULL"]
    label: "# Contacts to 5. SAO"
  }

}
