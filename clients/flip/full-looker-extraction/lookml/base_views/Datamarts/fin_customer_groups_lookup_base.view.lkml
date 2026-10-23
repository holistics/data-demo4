# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
explore: fin_customer_groups_lookup_base {
  hidden: yes
    join: fin_customer_groups_lookup__hubspot_company_ids_base {
      view_label: "Fin Customer Groups Lookup: Hubspot Company Ids"
      sql: LEFT JOIN UNNEST(${fin_customer_groups_lookup_base.hubspot_company_ids}) as fin_customer_groups_lookup__hubspot_company_ids ;;
      relationship: one_to_many
    }
}
view: fin_customer_groups_lookup_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.fin_customer_groups_lookup` ;;

  dimension_group: fin_customer_group_cohort {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.fin_customer_group_cohort ;;
  }
  dimension: fin_customer_group_cs_name {
    type: string
    sql: ${TABLE}.fin_customer_group_cs_name ;;
  }
  dimension: fin_customer_group_id {
    type: string
    sql: ${TABLE}.fin_customer_group_id ;;
  }
  dimension: fin_customer_group_name {
    type: string
    sql: ${TABLE}.fin_customer_group_name ;;
  }
  dimension: fin_customer_group_segment {
    type: string
    sql: ${TABLE}.fin_customer_group_segment;;
  }
  dimension: hubspot_company_ids {
    hidden: yes
    sql: ${TABLE}.hubspot_company_ids ;;
  }
  measure: count {
    type: count
    drill_fields: [fin_customer_group_name]
  }
}

view: fin_customer_groups_lookup__hubspot_company_ids_base {

  dimension: fin_customer_groups_lookup__hubspot_company_ids {
    type: string
    sql: fin_customer_groups_lookup__hubspot_company_ids ;;
  }

}
