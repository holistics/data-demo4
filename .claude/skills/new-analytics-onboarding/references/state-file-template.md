# Engagement state file template

Written to `00-onboarding-state.md` at Phase 0 and updated after every phase. **Any agent
resuming this engagement reads this file first and resumes — never restarts.**

Its job is to make the engagement survive a gap of weeks, a change of person, and a fresh
session with no memory of the last one.

---

```markdown
# Onboarding state — {Company}

**Started:** {date} · **Last updated:** {date} · **Lead:** {name}
**Stakeholder:** {name, role} · **Tenant / env:** {url or branch}
**Domain scope (first pass):** {one domain}
**Starting point:** {greenfield — no datasets / brownfield — {n} datasets existed}
**Project:** {path or repo of the customer's AMQL project} · **Data source:** {name}

## The question that defines success
> {The single business question the stakeholder most wants answered, verbatim from Phase 0.
> This becomes verification question #1. Do not paraphrase it.}

## Phase status
| # | Phase | Skill | Status | Artifact | Gate met? |
|---|---|---|---|---|---|
| 0 | Scope & access | new-analytics-onboarding | | 00-onboarding-state.md | |
| 1 | Scaffold semantic layer | scaffold-semantic-layer | | 01-semantic-layer.md | |
| 2 | Profile warehouse | profile-warehouse | | 02-data-inventory.md | |
| 3 | Interview | interview-business-context | | 03-business-context-raw.md | |
| 4 | Metric tree | define-metric-tree | | 04-metric-tree.md | |
| 5 | Route & emit | route-context-artifacts | | 05-routing-map.md, emit/ | |
| 6 | Verify | verify-ai-context | | 06-verification-report.md | |
| 7 | Handoff | new-analytics-onboarding | | 07-handoff.md | |

Status values: `not started` · `in progress` · `blocked` · `complete` · `revisiting`

## Access
- Holistics MCP: {configured / not configured}
- AMQL toolchain: {`holistics aml validate` available? `sync-code` wired?}
- Warehouse read: {live / branch / supplied DDL only}
- `list_datasets` at Phase 0: {empty → greenfield / {n} datasets → brownfield}
- **Degradations:** {e.g. "no sample data — test rows, soft deletes, and currency
  mislabelling will not have been caught in Phase 2"}

## Existing customer material
{Any context doc, metrics glossary, dashboard, or spreadsheet they already have — with a
path. An existing context doc is the richest input to Phase 5.}

## Customer project docs
- `docs/` written: {files, or "none yet"}
- Figure scan: {run / not run} · Hits: {n} · Handling: {shape / pointer / wiki, per file}
- External wiki: {MCP connected? name the destination, or "none — redact to shape"}
- Data-quality register: {n} open · {n} deferred · {n} closed · unowned: {n — must be zero}

## Relationships expected to change
| Relationship | Volatility | Trigger | Confirmed with |
{from Phase 1's join-graph quiz. Blank "confirmed with" means the join is an assumption.}

## Decisions made (do not relitigate)
| Date | Decision | Made by | Rationale |
|---|---|---|---|

## Open questions
| # | Question | Owner | Blocking which phase | Raised |
|---|---|---|---|---|

## Loop-backs
{When a later phase sent work back to an earlier one, and why. Expect at least one —
Phase 6 routinely exposes a missing metric, and Phase 2 routinely sends a grain or join
defect back to Phase 1. Zero loop-backs usually means verification was too easy.}

## Next action
{One sentence. What the next person or session does first.}
```

---

## Rules

- **Read before acting, always.** Resuming without reading this file is how engagements
  re-ask questions the customer already answered — the fastest way to lose their confidence.
- **Decisions are append-only.** The decisions table exists so a choice made in week one is
  not quietly reversed in week three. If a decision genuinely needs changing, add a new row
  that supersedes the old one and say so.
- **Every open question has a named owner.** An unowned question is an item that never
  closes. If nobody will own it, it is not actually blocking — drop it. The same applies to every
  `dq-NNN` entry: unowned means it closes never, and `wontfix` is the honest label.
- **Record degradations honestly.** If Phase 2 ran on a DDL dump with no sample data, every
  downstream phase inherits lower confidence, and the handoff must say so.
- **"Next action" is mandatory.** It is the difference between a resumable engagement and an
  archaeology exercise.
