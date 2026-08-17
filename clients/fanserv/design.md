---
version: alpha
name: FanServ Design System
description: FanServ brand and application design contract derived from the FDS Figma folder, with explicit legacy Stadium implementation fallbacks.
colors:
  brandPrimary: "#009247"
  stadiumLive: "#00E66F"
  primaryLighter: "#C8FACD"
  primaryLight: "#5BE584"
  primary: "#00AB55"
  primaryDark: "#007B55"
  primaryDarker: "#005249"
  secondaryLighter: "#D6E4FF"
  secondaryLight: "#84A9FF"
  secondary: "#3366FF"
  secondaryDark: "#1939B7"
  secondaryDarker: "#091A7A"
  infoLighter: "#CAFDF5"
  infoLight: "#61F3F3"
  info: "#00B8D9"
  infoDark: "#006C9C"
  infoDarker: "#003768"
  successLighter: "#D8FBDE"
  successLight: "#86E8AB"
  success: "#36B37E"
  successDark: "#1B806A"
  successDarker: "#0A5554"
  warningLighter: "#FFF5CC"
  warningLight: "#FFD666"
  warning: "#FFAB00"
  warningDark: "#B76E00"
  warningDarker: "#7A4100"
  errorLighter: "#FFE9D5"
  errorLight: "#FFAC82"
  error: "#FF5630"
  errorDark: "#B71D18"
  errorDarker: "#7A0916"
  grey0: "#FFFFFF"
  grey100: "#F9FAFB"
  grey200: "#F4F6F8"
  grey300: "#DFE3E8"
  grey400: "#C4CDD5"
  grey500: "#919EAB"
  grey600: "#637381"
  grey700: "#454F5B"
  grey800: "#212B36"
  grey900: "#161C24"
  black: "#000000"
  white: "#FFFFFF"
  textPrimary: "#212B36"
  textSecondary: "#637381"
  textDisabled: "#919EAB"
  backgroundPaper: "#FFFFFF"
  backgroundDefault: "#FFFFFF"
  backgroundNeutral: "#F4F6F8"
  divider: "rgba(145, 158, 171, 0.24)"
  actionActive: "#637381"
  actionHover: "rgba(145, 158, 171, 0.08)"
  actionSelected: "rgba(145, 158, 171, 0.16)"
  actionDisabled: "rgba(145, 158, 171, 0.80)"
  actionDisabledBackground: "rgba(145, 158, 171, 0.24)"
  actionFocus: "rgba(145, 158, 171, 0.24)"
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
  label:
    fontFamily: Inter, Manrope, -apple-system, system-ui, Segoe UI, Roboto, sans-serif
    fontSize: 12px
    fontWeight: 600
    lineHeight: 1.2
rounded:
  xs: 4px
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
  primaryButton:
    backgroundColor: "{colors.primaryDarker}"
    textColor: "{colors.white}"
    typography: "{typography.label}"
    rounded: "{rounded.sm}"
    padding: "8px 16px"
  card:
    backgroundColor: "{colors.backgroundPaper}"
    textColor: "{colors.textPrimary}"
    rounded: "{rounded.md}"
    padding: "{spacing.md}"
  statusLabel:
    backgroundColor: "{colors.backgroundNeutral}"
    textColor: "{colors.textSecondary}"
    typography: "{typography.label}"
    rounded: "{rounded.xs}"
    padding: "4px 8px"
  chip:
    backgroundColor: "{colors.backgroundNeutral}"
    textColor: "{colors.textPrimary}"
    typography: "{typography.label}"
    rounded: "{rounded.pill}"
    padding: "4px 10px"
  input:
    backgroundColor: "{colors.backgroundPaper}"
    textColor: "{colors.textPrimary}"
    rounded: "{rounded.sm}"
    padding: "8px 12px"
---

## Overview

FanServ combines an energetic sports-media brand with a practical advertising-platform UI. The brand layer uses a bold, italic, uppercase `FANSERV` wordmark and an angular upward-check `V` mark. The application layer uses light surfaces, dark readable text, semantic color families, compact controls, and reusable operational components.

This contract was rebuilt from every file in the shared Figma folder `FDS - FanServ Design System` on 2026-08-11:

| Figma file | Evidence used |
| --- | --- |
| `FDS - Web Components` | Buttons, cards, chips and labels, dropdowns, uploads, inputs, forms, modals, navigation, panels, tables, tabs, tooltips, and product patterns |
| `FDS - Color` | Exact primitive, semantic, text, background, divider, and action color values from the embedded normalized token JSON and `palette.ts` |
| `FDS - Infrastructure` | Page headers, designer notes, and Experimental/Stable lifecycle tags |
| `FDS - Branding` | FanServ, Stadium, vendor, league, and team marks; banner/footer background shapes |
| `FDS - Archive & Construction` | Non-normative WIP and construction artifacts only |
| `FDS - Icons` | Font Awesome 5/6 component method and the custom Scout icon |
| `FDS - Sizing, Effects, etc.` | `Shadow/Light/Card`; no numeric shadow specification was visible |
| `FDS - Typography` | File and page inspected; no readable type specification was present on the canvas |

