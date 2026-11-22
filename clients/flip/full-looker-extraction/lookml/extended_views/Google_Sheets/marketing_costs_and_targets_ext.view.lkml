include: "/base_views/Google_Sheets/marketing_costs_and_targets_base.view"
view: marketing_costs_and_targets_ext {

  extends: [marketing_costs_and_targets_base]

# --- DIMENSIONS ----------------------
  dimension: action_type {
    type: string
  }
  dimension: cost_euros {
    type: number
    hidden: yes
  }
  dimension_group: date {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: leads {
    type: number
    hidden: yes
  }
  dimension: location {
    type: string
  }
  dimension: marketing_action {
    type: string
    primary_key: yes
  }
  dimension: mqls {
    type: number
    hidden: yes
  }
  dimension: sals {
    type: number
    hidden: yes
  }
  dimension: saos {
    type: number
    hidden: yes
  }
  dimension: sao_volume {
    type: number
    hidden: yes
  }
  dimension: source_channel_department {
    type: string
  }
  dimension: source_channel_drilldown {
    type: string
    description: "Marketing Action in lower case for joining"
  }
  dimension: sqls {
    type: number
    hidden: yes
  }

  # --- ADDED DIMENSIONS ---------------

  # --- MEASURES -----------------------
  measure: count {
    type: count
    label: "# Marketing Actions"
  }

  measure: leads_sum {
    type: sum
    sql: ${leads} ;;
    label: "# Event Target 1. Leads"
  }

  measure: mqls_sum {
    type: sum
    sql: ${mqls} ;;
    label: "# Event Target 2. MQLs"
  }

  measure: sqls_sum {
    type: sum
    sql: ${sqls} ;;
    label: "# Event Target 3. SQLs"
  }

  measure: sals_sum {
    type: sum
    sql: ${sals} ;;
    label: "# Event Target 4. SALs"
  }

  measure: saos_sum {
    type: sum
    sql: ${saos} ;;
    label: "# Event Target 5. SAOs"
  }

  measure: sao_volume_sum {
    type: sum
    sql: ${sao_volume} ;;
    label: "€ Event Target SAO Volume"
    value_format_name: eur_0
  }

  measure: cost_euros_sum {
    type: sum
    sql: ${cost_euros} ;;
    label: "€ Event Costs"
    value_format_name: eur_0
  }
}
