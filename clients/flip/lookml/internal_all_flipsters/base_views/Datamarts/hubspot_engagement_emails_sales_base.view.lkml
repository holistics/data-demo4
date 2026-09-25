view: hubspot_engagement_emails_sales_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.hubspot_engagement_emails_sales` ;;

    dimension: associated_company_id {
      type: string
      sql: ${TABLE}.associated_company ;;
    }
    dimension: associated_company_name {
      type: string
      sql: ${TABLE}.associated_company_name ;;
    }
    dimension: associated_company_segment {
      type: string
      sql: ${TABLE}.associated_company_segment ;;
    }
    dimension: associated_contact_id {
      type: string
      sql: ${TABLE}.associated_contact_id ;;
    }

    dimension_group: email {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.email_date ;;
    }
    dimension: email_direction {
      type: string
      sql: ${TABLE}.email_direction ;;
    }
    dimension: email_id {
      type: string
      sql: ${TABLE}.email_id ;;
    }
    dimension: email_owner_name {
      type: string
      sql: ${TABLE}.email_owner_name ;;
    }
    dimension: email_owner_team {
      type: string
      sql: ${TABLE}.email_owner_team ;;
    }

    dimension: email_status {
      type: string
      sql: ${TABLE}.email_status ;;
    }

    dimension: joining_key_date_owner {
      type: string
      sql: ${TABLE}.joining_key_date_owner ;;
    }
    measure: count {
      type: count
      drill_fields: [associated_company_name, email_owner_name]
    }

  }