Evidence precedence is:

1. exact FDS tokens and published components;
2. FDS visual examples and lifecycle labels;
3. the existing FanServ public-brand and Holistics implementation only where FDS is silent.

The legacy `stadium/themes/fanserv.theme.aml` predates this Figma-derived contract. It implements the darker Stadium demo with public-brand green `#009247`, live green `#00E66F`, and the Inter/Manrope stack. Keep those values for that existing dashboard until its theme is deliberately migrated; use the FDS application tokens for new product-like surfaces.

## Colors

### Brand and application greens

Do not collapse the two confirmed green roles:

- `brandPrimary` (`#009247`) identifies the public FanServ brand and the existing Stadium dashboard.
- `primary` (`#00AB55`) is the exact FDS application primary from `palette.ts`.
- `stadiumLive` (`#00E66F`) remains a legacy dark-dashboard live accent, not an FDS semantic token.

Use the complete lighter-to-darker primary family for hover, selected, and emphasis states. The source palette specifies white `contrastText` on primary, secondary, info, success, and error backgrounds, but `primary` with white reaches only 3.02:1 contrast. Use `primaryDarker` for white-labelled buttons or use dark text on `primary`. Warning uses `grey800` for contrast.

### Neutral and surface system

FDS is light-first. Use white for the page and paper surfaces, `grey200` for neutral backgrounds, `grey800` for primary text, `grey600` for secondary text, and `grey500` for disabled text. Use `divider` for low-emphasis separation rather than inventing another border gray.

Action colors are alpha variants of `grey500`:

| State | Token | Value |
| --- | --- | --- |
| Hover | `actionHover` | `rgba(145, 158, 171, 0.08)` |
| Selected | `actionSelected` | `rgba(145, 158, 171, 0.16)` |
| Focus | `actionFocus` | `rgba(145, 158, 171, 0.24)` |
| Disabled background | `actionDisabledBackground` | `rgba(145, 158, 171, 0.24)` |
| Disabled foreground | `actionDisabled` | `rgba(145, 158, 171, 0.80)` |

### Status and data color

Use semantic families consistently:

- Green: active, completed, published, and successful outcomes.
- Red: error and rejected states.
- Blue: draft and informational states.
- Amber: warning or attention states.
- Gray: paused, archived, disabled, and neutral states.

Always pair status color with a label or icon. FDS shows solid, light-tint, and outlined status-label variants.

For categorical charts, start with `primary`, `secondary`, `info`, `warning`, `error`, `success`, then darker family members when more distinction is needed. Do not use ordered semantic shades as a categorical palette when adjacent series would be hard to distinguish.

For sequential charts, use one semantic family from lighter to darker. For diverging charts, use `error` through `grey200` to `success`. Verify text, marks, and legends against their actual dashboard background.

## Typography

The FDS Typography file was inspected, but its Typography page did not expose readable specimens, names, sizes, or weights. Therefore the typography tokens above preserve the current implemented Inter/Manrope fallback; they are not claimed as exported FDS typography values.

- Use sentence or title case for product controls and button labels.
- Use uppercase labels only for compact statuses, section markers, and the expressive brand wordmark.
- Keep dashboard body text at 13px or larger.
- Use weight and spacing before adding more colors to establish hierarchy.
- Treat the bold italic uppercase treatment as brand display language, not general body typography.

Replace the fallback tokens only when the FDS type styles or source tokens can be exported and verified.

## Layout

FDS application layouts are dense, operational, and light-first. Group related controls and data with clear headers rather than adding decorative containers.

- Use the 4/8/16/24/32px fallback spacing scale until exact FDS spacing variables are available.
- Align action groups to the end of forms, modals, cards, and table toolbars.
- Keep labels close to the input or value they describe.
- Use two-column label/value grids for compact campaign and IO information cards.
- Give large-number cards one clear brand or entity anchor followed by a small set of prominent metrics.
- Build tables from explicit toolbar, header, cell, row-count, pagination, helper-text, filter-button, and empty-state regions.
- Keep the Game Calendar denser than the Stadium executive dashboard; its separate Season Board contract controls its structure and hierarchy.

## Elevation & Depth

FDS documents a single `Shadow/Light/Card` asset, but the file does not expose numeric offset, blur, spread, or opacity values. Use a restrained light-surface card shadow and a one-pixel divider until exact effect variables are available.

