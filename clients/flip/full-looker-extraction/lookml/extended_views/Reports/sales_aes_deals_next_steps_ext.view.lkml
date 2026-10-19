include: "/base_views/Reports/sales_aes_deals_next_steps_base.view"

# ------ BASE DIMENSIONS ----------------------------------------------------------------------------------------------

view: sales_aes_deals_next_steps_ext {

  extends: [sales_aes_deals_next_steps_base]

    dimension_group: copied_at {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
    }

    dimension: date_and_step {
      type: string
      primary_key: yes
    }

    dimension: deal_id {
      type: string
    }

    dimension: deal_next_step {
      type: string
    }

    measure: count {
      type: count
      hidden: yes
    }

}
