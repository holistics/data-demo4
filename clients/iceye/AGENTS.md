# ICEYE — client demo

Read `clients/AGENTS.md` first for the client-folder baseline.

Two dashboards, on **two different datasets**:

- `ICEYE_finance_dashboard.page.aml` — reads `demo_finance` and `demo_finance_extended`.
  This is why ICEYE sits at top level rather than in `branded-themes/`.
- `ICEYE_demo_dashboard.page.aml` — reads the core `demo_ecommerce_version_2` dataset,
  so it is effectively a branded re-skin.

Both stay together here to keep the client's assets in one place. Do not split the
ecommerce one into `branded-themes/` — grouping by client wins over grouping by dataset.

Related material outside this folder: `02 demo (specific use-case)/demo iceye finance/`.
Check it before changing finance logic.

## Working here

- **Know which dataset you are in.** The two dashboards are not interchangeable: finance
  vocabulary does not apply to the ecommerce page and vice versa. Never write a metric
  that spans both.
- Both datasets are shared demo assets, not ICEYE's own. This folder is a **read-only
  consumer** of them — never edit `demo_finance*` or `demo_ecommerce_version_2` to suit
  ICEYE. If it needs its own numbers, that is a scope change for the operator.
- Adding a third file? Filenames use the `ICEYE_` prefix; keep it consistent.

## AI context

ICEYE has no routing block in `settings/ai/context.aml`. The ecommerce page is covered
by the default business context there, but **the finance dashboard is not** — Holistics
AI would narrate it with marketplace vocabulary (GMV / NMV / commission), which is
wrong for finance data. If anyone will ask the AI about the finance dashboard, raise that
gap with the operator per `clients/AGENTS.md`.

## Completion

`holistics aml validate "clients/iceye/"*.aml`, then confirm both dashboards render.
