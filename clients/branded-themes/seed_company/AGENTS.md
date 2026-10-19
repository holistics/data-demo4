# Seed Company — branded demo

Read `clients/AGENTS.md` and `clients/branded-themes/AGENTS.md` first.

A **theme/branding demo**, not a separate data stack: `seed_company_demo_dashboard`
("Seed Company — Portfolio Overview (Sample)") re-skins the core ecommerce demo under a
prospect's visual identity.

- Theme `themes/seed_company.theme.aml`; templated blocks
  `blocks/seed_company_header.block.tpl.aml` and `..._footer.block.tpl.aml`. These are
  `.tpl` templates — check their parameters before editing, and confirm no other folder
  reuses them.
- **Data comes from the shared core dataset `demo_ecommerce_version_2`.** This folder is
  a *read-only consumer* of it — never edit that dataset, the `ecommerce_*` models or
  anything in `01 demo ecommerce/` to suit Seed Company. If it needs different data, that
  is a scope change to raise with the operator.
- The dashboard title says "(Sample)". Keep that qualifier — the numbers are the generic
  demo dataset, not Seed Company's own.
- No routing block in `settings/ai/context.aml`, and none needed while it reuses the
  ecommerce dataset — the default ecommerce business context already applies. If it gains
  its own models or vocabulary, ask the operator about adding a route.
- After edits: `holistics aml validate "clients/branded-themes/seed_company/"**/*.aml`,
  then confirm the dashboard renders.
