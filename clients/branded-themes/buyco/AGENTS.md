# BuyCo — branded demo

Read `clients/AGENTS.md` and `clients/branded-themes/AGENTS.md` first.

A **theme/branding demo**, not a separate data stack: three re-skins of the core
ecommerce demo (`buyco_demo_dashboard_light` / `_dark` / `_midnight`) built to show the
same numbers under a prospect's visual identity.

- Themes `themes/buyco_{light,dark,midnight}.theme.aml`; header blocks
  `blocks/buyco_header_{light,dark,midnight}.block.aml`.
- **Data comes from the shared core dataset `demo_ecommerce_version_2`.** This folder is
  a *read-only consumer* of it — never edit that dataset, the `ecommerce_*` models or
  anything in `01 demo ecommerce/` to suit BuyCo. If BuyCo needs different data, that is
  a scope change to raise with the operator.
- Keep the three variants in sync: a layout or metric change to one usually belongs in
  all three. Say which variants you changed.
- BuyCo has no routing block in `settings/ai/context.aml`, and needs none while it
  reuses the ecommerce dataset — the default ecommerce business context already applies.
  If BuyCo ever gets its own models or vocabulary, ask the operator about adding a route.
- After edits: `holistics aml validate "clients/branded-themes/buyco/"**/*.aml`, then
  confirm all three variants render.
