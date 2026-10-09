include: "/base_views/Google_Sheets/rd_integrate_standard_integrations_base.view"

view: rd_integrate_standard_integrations_ext {

  extends: [rd_integrate_standard_integrations_base]

  # --- DIMENSIONS ----------------------------
    dimension: custom_integration_instances_hosted_on_the_platform {
      type: number
      hidden: yes
    }

    dimension: distinct_standard_services_deployed {
      type: number
      hidden: yes
    }
    dimension: environment {
      type: string
    }
    dimension_group: month {
      type: time
      description: "%E4Y-%m-%d"
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }

  dimension: standard_integration_instances_hosted_on_the_platform {
    type: number
    hidden: yes
  }

    dimension: tenants_using_standard_integrations {
      type: number
      hidden: yes
    }

    dimension: primary_key {
      type: string
      sql: CONCAT(${month_month},"-",${environment}) ;;
      hidden: yes
      primary_key: yes
    }

  # --- MEASURES -----------------------
    measure: count {
      type: count
      hidden: yes
    }

    measure: distinct_standard_integrations_deployed_avg {
      type: average
      sql: ${distinct_standard_integrations_deployed} ;;
    }

    measure: custom_integration_instances_hosted_on_the_platform_avg {
      type: average
      sql: ${custom_integration_instances_hosted_on_the_platform} ;;
    }

    measure: standard_integration_instances_hosted_on_the_platform_avg {
      type: average
      sql: ${standard_integration_instances_hosted_on_the_platform} ;;
    }

    measure: tenants_using_standard_integrations_avg {
      type: average
      sql: ${tenants_using_standard_integrations} ;;
    }
  }
