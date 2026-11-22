view: marketing_filters_allocation_base {
  sql_table_name: `fl-bi-p-poc.reports_poc.marketing_filters_allocation` ;;

  dimension: ae_official_quota_monthly_euros {
    type: number
    sql: ${TABLE}.ae_official_quota_monthly_euros ;;
  }
  dimension: ae_quota_on_the_street_monthly_euros {
    type: number
    sql: ${TABLE}.ae_quota_on_the_street_monthly_euros ;;
  }

  dimension: asset_name {
    type: string
    sql: ${TABLE}.asset_name ;;
  }
  dimension: bdr_daily_calls_target {
    type: number
    sql: ${TABLE}.bdr_daily_calls_target ;;
  }
  dimension: bdr_daily_deals_to_win_target {
    type: number
    sql: ${TABLE}.bdr_daily_deals_to_win_target ;;
  }
  dimension: bdr_daily_emails_target {
    type: number
    sql: ${TABLE}.bdr_daily_emails_target ;;
  }
  dimension: bdr_daily_meetings_target {
    type: number
    sql: ${TABLE}.bdr_daily_meetings_target ;;
  }
  dimension: bdr_daily_pipe_to_generate_target {
    type: number
    sql: ${TABLE}.bdr_daily_pipe_to_generate_target ;;
  }
  dimension: bdr_daily_quota_target {
    type: number
    sql: ${TABLE}.bdr_daily_quota_target ;;
  }
  dimension: bdr_daily_sal_target {
    type: number
    sql: ${TABLE}.bdr_daily_sal_target ;;
  }
  dimension: bdr_daily_sao_target {
    type: number
    sql: ${TABLE}.bdr_daily_sao_target ;;
  }
  dimension: bdr_team_daily_pipe_to_generate_target {
    type: number
    sql: ${TABLE}.bdr_team_daily_pipe_to_generate_target ;;
  }
  dimension: bdr_team_daily_sao_target {
    type: number
    sql: ${TABLE}.bdr_team_daily_sao_target ;;
  }
  dimension: bdr_teamlead_daily_pipe_to_generate_target {
    type: number
    sql: ${TABLE}.bdr_teamlead_daily_pipe_to_generate_target ;;
  }
  dimension: bdr_teamlead_daily_sao_target {
    type: number
    sql: ${TABLE}.bdr_teamlead_daily_sao_target ;;
  }
  dimension: bdr_team {
    type: string
    sql: ${TABLE}.bdr_team ;;
  }
  dimension: bdr_teamlead {
    type: string
    sql: ${TABLE}.bdr_teamlead ;;
  }
  dimension: channel_daily_total_spend_euros {
    type: number
    sql: ${TABLE}.channel_daily_total_spend_euros ;;
  }
  dimension: channel_planned_quarterly_spend_euros {
    type: number
    sql: ${TABLE}.channel_planned_quarterly_spend_euros ;;
  }
  dimension: closed_won_volume_euros_base_target {
    type: number
    sql: ${TABLE}.closed_won_volume_euros_base_target;;
  }
  dimension: closed_won_count_base_target {
    type: number
    sql: ${TABLE}.closed_won_count_base_target;;
  }
  dimension_group: date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }
  dimension: deal_allocation {
    type: string
    sql: ${TABLE}.deal_allocation ;;
  }
  dimension: foreign_key_ae_targets {
    type: string
    sql: ${TABLE}.foreign_key_ae_targets ;;
  }
  dimension: foreign_key_bdr_targets {
    type: string
    sql: ${TABLE}.foreign_key_bdr_targets ;;
  }
  dimension: foreign_key_bdr_team_targets {
    type: string
    sql: ${TABLE}.foreign_key_bdr_team_targets ;;
  }
  dimension: foreign_key_bdr_teamlead_targets {
    type: string
    sql: ${TABLE}.foreign_key_bdr_teamlead_targets ;;
  }
  dimension: foreign_key_contacts_table {
    type: string
    sql: ${TABLE}.foreign_key_contacts_table ;;
  }
  dimension: foreign_key_csm_targets {
    type: string
    sql: ${TABLE}.foreign_key_csm_targets ;;
  }
  dimension: foreign_key_date_source_channel {
    type: string
    sql: ${TABLE}.foreign_key_date_source_channel ;;
  }
  dimension: foreign_key_date_trunc_month_source_channel {
    type: string
    sql: ${TABLE}.foreign_key_date_trunc_month_source_channel ;;
  }
  dimension: foreign_key_date_trunc_quarter_source_channel {
    type: string
    sql: ${TABLE}.foreign_key_date_trunc_quarter_source_channel ;;
  }
  dimension: is_active_ae {
    type: yesno
    sql: ${TABLE}.is_active_ae ;;
  }
  dimension: is_active_bdr {
    type: yesno
    sql: ${TABLE}.is_active_bdr ;;
  }
  dimension: is_ae_onboarded {
    type: yesno
    sql: ${TABLE}.is_ae_onboarded ;;
  }
  dimension: is_bdr_onboarded {
    type: yesno
    sql: ${TABLE}.is_bdr_onboarded ;;
  }
  dimension: is_official_ae {
    type: yesno
    sql: ${TABLE}.is_official_ae ;;
  }
  dimension: is_official_bdr {
    type: yesno
    sql: ${TABLE}.is_official_bdr ;;
  }
  dimension: lead_count_base_target {
    type: number
    sql: ${TABLE}.lead_count_base_target ;;
  }
  dimension: mql_count_base_target {
    type: number
    sql: ${TABLE}.mql_count_base_target ;;
  }
  dimension: partner_stage {
    type: string
    sql: ${TABLE}.partner_stage ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  dimension: sal_count_base_target {
    type: number
    sql: ${TABLE}.sal_count_base_target ;;
  }
  dimension: sales_region {
    type: string
    sql: ${TABLE}.sales_region ;;
  }
  dimension: sao_count_base_target {
    type: number
    sql: ${TABLE}.sao_count_base_target ;;
  }
  dimension: sao_count_deployed_target {
    type: number
    sql: ${TABLE}.sao_count_deployed_target ;;
  }
  dimension: sao_volume_euros_base_target {
    type: number
    sql: ${TABLE}.sao_volume_euros_base_target ;;
  }
  dimension: deal_source_channel_cluster_hubspot {
    type: string
    sql: ${TABLE}.deal_source_channel_cluster_hubspot ;;
  }
  dimension: deal_source_channel_department_hubspot {
    type: string
    sql: ${TABLE}.deal_source_channel_department_hubspot ;;
  }
  dimension: deal_source_channel_inbound_vs_outbound_hubspot {
    type: string
    sql: ${TABLE}.deal_source_channel_inbound_vs_outbound_hubspot ;;
  }
  dimension: sql_count_base_target {
    type: number
    sql: ${TABLE}.sql_count_base_target ;;
  }
  dimension: unique_key_targets_in_looker {
    type: string
    sql: ${TABLE}.unique_key_targets_in_looker ;;
  }
  measure: count {
    type: count
    drill_fields: [asset_name]
  }
}
