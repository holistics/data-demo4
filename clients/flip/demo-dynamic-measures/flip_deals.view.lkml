# Reduced from hubspot_deals_all_base and hubspot_deals_all_ext.
# Source selector branches are preserved; unrelated fields and joins are omitted.
view: flip_deals {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.hubspot_deals_all` ;;

  dimension: deal_id {
    type: string
    primary_key: yes
    label: "Deal ID"
    sql: ${TABLE}.deal_id ;;
  }

  dimension: company_id {
    type: string
    hidden: yes
    sql: ${TABLE}.company_id ;;
  }

  dimension: deal_name {
    type: string
    label: "Deal Name"
    sql: ${TABLE}.deal_name ;;
  }

  dimension: deal_segment {
    type: string
    label: "Segment"
    sql: ${TABLE}.deal_segment ;;
  }

  dimension_group: dmt_closed_lost {
    type: time
    timeframes: [date]
    convert_tz: no
    datatype: date
    label: "Date - DMT Closed Lost"
    sql: ${TABLE}.dmt_closed_lost ;;
  }

  dimension_group: dmt_sao {
    type: time
    timeframes: [date]
    convert_tz: no
    datatype: date
    label: "Date - DMT SAO"
    sql: ${TABLE}.dmt_sao ;;
  }

  dimension: lost_amount_euros {
    # Source declares this as string with implicit same-named column SQL.
    # Preserve its metadata; verify the warehouse column is numeric before SUM.
    type: string
    hidden: yes
    label: "Lost Amount"
    sql: ${TABLE}.lost_amount_euros ;;
  }

  dimension: initial_sao_amount_euros {
    type: number
    hidden: yes
    label: "€ Initial Deal Amount - SAO"
    sql: ${TABLE}.initial_sao_amount_euros ;;
  }

  # Ordinary measures for the migration-tool demo, separate from Liquid.
  measure: sao_count {
    type: count
    filters: [dmt_sao_date: "-NULL"]
    label: "SAO Count"
  }

  measure: sao_volume_euros {
    type: sum
    sql: ${initial_sao_amount_euros} ;;
    label: "SAO Volume EUR"
    value_format: "€#,##0"
  }

  parameter: base_metric_loss_analysis {
    type: unquoted
    label: "Base Metric Loss Analysis - Closed Lost"
    allowed_value: {
      label: "# Lost Opps"
      value: "opps"
    }
    allowed_value: {
      label: "€ Lost ARR"
      value: "arr"
    }
  }

  parameter: base_metric_sao_loss_analysis {
    type: unquoted
    label: "Base Metric Loss Analysis - SAO"
    allowed_value: {
      label: "# SAOs"
      value: "opps"
    }
    allowed_value: {
      label: "€ SAO Volume"
      value: "arr"
    }
  }

  measure: dynamic_base_metric_loss_analysis {
    type: number
    label: "Closed Lost - Dynamic Metric Loss Analysis"
    label_from_parameter: base_metric_loss_analysis
    sql: {% if base_metric_loss_analysis._parameter_value == 'opps' %}
        ifnull(count(${dmt_closed_lost_date}),0)
        {% else %}
        ifnull(sum(${lost_amount_euros}),0)
        {% endif %} ;;
    value_format: "#,##0"
    html: {% if base_metric_loss_analysis._parameter_value == 'arr' %} €{{ rendered_value }}
          {% else %} {{ rendered_value }}
          {% endif %} ;;
    drill_fields: [deal_id, deal_name, deal_segment, dmt_closed_lost_date]
  }

  measure: dynamic_base_metric_sao {
    type: number
    label: "SAO - Dynamic Metric Loss Analysis"
    label_from_parameter: base_metric_sao_loss_analysis
    sql: {% if base_metric_sao_loss_analysis._parameter_value == 'opps' %}
        ifnull(count(${dmt_sao_date}),0)
        {% else %}
        ifnull(sum(${initial_sao_amount_euros}),0)
        {% endif %} ;;
    value_format: "#,##0"
    html: {% if base_metric_sao_loss_analysis._parameter_value == 'arr' %} €{{ rendered_value }}
          {% else %} {{ rendered_value }}
          {% endif %} ;;
    drill_fields: [deal_id, deal_name, deal_segment, dmt_sao_date]
  }
}
