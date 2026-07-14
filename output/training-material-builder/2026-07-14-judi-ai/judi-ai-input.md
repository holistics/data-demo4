# Judi.ai — Training Material Builder — Input Log

## Original Request
Build an **end-user training guide** for Judi.ai so their business users can learn to use
Holistics on their own datasets and dashboards. Scope chosen:
- **Deliverables:** content package (markdown) **+ branded HTML learning pages & decks** (no video clips).
- **Roles:** **Customer Success** (treated as *consumers who also build reports* — their track goes
  past "consume" into explore/build/share) and **Analysts / champions (Niina)** (deep power-user track).
- **Source of truth:** the customer's live Holistics project, read via `holistics mcp --live`
  (authenticated as niina.johansson@judi.ai, US server).

## Source of truth (verified 2026-07-14)
- Dataset: **`test_v3` — "Judi Dataset"** (tag: Endorsed). Not `test` / `test_v2` (both Archived).
- 20 models, 34 measures, 20 relationships. Data source `dw_test` (SQL Server).
- Single-tenant trial: data hard-scoped to one domain (vancity).
- Grain corrected in v3; `applications_current_decision` measure added for the superseded-decision
  fan-out; policy→gate joins corrected; geography read off `address.state_or_province_code`.

## Discussion Log
- 2026-07-14 — *clarification*: CS users **also create reports**, so the CS track includes creator
  skills (explore, save to personal workspace, share), not only consumer skills.
- 2026-07-14 — *clarification*: screenshots to be sourced from the **real product** via the user's
  own logged-in Chrome (CDP); assistant never enters credentials. Data is real (vancity) → PII gate
  applies before any asset is shared.
- 2026-07-14 — *decision*: build the markdown content package first (durable), then the HTML pages.

## Dropped from Scope
- In-product **video clips** (deferred; not in this pass).
- `test` / `test_v2` datasets (archived; not used).

## Requirements Summary (v01)
Content package (README, facilitator guide, metrics glossary, CS track, champions track,
capability→Judi map, hands-on labs) grounded 100% in `test_v3`, plus branded HTML learning pages +
decks + a universal cheatsheet. Screenshots pending the user's logged-in capture session.
