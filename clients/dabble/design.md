---
version: alpha
name: Dabble Holistics
description: Production light theme for Dabble's compact AU trading dashboards in Holistics.
colors:
  primary: "#21099B"
  canvas: "#FCFCFE"
  card: "#FFFFFF"
  surface-subtle: "#F4F4F5"
  surface-selected: "#EEE9FA"
  text-strong: "#180666"
  text-default: "#21099B"
  text-muted: "#4D4566"
  text-on-brand: "#FFFFFF"
  border-subtle: "#DDD8EA"
  border-strong: "#B8A4E7"
  focus: "#5C3BC4"
  brand-deep: "#180666"
  brand-primary: "#21099B"
  brand-action: "#5C3BC4"
  brand-chart: "#8A5DFF"
  positive-fill: "#E4F7EA"
  positive-text: "#176B35"
  positive-chart: "#28AC26"
  negative-fill: "#FDE8E7"
  negative-text: "#A61B1B"
  negative-chart: "#D9363E"
  attention-fill: "#FFF2D9"
  attention-text: "#7A4700"
  attention-chart: "#E58A00"
  info-fill: "#E7F1FF"
  info-text: "#174EA6"
  info-chart: "#3478D4"
  chart-categorical-1: "#8A5DFF"
  chart-categorical-2: "#73F8D4"
  chart-categorical-3: "#FE8885"
  chart-categorical-4: "#4D23A4"
  chart-categorical-5: "#3478D4"
  chart-categorical-6: "#E58A00"
  chart-categorical-7: "#D94FA3"
  chart-categorical-8: "#28AC26"
  chart-sequential-1: "#EEE9FA"
  chart-sequential-2: "#D8CCF3"
  chart-sequential-3: "#B8A4E7"
  chart-sequential-4: "#8B6ED8"
  chart-sequential-5: "#5C3BC4"
  chart-sequential-6: "#21099B"
  chart-diverging-negative: "#A61B1B"
  chart-diverging-negative-soft: "#FE8885"
  chart-diverging-neutral: "#F4F4F5"
  chart-diverging-positive-soft: "#73F8D4"
  chart-diverging-positive: "#176B35"
typography:
  dashboard-title:
    fontFamily: 'Inter, ui-sans-serif, system-ui, -apple-system, "Segoe UI", sans-serif'
    fontSize: 1.5rem
    fontWeight: 700
    lineHeight: 1.2
  section-title:
    fontFamily: 'Inter, ui-sans-serif, system-ui, -apple-system, "Segoe UI", sans-serif'
    fontSize: 0.875rem
    fontWeight: 600
    lineHeight: 1.3
  body:
    fontFamily: 'Inter, ui-sans-serif, system-ui, -apple-system, "Segoe UI", sans-serif'
    fontSize: 0.8125rem
    fontWeight: 400
    lineHeight: 1.4
  table-label:
    fontFamily: 'Inter, ui-sans-serif, system-ui, -apple-system, "Segoe UI", sans-serif'
    fontSize: 0.75rem
    fontWeight: 600
    lineHeight: 1.3
  kpi-value:
    fontFamily: 'Inter, ui-sans-serif, system-ui, -apple-system, "Segoe UI", sans-serif'
    fontSize: 2rem
    fontWeight: 700
    lineHeight: 1.1
rounded:
  sm: 6px
  md: 6px
spacing:
  xs: 4px
  sm: 8px
  md: 12px
  lg: 16px
  xl: 24px
components:
  primary-action:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.text-on-brand}"
  card:
    backgroundColor: "{colors.card}"
    textColor: "{colors.text-strong}"
    rounded: "{rounded.md}"
  table-header:
    backgroundColor: "{colors.brand-primary}"
    textColor: "{colors.text-on-brand}"
  selected-row:
    backgroundColor: "{colors.surface-selected}"
    textColor: "{colors.text-strong}"
  positive-status:
    backgroundColor: "{colors.positive-fill}"
    textColor: "{colors.positive-text}"
  negative-status:
    backgroundColor: "{colors.negative-fill}"
    textColor: "{colors.negative-text}"
  attention-status:
    backgroundColor: "{colors.attention-fill}"
    textColor: "{colors.attention-text}"
  info-status:
    backgroundColor: "{colors.info-fill}"
    textColor: "{colors.info-text}"
---

## Overview

