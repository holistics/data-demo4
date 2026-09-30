include: "/base_views/Reports/rd_prod02_customers_daily_users_agg_base.view"

view: rd_prod02_customers_daily_users_agg_ext {

  extends: [rd_prod02_customers_daily_users_agg_base]

  # --- DIMENSIONS --------------------
    dimension_group: date_berlin {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }
    dimension: dau {
      type: number
      hidden: yes
    }
    dimension: mau {
      type: number
      hidden: yes
    }
    dimension: users_created {
      type: number
      hidden: yes
    }
    dimension: users_onboarded {
      type: number
      hidden: yes
    }
    dimension: wau {
      type: number
      hidden: yes
    }

    # --- MANUAL DIMENSIONS ---------------------

    dimension: date_pk {
      type: string
      sql: ${date_berlin_date} ;;
      primary_key: yes
    }

  # --- MEASURES -----------------
    measure: count {
      type: count
      hidden: yes
    }

    measure: dau_sum {
      type: sum
      sql: ${dau} ;;
      label: "# DAU"
  }

  measure: wau_sum {
    type: sum
    sql: ${wau} ;;
    label: "# WAU"
  }

  measure: mau_sum {
    type: sum
    sql: ${mau} ;;
    label: "# MAU"
  }

  measure: users_created_sum {
    type: sum
    sql: ${users_created} ;;
    label: "# Users Created"
  }

  measure: users_onboarded_sum {
    type: sum
    sql: ${users_onboarded} ;;
    label: "# Users Onboarded"
  }
  }
