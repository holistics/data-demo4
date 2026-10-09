include: "/base_views/Datamarts/flip_page_settings_unique_base.view"

# view: flip_page_settings_unique_ext {
# # Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
#   explore: flip_page_settings_unique_base {
#     hidden: yes
#     join: flip_page_settings_unique__parent_path_ids {
#       view_label: "Flip Page Settings Unique: Parent Path Ids"
#       sql: LEFT JOIN UNNEST(${flip_page_settings_unique_base.parent_path_ids}) as flip_page_settings_unique__parent_path_ids ;;
#       relationship: one_to_many
#     }
#   }
  view: flip_page_settings_unique_ext {

  extends: [flip_page_settings_unique_base]

# --- DIMENSIONS ------------------------------------------------
    dimension_group: created_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: created_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }
    dimension_group: db_row_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: db_row_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }
    dimension: external_id {
      type: string
    }
    dimension: is_db_row_deleted {
      type: yesno
    }
    dimension: is_leaf {
      type: yesno
    }
    dimension: is_parent {
      type: yesno
    }
    dimension: is_root {
      type: yesno
    }
    dimension: managing_user_group_id {
      type: string
    }
    dimension: order_number {
      type: number
    }
    dimension: page_id {
      type: string
      primary_key: yes
    }
    dimension: parent_page_id {
      type: string
    }
    dimension: parent_path_ids {
      hidden: yes
    }
    dimension: publication_status {
      type: string
    }
    dimension_group: published_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: published_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }
    dimension: tenant {
      type: string
    }
    dimension_group: updated_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: updated_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }

# --- MEASURES ------------------------------
    measure: count {
      type: count
      label: "# Pages"
    }

    measure: tenant_count_distinct {
      type: count_distinct
      sql: ${tenant} ;;
    }

    measure: parent_pages_count {
      type: count
      filters: [is_parent: "Yes"]
      label: "# Parent Pages"
    }

    measure: leaf_pages_count {
      type: count
      filters: [is_leaf: "Yes"]
      label: "# Leaf Pages"
    }
  }

  # view: flip_page_settings_unique__parent_path_ids {

  #   dimension: flip_page_settings_unique__parent_path_ids {
  #     type: string
  #     sql: flip_page_settings_unique__parent_path_ids ;;
  #   }
  # }
