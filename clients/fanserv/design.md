---
version: alpha
name: FanServ Stadium
description: Visual identity and Holistics dashboard theme for fanserv.com.
colors:
  primary: "#009247"
  primaryDark: "#045C30"
  accent: "#00E66F"
  pageDark: "#000000"
  canvasDark: "#0A0A0A"
  cardDark: "#111111"
  cardDarkAlt: "#1A1A1A"
  borderDark: "#1F1F1F"
  borderDarkStrong: "#2A2A2A"
  textOnDark: "#FAFAFA"
  mutedOnDark: "#A6A6A6"
  subtleOnDark: "#6F6F6F"
  pageLight: "#F3F8F5"
  canvasLight: "#FFFFFF"
  cardLight: "#FFFFFF"
  cardLightAlt: "#F7FBF8"
  borderLight: "#DCEBE3"
  borderLightStrong: "#BFD8CA"
  textOnLight: "#06140D"
  mutedOnLight: "#4B6356"
  subtleOnLight: "#6C7F74"
  success: "#00A85A"
  warning: "#F59E0B"
  danger: "#EF4444"
  info: "#38BDF8"
  neutral: "#A6A6A6"
typography:
  display:
    fontFamily: Inter, Manrope, -apple-system, system-ui, Segoe UI, Roboto, sans-serif
    fontSize: 30px
    fontWeight: 800
    lineHeight: 1.1
    letterSpacing: -0.04em
  heading:
    fontFamily: Inter, Manrope, -apple-system, system-ui, Segoe UI, Roboto, sans-serif
    fontSize: 24px
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: -0.03em
  body:
    fontFamily: Inter, Manrope, -apple-system, system-ui, Segoe UI, Roboto, sans-serif
    fontSize: 13px
    fontWeight: 400
    lineHeight: 1.5
  labelCaps:
    fontFamily: Inter, Manrope, -apple-system, system-ui, Segoe UI, Roboto, sans-serif
    fontSize: 12px
    fontWeight: 600
    lineHeight: 1.2
    letterSpacing: 0.06em
  kpiValue:
    fontFamily: Inter, Manrope, -apple-system, system-ui, Segoe UI, Roboto, sans-serif
    fontSize: 32px
    fontWeight: 800
    lineHeight: 1.1
rounded:
  sm: 8px
  md: 12px
  pill: 999px
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
components:
  canvasDark:
    backgroundColor: "{colors.canvasDark}"
    textColor: "{colors.textOnDark}"
    rounded: "{rounded.md}"
    padding: "{spacing.lg}"
  canvasLight:
    backgroundColor: "{colors.canvasLight}"
    textColor: "{colors.textOnLight}"
    rounded: "{rounded.md}"
    padding: "{spacing.lg}"
  cardDark:
    backgroundColor: "{colors.cardDark}"
    textColor: "{colors.textOnDark}"
    rounded: "{rounded.md}"
    padding: "{spacing.md}"
  cardLight:
    backgroundColor: "{colors.cardLight}"
    textColor: "{colors.textOnLight}"
    rounded: "{rounded.md}"
    padding: "{spacing.md}"
  kpiCard:
    backgroundColor: "{colors.cardLight}"
    textColor: "{colors.textOnLight}"
    typography: "{typography.kpiValue}"
    rounded: "{rounded.md}"
    padding: "{spacing.md}"
  liveChip:
    backgroundColor: "#EAF7F1"
    textColor: "{colors.primaryDark}"
    typography: "{typography.labelCaps}"
    rounded: "{rounded.pill}"
    padding: "4px 10px"
---

## Overview

FanServ Stadium is a sports-media analytics identity for Holistics dashboards. It turns FanServ's public landing-page language — “Stadium”, “Scout AI”, “Live”, “The Playbook”, and “game day” — into a production dashboard system that feels operational, confident, and customer-facing.

The source of truth is the public FanServ website rather than a separate brand-guidelines document. Sources used:

