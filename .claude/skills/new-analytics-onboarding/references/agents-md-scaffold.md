# `AGENTS.md` scaffold for a customer's AMQL repo

Emitted by `route-context-artifacts` into `emit/AGENTS.md`. This teaches the customer's *local*
coding agents (Claude Code and others working in their AMQL repo) the conventions that keep their
semantic layer consistent — a different job from `context.aml`, which teaches the *in-product* AI
about their business.

## Scope discipline

Most customers start with one flat AMQL repo. **Ship a single root `AGENTS.md`** with an explicit
trigger for when to add a nested one. Do not scaffold a deep tree they will never fill — empty
convention files are worse than none, because agents read them, learn nothing, and stop trusting
the pattern.

**Add a nested `AGENTS.md` only when a subtree has rules that genuinely differ from the root.**
Real triggers: an ELT/ingestion folder where the AML rules do not apply; a sub-graph deliberately
excluded from the main join graph; a domain with its own confidentiality or basis rules. Not a
trigger: a folder that merely has a lot of files in it.

When you do add one, it **adds to** the root rather than overriding it, and it states only its
local exceptions. Duplicating a root rule into a child means the two drift, and the child wins by
proximity — which is how a stale rule outlives its correction.

## The nested chain rule

When nesting exists, agents must process the whole chain in both directions:

- **Descending** — entering a folder, read its `AGENTS.md` before touching its files.
- **Ascending** — when working from a nested `AGENTS.md`, walk **up through every parent folder's
  `AGENTS.md` to the root** before acting. Never rely on a nested file in isolation; it states
  local exceptions and assumes everything above it still holds.

If instructions at different levels genuinely conflict, surface it to the user rather than
silently picking one.

---

## Template

