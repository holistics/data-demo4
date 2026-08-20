---
version: alpha
name: Laasie POC · Lassie Visual Theme
description: Evidence-based light analytics theme for the two Laasie Demo4 dashboards, derived from Lassie's public website.
colors:
  primary: "#0632AA"
  secondary: "#FFC14F"
  page: "#F7F0E8"
  canvas: "#FCFAF7"
  card: "#FFFFFF"
  text-strong: "#000D45"
  text-default: "#434355"
  text-subtle: "#4F5D9C"
  border-subtle: "#EAEAF6"
  focus: "#0632AA"
  positive-text: "#2D6A3F"
  positive-fill: "#E8F0C3"
  warning-text: "#805B00"
  negative-text: "#B42334"
  negative-fill: "#FFE7E9"
  neutral-fill: "#F2F2F7"
  hover: "#D2E9FF"
  chart-categorical-1: "#3B79FF"
  chart-categorical-2: "#A765DB"
  chart-categorical-3: "#DA4C93"
  chart-categorical-4: "#DF5F35"
  chart-categorical-5: "#A87600"
  chart-categorical-6: "#669900"
  chart-categorical-7: "#009779"
  chart-categorical-8: "#0093B3"
typography:
  dashboard-title:
    fontFamily: 'Inter, Arial, sans-serif'
    fontSize: 1.5rem
    fontWeight: 600
    lineHeight: 1.2
  section-title:
    fontFamily: 'Inter, Arial, sans-serif'
    fontSize: 0.875rem
    fontWeight: 600
    lineHeight: 1.3
  body:
    fontFamily: 'Inter, Arial, sans-serif'
    fontSize: 0.8125rem
    fontWeight: 400
    lineHeight: 1.5
  table-label:
    fontFamily: 'Inter, Arial, sans-serif'
    fontSize: 0.8125rem
    fontWeight: 600
    lineHeight: 1.3
  kpi-value:
    fontFamily: 'Inter, Arial, sans-serif'
    fontSize: 3rem
    fontWeight: 600
    lineHeight: 1.05
rounded:
  sm: 8px
  md: 16px
  lg: 20px
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
    rounded: "{rounded.lg}"
  border-swatch:
    backgroundColor: "{colors.border-subtle}"
    textColor: "{colors.text-strong}"
  table-header:
    backgroundColor: "{colors.page}"
    textColor: "{colors.text-strong}"
  secondary-copy:
    backgroundColor: "{colors.card}"
    textColor: "{colors.text-subtle}"
  selected-row:
    backgroundColor: "{colors.hover}"
    textColor: "{colors.text-strong}"
  focus-indicator:
    backgroundColor: "{colors.focus}"
    textColor: "{colors.card}"
  positive-status:
    backgroundColor: "{colors.positive-fill}"
    textColor: "{colors.positive-text}"
  negative-status:
    backgroundColor: "{colors.negative-fill}"
    textColor: "{colors.negative-text}"
  attention-status:
    backgroundColor: "{colors.page}"
    textColor: "{colors.warning-text}"
  neutral-status:
    backgroundColor: "{colors.neutral-fill}"
    textColor: "{colors.text-default}"
  chart-series-1:
    backgroundColor: "{colors.chart-categorical-1}"
    textColor: "{colors.text-strong}"
  chart-series-2:
    backgroundColor: "{colors.chart-categorical-2}"
    textColor: "{colors.text-strong}"
  chart-series-3:
    backgroundColor: "{colors.chart-categorical-3}"
    textColor: "{colors.text-strong}"
  chart-series-4:
    backgroundColor: "{colors.chart-categorical-4}"
    textColor: "{colors.text-strong}"
  chart-series-5:
    backgroundColor: "{colors.chart-categorical-5}"
    textColor: "{colors.text-strong}"
  chart-series-6:
    backgroundColor: "{colors.chart-categorical-6}"
    textColor: "{colors.text-strong}"
  chart-series-7:
    backgroundColor: "{colors.chart-categorical-7}"
    textColor: "{colors.text-strong}"
  chart-series-8:
    backgroundColor: "{colors.chart-categorical-8}"
    textColor: "{colors.text-strong}"
---

## Overview

