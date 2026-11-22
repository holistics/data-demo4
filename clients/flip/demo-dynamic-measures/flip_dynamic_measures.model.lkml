connection: "fl-bi-p-looker-sa"

include: "flip_deals.view.lkml"
include: "flip_companies.view.lkml"

label: "Flip — Dynamic Measure Switching Demo"

explore: flip_deals {
  label: "Flip Deals — Dynamic Measures"
  description: "Count versus euro value by company. Minimal migration demo; not a fan-out demonstration."

  join: flip_companies {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flip_deals.company_id} = ${flip_companies.company_id} ;;
  }
}
