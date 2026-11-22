include: "/base_views/Google_Sheets/rd_sre_platform_costs_base.view"

view: rd_sre_platform_costs_ext {

  extends: [rd_sre_platform_costs_base]

  drill_fields: [month_month, source, total_costs_sum, total_azure_costs_sum]

  # --- DIMENSIONS

    dimension: aks {
      type: number
      hidden: yes
    }
  dimension: azure_ai {
    type: number
    hidden: yes
    }
    dimension: compute_ppu {
      type: number
      hidden: yes
    }
    dimension: compute_reserved_1yo3y {
      type: number
      hidden: yes
    }
  dimension: database_server {
    type: number
    hidden: yes
    }
    dimension: integration_placeholder1 {
      type: number
      hidden: yes
    }
    dimension: integration_placeholder2 {
      type: number
      hidden: yes
    }
    dimension: integration_placeholder3 {
      type: number
      hidden: yes
    }
    dimension: misc {
      type: number
      hidden: yes
    }
    dimension_group: month {
      type: time
      timeframes: [date, month, month_name, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension: network_bandwith {
      type: number
      hidden: yes
    }
    dimension: pulumi_iac_costs {
      type: number
      hidden: yes
    }
    dimension: source {
      type: string
    }
    dimension: sre_hardware_server {
      type: number
      hidden: yes
    }
    dimension: sre_platform_placeholder1 {
      type: number
      hidden: yes
    }
    dimension: sre_platform_placeholder2 {
      type: number
      hidden: yes
    }
    dimension: storage {
      type: number
      hidden: yes
    }

   # ----- MANUALLY CREATED DIMENSIONS --------

    dimension: primary_key {
      type: string
      sql: CONCAT(${month_month},"-",${source}) ;;
      primary_key: yes
      hidden: yes
    }

  # --- MEASURES ----------------------
    measure: count {
      type: count
      hidden: yes
    }

    measure: aks_sum {
      type: sum
      sql: ${aks} ;;
      value_format_name: eur_0
      label: "AKS Costs €"
    }

  measure: azure_ai_sum {
    type: sum
    sql: ${azure_ai} ;;
    value_format_name: eur_0
    label: "Azure AI Costs €"
  }

    measure: aks_avg {
      type: average
      sql: ${aks} ;;
      value_format_name: eur_0
      label: "AKS Costs € (avg)"
    }

    measure: compute_ppu_sum {
      type: sum
      sql: ${compute_ppu} ;;
      value_format_name: eur_0
      label: "Compute PPU Costs €"
      description: "Compute pay-per-use"
    }

    measure: compute_ppu_avg {
      type: average
      sql: ${compute_ppu} ;;
      value_format_name: eur_0
      label: "Compute PPU Costs € (avg)"
      description: "Compute Reserved 1y/3y"
    }

    measure: compute_reserved_1yo3y_sum {
      type: sum
      sql: ${compute_reserved_1yo3y} ;;
      value_format_name: eur_0
      label: "Compute Reserved Costs €"
      description: "Compute Reserved 1y/3y"
    }

    measure: compute_reserved_1yo3y_avg {
      type: average
      sql: ${compute_reserved_1yo3y} ;;
      value_format_name: eur_0
      label: "Compute Reserved Costs € (avg)"
      description: "Compute Reserved 1y/3y"
    }

  measure: database_server_sum {
    type: sum
    sql: ${database_server} ;;
    value_format_name: eur_0
    label: "Database Server Costs €"
  }

    measure: misc_sum {
      type: sum
      sql: ${misc} ;;
      value_format_name: eur_0
      label: "Misc Costs €"
    }

    measure: misc_avg {
      type: average
      sql: ${misc} ;;
      value_format_name: eur_0
      label: "Misc Costs € (avg)"
    }

    measure: network_bandwith_sum {
      type: sum
      sql: ${network_bandwith} ;;
      value_format_name: eur_0
      label: "Network Bandwith Costs €"
    }

    measure: network_bandwith_avg {
      type: average
      sql: ${network_bandwith} ;;
      value_format_name: eur_0
      label: "Network Bandwith Costs € (avg)"
    }

    measure: pulumi_iac_costs_sum {
      type: sum
      sql: ${pulumi_iac_costs} ;;
      value_format_name: eur_0
      label: "Pulumi IAC Costs €"
    }

    measure: pulumi_iac_costs_avg {
      type: average
      sql: ${pulumi_iac_costs} ;;
      value_format_name: eur_0
      label: "Pulumi IAC Costs € (avg)"
    }

  measure: sre_hardware_server_sum {
    type: sum
    sql: ${sre_hardware_server} ;;
    value_format_name: eur_0
    label: "SRE Hardware Server Costs €"
  }

  measure: sre_hardware_server_avg {
    type: average
    sql: ${sre_hardware_server} ;;
    value_format_name: eur_0
    label: "SRE Hardware Server Costs € (avg)"
  }

  measure: storage_sum {
    type: sum
    sql: ${storage} ;;
    value_format_name: eur_0
    label: "Storage Costs €"
  }

  measure: storage_avg {
    type: average
    sql: ${storage} ;;
    value_format_name: eur_0
    label: "Storage Costs € (avg)"
  }

  measure: total_costs_sum {
    type: number
    sql: ${aks_sum}+${azure_ai_sum}+${compute_ppu_sum}+${compute_reserved_1yo3y_sum}+${database_server_sum}+${misc_sum}+${network_bandwith_sum}+${pulumi_iac_costs_sum}+${sre_hardware_server_sum}+${storage_sum} ;;
    value_format_name: eur_0
    label: "Total Costs €"
  }

  measure: total_costs_excl_ai_sum {
    type: number
    sql: ${aks_sum}+${compute_ppu_sum}+${compute_reserved_1yo3y_sum}+${database_server_sum}+${misc_sum}+${network_bandwith_sum}+${pulumi_iac_costs_sum}+${sre_hardware_server_sum}+${storage_sum} ;;
    value_format_name: eur_0
    label: "Total Costs (excl. AI) €"
  }

  measure: total_azure_costs_sum {
    type: number
    sql: ${aks_sum}+${azure_ai_sum}+${compute_ppu_sum}+${compute_reserved_1yo3y_sum}+${database_server_sum}+${misc_sum}+${network_bandwith_sum}+${pulumi_iac_costs_sum}+${storage_sum} ;;
    value_format_name: eur_0
    label: "Total Azure Costs €"
  }

  }