This contract makes the Dabble AU trading dashboard unmistakably purple while keeping dense operational data readable. Published evidence is the creator-authored Dabble identity by Jeremy Blaze / Never Before Seen: [Dabble Visual Identity](https://dribbble.com/shots/15363095-Dabble-Visual-Identity) and [Never Before Seen — Dabble](https://www.neverbeforeseen.co/projects/dabble). Its published palette is `#180666`, `#21099B`, `#290CD5`, `#5C3BC4`, `#8B6ED8`, `#B8A4E7`, and `#FCFCFE`.

The [official Dabble site](https://www.dabble.com.au/) confirms current product language, but Cloudflare blocked visual browser rendering during this implementation. Customer-supplied report screenshots in `.amp/in/artifacts/dabble` are the product-UI evidence: repeated purple near `#8A5DFF`, dark purple near `#4D23A4`, mint near `#73F8D4`, coral near `#FE8885`, green near `#28AC26`, off-white canvases, white cards, deep-purple table headers, and compact density. Support colours for negative, attention, info, and magenta chart roles are inferred rather than published brand values.

Implementation uses the Holistics `PageTheme` named `dabble_light`, palettes `dabble_categorical_palette`, `dabble_purple_sequential_palette`, and `dabble_performance_diverging_palette`, and dashboard `clients/dabble/dashboards/dabble_au_trading.page.aml`.

## Colors

Use `canvas` for the page and reporting canvas, `card` for blocks, `surface-subtle` for zebra rows, and `surface-selected` for hover, selection, and informational callouts. Use `text-strong` for headings and important values, `text-default` for branded supporting emphasis, and `text-muted` for secondary copy. Deep-purple headers use `brand-primary` with `text-on-brand`; focus indicators use `focus` and must remain visible beyond the component border.

The default categorical order is `#8A5DFF`, `#73F8D4`, `#FE8885`, `#4D23A4`, `#3478D4`, `#E58A00`, `#D94FA3`, `#28AC26`. The purple sequential order is `#EEE9FA`, `#D8CCF3`, `#B8A4E7`, `#8B6ED8`, `#5C3BC4`, `#21099B`. The performance diverging order is `#A61B1B`, `#FE8885`, `#F4F4F5`, `#73F8D4`, `#176B35`. Holistics AML documents only the `categorical { colors: [...] }` palette shape, so the sequential and diverging sets are intentionally stored as selectable ordered categorical palette objects; do not invent unsupported AML sections.

Use positive fill/text/chart as `#E4F7EA` / `#176B35` / `#28AC26`; negative as `#FDE8E7` / `#A61B1B` / `#D9363E`; attention as inferred `#FFF2D9` / `#7A4700` / `#E58A00`; and info as inferred `#E7F1FF` / `#174EA6` / `#3478D4`. Always pair semantic colour with a label, sign, or icon. Never communicate outcomes through red and green alone. Do not use `#8A5DFF`, `#8B6ED8`, `#B8A4E7`, `#73F8D4`, `#FE8885`, or `#28AC26` as normal text on white. White text is allowed on `#5C3BC4` and `#21099B`.

## Typography

The exact Dabble font is unverified. Use `Inter, ui-sans-serif, system-ui, -apple-system, "Segoe UI", sans-serif`; AML uses the validator-supported string form of this stack. Dashboard titles are 24px/700, KPI values 32px/700, block labels 14px/600, body and table data 13px/400, and table headers 12px/600. Keep numeric columns aligned and avoid decorative display type in analytical views.

## Layout

Use a compact 4px base rhythm: 8px within controls, 12px card padding, 16px between closely related groups, and 24px between major sections. Controls and table rows should resolve to 32–36px high. Preserve the dashboard's 10px canvas grid and align cards, filters, and charts to common edges.

On narrow and mobile layouts, use Holistics automatic mobile flow: stack filters before content, keep KPI summaries ahead of detail tables, allow horizontal table scrolling rather than shrinking text, and keep chart legends adjacent to their charts. Do not encode meaning that depends on hover.

## Elevation & Depth

Separate surfaces with 1px `border-subtle` borders. Use no shadow on cards and only a restrained small shadow on the outer canvas; never use heavy or layered shadows. Near-white canvas and white cards provide the primary depth cue.

## Shapes

Use a consistent 6px radius for canvases, cards, controls, tables, and status containers. Keep data geometry crisp; avoid oversized pills except for short status labels.

## Components

- Cards: white, 1px subtle border, 6px radius, 12px padding, no heavy shadow.
- Tables: 32–36px rows, deep-purple header with white 12px semibold text, pale-purple subheaders, subtle zebra rows, and pale-purple hover/selection. Keep grid lines quiet but visible.
- Filters: compact 32–36px controls with white fill, subtle border, strong violet labels, and a visible `focus` ring. Stack at narrow widths.
- KPI blocks: strong violet values, short labels, and semantic trend chips using pale fills plus dark accessible text and explicit signs/labels.
<<<<<<< local:clients/dabble/design.md
- Charts: inherit `dabble_categorical_palette` by default. Single-series charts in this dashboard explicitly use `chart-categorical-1` (`#8A5DFF`) as a deterministic fallback because current Studio palette inheritance rendered the project default. Reserve sequential and diverging palettes for ordered intensity and performance comparisons respectively; legends and direct labels remain mandatory where categories could be ambiguous.
=======
<<<<<<< local:clients/dabble/design.md
- Charts: inherit `dabble_categorical_palette` by default. Single-series charts in this dashboard explicitly use `chart-categorical-1` (`#8A5DFF`) as a deterministic fallback because current Studio palette inheritance rendered the project default. Reserve sequential and diverging palettes for ordered intensity and performance comparisons respectively; legends and direct labels remain mandatory where categories could be ambiguous.
=======
- Charts: inherit `dabble_categorical_palette` by default. Reserve sequential and diverging palettes for ordered intensity and performance comparisons respectively; legends and direct labels remain mandatory where categories could be ambiguous.
>>>>>>> cloud:clients/dabble/design.md
>>>>>>> cloud:clients/dabble/design.md
- Callouts: use `surface-selected` with a `brand-action` left rule and strong violet text. Keep callout copy unchanged and concise.

## Do's and Don'ts

- Do use deep violet for hierarchy and vivid colours for data marks.
- Do keep dense trading tables compact, aligned, and scannable.
- Do pair positive and negative colours with signs, words, or icons.
- Don't use bright chart colours as normal text on white.
- Don't introduce unsupported chart styling, numeric palette IDs, or custom CSS when native theme properties suffice.
- Don't use gradients, heavy shadows, excessive rounding, or spacious marketing layouts in this analytical dashboard.
