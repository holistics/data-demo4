include: "/base_views/Datamarts/linkedin_ad_performance_pivots_base.view"

view: linkedin_ad_performance_pivots_ext {
  extends: [linkedin_ad_performance_pivots_base]

# ----- ORIGINAL DIMENSIONS ---------------------------------------------------------------------------------------------------------------------------------------

  dimension: ad_cost_euros {
    type: number
    hidden: yes
  }

  dimension: clicks {
    type: number
    hidden: yes
  }

  dimension_group: date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  dimension: foreign_key_account_scoring {
    type: string
  }

  dimension: hubspot_company_id {
    type: string
  }

  dimension: hubspot_company_name {
    type: string
  }

  dimension_group: imported_at {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
  }

  dimension: impressions {
    type: number
    hidden: yes
  }

  dimension: pivot {
    type: string
  }

  dimension: primary_key {
    type: string
    primary_key: yes
    hidden: yes
  }

  dimension: total_engagements {
    type: number
    hidden: yes
  }

  dimension: value_label {
    type: string
  }

# ----- MANUALLY CREATED DIMENSIONS -------------------------------------------------------------------------------------------------------------------------------

  dimension: linkedin_ads_date_foreign_key {
    type: string
    sql: CONCAT(${date_date},"_","linkedin_ads") ;;
    hidden: yes
  }

  dimension: value_label_seniority_sorted {
    type: string
    sql: CASE WHEN ${pivot} = "seniority" AND ${value_label} = "Unpaid" THEN "1. Unpaid"
              WHEN ${pivot} = "seniority" AND ${value_label} = "Training" THEN "2. Training"
              WHEN ${pivot} = "seniority" AND ${value_label} = "Entry" THEN "3. Entry"
              WHEN ${pivot} = "seniority" AND ${value_label} = "Senior" THEN "4. Senior"
              WHEN ${pivot} = "seniority" AND ${value_label} = "Manager" THEN "5. Manager"
              WHEN ${pivot} = "seniority" AND ${value_label} = "Director" THEN "6. Director"
              WHEN ${pivot} = "seniority" AND ${value_label} = "VP" THEN "7. VP"
              WHEN ${pivot} = "seniority" AND ${value_label} = "CXO" THEN "8. CXO"
              WHEN ${pivot} = "seniority" AND ${value_label} = "Partner" THEN "9. Partner"
              WHEN ${pivot} = "seniority" AND ${value_label} = "Owner" THEN "10. Owner"
              ELSE ${value_label} END ;;
    # hidden: yes
  }

# ----- MEASURES --------------------------------------------------------------------------------------------------------------------------------------------------

  measure: count {
    type: count
    hidden: yes
  }

  # sum_distinct because of the join many_to_many performed in the internal_marketing model
  measure: impressions_sum {
    type: sum_distinct
    sql_distinct_key: ${primary_key} ;;
    sql:  ${impressions};;
    description: "How many times an ads was shown"
    label: "# Impressions"
    value_format: "[>=1000000]#0.000,,\" M\";[>=1000]#0.00,\" K\";[<1000]#0;0"
  }

  # sum_distinct because of the join many_to_many performed in the internal_marketing model
  measure: clicks_sum {
    type: sum_distinct
    sql_distinct_key: ${primary_key} ;;
    sql:  ${clicks};;
    description: "How many times an ads was clicked"
    label: "# Clicks"
    value_format: "[>=1000000]#0.000,,\" M\";[>=1000]#0.00,\" K\";[<1000]#0;0"
  }

  # sum_distinct because of the join many_to_many performed in the internal_marketing model
  measure: total_engagements_sum {
    type: sum_distinct
    sql_distinct_key: ${primary_key} ;;
    sql:  ${total_engagements};;
    description: "The sum of all social actions, clicks to Landing Page, and clicks to LinkedIn Page, both chargeable and free"
    label: "# Total Engagements"
    value_format: "[>=1000000]#0.000,,\" M\";[>=1000]#0.00,\" K\";[<1000]#0;0"
  }

  # sum_distinct because of the join many_to_many performed in the internal_marketing model
  measure: unique_companies_engaged {
    type: count_distinct
    sql:  ${hubspot_company_id};;
    description: "How many companies were intact"
    label: "# Unique Companies"
    drill_fields: [hubspot_company_name, hubspot_company_id, impressions_sum, clicks_sum, total_engagements_sum]
  }

}
