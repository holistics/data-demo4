include: "/base_views/Datamarts/hubspot_customers_all_base.view"

view: hubspot_customers_all_ext {
  extends: [hubspot_customers_all_base]

drill_fields: [company_name, cs_name, vitally_lifecycle, newlogo_signed_date, vitally_kickoff_date, company_segment, industry, licences_sold]

# ----- DIMENSIONS --------------------------------------------------------

  dimension: ae_name {
    type: string
    label: "AE name"
  }

  dimension: automatic_contract_renewal {
    type: yesno
  }

  dimension_group: churn {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: datetime
    description: "Date of contract end (recognized churn) - NOT the day the customer hands in the churn notice (signed)."
  }

  dimension: company_allocation {
    type: string
    description: "Structure used for targets 2025"
    hidden: no
  }

    dimension: company_id {
      type: string
      primary_key: yes
      link: {
        label: "HubSpot URL"
        url: "https://app.hubspot.com/contacts/7401529/company/{{ company_id }}"
      }
    }

    dimension: company_name {
      type: string
      link: {
        label: "HubSpot URL"
        url: "https://app.hubspot.com/contacts/7401529/company/{{ company_id }}"
      }
    }

  dimension: company_name_groups { # old! use fin_customer_group instead
    type: string
    description: "Groups single companies such as Edeka stores together on base of the mother company."
    label: "Company Name GROUP"
    hidden: yes
  }

  dimension: company_segment {
    type: string
    description: "Targets until 2024 were structured by segment. Starting 2025: use company allocation."
    hidden: no
  }

  dimension_group: contract_start {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

    dimension_group: created_at_timestamp {
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year
      ]

    }

    dimension: cs_name {
      type: string
      label: "CS Name (Company)"
    }

  dimension: currency {
    type: string
  }

  dimension: current_arr_euros {
    type: number
    hidden: yes
  }

  dimension: current_arr_in_record_currency {
    type: number
    hidden:  yes
  }

  dimension: current_contract_term__in_months_ {
    type: number
    label: "Contract Term (months)"
  }

  #dimension: dau_average_l30d {
  #  type: number
  #  hidden: yes
  #  }

  dimension: dau_30d_avg {
    type: number
    hidden:  yes
  }

  dimension: dau_onboarded {
    type: number
    label: "DAU % Onboarded"
  }

  dimension_group: domain_created {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension: expansion_potential {
    type: number
    hidden: yes
    }

  dimension: fin_customer_group_id {
    type: string
  }

  dimension: fin_customer_group_segment_investor {
    type: string
  }

    # dimension: flip_additional_features { # check with armin -> new?/still needed?
    #   type: string

    # }

    # dimension: flip_basic_features {  # check with armin -> new?/still needed?
    #   type: string

    # }

    dimension_group: go_live { # rather use vitally_app_handover_date
      type: time
      timeframes: [
        raw,
        date,
        week,
        month,
        quarter,
        year
      ]
      convert_tz: no
      datatype: date
      hidden: yes
    }

    dimension: industry {
      type: string
    }

    dimension: industry_simplified_investors {
      type: string
    }
  dimension: is_ai_assistant_activated {
    type: yesno
  }
  dimension: is_ai_assistant_user_groups_activated {
    type: yesno
  }
  dimension: is_affected_by_zabbix_data_loss {
      type: yesno
    }

    dimension: is_company_licence {
      type: yesno

    }

  dimension_group: last_modified_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension: licence_activation_rate {
    type: number
    label: "Licence Activation Rate % (TC)"
    }

  dimension: licence_success_rate {
    type: number
    label: "Licence Success Rate LSR % (TC)"
  }

  dimension: licence_success_rate_sold {
    type: number
    label: "Licence Success Rate LSR % (Sold)"
    description: "# Licences entered in Hubspot Company Account - in case of company-licence: # users created."
  }

  dimension: licences_sold {
    type: number
    hidden: no
    description: "# Licences entered in Hubspot Company Account - in case of company-licence: # users created."
  }

  dimension: licences_sold_raw {
    type: number
  }

  dimension: licences_tenant_controller {
    type: number
    hidden: yes
    }

  dimension: licences_tenant_controller_raw {
    type: number
    hidden: yes
  }

    dimension: life_cycle_stage {
      type: string
    }

  dimension: lifetime_net_retention_rate {
    type: number
    hidden: yes
  }

  #dimension: mau_average_l30d {
  #  type: number
  #  hidden: yes
  #}

  dimension: mau_count {
    type: number
    hidden: yes
  }

  dimension: mau_onboarded {
    type: number
    label: "MAU % Onboarded"
    drill_fields: [company_name, cs_name, newlogo_signed_date, company_segment, licences_sold, users_onboarded, dau_30d_avg, wau_count, mau_count]
  }

  dimension: new_logo_arr_euros {
    type: number
    hidden: yes
  }
  dimension: new_logo_arr_in_record_currency {
    type: number
    hidden: yes
  }

  dimension_group: newlogo_renewal {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: datetime
    description: "Date from new-logo deal"
  }

  dimension_group: newlogo_signed {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    description: "Date of first NewLogo Deal of the Customer (not group!). Pulled via Deal information."
  }

  dimension: number_of_associated_deals {
    type: number
  }

  dimension: number_of_employees {
    type: number
    hidden: yes
  }

  dimension: onboarding_rate {
    type: number
    hidden: yes
    label: "Onboarding Rate %"
  }

  dimension: pricing_addon {
    type: string
  }

  dimension: pricing_module {
    type: string
  }

  dimension: pricing_package_estimated {
    type: string
  }

  dimension_group: renewal_date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension: scoped_licences {
    type: number
    hidden: no # temporary no
  }

  # dimension: scoped_licences_old {
  #   type: number
  #   hidden: yes
  # }

  dimension: support_level {
    type: string
  }

  dimension: tenant {
    type: string
  }

  dimension_group: tenant_created {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension: tenant_level {
    type: string
  }

  dimension: users_created {
    type: number
    hidden: yes
  }

  dimension: users_created_net {
    type: number
    hidden: yes
    }

  dimension: users_enabled_net {
    type: number
    hidden: yes
    }

  dimension: users_onboarded {
    type: number
    hidden: yes
    }

  dimension: users_onboarded_net {
    type: number
    hidden: no
    }

  dimension_group: vitally_app_handover {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension: vitally_customer_journey_stage {
    type: string
  }

  dimension_group: vitally_cse_kickoff {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  dimension_group: vitally_kickoff {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
  }

  dimension: vitally_lifecycle {
    type: string
  }

  dimension: vitally_nps {
    type: number
  }

  dimension: vitally_overall_health_score {
    type: number
    hidden: yes
  }

  dimension: wau_count {
    type: number
    hidden: yes
  }

  dimension: wau_licence_rate {
    type: number
    hidden: yes
  }

  dimension: wau_onboarded {
    type: number
    label: "WAU % Onboarded"
  }

  dimension: zabbix_host_id { # remove
    type: string
    hidden: yes
  }

  dimension: has_active_flows {
    type: yesno
  }

  # dimension: zabbix_host_key { #remove
  #   type: string
  #   hidden: yes
  # }

  # dimension: zabbix_host_name { #remove
  #   type: string
  #   hidden: yes
  # }

# ----- NEW DIMENSIONS --------------------------------------------------------

  dimension: is_live_on_flip {
    type: yesno
    sql: CASE
        WHEN ${go_live_raw} <= current_date() THEN TRUE
        WHEN ${go_live_raw} > current_date() THEN FALSE
        WHEN ${go_live_raw} IS NULL THEN false END;;
  }

  dimension: newlogo_last_30d_dimension {
    type: string
    sql: CASE
            WHEN DATE_DIFF(current_date(), ${newlogo_signed_date}, DAY) <= 29 THEN "last 30d"
            ELSE "before" END ;;
  }

  dimension: newlogo_last_14d_dimension {
    type: string
    sql: CASE
            WHEN DATE_DIFF(current_date(), ${newlogo_signed_date}, DAY) <= 13 THEN "last 14d"
            ELSE "before" END ;;
  }

  dimension: newlogo_last_7d_dimension {
    type: string
    sql: CASE
          WHEN DATE_DIFF(current_date(), ${newlogo_signed_date}, DAY) <= 6 THEN "last 7d"
          ELSE "before" END ;;
  }

  dimension: days_since_go_live_date {
    type: number
    hidden: yes
    sql: DATE_DIFF(current_date(), ${go_live_raw}, DAY) ;;
  }

  dimension: months_since_go_live_floor {
    type: number
    sql: FLOOR(${days_since_go_live_date}/(30)) ;;
    label: "Months since GoLive (Hubspot)"
    description: "Number of months since the Customer went live"
  }

  dimension: is_in_adoption_phase { # old / won't be used when we have cs customer journey
    type: yesno
    sql: CASE WHEN ${go_live_date} < current_date() AND
      date_diff(current_date(),${go_live_date}, day) <= 30 THEN true ELSE false END ;;
  }

  dimension: health_score_tiers {
    type: tier
    sql: ${vitally_overall_health_score} ;;
    tiers: [4,7]
    style: relational
    label: "Segment by Health Score"
    description: "Tiers based on the current value of the overall health score"
  }

  # dimension: segment_sorted { # removed 18.4.24, can be deleted soon if no issues
  #   type: string
  #   sql: ${company_segment} ;;
  #         label: "Segment (sorted)"
  #         description: "Customer Segments with according 'chronological' order / numeration for visualization by size. Does not include a separate Edeka segment."
  # }

  dimension: dau_tiers {
    type: tier
    sql: ${dau_30d_avg} ;;
    tiers: [10,50,100,250,500,1000,2500,5000,10000]
    style: integer
    label: "Tiers DAU (l30d average)"
  }

  dimension: wau_tiers {
    type: tier
    sql: ${wau_count} ;;
    tiers: [10,50,100,250,500,1000,2500,5000,10000]
    style: integer
    label: "Tiers WAU"
  }

  dimension: mau_tiers {
    type: tier
    sql: ${mau_count} ;;
    tiers: [10,50,100,250,500, 1000,2500,5000,10000]
    style: integer
    label: "Tiers MAU"
  }

  dimension: users_onboarded_tiers {
    type: tier
    sql: ${users_onboarded} ;;
    tiers: [10, 50, 100, 250, 500, 1000, 2500, 5000, 10000]
    style: integer
    label: "Tiers Onboarded Users"
  }

  dimension: licence_success_rate_tiers {
    type: tier
    sql: ${licence_success_rate} ;;
    style: relational
    tiers: [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]
  }

  dimension: wau_licence_rate_tiers {
    type: tier
    sql: ${wau_licence_rate} ;;
    style: relational
    tiers: [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]
  }

  dimension: wau_onboarded_tiers {
    type: tier
    sql: ${wau_onboarded} ;;
    style: relational
    tiers: [0.2,0.4,0.6,0.8,1.01]
    label: "WAU % Onboarded Tiers"
  }

  dimension: number_of_employees_tiers_maxi {
    type: tier
    style: integer
    tiers: [0,501,2501,5001,25001]
    sql: ${number_of_employees} ;;
  }

  dimension: current_contract_term__in_months_tiers {
    type: tier
    style: integer
    tiers: [12,24,36,48]
    sql: ${current_contract_term__in_months_} ;;
  }

  dimension: current_arr_euros_tiers {
    type: tier
    style: relational
    tiers: [500,5000,10000,50000,100000,200000,500000]
    value_format_name: eur_0
    sql: ${current_arr_euros} ;;
  }

# ----- MEASURES --------------------------------------------------------

  measure: count {
    type: count
    drill_fields: [cs_name, company_name, company_name_groups]
    label: "# Customer Accounts"
  }

  measure: number_of_employees_sum {
    type: sum
    sql: ${number_of_employees} ;;
  }

  measure: count_customer_contracts {
  type: count
  filters: [number_of_associated_deals: ">0"]
  drill_fields: [cs_name, company_name, company_name_groups]
  label: "# Customer Contracts"
  }

  measure: count_distinct_customer_groups {
    type: count_distinct
    sql: ${fin_customer_group_id};;
    drill_fields: [cs_name, company_name, company_name_groups]
    label: "# Fin Customer Groups"
  }

  measure: running_total {
    type: running_total
    sql: ${count} ;;
    label: "# Customer Accounts (run. total)"
  }

  measure: running_total_customer_contracts {
    type: running_total
    sql: ${count_customer_contracts} ;;
    label: "# Customer Contracts (run. total)"
  }

  measure: running_total_customer_groups {
    type: running_total
    sql: ${count_distinct_customer_groups} ;;
    label: "# Customer Groups (run. total)"
  }

  measure: percent_of_total {
    type: percent_of_total
    sql: ${count} ;;
    label: "% Customer Contracts"
  }

  measure: percent_of_total_customer_contracts {
    type: percent_of_total
    sql: ${count} ;;
    label: "% Customer Acounts"
  }

  measure: percent_of_total_customer_groups {
    type: percent_of_total
    sql: ${count_distinct_customer_groups} ;;
    label: "% Customer Groups"
  }

  measure: number_of_associated_deals_sum {
    type: sum
    sql: ${number_of_associated_deals} ;;
    label: "# Deals Associated"
  }

  measure: licences_sold_sum {
    type: sum
    sql: ${licences_sold} ;;
    label: "# Licences Sold"
    description: "# Licences entered in Hubspot Company Account (total licences a customer holds) - in case of company-licence: # users created."
    drill_fields: [company_name, cs_name, vitally_lifecycle, newlogo_signed_date, vitally_kickoff_date, company_segment, industry, licences_tenant_controller, licences_sold, licences_sold_sum]
  }

  measure: licences_sold_avg {
    type: average
    sql: ${licences_sold} ;;
    label: "# Licences Sold avg (Hubspot)"
    description: "# Licences entered in Hubspot Company Account (total licences a customer holds) - in case of company-licence: # users created."
    drill_fields: [company_name, cs_name, vitally_lifecycle, newlogo_signed_date, vitally_kickoff_date, company_segment, industry, licences_tenant_controller, licences_sold, licences_sold_sum]

  }

  measure: licences_tenant_controller_sum {
    type: sum
    sql: ${licences_tenant_controller} ;;
    label: "# Licences TC"
    description: "# Licences entered in tenant controller - in case of company-licence: # users created."
    drill_fields: [tenant, vitally_lifecycle, vitally_customer_journey_stage, licences_tenant_controller, licences_tenant_controller_sum]
  }

  measure: licence_deviation_sold_to_tc {
    type: number
    sql: ${licences_sold_sum}/nullif(${licences_tenant_controller_sum},0) ;;
    label: "Licence Deviation % (Sold / TC)"
    value_format_name: percent_0
  }

  measure: overall_health_score_avg {
    type: average
    sql: ${vitally_overall_health_score} ;;
    label: "Overall Health Score Current (avg)"
    value_format_name: decimal_1
  }

  measure: overall_health_score_max {
    type: max
    sql: ${vitally_overall_health_score} ;;
    label: "Overall Health Score Current (max)"
    value_format_name: decimal_1
  }

  measure: overall_health_score_min {
    type: min
    sql: ${vitally_overall_health_score} ;;
    label: "Overall Health Score Current (min)"
    value_format_name: decimal_1
  }

  measure: scoped_licences_sum {
    type: sum
    sql: ${scoped_licences} ;;
    label: "# Licences Scoped"
    description: "Users created that have also been instructed to login. Scoped Licences are manually entered by CSS, if no value given then # Users Created is taken."
  }

  measure: scoped_licences_avg {
    type: average
    sql: ${scoped_licences} ;;
    label: "# Licences Scoped avg"
    description: "Users created that have also been instructed to login. Scoped Licences are manually entered by CSS, if no value given then # Users Created is taken."
  }

  measure: nps_avg {
    type: average
    sql: ${vitally_nps} ;;
    label: "NPS (avg)"
  }

  measure: users_created_sum {
    type: sum
    sql: ${users_created} ;;
    label: "# Users Created Gross"
  }

  measure: users_created_avg {
    type: average
    sql: ${users_created} ;;
    label: "# Users Created Gross (avg)"
    value_format_name: decimal_0
  }

  measure: users_created_net_sum {
    type: sum
    sql: ${users_created_net} ;;
    label: "# Users Created"
  }

  measure: users_created_net_avg {
    type: average
    sql: ${users_created_net} ;;
    label: "# Users created (avg)"
    value_format_name: decimal_0
  }

  measure: users_onboarded_sum {
    type: sum
    sql: ${users_onboarded} ;;
    label: "# Users Onboarded Gross"
  }

  measure: users_onboarded_avg {
    type: average
    sql: ${users_onboarded} ;;
    label: "# Users Onboarded Gross (avg)"
    value_format_name: decimal_0
  }

  measure: users_onboarded_net_sum {
    type: sum
    sql: ${users_onboarded_net} ;;
    label: "# Users Onboarded"
  }

  measure: users_onboarded_net_avg {
    type: average
    sql: ${users_onboarded_net} ;;
    label: "# Users Onboarded (avg)"
    value_format_name: decimal_0
  }

  measure: users_enabled_net_sum {
    type: sum
    sql: ${users_enabled_net} ;;
    label: "# Users Enabled"
  }

  measure: users_enabled_net_avg {
    type: average
    sql: ${users_enabled_net} ;;
    label: "# Users Enabled (avg)"
    value_format_name: decimal_0
  }

 # measure: dau_average_l30d_avg {
  #  type: average
  #  sql: ${dau_average_l30d} ;;
  #  label: "# DAU (l30d avg)"
  #  value_format_name: decimal_0
  #}

  #measure: wau_average_l30d_avg {
  #  type: average
  #  sql: ${wau_average_l30d} ;;
  #  label: "# WAU (l30d avg)"
  #  value_format_name: decimal_0
  #}

  #measure: mau_average_l30d_avg {
  #  type: average
  #  sql: ${mau_average_l30d} ;;
  #  label: "# MAU (l30d avg)"
  #  value_format_name: decimal_0
  #}

  #measure: dau_average_l30d_sum {
  #  type: sum
  #  sql: ${dau_average_l30d} ;;
  #  label: "# DAU (l30d avg) / sum for Customer Groups"
  #  value_format_name: decimal_0
  #}

  #measure: wau_average_l30d_sum {
  #  type: sum
  #  sql: ${wau_average_l30d} ;;
  #  label: "# WAU (l30d avg) / for Customer Groups"
  #  value_format_name: decimal_0
  #}

  #measure: mau_average_l30d_sum {
  #  type: sum
  #  sql: ${mau_average_l30d} ;;
  #  label: "# MAU (l30d avg) / for Customer Groups"
  #  value_format_name: decimal_0
# }

  measure: dau_30d_avg_sum {
      type: sum
      sql: ${dau_30d_avg} ;;
      label: "# DAU (l30d avg) / sum for Customer Groups"
      value_format_name: decimal_0
    }

  measure: mau_count_sum {
    type: sum
    sql: ${mau_count} ;;
    label: "# MAU / sum for Customer Groups"
    value_format_name: decimal_0
  }

  measure: wau_count_sum {
    type: sum
    sql: ${wau_count} ;;
    label: "# WAU / sum for Customer Groups"
    value_format_name: decimal_0
  }

  measure: dau_onboarded_net_avg {
    type: average
    sql: ${dau_onboarded} ;;
    value_format_name: percent_1
    label: "DAU % Onboarded (l30d avg)"
    description: "Divides DAU (l30d avg) by the current number of onboarded Users (Net)."
  }

  measure: dau_onboarded_net_percentage {
    type: average
    sql: ${dau_30d_avg} / nullif(${users_onboarded_net},0) ;;
    value_format_name: percent_1
    label: "DAU % Onboarded (l30d avg) NUM"
    hidden: yes
    description: "Divides DAU (l30d avg) by the current number of onboarded Users (Net)."
  }

  measure: wau_onboarded_net_percentage {
    type: average
    sql: ${wau_count} / nullif(${users_onboarded_net},0) ;;
    value_format_name: percent_1
    label: "WAU % Onboarded NUM"
    hidden: yes
    description: "Divides WAU by the current number of onboarded Users (Net)."
  }

  measure: wau_onboarded_net_avg {
    type: average
    sql: ${wau_onboarded} ;;
    value_format_name: percent_1
    label: "WAU % Onboarded "
    description: "Divides WAUby the current number of onboarded Users (Net)."
  }

  measure: mau_onboarded_net_percentage {
    type: average
    sql: ${mau_count} / nullif(${users_onboarded_net},0) ;;
    value_format_name: percent_1
    label: "MAU % Onboarded NUM"
    hidden: yes
    description: "Divides MAU by the current number of onboarded Users (Net)."
  }

  measure: mau_onboarded_net_avg {
    type: average
    sql: ${mau_onboarded} ;;
    value_format_name: percent_1
    label: "MAU % Onboarded"
    description: "Divides MAU by the current number of onboarded Users (Net)."
  }

  measure: licence_scoped_rate {
    type: number
    sql: ${scoped_licences_sum}/nullif(${licences_sold_sum}, 0) ;;
    value_format_name: percent_1
    label: "Licence Scoped Rate %"
    description: "% of sold Licences that have been scoped - this number always shows the current status / no historization."
  }

  measure: licence_success_rate_avg {
    type: average
    sql: ${licence_success_rate};;
    value_format_name: percent_1
    label: "Licence Success Rate % (TC)"
    description: "% of Onboarded Users (Net) by Licences (Tenant Controller) - this number always shows the current status / no historization. "
  }

  measure: licence_success_rate_sold_avg {
    type: average
    sql: ${licence_success_rate_sold};;
    value_format_name: percent_1
    label: "Licence Success Rate % (Sold)"
    description: "% of Onboarded Users (Net) by Licences (sold) - this number always shows the current status / no historization. "
  }

  measure: wau_licence_rate_avg {
    type: average
    sql: ${wau_licence_rate};;
    value_format_name: percent_1
    label: "WAU Licence Rate % (TC)"
    description: "% of WAU by Licences (Tenant Controller) - this number always shows the current status / no historization. "
  }

  measure: onboarding_rate_avg {
    type: average
    sql: ${onboarding_rate} ;;
    value_format_name: percent_1
    label: "Onboarding Rate %"
    description: "% of Onboarded Users (Net) by Created Users (Net) - this number always shows the current status / no historization. "
  }

  measure: licence_activation_rate_num {
    type: number
    sql: ${users_created_net_sum}/nullif(${licences_tenant_controller_sum}, 0) ;;
    value_format_name: percent_1
    label: "Licence Activation Rate % NUM"
    description: "% of Created Users (Net) by Licences (Tenant Controller) - this number always shows the current status / no historization. "
  }

  measure: expansion_potential_num {
    type: number
    sql: ${licences_sold_sum}/nullif(${number_of_employees_sum},0) ;;
    value_format_name: percent_1
    label: "Expansion Potential %"
    description: "% of Licences Sold of Number of Employees"
  }

    measure: mau_licences_sold_percentage {
    type: average
    sql: ${mau_count} / nullif(${licences_sold},0) ;;
    value_format_name: percent_1
    label: "MAU % Licences Sold"
    description: "Divides MAU by Licences Sold."
  }

  measure: wau_licences_sold_percentage {
    type: average
    sql: ${wau_count} / nullif(${licences_sold},0) ;;
    value_format_name: percent_1
    label: "WAU % Licences Sold"
    description: "Divides WAU by Licences Sold."
  }

  measure: dau_30d_licences_sold_percentage {
    type: average
    sql: ${dau_30d_avg} / nullif(${licences_sold},0) ;;
    value_format_name: percent_1
    label: "DAU (30d avg) % Licences Sold"
    description: "Divides DAU 30d avg by Licences Sold."
  }

  measure: count_accounts_with_higher_65_percent_wau_license_sold {
    type: sum
    sql: CASE WHEN (${wau_count} / nullif(${licences_sold},0))>0.65 THEN 1 ELSE NULL END ;;
    #filters: [wau_licences_sold_percentage: ">0.65"]
    label: "# Customer Accounts with >65 % WAU by licenses"
    description: "Counts accounts that have 65% WAU by licenses sold or higher."
  }

  # --- SETS ---------------

  set: all_flipsters_usage_relevant { # for combination with usage data in "all flipsters" model -> visible for all looker users
    fields: [company_name, company_name_groups, fin_customer_group_id, count_distinct_customer_groups, count, count_customer_contracts, percent_of_total, percent_of_total_customer_contracts, percent_of_total_customer_groups, company_id, ae_name, cs_name, is_company_licence, number_of_associated_deals, number_of_associated_deals_sum, health_score_tiers, vitally_overall_health_score, overall_health_score_avg, current_contract_term__in_months_tiers, current_arr_euros_tiers, churn_date, churn_month, churn_quarter, churn_year, contract_start_date, contract_start_month, contract_start_quarter, contract_start_year, newlogo_signed_date, newlogo_signed_month, newlogo_signed_quarter, newlogo_signed_year, newlogo_last_7d_dimension, newlogo_last_14d_dimension, newlogo_last_30d_dimension, licence_success_rate_avg, licence_success_rate, licence_success_rate_sold_avg, licences_sold_sum, onboarding_rate_avg, vitally_customer_journey_stage, number_of_employees_sum, vitally_app_handover_date, vitally_app_handover_month, vitally_app_handover_quarter, vitally_app_handover_raw, vitally_app_handover_year, go_live_date, go_live_month, go_live_quarter, go_live_raw, go_live_year, industry, industry_simplified_investors, pricing_package_estimated, vitally_overall_health_score, company_allocation, company_segment, fin_customer_group_segment_investor, vitally_lifecycle, nps_avg, count, tenant, dau_30d_avg_sum, mau_count_sum, wau_count_sum, dau_onboarded_net_avg, wau_onboarded_net_avg, mau_onboarded_net_avg, dau_30d_licences_sold_percentage, wau_licences_sold_percentage, mau_licences_sold_percentage, users_created_net_sum, users_onboarded_net_sum, licences_tenant_controller_sum, users_onboarded_net_sum, count_accounts_with_higher_65_percent_wau_license_sold, has_active_flows, is_ai_assistant_user_groups_activated, is_ai_assistant_activated, renewal_date_date]
  }

  set: exclude_names {
    fields: [cs_name, ae_name]
  }

  }
