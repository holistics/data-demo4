# FanServ demos

Read `clients/AGENTS.md` first for the client-folder baseline.

This folder contains two separate FanServ demonstrations:

- `stadium/` archives the legacy dark-first, finance-backed Stadium POC using the
  shared `demo_finance_extended` dataset. Its AML objects are grouped under
  `stadium/dashboards/` and `stadium/themes/`.
- `game-calendar/` is a CSV-backed Game Calendar / Season Board POC. Read
  `game-calendar/AGENTS.md` before changing its models, datasets, dashboards, data,
  presentation, or documentation.

- The legacy Stadium theme is `stadium/themes/fanserv.theme.aml`; design tokens are
  documented in `design.md`.
- Treat `demo_finance_extended` as read-only. Never change it or its models to suit
  the Stadium demo; raise different data needs as a scope change.
- No routing block in `settings/ai/context.aml`. Because FanServ reads the finance
  dataset rather than the ecommerce one, the default ecommerce business context in
  `context.aml` does **not** describe the Stadium demo. Neither current demo uses
  Holistics AI; leave `settings/ai/context.aml` unchanged unless the operator approves
  tenant-wide routing work.
- After Stadium AML edits, validate
  `clients/fanserv/stadium/themes/*.aml clients/fanserv/stadium/dashboards/*.aml`,
  then confirm the dashboard renders.