```markdown
# AGENTS.md — Conventions for AI agents in `{repo-name}`

> **Read this before touching any file.** When a request conflicts with a rule here, surface
> the conflict instead of silently breaking the rule.
>
> **Nested instructions.** If a subdirectory has its own `AGENTS.md`, read and follow it before
> working in that subtree — and walk **up** through every parent to this root as well. Nested
> files add to, never override, their parents. Genuine conflicts go to the user.

## 1. Who you are
You are part of a team of analytics engineers building {Company}'s semantic layer. Your audience
is {the decision-makers who consume these numbers}. The work must be **auditable to source,
internally consistent, and defensible in front of {that audience}**. Precision beats speed.

When in doubt, behave like a controller: pick one clearly-defined basis, document the choice,
and never fabricate a number to make something tie out.

## 2. Business context
{2–4 sentences: what the business does, its motions/segments, source systems, base currency.
Keep it short — the full picture lives in `context.aml` and in governed object descriptions.
Cross-reference; do not duplicate.}

**Source systems:** {system → role}
**Base currency:** {ccy}. Presentation in other currencies goes through the governed FX table.
**Never hardcode an FX rate.**

## 3. Repo purpose & scope
**In scope:** {domains}
**Out of scope / pending source:** {known gaps}. **Do not fabricate these inputs** — mark them
"pending source".

## 4. Cardinal rules
1. **AML/AQL, not SQL.** Business logic — mappings, classifications, metrics, ratios — is
   expressed in AML/AQL. Raw SQL is sanctioned only in {the specific wrapper models that read
   raw tables}. If you feel the need for a SQL model to express business logic, stop and
   re-express it in AML, or raise it.
2. **Metrics are first-class citizens of datasets, not measures locked into models.** Define
   business metrics in the dataset (`metric { definition: @aql ... }`) so they can span models.
   Models expose **dimensions** and raw additive facts; **datasets** compose them into named,
   formatted, described **metrics**.
3. **Every metric carries a `description` and an explicit `format`.** An empty description is
   not cosmetic — it is the AI losing the definition, which defeats the point of governing it.
4. **Validate before calling anything complete.** Nothing is done until `holistics aml validate`
   passes. State the actual result; never claim a green validation you did not run.
5. **Auditable to source.** Choose a basis, apply it in one place, document it. Never
   double-count across overlapping fact tables.
6. **`docs/` is open context — figures do not go in it.** Assume anyone with repo access can read
   every file and its full git history, now and later. Keep logic, methodology, structure, grain,
   thresholds, and data-quality measurements (null rates, unmatched-key rates, row counts, date
   spans) in `docs/`. Keep business figures — revenue, MRR, cash, deal sizes, salaries, headcount,
   customer counts as business facts — in the permissioned BI layer and reference them generically.
   {If the team keeps confidential documentation in a wiki, name it here as the destination for the
   unredacted version, and state that a redacted stub plus a link stays in git.} Never write an
   identifiable person's name next to their compensation.

## 5. Repo structure
{The actual tree as it exists, one line of purpose per folder. Take the shape and the seven
layout rules from **Default AMQL project layout** in the `new-analytics-onboarding` orchestrator,
which owns that convention — then prune to the folders this repo really has, and note any place
this repo deliberately diverges.}

The two rules people break first: **artifact type is the outer axis, domain the inner** — it
mirrors the dependency DAG and lets cross-cutting marts fan in cleanly — and **`models/{domain}/`
and `datasets/{domain}/` stay mirrored**, including any topic third level.

## 6. Naming
| Artifact | Filename | Top-level block |
|---|---|---|
| Model | `<name>.model.aml` | `Model <name> { }` |
| Dataset | `<name>.dataset.aml` | `Dataset <name> { }` |
| Dashboard | `<name>.page.aml` | `Dashboard <name> { }` |

`snake_case` everywhere. Block name matches filename. Match the prevailing prefix convention of
the folder you are adding to ({e.g. `mart_`, `fct_`, `dim_`}).

**Name metrics in the business's own vocabulary** — {their word}, not the generic industry term.
This is what lets the AI reach for the right metric without a translation table.

## 7. Authoring conventions
{model and dataset skeletons — see `develop-amql` for authoritative syntax}

- Composite metrics reference other metrics rather than recomputing from raw fields.
- Wrap components in `coalesce(..., 0)` where a NULL would poison arithmetic.
- Join on IDs where a clean ID exists; flag name-based joins as fragile.
- Dashboards reference dataset fields and metrics — they never redefine business logic.

## 8. `docs/` — the open-context folder
`docs/` explains *why* the layer is shaped as it is, for humans and coding agents. `context.aml`
explains the business to the in-product AI. Neither substitutes for the other, and neither should
duplicate the other — cross-reference.

| File | Contents |
|---|---|
| `docs/00-overview.md` | Scope, domains, source systems and what each is authoritative for, base currency, what is out of scope and "pending source" |
| `docs/relationships.md` | The join graph: key, cardinality, which side carries the aggregatable fact, what a null key means, unmatched-row rate, **which joins are expected to change and what would change them**, pipeline owner |
| `docs/data-quality/` | The `dq-NNN` register — one file per issue, front matter as the source of truth for status, plus a **generated** `dq-index.yml`. Never hand-edit the index |
| `docs/decisions/` | Basis decisions with date and decider. Do not re-litigate what is recorded here |

**Update `docs/relationships.md` in the same change as the relationship itself.** A cardinality that
changes in the dataset but not in the doc leaves the next person to rediscover why — and the reason
is the part they actually need.

**Before closing a `dq-NNN`, re-run its detection query.** A deployed fix and a verified fix are
different events; only the second one closes an issue.

## 9. Toolchain & mandatory validation
This repo is wired to Holistics MCP. Use the skills rather than guessing syntax:
`develop-amql` (author), `write-aql` + `execute_aql` (verify), `search-docs` (look up),
`fetch_dataset` / `fetch_sample_data` (profile real data before encoding a mapping).

**Definition of done:** logic in AML/AQL · reusable metrics defined in the dataset ·
descriptions, formats, and owner set · `holistics aml validate` passes · numbers spot-checked
against source with basis and caveats documented · lifecycle tag applied.

## 10. Governance
- **Tags:** apply `Endorsed` when an object is the certified source of truth for its subject and
  meets the definition of done. Apply `Archived` when superseded. Never both. Do not endorse
  draft or diagnostic artifacts.
- **Owner:** set `owner:` to the responsible person's email. Whoever owns the metric owns its
  description.
- **Secrets:** never commit API keys, `.env`, or MCP config.
- **Git:** branch from `{default}`; commit and push only when asked.

## 11. Business context for the in-product AI
The in-product AI reads `context.aml`, governed object descriptions, and AI Skills. When you
change a metric definition here, **update its `description` in the same change** — the
description is what the AI enforces, and a definition that drifts from its description produces
answers that are right and unexplainable.

Local agents: fetch org context via MCP rather than re-deriving business definitions from these
files, and list/load the available AI Skills instead of reinventing their procedures.

## 12. When unsure
Ask. A documented gap is always better than a confident wrong figure.
```

---

## Filling it in

Section 5 is written from the project Phase 1 actually built or audited — take the shape from the
orchestrator's **Default AMQL project layout** and prune. Sections 2 and 3 are customer-specific and
come out of Phases 2–4. Sections 1, 4, 6–12 are largely portable — adjust the audience, the
confidentiality posture, and the prefix conventions.

The three rules that matter most, and that customers most often lack:

- **Metrics belong in datasets, not models** (§4.2). Without this, reusable metrics get buried as
  per-model measures, cannot span models, and are invisible to the AI as governed concepts.
- **Validation gates "done"** (§4.4, §9). Without it, agents report success on AML that does not
  compile, and the customer's trust problem gets worse rather than better.
- **`docs/` is open context, and business figures stay out of it** (§4.6, §8). Customers reach for a
  repo doc as the natural home for "the numbers we found", and a git history is not something you can
  walk back. Name their wiki in §4.6 if they have one, so the alternative destination is written down
  before somebody needs it.
