include: "/base_views/Reports/marketing_account_scoring_all_touchpoints_base.view"

view: marketing_account_scoring_all_touchpoints_ext {

  extends: [marketing_account_scoring_all_touchpoints_base]
  drill_fields: [account_id, touchpoint_details, touchpoint_type]

# ----- DIMENSIONS ---------------------------------------------------------------------------------------------------------

  dimension: account_contact_foreign_key {
    type: string
    drill_fields: []
  }

  dimension: account_id {
    type: string
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/company/{{ account_id }}"
    }
    drill_fields: []
  }

  dimension: cost_euros {
    type: number
    drill_fields: []
    hidden: yes
  }

  dimension: hubspot_object_id {
    type: string
    link: {
      label: "HubSpot URL"
      url: "https://app.hubspot.com/contacts/7401529/contact/{{ hubspot_object_id }}"
    }
    drill_fields: []
  }

  dimension: hubspot_object_source_channel { # remove
    type: string
    label: "Hubspot Object Source Channel OLD"
  }

  dimension: hubspot_object_source_channel_cluster_hubspot {
    type: string
  }

  dimension: touchpoint_type {
    type: string
    drill_fields: []
  }

  dimension: touchpoint_details { # already replaced with hubspot_object_source_channel_drilldown_hubspot where applicable - no need for replacement
    type: string
    drill_fields: []
  }

  dimension_group: touchpoint_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    drill_fields: []
  }

  dimension_group: touchpoint_timestamp_start {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    drill_fields: []
  }

  dimension_group: touchpoint_timestamp_end {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    drill_fields: []
  }

  dimension: primary_key {
    type: string
    primary_key: yes
    hidden: yes
    drill_fields: []
  }

  dimension: touchpoint_url {
    type: string
    link: {
      label: "Access URL"
      url: "{{ touchpoint_url }}"
    }
    drill_fields: []
  }

# ----- DIMENSIONS ---------------------------------------------------------------------------------------------------------

  parameter: date_range_parameter {
    type: unquoted
    allowed_value: {
      label: "Last 30 complete days"
      value: "last_30"
    }
    allowed_value: {
      label: "Last 60 complete days"
      value: "last_60"
    }
    allowed_value: {
      label: "Last 90 complete days"
      value: "last_90"
    }
  }

  dimension: date_range_flag {
    type: string
    label_from_parameter: date_range_parameter
    sql:
          {% if date_range_parameter._parameter_value == 'last_30' %}
            CASE WHEN ${touchpoint_timestamp_date} BETWEEN (CURRENT_DATE()-30) AND (CURRENT_DATE()-1) THEN "yes"
            ELSE NULL END
          {% elsif date_range_parameter._parameter_value == 'last_60' %}
            CASE WHEN ${touchpoint_timestamp_date} BETWEEN (CURRENT_DATE()-60) AND (CURRENT_DATE()-1) THEN "yes"
            ELSE NULL END
          {% elsif date_range_parameter._parameter_value == 'last_90' %}
            CASE WHEN ${touchpoint_timestamp_date} BETWEEN (CURRENT_DATE()-90) AND (CURRENT_DATE()-1) THEN "yes"
            ELSE NULL END
          {% else %}
            NULL
          {% endif %};;
  }

  dimension: is_reached {
    type: yesno
    sql:CASE
        WHEN touchpoint_type IN (
          'bdr call answered',
          'bdr call not answered',
          'bdr email sent',
          'email clicked',
          'website pageview',
          'content syndication',
          'trade show attendance',
          'demo request',
          'organic social engagement',
          'whitepaper submission',
          'bdr meeting attended',
          'external webinar attendance',
          'webinar attendance',
          'paid ads click',
          'other form submission',
          'webinar sign-up'
          'newsletter sign-up',
          'savings calculator submission',
          'reachdesk gift redeemed',
          'contact conversion',
          'linkedin ad engagement',
          'dinner attendance',
          'contact form submission',
          'linkedin ad click',
          'linkedin ad impression'
        ) THEN TRUE
        ELSE FALSE
      END;;
    label: "Touchpoint is reaching"
  }

  dimension: is_engaged {
    type: yesno
    sql:CASE
        WHEN touchpoint_type IN (
          'email clicked',
          'website pageview',
          'content syndication',
          'trade show attendance',
          'demo request',
          'organic social engagement',
          'whitepaper submission',
          'bdr meeting attended',
          'external webinar attendance',
          'webinar attendance',
          'paid ads click',
          'other form submission',
          'newsletter sign-up',
          'webinar sign-up'
          'savings calculator submission',
          'reachdesk gift redeemed',
          'contact conversion',
          'dinner attendance',
          'contact form submission',
          'linkedin ad click'
        ) THEN TRUE
        ELSE FALSE
      END;;
    label: "Touchpoint is engaging"
  }

  dimension: is_converted {
    type: yesno
    sql:CASE
        WHEN touchpoint_type IN (
          'content syndication',
          'demo request',
          'whitepaper submission',
          'bdr meeting attended',
          'external webinar attendance',
          'webinar attendance',
          'other form submission',
          'newsletter sign-up',
          'webinar sign-up'
          'savings calculator submission',
          'reachdesk gift redeemed',
          'contact conversion',
          'dinner attendance',
          'contact form submission'
        ) THEN TRUE
        ELSE FALSE
      END;;
    label: "Touchpoint is converting"
  }

  dimension: distinct_key_contact_touchpoint {
    type: string
    sql: CONCAT(${hubspot_object_id},"_",${touchpoint_type},"_",${touchpoint_details},"_",${touchpoint_timestamp_date}) ;;
  }

