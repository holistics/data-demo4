
include: "/base_views/Meta_Data/project_costs_daily_base.view"

# for fl-bi-p-customer-dashboards !

view: project_costs_daily_ext {

 extends: [project_costs_daily_base]

    dimension_group: day {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }

    dimension: primary_key {
      type: string
      primary_key: yes
      hidden: yes
    }

    dimension: project_id {
      type: string
    }
    dimension: total_dollar_billed {
      type: number
      hidden: yes
    }
    dimension: total_tb_billed {
      type: number
      hidden: yes
    }
    dimension: user_email {
      type: string

# MEASURES
    }
    measure: count {
      type: count
      hidden: yes
    }

    measure: total_dollar_billed_sum {
      type: sum
      sql: ${total_dollar_billed} ;;
      value_format_name: eur_0
    }

    measure: total_tb_billed_sum {
      type: sum
      sql: ${total_tb_billed} ;;
      value_format_name: decimal_1
    }

  }
