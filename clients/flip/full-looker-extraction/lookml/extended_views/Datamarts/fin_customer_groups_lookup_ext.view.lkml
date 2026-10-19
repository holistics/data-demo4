include: "/base_views/Datamarts/fin_customer_groups_lookup_base.view"

view: fin_customer_groups_lookup_ext {
extends: [fin_customer_groups_lookup_base]

drill_fields: [fin_customer_group_id, fin_customer_group_name, fin_customer_group_segment]

  dimension_group: fin_customer_group_cohort {
    type: time
    timeframes: [raw, date, week, month, month_num, quarter, year]
    convert_tz: no
    datatype: date
  }
  dimension: fin_customer_group_cs_name {
    type: string
  }
  dimension: fin_customer_group_id {
    type: string
    primary_key: yes
  }
  dimension: fin_customer_group_name {
    type: string
  }
  dimension: fin_customer_group_segment {
    type: string
  }
  dimension: hubspot_company_ids {
    hidden: yes
  }

# --- MANUAL DIMENSIONS ----------------

  dimension: is_group_cohort_eoy {
    type: yesno
    sql: ${fin_customer_group_cohort_year} <= EXTRACT(YEAR FROM current_date())-1  ;;
  }

  dimension: is_group_cohort_yoy {
    type: yesno
    sql: ${fin_customer_group_cohort_month} <= FORMAT_DATE("%Y-%m", DATE_ADD(CURRENT_DATE(), INTERVAL -12 MONTH)) ;;
  }

  # --- MEASURES -------------------------
    measure: count {
      type: count
      drill_fields: [fin_customer_group_name]
      label: "# Customer Groups"
    }

  }

###

view: fin_customer_groups_lookup__hubspot_company_ids_ext {
  extends: [fin_customer_groups_lookup__hubspot_company_ids_base]

  dimension: fin_customer_groups_lookup__hubspot_company_ids {
    type: string
    sql: fin_customer_groups_lookup__hubspot_company_ids ;;
    label: "Hubspot Company Id"
  }

  measure: hubspot_company_ids_count_distinct {
    type: count_distinct
    sql: ${fin_customer_groups_lookup__hubspot_company_ids} ;;
    label: "# Customers"
  }
}
