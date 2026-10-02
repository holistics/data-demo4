# FanServ — branded demo

Read `clients/AGENTS.md` first for the client-folder baseline.

A **theme/branding demo** for fanserv.com (stadium / fan services):
`fanserv_demo_dashboard` ("FanServ Stadium Demo Dashboard") re-skins an existing demo
dataset under FanServ's visual identity.

- Theme `stadium/themes/fanserv.theme.aml`; design tokens in `design.md` — take colours from those
  tokens (primary `#009247`, dark-first palette) rather than hardcoding hex values.
- **Data comes from the shared `demo_finance_extended` dataset** — note this is the
  finance demo, *not* the ecommerce core dataset. This folder is a *read-only consumer*:
  never edit that dataset or its models to suit FanServ. If it needs different data, that
  is a scope change to raise with the operator.
- The dashboard is dark-first. Preserve contrast against the near-black canvas when
  adding blocks.
- No routing block in `settings/ai/context.aml`. Because FanServ reads the finance
  dataset rather than the ecommerce one, the default ecommerce business context in
  `context.aml` does **not** describe these numbers — if anyone will ask Holistics AI
  about this dashboard, raise that gap with the operator.
- After edits: `holistics aml validate "clients/fanserv/stadium/"**/*.aml`, then confirm the
  dashboard renders.
