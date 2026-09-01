# Dabble dashboards

**Inherit first:** read `clients/dabble/AGENTS.md` before anything in this file. It
carries the persona, the three audiences, the QuickSight frustrations the PoC answers,
the stack, the turnover / gross win / margin vocabulary, the measurement
non-negotiables, and the `settings/ai/context.aml` prompt rule. Everything below is
additional, dashboard-specific context only.

## Scope of this folder

- `dabble_au_trading.page.aml` and `dabble_au_trading_after.page.aml` — the AU trading
  performance dashboards. `..._after.page.aml` is the reworked version; check
  `../docs/dabble_au_trading_after_audit.md` before changing either.
- `dabble_au_trading_board_pack.page.aml` — the single-page Executive Board Pack for the
  quarterly board / commercial review. It owns the turnover-to-net-revenue chain, the
  cost-chain leak, net revenue drag by sport and state, and an explicit data-confidence
  statement. It deliberately does **not** duplicate the command centre's operating cadence,
  and it uses the settled-date lens only — do not add an event-date filter to it.
- `dabble_competition_cards.chart.aml`, `dabble_sport_quadrant.chart.aml`,
  `dabble_pnl_waterfall.chart.aml` — reusable charts consumed by those pages. Changing one
  affects every page that references it.
- Custom-chart templates: `@{fields.x.name}` interpolates as a **quoted JSON string**, so it
  may only appear where the Vega-Lite spec wants a field-name value. It cannot be embedded in
  a `calculate` expression string. `dabble_pnl_waterfall.chart.aml` shows the workaround —
  chain single-field `fold` transforms to rename runtime fields to template-controlled names
  first, then reference those names in `calculate`.
- All blocks read the `dabble_trading` dataset. Push new metric logic into the dataset
  or metric definitions, not into per-widget expressions, so the semantic layer stays
  the single source of truth — that is the point of the PoC.

## Design and layout

- Apply `dabble.theme.aml`; take colours from `../design.md` tokens rather than
  hardcoding hex values.
- Read `../docs/dabble_dashboard_context.md` for which tab owns which question, and
  preserve that information architecture unless the user changes scope.
- Executive-facing pages: clarity and fast decision-making over density. Label every
  number with its date lens, and never show a margin without the turnover behind it.
- Give every dashboard filter an explicit default, and size text and KPI blocks so
  nothing is cramped or truncated.

## Acceptance

- After edits, inspect the dashboard in Demo4 Development, then verify Reporting.
  Completion means every block renders, filters propagate, and there are no loading or
  query errors.
- Renaming a dashboard, page or block label is the highest-risk edit here: the
  tenant-wide AI context now routes by the underlying `dabble_*` model set, but labels
  still shape what users ask and what the semantic layer exposes. Flag any rename to the
  operator per `clients/dabble/AGENTS.md`.