- Use one elevation layer for cards, menus, and modal surfaces.
- Prefer borders and neutral background changes for routine grouping.
- Do not add glow to FDS light surfaces.
- The dark Stadium demo may retain its existing green live glow as a deliberate legacy treatment.

## Shapes

- Buttons, inputs, selects, cards, and labels use modest corner rounding rather than full pills.
- Team, overflow, creative, and sync-status chips use pill geometry.
- Banner and footer artwork uses broad green organic waves over charcoal, with a darker green inner edge for depth.
- Brand marks use sharp, forward-moving angles; the final `V` reads as an upward check or arrow.
- Use square tab indicators where the FDS comment history explicitly replaces circular ones.

The radius tokens are implementation fallbacks inferred from the current theme and visible examples; they are not exported FDS dimensions.

## Components

### Buttons

Use filled buttons for primary actions such as Save and Save and Continue. Use text or ghost buttons for Cancel. Buttons are title case, compact, and modestly rounded. Keep the click area visible; the FDS WIP notes favor a neutral default background over an invisible hit area.

### Cards

Confirmed card families include `FDS-campaignInfoCard`, `FDS-IOInfoCard`, and `FDS-campaignBigNumbersCard`. Use a clear header, a white body, restrained shadow, and compact data hierarchy. Treat frames explicitly labeled `WIPs` as non-normative.

### Chips and labels

Confirmed families include `FDS-creativeChip`, `FDS-teamChip`, `FDS-overflowChip`, `FDS-syncStatusChips`, and grouped Time/Spend/Risk chips. Keep labels compact with modest radii; reserve pills for chips. `FDS-teamChip` and `FDS-syncStatusChips` were visibly marked WIP or Experimental and require confirmation before production reuse.

Current documented statuses include Draft, Published, Paused, Archived, Error, Active, Completed, Rejected, and Canceled. Do not reintroduce Pending, Synced, or Failed merely because older screenshots show them; the Figma comment history records their removal.

### Inputs and forms

FDS covers radio buttons, checkboxes, text inputs, single-selects, large radio buttons, date selection, switches, and toggles. Use rounded rectangular controls and explicit focus/error states. Error text appears above helper text when both are present. The switch/toggle area is marked WIP.

### Tables

Compose tables from the named FDS parts: `FDS-tableToolbar`, `FDS-tableHeader`, `FDS-tableCell`, `FDS-tableFiltersButton`, `FDS-betterHelperText`, `FDS-emptyState`, `FDS-rowCount`, and `FDS-pagination`. Preserve readable density and a complete empty state. Do not treat the `WIP Table Exampels` frame as a final specification.

### Icons

Use the documented Font Awesome 6 component first; Font Awesome 5 remains available for legacy use. The component supports style swaps, padding, scale, and icon-name properties. Duotone icons use separate primary and secondary layers. Use the custom solid Scout icon only for Scout-specific product meaning.

### Infrastructure and lifecycle

Use dark-green section headers with white text for design-system documentation. Designer notes use a clearly separate annotation treatment. Mark incomplete components Experimental and reviewed components Stable; never present Archive & Construction artifacts as current standards.

### Holistics implementation

- Legacy theme file: `clients/fanserv/stadium/themes/fanserv.theme.aml`
- Existing dark theme: `fanserv_stadium`
- Existing light theme: `fanserv_stadium_light`
- Existing chart palette: `fanserv_categorical_palette`
- Legacy Stadium dashboard: `clients/fanserv/stadium/dashboards/fanserv_demo_dashboard.page.aml`
- Game Calendar assets: `clients/fanserv/game-calendar/`

The AML themes still implement the earlier Stadium visual identity. Do not claim FDS conformance until their colors, components, and typography have been deliberately mapped and visually verified.

## Do's and Don'ts

Do:

- Use exact FDS color values from the token block for new product-like UI.
- Keep `brandPrimary` and FDS `primary` as separate roles.
- Use labels or icons with semantic color.
- Prefer light surfaces, compact controls, and clear operational hierarchy.
- Preserve named component anatomy for cards, forms, and tables.
- Check lifecycle labels and comments before treating a Figma frame as normative.
- Keep the current Stadium theme unchanged until a deliberate migration is approved.

Don't:

- Do not invent FDS typography, spacing, radii, or shadow values that were not visible in the source files.
- Do not use Archive & Construction, WIP, or Experimental artifacts as final standards.
- Do not encode status or KPI direction by color alone.
- Do not use pills for every control; reserve them for chips and compact status affordances.
- Do not use expressive brand italics for body copy or dense data tables.
- Do not claim the current Holistics AML themes are FDS-aligned.
