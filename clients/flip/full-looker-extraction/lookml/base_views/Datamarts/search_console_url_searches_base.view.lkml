view: search_console_url_searches_base {
  sql_table_name: `fl-bi-p-poc.datamarts_poc.search_console_url_searches` ;;

  dimension: clicks {
    type: number
    sql: ${TABLE}.clicks ;;
  }
  dimension: foreign_key {
    type: string
    sql: ${TABLE}.foreign_key ;;
  }
  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
  }
  dimension: is_target_keyword {
    type: yesno
    sql: ${TABLE}.is_target_keyword ;;
  }
  dimension: matched_target_keyword {
    type: string
    sql: ${TABLE}.matched_target_keyword ;;
  }
  dimension_group: period {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.period ;;
  }
  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
  }
  dimension: query {
    type: string
    sql: ${TABLE}.query ;;
  }
  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }
  dimension: search_brand_type {
    type: string
    sql: ${TABLE}.search_brand_type ;;
  }
  dimension: search_type {
    type: string
    sql: ${TABLE}.search_type ;;
  }
  dimension: sum_position {
    type: number
    sql: ${TABLE}.sum_position ;;
  }
  dimension: url {
    type: string
    sql: ${TABLE}.url ;;
  }
  measure: count {
    type: count
  }
}
