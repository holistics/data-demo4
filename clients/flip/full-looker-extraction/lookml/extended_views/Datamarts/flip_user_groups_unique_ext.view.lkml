include: "/base_views/Datamarts/flip_user_groups_unique_base.view"

  # explore: flip_user_groups_unique_base {
  #   hidden: yes
  #   join: flip_user_groups_unique__parent_path_ids {
  #     view_label: "Flip User Groups Unique: Parent Path Ids"
  #     sql: LEFT JOIN UNNEST(${flip_user_groups_unique_base.parent_path_ids}) as flip_user_groups_unique__parent_path_ids ;;
  #     relationship: one_to_many
  #   }
  # }

view: flip_user_groups_unique_ext {
  extends: [flip_user_groups_unique_base]

# --- DIMENSIONS

    dimension_group: created_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: created_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: db_row_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: db_row_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension: external_id {
      type: string
    }
    dimension: group_title {
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
    dimension: parent_id {
      type: string
    }
    dimension: parent_path_ids {
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
    }
    dimension: user_group_id {
      type: string
      primary_key: yes
    }
    dimension: user_group_id_wo_tenant {
      type: string
      hidden: yes
    }
    dimension: is_dark_mode_set {
      type: yesno
    }
    dimension: is_light_mode_set {
      type: yesno
    }
    dimension: is_banner_image_set {
      type: yesno
    }

    # --- MEASURES --------------------
    measure: count {
      type: count
      label: "# User Groups"
    }
  }

  # view: flip_user_groups_unique__parent_path_ids {

  #   dimension: flip_user_groups_unique__parent_path_ids {
  #     type: string
  #     sql: flip_user_groups_unique__parent_path_ids ;;
  #   }
  # }
