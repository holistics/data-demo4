include: "/base_views/Datamarts/flip_user_ids_original_and_piis_unique_SENSITIVE_base.view"

view: flip_user_ids_original_and_piis_unique_sensitive_ext {

  extends: [flip_user_ids_original_and_piis_unique_SENSITIVE_base]

## !! highly GDPR sensitive information - limited access!! ##

  drill_fields: [tenant, user_id_hashed, user_id_original, first_name, last_name, job_title, department, location]

# ----- DIMENSIONS ----------------------------------------
    dimension_group: db_row_timestamp {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
    }
    dimension_group: db_row_timestamp_berlin {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      hidden: yes
    }
    dimension: department { #sensitive
      type: string
    }
    dimension: email { #sensitive
      type: string
      hidden: yes
    }
  dimension: external_id {
    type: string
  }
    dimension: first_name { #sensitive
      type: string
    }
    dimension: is_db_row_deleted {
      type: yesno
    }
    dimension: job_title { #sensitive
      type: string
    }
    dimension: last_name { #sensitive
      type: string
    }
    dimension: location { #sensitive
      type: string
    }
    dimension: reversed_ranking {
      type: number
      hidden: yes
    }
    dimension: tenant {
      type: string
    }
    dimension: user_id_hashed {
      type: string
      primary_key: yes
      hidden: yes # this table is just an additional lookup for datamarts.flip_users_unique -> user_id can be pulled from there
    }
    dimension: user_id_original { #sensitive
      type: string
    }
    dimension: username {
    type: string
    }

    dimension: has_email {
      type: yesno
      sql: CASE WHEN ${email} IS NOT NULL THEN true ELSE false END ;;
    }

    dimension: about_me_text {
      type: string
    }
    dimension: phone_number {
      type: string
    }
    dimension: mobile_number {
      type: string
    }

# ---- MEASURES -------------------------------
    measure: count {
      type: count
      drill_fields: [last_name, first_name]
      label: "# Users"
    }
  }
