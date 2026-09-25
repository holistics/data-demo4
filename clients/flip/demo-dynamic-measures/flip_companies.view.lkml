# Reduced from hubspot_companies_all_base; validate company_id uniqueness.
view: flip_companies {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.hubspot_companies_all` ;;

  dimension: company_id {
    type: string
    primary_key: yes
    sql: ${TABLE}.company_id ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
  }

  dimension: industry {
    type: string
    sql: ${TABLE}.industry ;;
  }

  dimension: company_region {
    type: string
    sql: ${TABLE}.company_region ;;
  }
}