This contract translates the public [Lassie English homepage](https://www.lassie.co/en) into a calm, warm light theme for the Laasie hospitality-loyalty POC. The rendered site was inspected on 20 August 2026 at a 1200 × 857 desktop viewport. Supporting evidence came only from the same Lassie origin: its rendered CSS, the build stylesheet at [`5baaefa2646d7dfb.css`](https://www.lassie.co/_next/static/css/5baaefa2646d7dfb.css), and the [dark-blue Lassie logo](https://www.lassie.co/images/logo-with-name-darkblue.svg).

The visual implementation is `Dashboards/laasie.theme.aml`: `laasie_theme` plus `laasie_palette`. Exactly two dashboards consume it: `Dashboards/laasie_growth_performance.page.aml` and `Dashboards/laasie_owner_portal.page.aml`. The theme changes presentation only; dashboard content, layout, datasets, filters, and access semantics remain unchanged.

### Directly observed evidence

| Token or pattern | Evidence |
|---|---|
| `#0632AA` primary blue | Computed fill on `.Header_logoSvg__aqBHD`; computed background on `.Header_linkButton___x6VQ`; CTA text on `.Button_secondary__84leU`. |
| `#000D45` ink navy | Computed heading color on `.typography_headingLg__q26mW` and `.FeatureCard_frontTitle__n5V1i`; the rendered page used it on 500+ visible elements. |
| `#434355` muted text | `.PackageCard_description__BvnwG`, `.PackageCard_coverageLabel__Bl67a`, and `.PackageCard_uspItem__4wOrZ`. |
| `#FCFAF7` warm off-white | `.app._app_redesign__nCiKY`, `.StandardHeroV2_container__tGZA_`, and `.BenefitsCarousel_section__VjWds`. |
| `#F7F0E8` cream | `.SmallGridCard_card__RrBkR` and the outer stop of `.FeatureCard_cardWrapper__ezD_u`'s radial background. |
| `#EAEAF6` cool hairline | FAQ item borders and carousel/control surfaces. |
| `#D2E9FF`, `#FFEDC1`, `#E8F0C3` | Alternate `.TextAndMediaCarousel_background__Wg_lA` panels; the same hues appear in feature-card radial gradients. |
| `#E5F2A7` lime | `.BannerV2_container__MoYh8` promotion background. |
| `#FFC14F` amber | `.ReviewCard_star__s1518`. |
| Eina typography | Rendered `@font-face` families are `eina`, `einaSemiBold`, and `einaBold`. Hero: 56px/58.24px with −0.56px tracking; section heading: 40px/41.6px with −0.4px; body: commonly 15px/24px or 17px/25.5px. |
| Soft cards and pills | Feature/review cards use 24px radius; package cards 20px; controls use 360px/999px pills. Repeated spacing is 8px, 16px, and 24px. |
| Restrained elevation | `.redesign-shadows_elevation1___WUEx`: `0 0 8px rgba(144,127,111,.16)`; `.redesign-shadows_elevation2__1u6CJ`: `0 4px 24px -8px rgba(67,67,85,.12)`. |

## Colors

The front-matter colors are the implementation recommendation. `primary`, `page`, `canvas`, `card`, all three text roles, `border-subtle`, `hover`, `positive-fill`, and `secondary` are direct Lassie colors. Dark semantic text colors and categorical colors 2–8 are accessibility adaptations, not published Lassie brand tokens.

Use navy for hierarchy, blue for focus and single-series emphasis, warm cream for the page frame, off-white for the canvas, and white for analytical cards. The categorical palette uses eight approximately 45°-spaced OKLCH hues in AML. Slot 1 is the observed bright Lassie blue (`#3978FF` in the site stylesheet, rounded to the palette's `#3B79FF` fallback); amber, green, pink, and blue families are traceable to Lassie's visible accents. Chroma and lightness are adjusted for marks on white, so the palette is deliberately more saturated and darker than Lassie's pastel marketing panels.

Text contrast on white is 18.36:1 for `text-strong`, 9.67:1 for `text-default`, 6.22:1 for `text-subtle`, and 10.27:1 for `primary`. White on `primary` is 10.27:1. Positive, warning, and negative semantic text are all at least 6.1:1 on white. `border-subtle` is intentionally decorative and only 1.19:1 on white; never use it as the sole focus or selection indicator. Use `focus` for interactive focus, and pair chart/status colors with labels, legends, signs, or icons rather than color alone.

## Typography

Eina is proprietary and the site does not establish reuse rights or a stable public font import for third-party applications. Holistics therefore uses bundled `Inter, Arial, sans-serif`, which preserves Eina's clean geometric tone and avoids missing-font flashes. Use 600 for headings and KPI values, 400 for body and table data, and sentence case. Website negative tracking is reserved for large marketing headings; small analytical labels remain at normal tracking for readability.

## Layout

Use a comfortable 8px rhythm: 8px within tight groups, 16px card padding, 24px between related regions, and 32px between major dashboard sections. Keep dashboard grids and existing block positions unchanged. The theme applies equally to the internal growth page and the scoped owner portal; it does not alter mobile flow or the established KPI → trend → metric sheet → detail → Sankey order.

## Elevation & Depth

Use a warm page, a slightly lighter canvas, and white cards. Separate cards with Holistics' `sm` shadow rather than a strong outline, matching Lassie's restrained elevation. Tables use quiet cool hairlines. Avoid layered shadows and marketing gradients inside analytical surfaces.

## Shapes

Use 20px for canvases and cards, reflecting Lassie's repeated 20–24px card radii while staying within the Holistics theme scale. Reserve pills for native filters, short statuses, and controls; do not turn charts or large table regions into capsules.

## Components

- Cards: white, 20px radius, 16px padding, `sm` shadow, navy headings, and muted body copy.
- Tables and metric sheets: cream header, off-white banding, pale-blue hover, dark text, quiet grid lines, and 13px data text.
- KPI blocks: left-aligned 48px navy values, 20px muted labels, blue progress indicator, and labeled semantic trend badges.
- Charts: inherit `laasie_palette`. Use the blue first for single-series analysis; preserve legends/direct labels for multi-series charts.
- Text blocks: Inter, muted navy-gray body copy, navy headings, and the same 1.6/1.3 line-height hierarchy as the rendered site.

## Do's and Don'ts

- Do keep the warm cream frame, ink-navy hierarchy, soft white cards, and confident blue focus.
- Do keep text at WCAG AA contrast and add non-color cues to trends and chart series.
- Do preserve both dashboards' datasets, permissions, content, and layout.
- Don't import or claim Eina without a verified licence and hosting contract.
- Don't treat the engineered chart palette or semantic dark colors as observed Lassie brand standards.
- Don't use pastel accents for small text or data marks on white; they do not provide enough contrast.

### Risks and unknowns

Lassie publishes no analytics-specific palette, dashboard examples, or official brand guideline on the inspected source. Eina's licence and cross-origin reuse are unverified. Build-hashed stylesheet URLs can change, so selectors and computed values are the durable evidence; re-check the homepage before future brand refreshes.