# ----- MEASURES -----------------------------------------------------------------------------------------------------------

measure: earliest_touchpoint_date {
  type:  date
  sql:  MIN(touchpoint_timestamp) ;;
  label: "Earliest Touchpoint With Account"
  drill_fields: [touchpoint_timestamp_date, touchpoint_type, touchpoint_details, account_id]
}

  measure: count {
    type: count
    hidden: no
    label: "# Total Touchpoints"
  }

measure: count_distinct_accounts {
  type: count_distinct
  sql_distinct_key: ${hubspot_object_id} ;;
  sql: ${hubspot_object_id} ;;
  label: "# Accounts"
}
  measure: event_cost_sum_euros {
    type: sum_distinct
    sql_distinct_key: ${touchpoint_details} ;;
    sql: ${cost_euros};;
    label: "€ Event Costs"
    value_format: "[>=1000000]€#0.000,,\" M\";[>=1000]€#0.00,\" K\";[<1000]€#0.00;0"
    description: "Budget (in euros) spent on the respective Marketing action"
  }

  # measure: phone_calls_count {
  #   type: count
  #   filters: [touchpoint_type: "phone call"]
  #   label: "Δ Phone calls"
  # }

  # measure: meetings_count {
  #   type: count
  #   filters: [touchpoint_type: "meeting"]
  #   label: "Δ Meetings"
  # }

  measure: email_clicked_count {
    type: count
    filters: [touchpoint_type: "email clicked"]
    label: "Δ Emails clicked"
  }

  measure: demo_requests_count {
    type: count
    filters: [touchpoint_type: "demo request"]
    label: "Δ Demo requests"
  }

  # measure: linkedin_ad_engagement_count {
  #   type: count
  #   filters: [touchpoint_type: "linkedin ad engagement"]
  #   label: "Δ LinkedIn Ad Engagements"
  # }

  measure: other_form_submissions_count {
    type: count
    filters: [touchpoint_type: "other form submission"]
    label: "Δ Other form submissions"
  }

  measure: contact_form_submissions_count {
    type: count
    filters: [touchpoint_type: "contact form submission"]
    label: "Δ Contact form submissions"
  }

  measure: pageview_count {
    type: count
    filters: [touchpoint_type: "website pageview"]
    label: "Δ Pageviews"
  }

  measure: savings_calculator_count {
    type: count
    filters: [touchpoint_type: "savings calculator submission"]
    label: "Δ Savings Calculator submissions"
  }

  measure: trade_shows_count {
    type: count_distinct
    sql: ${distinct_key_contact_touchpoint} ;;
    filters: [touchpoint_type: "trade show attendance"]
    label: "Δ Trade Shows attendances"
  }

  measure: webinar_signup_count {
    type: count
    filters: [touchpoint_type: "webinar sign-up"]
    label: "Δ Demand webinar sign-up"
  }

  measure: webinar_attendance_count {
    type: count
    filters: [touchpoint_type: "external webinar attendance"]
    label: "Δ Webinar attendances"
  }

  measure: whitepaper_form_submission_count {
    type: count
    filters: [touchpoint_type: "whitepaper submission"]
    label: "Δ Whitepaper submissions"
  }

  measure: dinners_count {
    type: count
    filters: [touchpoint_type: "dinner attendance"]
    label: "Δ Dinner attendances"
  }

  measure: content_syndication_count {
    type: count
    filters: [touchpoint_type: "content syndication"]
    label: "Δ Content syndication"
  }

  measure: paid_ads_clicks_count {
    type: count
    filters: [touchpoint_type: "paid ads click"]
    label: "Δ Pageviews though Paid Ads"
  }

  measure: organic_social_engagements_count {
    type: count
    filters: [touchpoint_type: "organic social engagement"]
    label: "Δ Organic Social engagements"
  }

  measure: linkedin_ad_impressions {
    type: count
    filters: [touchpoint_type: "linkedin ad impression"]
    label: "Δ LinkedIn Ad Impression"
  }

  measure: linkedin_ad_clicks {
    type: count
    filters: [touchpoint_type: "linkedin ad click"]
    label: "Δ LinkedIn Ad Clicks"
  }

  measure: total_engagements_count {
    type: count
    filters: [touchpoint_type: "-meetings, -phone call, -deal conversion, -contact conversion, -linkedin ad engagement"]
    label: "Δ Marketing Total Engagements"
  }

  measure: reaching_touchpoints {
    type: count
    #filters: [touchpoint_type: "phone call"]
    label: "Δ Reaching Touchpoints"
  }
 measure: engaging_touchpoints {
  type: count
  filters: [touchpoint_type: "email clicked, website pageview, content syndication, trade show attendance, demo request, organic social engagement, whitepaper submission, bdr meeting attended, external webinar attendance, paid ads click, other form submission, newsletter sign-up, savings calculator submission, reachdesk gift redeemed, contact conversion, linkedin ad engagement, dinner attendance, contact form submission, linkedin ad click"]
  label: "Δ Engaging Touchpoints"
}