- FanServ public landing page: https://fanserv.com/
- FanServ Stadium launch press page: https://www.fanserv.com/press/fanserv-launches-stadium-platform
- Browser inspection of `fanserv.com` on 2026-07-08, including computed colors, typography, assets, and the saved screenshot at `.amp/in/artifacts/fanserv-home-viewport-small.png`.

The original brand read is dark, high-contrast, and broadcast-like: black surfaces, white copy, bright stadium green, compact live chips, glassy cards, and sports operations language. The current dashboard applies the light variant for executive readability while preserving FanServ green, live status, and stadium-card structure.

## Colors

FanServ green `#009247` is the primary brand color. `#045C30` is the deep green used for readable text, borders, and restrained emphasis. `#00E66F` is the dark-theme live accent and should be used sparingly for active states, glows, and high-contrast highlights.

### Dark surface system

Use the dark system when the dashboard should feel like a sports control room or broadcast operations surface.

| Role | Token | Value |
| --- | --- | --- |
| Page | `pageDark` | `#000000` |
| Canvas | `canvasDark` | `#0A0A0A` |
| Card | `cardDark` | `#111111` |
| Alternate card/table band | `cardDarkAlt` | `#1A1A1A` |
| Border | `borderDark` | `#1F1F1F` |
| Strong border/grid | `borderDarkStrong` | `#2A2A2A` |
| Primary text | `textOnDark` | `#FAFAFA` |
| Muted text | `mutedOnDark` | `#A6A6A6` |

### Light surface system

Use the light system for executive dashboards and review sessions where readability is more important than immersion.

| Role | Token | Value |
| --- | --- | --- |
| Page | `pageLight` | `#F3F8F5` |
| Canvas | `canvasLight` | `#FFFFFF` |
| Card | `cardLight` | `#FFFFFF` |
| Alternate card/table band | `cardLightAlt` | `#F7FBF8` |
| Border | `borderLight` | `#DCEBE3` |
| Strong border/grid | `borderLightStrong` | `#BFD8CA` |
| Primary text | `textOnLight` | `#06140D` |
| Muted text | `mutedOnLight` | `#4B6356` |

### Semantic colors

| Semantic | Token | Value | Use |
| --- | --- | --- | --- |
| Success | `success` | `#00A85A` | Positive KPI movement, success states |
| Warning | `warning` | `#F59E0B` | Attention, pacing risk, incomplete work |
| Danger | `danger` | `#EF4444` | Negative KPI movement, errors, missed targets |
| Info | `info` | `#38BDF8` | Neutral information and links |
| Neutral | `neutral` | `#A6A6A6` | Secondary annotations and low-emphasis chart marks |

### Chart palettes

Holistics currently documents AML `ColorPalette` support for categorical palettes only. The reusable theme file encodes the categorical palette in AML. Sequential and diverging palettes are design guidance for heatmaps, conditional formatting, custom charts, and future palette-as-code support.

Categorical:

```text
#009247  FanServ green
#00E66F  Live accent
#38BDF8  Broadcast/info blue
#2563EB  Playbook blue
#F59E0B  Warning amber
#F97316  Game-day orange
#EF4444  Danger red
#A855F7  Highlight violet
#14B8A6  Teal
#A6A6A6  Neutral gray
```

Sequential:

```text
#07120C  Lowest / no activity
#0A2417
#0B3A24
#045C30
#009247  Brand midpoint
#00B85A
#00E66F  Highest / live peak
#C8FFE0  Optional highlight endpoint
```

Diverging:

```text
#7F1D1D  Strong negative
#DC2626
#F97316  Mild negative / warming
#2A2A2A  Neutral on dark surfaces
#0F766E  Mild positive
#009247
#00E66F  Strong positive
```

## Typography

Use the landing-page stack across all dashboard text:

```css
Inter, Manrope, -apple-system, system-ui, "Segoe UI", Roboto, sans-serif
```

