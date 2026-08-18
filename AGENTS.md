# Demo4 — Holistics sales demo & PoC repo

The AML project behind `demo4.holistics.io`, owned by the Holistics **sales team**
(AEs + solution engineers). It exists to run **demos and PoCs for prospects,
customers and companies** — not to serve production analytics for a real business.

## Default context — ecommerce

**Unless the work clearly belongs to a named client, the default context is the
ecommerce core demo.** `01 demo ecommerce/` is the main demo, shown on the first
call when the prospect has not shared their own database. An asset belongs to it
when the word `ecommerce` appears in its name, label, description or metadata;
cross-check semantics against `settings/ai/context.aml`.

**Before changing anything under `01 demo ecommerce/`, read
[`01 demo ecommerce/docs/core-demo.md`](01%20demo%20ecommerce/docs/core-demo.md).**

## Active client PoC — Dabble

The one client PoC currently wired into tenant-level AI context is **Dabble**
(`clients/dabble/`) — an AU social betting / wagering company across the AU, UK and
US markets, migrating off AWS QuickSight.

- Data source `dabble_neon`, schema `"dabble_demo"."*"`; models `dabble_*`, dataset
  `dabble_trading`, dashboards in `clients/dabble/dashboards/`.
- Vocabulary is turnover / gross win / margin / generosity / net revenue — **not**
  GMV / NMV / commission. The ecommerce business context does not apply.
- Read `clients/dabble/dashboards/AGENTS.md` (audience + design constraints),
  `clients/dabble/design.md` and `clients/dabble/docs/` before editing.
- Runtime AI behaviour is defined by conditional routing in
  `settings/ai/context.aml` plus three Dabble-owned reference skills in
  `clients/dabble/dabble-refrence/`:
  `dabble_trading_context`, `dabble_trading_measurement_rules`,
  `dabble_executive_readout`.

Other folders under `clients/` are demos without tenant-level AI routing; treat them
under the general PoC rules below.

## PoCs for other companies (development mode)

Sales and SEs stand up PoCs for specific companies. A PoC may bring its own models,
datasets, dashboards, themes and even its own data source (e.g. `clients/dabble/`
runs on `dabble_neon`, not `demodb`). PoCs live under `clients/<company>/`,
`04 demo dashboards 2026/<theme>/`, `02 demo (specific use-case)/` or
`team-folders/<person>/`, and **each carries its own `AGENTS.md`** with the rules
for that folder.

Within `clients/`, demos that are **only design + theme on the ecommerce dataset** live
in `clients/branded-themes/`; clients with their own or other data stay at top level.
See `clients/AGENTS.md`.

When working on a PoC:

1. **Read the nearest `AGENTS.md` (and any `README.md`) first** — it overrides this
   file within its scope. `clients/AGENTS.md` is the umbrella for every client folder.
2. **Keep changes inside that folder.** Never touch `01 demo ecommerce/`, shared
   `library/`, `Datasets Library/`, or another client's folder.
3. **Namespace everything** with the company name (`dabble_*`, `Dabble …`).
4. **Use the PoC's own data source.** Do not join prospect data onto `demodb`.
5. **New PoC?** Create the folder with its own `AGENTS.md` stating data source,
   scope boundary, naming prefix and validate command.
6. **Client context in `settings/ai/context.aml`** is global to the tenant, so
   client-specific rules must be conditional routing (see the Dabble block) plus a
   scoped AML skill kept with the client and documented by that client's `AGENTS.md`.
   Never replace the default ecommerce context with a client's.

Prospect data is confidential — no credentials, connection strings or tokens in
files or command output.

## Keep `AGENTS.md` and `context.aml` in sync

`AGENTS.md` steers CLI/coding agents in this repo. `settings/ai/context.aml` steers
Holistics AI at query time. They describe the same tenant, so **they must not drift.**

- **When you edit `AGENTS.md`, update `settings/ai/context.aml` accordingly — and
  vice versa.** Adding a client, renaming a data source, changing which assets are
  the default context, or adding a skill affects both.
- **On every session that edits `AGENTS.md` or adds new AML files, diff the two:**
  does `context.aml` carry business context, client routing blocks, skill
  references or vocabulary rules that `AGENTS.md` does not mention? Does `AGENTS.md`
  name clients, folders or data sources that `context.aml` has no route for?
- **Report differences to the operator; do not silently reconcile them.** When
  running in Holistics BI Development Studio mode, surface the mismatches as a short
  list and ask which side is authoritative — the operator decides whether to align,
  because a `context.aml` edit changes live AI answers for anyone in the tenant.
- **Touching any client folder triggers the same prompt.** Per `clients/AGENTS.md`,
  ask the operator whether client-folder changes belong in `context.aml` before
  finishing, and never edit it as a side effect of client work.
- Nothing in `context.aml` can reference repo files as instructions — the runtime AI
  cannot read the filesystem. Doc paths in it are breadcrumbs for humans and coding
  agents only; anything the AI must act on has to be inline.
- After any `context.aml` edit: `holistics aml validate settings/ai/context.aml`.

## User's rules

- When developing AMQL, use tools from the holistics cli (`holistics mcp ...`)
- SUPER IMPORTANT: everytime, you must run `holistics aml validate` after new/edit AMQL files to validate syntax
