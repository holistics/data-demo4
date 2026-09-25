include: "/base_views/Datamarts/hubspot_deal_marketing_influence_touchpoints_unnested_base.view"
#include: "/base_views/Datamarts/hubspot_deals_all_ext.view"

  view: hubspot_deal_marketing_influence_touchpoint_ext {

    extends: [hubspot_deal_marketing_influence_touchpoints_unnested_base]

    ## DIMENSIONS

    dimension: deal_id {
      type: string
    }
    dimension: deal_marketing_influence_touchpoint {
      type: string
    }
    dimension: ae_name {
      type: string
    }
    dimension: bdr_name {
      type: string
    }
    dimension: created_at_date_drilldown {
      type: string
      label: "Created At Date"
      # hidden: yes
    }

    dimension: close_date_drilldown {
      type: string
      sql: ${close_date} ;;
      label: "Close Date"
      # hidden: yes
    }

    dimension: contact_dmt_lead_drilldown {
      type: string
      sql: ${contact_dmt_lead_date} ;;
      label: "Contact DMT Lead"
      # hidden: yes
    }

    dimension: contact_dmt_mql_drilldown {
      type: string
      sql: ${contact_dmt_mql_date} ;;
      label: "Contact DMT MQL"
      # hidden: yes
    }

    dimension: contact_dmt_sql_drilldown {
      type: string
      sql: ${contact_dmt_sql_date} ;;
      label: "Contact DMT SQL"
      # hidden: yes
    }
    dimension_group: close {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: contact_dmt_lead {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: contact_dmt_mql {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: contact_dmt_sql {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: created_at_date {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension: current_amount_euros {
      type: number
      hidden: yes
    }
    dimension: deal_allocation {
      type: string
    }
    dimension: deal_allocation_mix {
      type: string
    }
    dimension: deal_name {
      type: string
    }
    dimension: deal_owner_name {
      type: string
    }
    dimension: deal_segment {
      type: string
    }
    dimension: deal_source_channel_campaign_name {
      type: string
    }
    dimension: deal_source_channel_cluster_hubspot {
      type: string
    }
    dimension: deal_source_channel_drilldown_hubspot {
      type: string
    }
    dimension: deal_type {
      type: string
    }
    dimension: dmt_sal_drilldown {
      type: string
      sql: ${dmt_sal_date} ;;
      label: "DMT SAL"
      hidden: yes
    }

    dimension: dmt_sao_drilldown {
      type: string
      sql: ${dmt_sao_date} ;;
      label: "DMT SAO"
      hidden: yes
    }

    dimension: dmt_solution_design_drilldown {
      type: string
      sql: ${dmt_solution_design_date} ;;
      label: "DMT Solution Design"
      hidden: yes
    }

    dimension: dmt_evaluation_drilldown {
      type: string
      sql: ${dmt_evaluation_date} ;;
      label: "DMT Evaluation"
      hidden: yes
    }

    dimension: dmt_proposal_drilldown {
      type: string
      sql: ${dmt_proposal_date} ;;
      label: "DMT Proposal"
      hidden: yes
    }

    dimension: dmt_negotiation_drilldown {
      type: string
      sql: ${dmt_negotiations_date} ;;
      label: "DMT Negotiation"
      hidden: yes
    }

    dimension: dmt_closed_won_drilldown {
      type: string
      sql: ${dmt_closed_won_date} ;;
      label: "DMT Closed Won"
      hidden: yes
    }

    dimension_group: dmt_closed_won {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: dmt_evaluation {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: dmt_negotiations {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: dmt_proposal {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: dmt_sal {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: dmt_sao {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: dmt_solution_design {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension_group: event_date {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension: forecast_category {
      type: string
    }
    dimension: initial_sao_amount_euros {
      type: number
      hidden: yes
    }
    dimension: new_business_vs_upsell {
      type: string
    }
    dimension: sales_region {
      type: string
    }
    dimension: stage_label {
      type: string
    }

    ## MEASURES

    measure: marketing_influenced_count {
      type: count_distinct
      sql: ${deal_id} ;;
      drill_fields: [deal_id, deal_name,  deal_type, deal_source_channel_cluster_hubspot, deal_source_channel_drilldown_hubspot, deal_source_channel_campaign_name, bdr_name, ae_name, deal_owner_name, sales_region, deal_segment, deal_allocation, deal_allocation_mix, stage_label, created_at_date_drilldown, contact_dmt_lead_drilldown, contact_dmt_mql_drilldown, contact_dmt_sql_drilldown, dmt_sal_drilldown, dmt_sao_drilldown, dmt_solution_design_drilldown, dmt_evaluation_drilldown, dmt_proposal_drilldown, dmt_negotiation_drilldown, dmt_closed_won_drilldown, close_date,  forecast_category, sao_volume_sum_euros, current_amount_sum_euros, deal_marketing_influence_touchpoint]
      label: "# Deals Marketing Influenced (raw)"
      description: "Count of deals where the event matches one of the deal's marketing influence touchpoints. Filter by stage (SAO/Closed Won) using the joined deals view's date fields."
    }

    measure: sao_volume_sum_euros {
      type: sum_distinct
      sql_distinct_key: ${deal_id} ;;
      sql:  ${initial_sao_amount_euros};;
      filters: [dmt_sao_date:"-NULL", new_business_vs_upsell: "New Business, Upsell"]
      value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";0"
      drill_fields: [deal_id, deal_name, deal_source_channel_cluster_hubspot, deal_type, deal_source_channel_campaign_name, deal_source_channel_drilldown_hubspot, bdr_name, ae_name,  deal_owner_name, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, forecast_category, dmt_sao_drilldown, close_date_drilldown, sao_volume_sum_euros, current_amount_sum_euros]
      label: "€ SAO Volume (total)"
      description: "includes all deal types"
    }

    measure: current_amount_sum_euros {
      type: sum
      sql:  ${current_amount_euros};;
      value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
      drill_fields: [deal_name, deal_id, deal_source_channel_cluster_hubspot, sales_region,deal_segment, deal_allocation, deal_allocation_mix, stage_label, bdr_name, deal_owner_name, ae_name, dmt_sao_drilldown, close_date_drilldown, current_amount_sum_euros]
      label: "€ Deal Volume: Current Value (sum)"
    }

  }