- Display titles use `display`: 30px, 800 weight, tight tracking.
- Section headings use `heading`: 24px, 700 weight, tight tracking.
- Body and helper copy use `body`: 13px, regular weight, 1.5 line height.
- KPI labels and live chips use `labelCaps`: uppercase, 12px, 600 weight, 0.06em tracking.
- KPI values use `kpiValue`: 32px, 800 weight, center-aligned in the dashboard theme.

## Layout

The dashboard layout should feel like a stadium control panel: a strong hero band at the top, a row of centered KPI scorecards, then paired analysis panels below.

- Use a 1440px-wide canvas for desktop review.
- Use generous horizontal spacing so the dashboard feels premium rather than dense.
- Keep the hero/header short enough that KPIs are visible above the fold.
- Put global filters in the hero band, right-aligned, so they feel like operational controls.
- Use paired 50/50 analysis panels for comparable chart groups, such as revenue playbook and cost control.
- Prefer center alignment for KPI cards and live-status chips.

The current Holistics implementation is standalone AML content in `clients/fanserv/fanserv_demo_dashboard.page.aml`: hero/header blocks, date filter, KPI cards, trend charts, expense mix chart, monthly detail table, layout, interactions, and settings. It uses `theme: fanserv_stadium_light`.

## Elevation & Depth

Depth should be subtle. FanServ should feel polished and operational, not decorative.

- Dark theme: use near-black cards with a low-opacity top highlight and green radial glow in the page/canvas background.
- Light theme: use white cards, pale green borders, and soft shadows.
- Use one-pixel borders for most separation; avoid heavy outlines.
- Reserve glow for live/active elements, not every card.
- Avoid stacking too many shadows. One card layer plus one canvas layer is enough.

## Shapes

Shapes should be simple and modern.

- Cards: 12px radius.
- Tables and filter containers: 12px radius when they are card-like, 8px when compact.
- Live chip: pill radius (`999px`).
- Avoid sharp-corner hero surfaces; they break the Stadium product feel.
- Avoid overly rounded cards beyond 16px; they feel playful rather than enterprise-ready.

## Components

### Holistics theme assets

- Reusable AML theme file: `clients/fanserv/fanserv.theme.aml`
- Dark theme identifier: `fanserv_stadium`
- Light theme identifier: `fanserv_stadium_light`
- AML chart palette identifier: `fanserv_categorical_palette`
- Applied dashboard: `clients/fanserv/fanserv_demo_dashboard.page.aml`

### KPI cards

KPI cards are center-aligned scorecards. Use uppercase muted labels, large values, and semantic trend chips. Do not rely on color alone for direction; preserve signs, arrows, or labels when available.

### Live chip

The live chip communicates real-time Stadium status. It uses the `liveChip` component tokens and embeds a small `data:image/gif` ping indicator that pulses every 5 seconds. This is intentionally embedded in the dashboard block so it remains visible even if dashboard markdown does not render pseudo-elements from theme CSS.

### Tables

Tables are operational detail surfaces. Use low-contrast grid lines, subtle banding, and green hover states. In light mode, table headers should be pale green with deep green text. In dark mode, table headers should use deep green with white text.

### Filters

Filters should look like control inputs, not plain form fields. Use green focus rings, compact labels, and card-level grouping when filters appear in hero/header areas.

## Do's and Don'ts

Do:

- Use `#009247` as the brand anchor and `#045C30` when green needs to be readable on light backgrounds.
- Use `#00E66F` for dark-theme live accents and active glows.
- Keep dashboard copy direct and operational.
- Use sports language sparingly: “Stadium”, “Playbook”, “Live”, and “game day” are useful accents, not a substitute for analytical labels.
- Keep KPI cards center-aligned.
- Keep the light theme as the current applied dashboard theme for executive readability.

Don't:

- Do not use `#009247` for small text on dark backgrounds; use `#00E66F` or white text instead.
- Do not encode KPI direction by color alone.
- Do not introduce extra brand colors beyond green, blue, amber, red, violet, teal, and neutral unless there is a chart-series need.
- Do not overuse glow effects outside live/status affordances.
- Do not duplicate the dashboard just to switch dark/light themes; switch the `theme:` reference unless the content also changes.
