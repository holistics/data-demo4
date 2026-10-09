include: "/base_views/Datamarts/zendesk_tickets_all_base.view"
#include: "/extended_views/Reports/cs_customers_ext.view"

view: zendesk_tickets_all_ext {

    extends: [zendesk_tickets_all_base]

  drill_fields: [ticket_id, assignee_name, organization_name, ticket_form_type, ticket_status, created_timestamp_date, ticket_topic]

# ---- DIMENSIONS ------------------------------------------------

    dimension: assignee_name {
      type: string
    }

    dimension_group: created_timestamp {
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        day_of_week,
        month,
        quarter,
        year
      ]
     label: "Created"
    }

  dimension: cs_name { # from tag
    type: string
    description: "Manual Tag assigned by CC"
  }

  dimension_group: company_go_live {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      day_of_week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    label: "Go Live"
  }

  dimension: hubspot_id {
    type: string
  }

    dimension: hours_to_solved {
      type: number

    }

    dimension: is_reopened {
      type: yesno

    }

    dimension_group: last_event_timestamp {
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year
      ]
      label: "Last Event"
      hidden: yes
    }

    dimension_group: last_updated_timestamp {
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year
      ]
    label: "last updated"
    }

    dimension_group: new_timestamp {
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year
      ]
      hidden: yes
    }

  dimension: organization_id {
    type: string
  }

    dimension: organization_name {
      type: string
    }

    dimension: requester_id {
      type: string
      hidden: yes
    }

    dimension: satisfaction_rating_comment {
      type: string
    }

    dimension: satisfaction_rating_score {
      type: string
    }

    dimension_group: solved_timestamp {
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year
      ]
    label: "Solved"
    }

    dimension: submitter_id {
      type: string
      hidden: yes
    }

    dimension: tenant_id {
      type: string
    }

    dimension: ticket_category {
      type: string
    }

  dimension: ticket_form_type {
    type: string
   }

    dimension: ticket_id {
      type: string
      primary_key: yes
      link: {
        label: "Zendesk URL"
        url: "https://flipappsupport.zendesk.com/agent/tickets/{{ ticket_id }}"
      }
    }

    dimension: ticket_priority {
      type: string
    }

  dimension: ticket_topic {
    type: string
    description: "Manual Tag assigned by CC"
  }

  dimension: ticket_status {
    type: string
  }

    dimension: ticket_status_current {
      type: string
      hidden: yes
    }

    dimension: ticket_status_previous {
      type: string
      hidden: yes
    }

    dimension: ticket_submission_channel {
      type: string
    }

    dimension: ticket_url {
      type: string
      hidden: yes
    }

    dimension: user_browser {
      type: string
    }

    dimension: user_device {
      type: string
    }

    dimension: user_os {
      type: string
    }

    dimension: user_type {
      type: string
    }

    # --- NEW DIMENSIONS ----------------------------------------------

    dimension: hours_to_solved_tiers {
      type: tier
      sql: ${hours_to_solved} ;;
      tiers: [8,24,48,72]
      style: integer
    }

    dimension: ticket_status_sorted {
      type: string
      sql: CASE
      WHEN ${ticket_status} = "closed" THEN "6_closed"
      WHEN ${ticket_status} = "hold" THEN "4_hold"
      WHEN ${ticket_status} = "pending" THEN "3_pending"
      WHEN ${ticket_status} = "deleted" THEN "7_deleted"
      WHEN ${ticket_status} = "solved" THEN "5_solved"
      WHEN ${ticket_status} = "open" THEN "2_open"
      WHEN ${ticket_status} = "new" THEN "1_new" END;;
    }

    # --- COHORTS -------------------------------------

    # dimension: days_since_go_live_date {
    #   type: number
    #   sql:  DATE_DIFF(${created_timestamp_date}, ${cs_customers_ext.zabbix_go_live_date}, DAY);;
    #   hidden: yes
    # }

  dimension: days_since_go_live_date {
    type: number
    sql:  DATE_DIFF(${created_timestamp_date}, ${company_go_live_date}, DAY);;
    hidden: yes
  }

  dimension: months_since_go_live_floor {
    type: number
    sql: FLOOR(${days_since_go_live_date}/(30)) ;;
    label: "Months since GoLive (App Handover)"
    description: "Number of months since the Customer started using Flip (GoLive Date = Vitally App Handover Date)"
    }

    # --- MEASURES ----------------------------------------------
    measure: count {
      type: count
      #drill_fields: [assignee_name, organization_name]
      label: "# of Tickets"
    }

    measure: ticket_percentage {
      type: percent_of_total
      sql: ${count} ;;
      label: "% of Tickets"
    }

    measure: count_ratings_good {
      type: count
      label: "# Tickets: rating 'good'"
      filters: [satisfaction_rating_score: "good"]
    }

  measure: count_ratings_bad {
    type: count
    label: "# Tickets: rating 'bad'"
    filters: [satisfaction_rating_score: "bad"]
  }

  measure: count_ratings_all_offered {
    type: count
    label: "# Tickets: rating offered"
    description: "All tickets where a rating was offered (with answer and without answer)"
    filters: [satisfaction_rating_score: "good, bad, offered"]
  }

  measure: count_ratings_all_given {
    type: count
    label: "# Tickets: rating given"
    description: "All tickets that were offered a rating and got one from the user."
    filters: [satisfaction_rating_score: "bad, good"]
  }

    measure: hours_solved_avg {
      type: average
      sql: ${hours_to_solved} ;;
      value_format_name: decimal_1
      label: "Hours to Solved Avg"
    }

  measure: hours_solved_sum {
    type: sum
    sql: ${hours_to_solved} ;;
    label: "Hours to Solved Total"
  }

  }
