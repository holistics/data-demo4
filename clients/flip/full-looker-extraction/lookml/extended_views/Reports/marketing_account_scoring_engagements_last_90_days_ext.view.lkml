include: "/base_views/Reports/marketing_account_scoring_engagements_last_90_days_base.view"

view: marketing_account_scoring_engagements_last_90_days_ext {

  extends: [marketing_account_scoring_engagements_last_90_days_base]

  drill_fields: []

# ----- DIMENSIONS ---------------------------------------------------------------------------------------------------------

  dimension: account_id {
    type: string
  }
  dimension: last_90_days_account_engagement_score {
    type: string
    hidden: yes
  }
  dimension: last_90_days_account_engagement_stage {
    type: string
    hidden: yes
  }
  dimension: last_90_days_account_intent_score {
    type: string
    hidden: yes
  }
  dimension: last_90_days_account_intent_stage {
    type: string
    hidden: yes
  }
  dimension: primary_key {
    type: string
    primary_key: yes
    hidden: yes
  }
  dimension: touchpoint_details {
    type: string
    label: "Engagement Details"
  }
  dimension_group: touchpoint_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    label: "Engagement Date"
  }
  dimension: touchpoint_type {
    type: string
    label: "Engagement Type"
  }
  dimension: touchpoint_url {
    type: string
    label: "Engagement URL"
  }

# ----- CUSTOM DIMENSIONS ------------------------------------------------------------------------------------------------

  dimension: account_engagement_stage{
    type: string
    sql: IFNULL(${last_90_days_account_engagement_stage},"-") ;;
    label: "Account Engagement Stage (l90d)"
    description: "How often has an account engaged in the last 90 days with GTM assets"
    html:
      {% if value contains "High" %}
      <p style="color: white; background-color: #008000; font-weight: bold;">{{ value }}</p>
      {% elsif value contains "Medium" %}
      <p style="color: black; background-color: #ffd966; font-weight: bold;">{{ value }}</p>
      {% elsif value contains "Low" %}
      <p style="color: black; background-color: #bdd7ee; font-weight: bold;">{{ value }}</p>
      {% else %}
      {{ value }}
      {% endif %}
      ;;
    drill_fields: [touchpoint_timestamp_date, touchpoint_type, touchpoint_details, touchpoint_url]
  }

  dimension: account_intent_stage{
    type: string
    sql: IFNULL(${last_90_days_account_intent_stage},"-") ;;
    label: "Account Intent Stage (l90d)"
    description: "How active has an account been in the last 90 days at engaging with content that is focused on purchase behaviour"
    html:
      {% if value contains "Decision" %}
      <p style="color: white; background-color: #008000; font-weight: bold;">{{ value }}</p>
      {% elsif value contains "Consideration" %}
      <p style="color: black; background-color: #ffd966; font-weight: bold;">{{ value }}</p>
      {% elsif value contains "Awareness" %}
      <p style="color: black; background-color: #bdd7ee; font-weight: bold;">{{ value }}</p>
      {% else %}
      {{ value }}
      {% endif %}
      ;;
    drill_fields: [touchpoint_timestamp_date, touchpoint_type, touchpoint_details, touchpoint_url]
  }

# ----- MEASURES ---------------------------------------------------------------------------------------------------------

  measure: count {
    type: count
    hidden: yes
  }

}
