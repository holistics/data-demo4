---
name: holistics-widget-spacing
description: >-
  Enforce readable spacing/sizing for Holistics canvas-dashboard (CanvasLayout) blocks so text
  headers and KPI (MetricKpi) widgets are never cramped or truncated, and give every dashboard
  filter an explicit default. Use whenever creating or editing a `.page.aml` dashboard: sizing
  TextBlock/MetricKpi/chart blocks, writing the `pos(x, y, w, h)` layout, setting filter defaults,
  or when the user says widgets look cut off / don't have enough space.
---

# Holistics widget spacing

Holistics canvas dashboards lay out every block with `position: pos(x, y, width, height)`
inside `view: TabLayout { tab ...: CanvasLayout { width, height, grid_size: 20 ... } }`.
Content does **not** auto-grow — an undersized `height` truncates the title/number.
Apply the minimums below (all values are multiples of the 20px grid).

## Minimum sizes (grid_size 20, canvas width 1220)

| Block kind | Min height | Notes |
|---|---|---|
| Section header `TextBlock` with `## …` | **60** | one-line H2 |
| Header `TextBlock` with `###` one-liner | **50** | |
| Title `TextBlock` (`#` + a paragraph of body) | **150** | add 40 per extra body line |
| `MetricKpi` widget | **150** (h) × **280** (w) | add ~20h if it has a `compare_value` (PoP) |
| Any chart (Line/Column/Bar/Pie/Scatter) | **300** | 360–400 if it has a legend or many x categories |
| `PivotTable` / `DataTable` | **240** | +~40 per expected extra row |

Leave a **20px gap** between adjacent blocks (grid-aligned). Never let two blocks overlap.

## KPI widgets: kill the duplicated label

A `MetricKpi` renders the **block `label:`** (small grey title) *and* the **value field's
`label:`** (a second line) above the number. If both are set you get two lines of text
crowding the number (often clipping it). Fix: put the human title on the block `label`
and **blank the value field label** with a single space.

```aml
block k_sla_resp: VizBlock {
  label: '% First response ≤ 4h (SLA)'      // <- the visible title
  viz: MetricKpi {
    dataset: my_dset
    value: VizFieldFull {
      label: ' '                            // <- blank: don't repeat the measure name
      ref: r(my_model.pct_first_response_within_sla)
      format { type: 'number' pattern: 'inherited' }
    }
  }
}
```
Keep block labels short (they render on one line). If a title needs to be long, give the
KPI more width or shorten it.

## Text headers: give them room + real paragraphs

- Put the section title and any body text in the **same** `TextBlock`, and size the block
  for the *rendered* height (H1 is large; a wrapped 2-line paragraph needs ~2×20px more).
- For a title + subtitle, prefer a blank line between them so it renders as heading +
  paragraph rather than one clipped block:

```aml
block t_header: TextBlock {
  content: @md
# 🎯 Support Quality Overview

Response & resolution SLAs, business-hours coverage, CSAT ...;;   // body on its own line
}
// layout: block t_header { position: pos(20, 430, 1180, 150) layer: 1 }
```

## Standard column x-positions (width 1220, 20px margins)

- Full width: `x=20, w=1180`
- Halves: `x=20 w=580` · `x=620 w=580`
- Thirds: `x=20 w=380` · `x=420 w=380` · `x=820 w=380`
- Quarter / KPI: `x=20 w=285` · `x=325 w=285` · `x=630 w=285` · `x=935 w=265`

## Filters: declare an explicit default

A drill-down dashboard scoped to one entity (one tenant, one account, one rep) should not open
on an arbitrary or implicit filter state. Give the filter a `default` block so the opening state
is a deliberate choice rather than whatever the field happens to resolve to. `$H_NIL$` is the
sentinel for "no value", so `operator: 'is'` + `value: '$H_NIL$'` opens the dashboard with
nothing selected — the viewer must pick an entity before any wide query runs:

```aml
filter tenant_filter {
  label: 'Tenant'
  type: 'field'
  dataset: tenants_features_usage
  field: r(domain_holistics_tenants.name)
  default {
    operator: 'is'
    value: '$H_NIL$'
  }
  settings {
    input_type: 'nullable-single'
  }
}
```

Use the empty default when an unfiltered load would scan the full population; use a concrete
default (a date range, the current period) when the unfiltered view is the useful one. Either
way, state it — do not leave it to chance.

## Workflow when adding/moving blocks

1. Size each block to its **content**, not the previous block's height.
2. Stack sections top→down; track a running `y` and add the block height + a 20px gap.
3. When inserting a section mid-page, shift every block below it down by the inserted
   height (a small script over the `pos(...)` lines is reliable — see how existing
   dashboards do it) and grow the `CanvasLayout` `height`.
4. Always finish with `holistics aml validate <file>` and, when possible, an
   `execute_viz` smoke test.
