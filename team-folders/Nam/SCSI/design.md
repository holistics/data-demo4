---
version: alpha
name: State Collection Service · Client Analytics
description: Light analytics design contract for the SCSI external client portal, derived from State Collection Service's public website and the matching embed shell.
colors:
  primary: "#015AAA"
  secondary: "#01BDF2"
  page: "#F2F7FB"
  canvas: "#F7FAFC"
  card: "#FFFFFF"
  text-strong: "#123653"
  text-default: "#587086"
  text-subtle: "#6F8496"
  border: "#DBE6EE"
  hover: "#DFF4FC"
  positive-text: "#17624F"
  positive-fill: "#DFF3ED"
  negative-text: "#9B3030"
  negative-fill: "#FDE8E8"
  chart-categorical-1: "oklch(0.60 0.17 254)"
  chart-categorical-2: "oklch(0.68 0.16 299)"
  chart-categorical-3: "oklch(0.63 0.18 344)"
  chart-categorical-4: "oklch(0.57 0.17 29)"
  chart-categorical-5: "oklch(0.65 0.15 74)"
  chart-categorical-6: "oklch(0.62 0.17 119)"
  chart-categorical-7: "oklch(0.61 0.14 164)"
  chart-categorical-8: "oklch(0.63 0.15 209)"
typography:
  dashboard-title:
    fontFamily: 'Roboto, Arial, sans-serif'
    fontSize: 1.5rem
    fontWeight: 600
    lineHeight: 1.2
  section-title:
    fontFamily: 'Roboto, Arial, sans-serif'
    fontSize: 0.875rem
    fontWeight: 600
    lineHeight: 1.3
  body:
    fontFamily: 'Roboto, Arial, sans-serif'
    fontSize: 0.8125rem
    fontWeight: 400
    lineHeight: 1.5
  table-label:
    fontFamily: 'Roboto, Arial, sans-serif'
    fontSize: 0.8125rem
    fontWeight: 600
    lineHeight: 1.3
  kpi-value:
    fontFamily: 'Roboto, Arial, sans-serif'
    fontSize: 2.25rem
    fontWeight: 600
    lineHeight: 1.05
rounded:
  sm: 4px
  md: 6px
  pill: 999px
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
components:
  page-frame:
    backgroundColor: "{colors.page}"
    textColor: "{colors.text-default}"
  canvas:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.text-default}"
  card:
    backgroundColor: "{colors.card}"
    textColor: "{colors.text-strong}"
    rounded: "{rounded.md}"
  table-header:
    backgroundColor: "{colors.page}"
    textColor: "{colors.text-strong}"
  hairline:
    backgroundColor: "{colors.border}"
  selected-row:
    backgroundColor: "{colors.hover}"
    textColor: "{colors.text-strong}"
  secondary-label:
    textColor: "{colors.text-subtle}"
  focus-indicator:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.card}"
  positive-status:
    backgroundColor: "{colors.positive-fill}"
    textColor: "{colors.positive-text}"
  negative-status:
    backgroundColor: "{colors.negative-fill}"
    textColor: "{colors.negative-text}"
  chart-series-1:
    backgroundColor: "{colors.chart-categorical-1}"
  chart-series-2:
    backgroundColor: "{colors.chart-categorical-2}"
  chart-series-3:
    backgroundColor: "{colors.chart-categorical-3}"
  chart-series-4:
    backgroundColor: "{colors.chart-categorical-4}"
  chart-series-5:
    backgroundColor: "{colors.chart-categorical-5}"
  chart-series-6:
    backgroundColor: "{colors.chart-categorical-6}"
  chart-series-7:
    backgroundColor: "{colors.chart-categorical-7}"
  chart-series-8:
    backgroundColor: "{colors.chart-categorical-8}"
---

## Overview

This contract makes the embedded `scsi_client_portal` dashboard feel continuous with its host application rather than like a dark product nested inside a light product. Brand evidence comes from the [State Collection Service website](https://www.statecollectionservice.com/) and the SCSI client analytics shell in `holistics-embed-demo`. The official website supplied the State wordmark, `#015AAA` blue, `#01BDF2` cyan, Roboto body typography, white navigation surfaces, and restrained rectangular controls. The embed shell supplied the analytics-specific surface, text, border, hover, and semantic roles.

The implementation is `Dashboards/scsi_client_portal.theme.aml`, which defines `scsi_client_portal_palette` and `scsi_client_portal_theme`. Only `Dashboards/scsi_client_portal.page.aml` consumes it. The internal `scsi_collections_analytics` dashboard keeps the existing dark `scsi_theme`; this contract changes no datasets, metrics, filters, permissions, user attributes, layout positions, or embed access.

## Colors

Use State blue for analytical emphasis and focus, cyan as a supporting brand accent, deep blue for strong hierarchy, and cool near-whites for the page and canvas. White cards sit above the canvas with a 1px blue-gray hairline. Table headers repeat the page blue-gray while hover states use the pale cyan wash.

The eight-series chart palette preserves blue as the first series and spreads the remaining hues around the OKLCH wheel so adjacent categories remain distinguishable on white. It is an analytics adaptation, not an official State marketing palette. Keep legends, labels, and table values as non-color cues.

Primary text on white has strong contrast, while muted and subtle text remain reserved for secondary copy. Cyan is decorative and supportive; do not use it for small text on white. Focus and selected states use the darker primary blue.

## Typography

Use Roboto to match the public website and embed shell, with Arial as a robust fallback. Headings, block labels, and KPI values use 600 weight. Body and table text use 400. Keep labels in sentence case unless Holistics supplies an existing visualization label in uppercase.

## Layout

Preserve the existing 1300px canvas and all block positions. Use a comfortable 8px rhythm: 8px within tight groups, 16px card padding, 24px between related regions, and 32px between major sections. The dashboard remains responsive through its existing automatic mobile layout.

## Elevation & Depth

Use the page → canvas → white-card surface progression instead of dark nested panels. Separate cards with 1px hairline borders and no shadows, matching the host shell's flat, operational visual language. Avoid decorative gradients and elevated marketing treatments.

## Shapes

Use restrained 4–6px radii for canvases, cards, tables, and filter controls. Reserve pills for short statuses. The shape language should feel precise and operational rather than soft or playful.

## Components

- Cards: white, 6px radius, 16px padding, blue-gray hairline, no shadow.
- Filters: white control surfaces, dark labels, light borders, and State-blue focus states inherited from the block theme.
- KPI blocks: left-aligned 36px deep-blue values with compact muted labels.
- Tables: white body, pale page-colored header, subtle horizontal rules, pale-cyan hover, and 13px text.
- Charts: use `scsi_client_portal_palette`, with State blue first for single-series analysis.
- Text blocks: dark-blue headings, muted blue-gray body copy, and compact vertical spacing.

## Do's and Don'ts

- Do make the embedded dashboard and the light host shell read as one application.
- Do preserve strong text contrast and use labels or legends alongside color.
- Do keep the existing scoped dataset and PII masking behavior unchanged.
- Don't reuse the dark internal-operations theme for the external portal.
- Don't use cyan for small text, table values, or focus rings on white.
- Don't apply this client-portal theme to the internal SCSI dashboard without a separate review.
