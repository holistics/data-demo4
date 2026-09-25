include: "/base_views/Google_Sheets/fin_company_report_fte_base.view"

view: fin_company_report_fte_ext {

  extends: [fin_company_report_fte_base]

    dimension: development {
      type: number
    }
    dimension: general_administrative {
      type: number
      hidden: yes
    }
    dimension: marketing {
      type: number
      hidden: yes
    }

   dimension_group: month {
    type: time
    description: "%m/%d/%E4Y"
    timeframes: [month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    hidden: yes
  }

    dimension: product {
      type: number
      hidden: yes
    }
    dimension: sales {
      type: number
      hidden: yes
    }
    dimension: success_support {
      type: number
      hidden: yes
    }
    dimension: type {
      type: string
      label: "FTE Type"
    }

  # --- DIMENSIONS ------------

  dimension: date_pk{
    type: string
    sql: ${month_month} ;;
    primary_key:  yes
  }

  # --- MEASURES --------------------

  measure: count {
    type: count
    hidden: yes
  }

  measure: development_sum {
    type: sum
    sql: ${development} ;;
    label: "FTE Engineering"
    value_format_name: decimal_1
  }

  measure: development_avg {
    type: average_distinct
    sql: ${development} ;;
    label: "FTE Engineering avg."
    value_format_name: decimal_1
  }

  measure: general_administrative_sum {
    type: sum
    sql: ${general_administrative} ;;
    label: "FTE G&A"
    value_format_name: decimal_1
  }

  measure: general_administrative_avg {
    type: average_distinct
    sql: ${general_administrative} ;;
    label: "FTE G&A avg."
    value_format_name: decimal_1
  }

  measure: marketing_sum {
    type: sum
    sql: ${marketing} ;;
    label: "FTE Marketing"
    value_format_name: decimal_1
  }

  measure: marketing_avg {
    type: average_distinct
    sql: ${marketing} ;;
    label: "FTE Marketing avg."
    value_format_name: decimal_1
  }

  measure: product_sum {
    type: sum
    sql: ${product} ;;
    label: "FTE Product"
    value_format_name: decimal_1
  }

  measure: product_avg {
    type: average_distinct
    sql: ${product} ;;
    label: "FTE Product avg."
    value_format_name: decimal_1
  }

  measure: rd_sum {
    type: sum
    sql: ${product}+${development} ;;
    label: "FTE R&D"
    value_format_name: decimal_1
  }

  measure: rd_avg {
    type: average
    sql: ${product}+${development} ;;
    label: "FTE R&D (avg)"
    value_format_name: decimal_1
  }

  measure: sales_sum {
    type: sum
    sql: ${sales} ;;
    label: "FTE Sales"
    value_format_name: decimal_1
  }

  measure: sales_avg {
    type: average_distinct
    sql: ${sales} ;;
    label: "FTE Sales avg."
    value_format_name: decimal_1
  }

  measure: success_support_sum {
    type: sum
    sql: ${success_support} ;;
    label: "FTE Success & Support"
    value_format_name: decimal_1
  }

  measure: success_support_avg {
    type: average_distinct
    sql: ${success_support} ;;
    label: "FTE Success & Support avg."
    value_format_name: decimal_1
  }

  measure: total_ftes_sum {
    type: sum
    sql: ${product}+${development}+${marketing}+${sales}+${success_support}+${general_administrative} ;;
    label: "FTEs Total"
    value_format_name: decimal_0
  }
  }
