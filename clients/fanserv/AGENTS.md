# FanServ demos

Read `clients/AGENTS.md` first for the client-folder baseline.

This folder contains two separate FanServ demonstrations:

- `fanserv_demo_dashboard` ("FanServ Stadium Demo Dashboard") is a dark-first,
  finance-backed branding demo using the shared `demo_finance_extended` dataset.
- `game-calendar/` is a CSV-backed Game Calendar / Season Board POC. Read
  `game-calendar/AGENTS.md` before changing its data, presentation, or documentation.

- Theme `fanserv.theme.aml`; design tokens in `design.md` — take colours from those
  tokens (primary `#009247`, dark-first palette) rather than hardcoding hex values.
- Treat `demo_finance_extended` as read-only. Never change it or its models to suit
  the Stadium demo; raise different data needs as a scope change.
- No routing block in `settings/ai/context.aml`. Because FanServ reads the finance
  dataset rather than the ecommerce one, the default ecommerce business context in
  `context.aml` does **not** describe the Stadium demo. Neither current demo uses
  Holistics AI; leave `settings/ai/context.aml` unchanged unless the operator approves
  tenant-wide routing work.
- After Stadium AML edits: `holistics aml validate "clients/fanserv/"*.aml`, then
  confirm the dashboard renders.
