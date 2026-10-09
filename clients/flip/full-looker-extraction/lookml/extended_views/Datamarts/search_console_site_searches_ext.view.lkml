include: "/base_views/Datamarts/search_console_site_searches_base.view"

view: search_console_site_searches_ext {
  extends: [search_console_site_searches_base]

# ----- ORIGINAL DIMENSIONS ---------------------------------------------------------------------------------------------------------------------------------------

  dimension: clicks {
    type: number
    hidden: yes
  }
  dimension: foreign_key {
    type: string
    hidden: yes
  }
  dimension: impressions {
    type: number
    hidden: yes
  }
  dimension: is_target_keyword {
    type: yesno
  }
  dimension: matched_target_keyword {
    type: string
  }
  dimension_group: period {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    hidden: yes
  }
  dimension: primary_key {
    type: string
    primary_key: yes
  }
  dimension: query {
    type: string
  }
  dimension: region {
    type: string
  }
  dimension: search_brand_type {
    type: string
  }
  dimension: search_type {
    type: string
  }
  dimension: sum_top_position {
    type: number
    hidden: yes
  }

  # ----- MEASURES --------------------------------------------------------------------------------------------------------------------------------------------------

  measure: keywords_count {
    type: count_distinct
    sql: ${query} ;;
    label: "# Keywords"
  }

  measure: impressions_sum {
    type: sum
    sql: ${impressions} ;;
    label: "# Impressions"
    description: "Impressions are counted each time a URL is viewed in a search result, whether it's on the first page or subsequent pages of the search results. This means that a user may see your site's link in the search results, regardless of whether they interact with it by clicking on it."
    value_format: "#,##0"
    drill_fields: [query, search_type, search_brand_type, impressions_sum, clicks_sum, ctr_percent, avg_position]
  }

  measure: clicks_sum {
    type: sum
    sql: ${clicks} ;;
    label: "# Clicks"
    description: "A click represents each time a user clicks on your site's link in the search results. It indicates direct interaction with your site's link, demonstrating user engagement with your content."
    value_format: "#,##0"
    drill_fields: [query, search_type, search_brand_type, impressions_sum, clicks_sum, ctr_percent, avg_position]
  }

  measure: ctr_percent {
    type: number
    sql: ${clicks_sum}/${impressions_sum} ;;
    label: "CTR %"
    description: "Click-Through Rate is a metric that measures the ratio of clicks to impressions for a specific URL, page, or search query."
    value_format: "0.00%"
    drill_fields: [query, search_type, search_brand_type, impressions_sum, clicks_sum, ctr_percent, avg_position]
  }

  measure: avg_position {
    type: number
    sql: SUM(${sum_top_position})/SUM(${impressions}) + 1 ;;
    label: "Avg Position"
    description: "Average ranking of the web pages in search engine results pages (SERPs) for specific queries."
    value_format: "0.000"
    drill_fields: [query, search_type, search_brand_type, impressions_sum, clicks_sum, ctr_percent, avg_position]
  }

  measure: branded_searches_count {
    type: count_distinct
    sql: ${query} ;;
    filters: [search_brand_type: "branded"]
    label: "# Searches (branded)"
    description: "Search queries that are explicitly mentioning 'Flip'."
    value_format: "#,##0"
    drill_fields: [query, search_type, search_brand_type, impressions_sum, clicks_sum, ctr_percent, avg_position]
  }

  measure: non_branded_searches_count {
    type: count_distinct
    sql: ${query} ;;
    filters: [search_brand_type: "non-branded"]
    label: "# Searches (non-branded)"
    description: " Searches queries that do not contain 'Flip'. They are typically more generic and focused on a product, service, or topic."
    value_format: "#,##0"
    drill_fields: [query, search_type, search_brand_type, impressions_sum, clicks_sum, ctr_percent, avg_position]
  }

}