measure: conversion_touchpoints {
  type: count
  filters:[touchpoint_type: "content syndication, demo request, whitepaper submission, bdr meeting attended,  other form submission, newsletter sign-up, savings calculator submission, reachdesk gift redeemed, contact conversion, linkedin ad engagement, dinner attendance, contact form submission"]
  label: "Δ Conversion Touchpoints"
}

# similar calculations regarding unique accounts

  measure: bdr_call_answered_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "bdr call answered"]
    label: "Δ Accounts reached via BDR call answered"
  }

  measure: bdr_call_not_answered_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "bdr call not answered"]
    label: "Δ Accounts reached via BDR call not answered"
  }

  measure: bdr_email_sent_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "bdr email sent"]
    label: "Δ Accounts reached via BDR email sent"
  }

  # measure: phone_calls_accounts {
  #   type: count_distinct
  #   sql: ${account_id} ;;
  #   filters: [touchpoint_type: "phone call"]
  #   label: "Δ Accounts reached via Phone calls"
  # }

  # measure: meetings_accounts {
  #   type: count_distinct
  #   sql: ${account_id} ;;
  #   filters: [touchpoint_type: "meeting"]
  #   label: "Δ Accounts reached via Meetings"
  # }

  measure: email_clicked_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "email clicked"]
    label: "Δ Accounts reached via Emails clicked"
  }

  measure: demo_requests_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "demo request"]
    label: "Δ Accounts reached via Demo requests"
  }

  measure: linkedin_ad_impression_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "linkedin ad impression"]
    label: "Δ Accounts reached via Linkedin Ad Impression"
  }

  measure: linkedin_ad_click_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "linkedin ad click"]
    label: "Δ Accounts reached via Linkedin Ad Click"
  }

  measure: other_form_submissions_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "other form submission"]
    label: "Δ Accounts reached via Other form submissions"
  }

  measure: contact_form_submissions_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "contact form submission"]
    label: "Δ Accounts reached via Contact form submissions"
  }

  measure: contact_conversion_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "contact conversion"]
    label: "Δ Accounts reached via Contact conversion"
  }

  measure: pageview_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "website pageview"]
    label: "Δ Accounts reached via Pageviews"
  }

  measure: savings_calculator_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "savings calculator submission"]
    label: "Δ Accounts reached via Savings Calculator submissions"
  }

  measure: trade_shows_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "trade show attendance"]
    label: "Δ Accounts reached via Trade Shows attendances"
  }

  measure: webinar_signup_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "webinar sign-up"]
    label: "Δ Accounts reached via Demand webinar sign-up"
  }

  measure: webinar_attendance_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "external webinar attendance"]
    label: "Δ Accounts reached via Webinar attendances"
  }

  measure: newsletter_signup_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "newsletter sign-up"]
    label: "Δ Accounts reached via Newsletter sign-up"
  }

  measure: whitepaper_form_submission_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "whitepaper submission"]
    label: "Δ Accounts reached via Whitepaper submissions"
  }

  measure: bdr_meeting_attended_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "bdr meeting attended"]
    label: "Δ Accounts reached via BDR Meeting attended"
  }

  measure: dinners_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "dinner attendance"]
    label: "Δ Accounts reached via Dinner attendances"
  }

  measure: content_syndication_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "content syndication"]
    label: "Δ Accounts reached via Content syndication"
  }

  measure: paid_ads_clicks_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "paid ads click"]
    label: "Δ Accounts reached via Pageviews though Paid Ads"
  }

  measure: organic_social_engagements_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "organic social engagement"]
    label: "Δ Accounts reached via Organic Social engagements"
  }

  measure: reachdesk_gift_redeemed_accounts {
    type: count_distinct
    sql: ${account_id} ;;
    filters: [touchpoint_type: "reachdesk gift redeemed"]
    label: "Δ Accounts reached via Reachdesk gift redeemed"
  }

  measure: accounts_reached {
    type: count_distinct
    sql: ${account_id} ;;
    #filters: [touchpoint_type: "phone call"]
    # drill_fields: [account_id]
    drill_fields: [bdr_email_sent_accounts, bdr_call_not_answered_accounts, bdr_call_answered_accounts, email_clicked_accounts, pageview_accounts, content_syndication_accounts, trade_shows_accounts, demo_requests_accounts, organic_social_engagements_accounts, whitepaper_form_submission_accounts, bdr_meeting_attended_accounts, paid_ads_clicks_accounts, webinar_attendance_accounts, other_form_submissions_accounts, newsletter_signup_accounts, savings_calculator_accounts, reachdesk_gift_redeemed_accounts, contact_conversion_accounts, dinners_accounts, contact_form_submissions_accounts, linkedin_ad_impression_accounts, linkedin_ad_click_accounts]
    filters: [touchpoint_type: "bdr call answered, bdr call not answered, bdr email sent, email clicked, website pageview, content syndication, trade show attendance, demo request, organic social engagement, whitepaper submission, bdr meeting attended, external webinar attendance, paid ads click, other form submission, newsletter sign-up, savings calculator submission, reachdesk gift redeemed, contact conversion, linkedin ad engagement, dinner attendance, contact form submission, linkedin ad click, linkedin ad impression"]
    label: "Δ Reached Accounts"
  }
  measure: accounts_engaged {
    type: count_distinct
    sql: ${account_id} ;;
    drill_fields: [email_clicked_accounts, pageview_accounts, content_syndication_accounts, trade_shows_accounts, demo_requests_accounts, organic_social_engagements_accounts, whitepaper_form_submission_accounts, bdr_meeting_attended_accounts, webinar_attendance_accounts, paid_ads_clicks_accounts, webinar_attendance_accounts, other_form_submissions_accounts, newsletter_signup_accounts, savings_calculator_accounts, reachdesk_gift_redeemed_accounts, contact_conversion_accounts, dinners_accounts, contact_form_submissions_accounts, linkedin_ad_click_accounts]
    filters: [touchpoint_type: "email clicked, website pageview, content syndication, trade show attendance, demo request, organic social engagement, whitepaper submission, bdr meeting attended, external webinar attendance, paid ads click, other form submission, newsletter sign-up, savings calculator submission, reachdesk gift redeemed, contact conversion, linkedin ad engagement, dinner attendance, contact form submission, linkedin ad click"]
    label: "Δ Engaged Accounts"
  }

  measure: accounts_conversed {
    type: count_distinct
    sql: ${account_id} ;;
    drill_fields: [content_syndication_accounts, demo_requests_accounts, whitepaper_form_submission_accounts, bdr_meeting_attended_accounts, webinar_attendance_accounts, other_form_submissions_accounts, newsletter_signup_accounts, savings_calculator_accounts, reachdesk_gift_redeemed_accounts, contact_conversion_accounts, dinners_accounts, contact_form_submissions_accounts]
    filters:[touchpoint_type: "content syndication, demo request, whitepaper submission, bdr meeting attended, other form submission, external webinar attendance, newsletter sign-up, savings calculator submission, reachdesk gift redeemed, contact conversion, linkedin ad engagement, dinner attendance, contact form submission"]
    label: "Δ Conversed Accounts"
  }

  measure: account_score_sum {
    type: number
    sql:  SUM(CASE
                  WHEN ${touchpoint_type} = "content syndication" THEN 25
                  WHEN ${touchpoint_type} = "demo request" THEN 100
                  WHEN ${touchpoint_type} = "dinner attendance" THEN 100
                  WHEN ${touchpoint_type} = "email clicked" THEN 15
                  WHEN ${touchpoint_type} = "organic social engagement" THEN 10
                  WHEN ${touchpoint_type} = "other form submission" THEN 20
                  WHEN ${touchpoint_type} = "paid ads click" THEN 10
                  WHEN ${touchpoint_type} = "trade show attendance" THEN 15
                  WHEN ${touchpoint_type} = "external webinar attendance" THEN 25
                  WHEN ${touchpoint_type} = "whitepaper submission" THEN 25
                  WHEN ${touchpoint_type} = "savings calculator submission" THEN 50
                  WHEN ${touchpoint_type} = "website pageview" AND ${touchpoint_details} = "pageview: product/benefits" THEN 15
                  WHEN ${touchpoint_type} = "website pageview" AND ${touchpoint_details} = "pageview: case studies" THEN 15
                  WHEN ${touchpoint_type} = "website pageview" AND ${touchpoint_details} = "pageview: demo" THEN 15
                  WHEN ${touchpoint_type} = "website pageview" AND ${touchpoint_details} = "pageview: pr news/media" THEN 15
                  WHEN ${touchpoint_type} = "website pageview" AND ${touchpoint_details} = "pageview: let's connect content" THEN 15
                  WHEN ${touchpoint_type} = "website pageview" THEN 5
                  ELSE NULL END) ;;
    label: "Δ Account Score"
  }

}
