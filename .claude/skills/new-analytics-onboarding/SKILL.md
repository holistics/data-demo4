---
name: new-analytics-onboarding
description: Orchestrate the end-to-end onboarding of a new Holistics customer or prospect's business context — scaffolding their semantic layer (models, relationships, datasets), profiling their warehouse, interviewing stakeholders, defining a governed metric tree, routing each piece of context to the right destination (context.aml / governed metrics / AI Skills), and verifying the AI actually answers correctly. Use whenever the user wants to onboard, set up, or improve business context for Holistics AI; when a tenant is brand new and has nothing modelled yet; when a customer says the AI's answers feel "disjointed", "generic", or "not trusted"; when someone has written a large context document and wants to know where each part belongs; or when starting an AI analytics POC. Also trigger on 'business context', 'context.aml', 'AI context setup', 'onboard analytics', 'context ingester', 'set up Holistics AI', or 'why doesn't the AI trust our numbers'.
---

# New analytics onboarding — orchestrator

> **Start here.** This is the entry point for the whole engagement — it owns Phases 0 and 7
> directly and routes 1–6. If a user asks for onboarding, context setup, or "the AI isn't
> trusted", invoke *this* skill.
>
> **This file is the single source of truth for phase order, data flow, gates, and the customer's
> project layout.** Each phase's method lives in `references/phase-N-*.md` and deliberately does
> not restate any of them. You route: read the phase table, then read the matching reference file
> and follow it. When sequence changes, it changes here and nowhere else.
>
> **Each phase reference also has a thin stub skill of the same name** (`profile-warehouse`,
> `verify-ai-context`, …) carrying only a description and a pointer back to its reference file.
> Those exist so a standalone ask — a data-readiness review, a metrics glossary, a context
> restructure, a regression suite — still matches without loading this whole orchestrator. They
> hold no method, so the sequenced path and the standalone path cannot drift. **Never write method
> into a stub.**
>
> Chronology lives in the numbered **reference files** (`phase-1-` … `phase-6-`) and the numbered
> **artifacts** (`00-` … `07-`). Stub skill names stay unnumbered: they are matched by description
> and typed by name, and each stands alone.

You are running a structured engagement that turns a customer's undocumented business
knowledge into **enforced** context that Holistics AI reasons against. This skill is the
entry point and the traffic controller. It owns phase order, gating, and state. The actual
method for each phase lives in `references/phase-N-*.md`, which you read and follow in turn.

## The problem you are solving

Customers fail at AI analytics for one specific reason, and it is not effort. They write a
long, thoughtful business-context document, paste the whole thing into one context field,
and the AI still guesses. The document was good; the **placement** was wrong.

Holistics AI reads from layers with different enforcement strength:

| Layer | Enforcement | What belongs here |
| --- | --- | --- |
| `context.aml` custom context | **Suggestion** — the AI may or may not honour it | Org-wide orientation, conventions, answer style |
| Governed `metric` / `dataset` / `model` descriptions + definitions | **Ground truth on every query** | Anything with a real definition or formula |
| AI Skills | **Loaded on demand** | Repeatable multi-step procedures |

Prose in `context.aml` is a suggestion. A governed metric is enforcement. A definition
written as prose in the context field can still produce a wrong-formula answer; the same
definition encoded as a `metric` cannot.

**Therefore the highest-value thing you do in this engagement is not writing context. It is
routing each statement to the layer that actually enforces it.**

## Non-negotiable rules

1. **Never put a formula in `context.aml`.** If a statement contains or implies arithmetic
   ("net of refunds", "revenue ÷ spend", "excluding tax", "expanded to underlying units"),
   it is a metric definition. Encode it. Phase 5 enforces this mechanically — do not bypass it.
2. **Model before you profile; profile before you interview.** There is nothing to profile
   until a semantic layer exists — `list_datasets` returns an empty list on a new tenant, and
   `execute_aql` and `fetch_sample_data` read through the layer, so Phase 1 is a hard
   precondition for Phase 2. And you may not ask a customer about metrics their data cannot
   produce, so Phase 2 gates Phase 3. Together these are the single biggest guard against
   producing an impressive framework that is disconnected from the warehouse.
3. **Never invent a number, and never leak one.** Targets, prices, headcounts, and current
   performance figures go stale and must be retrieved from governed data at query time, not
   written into any artifact. Where a customer states a figure, record that a target *exists*
   and where it lives — not its value. Anything written into the customer's `docs/` folder is
   visible to their whole git organisation, history included: scan every doc before writing it,
   warn on any business figure, and let the customer choose between rewriting as shape,
   pointing at the governed layer, or publishing the full version to their own wiki. See
   **Project `docs/`** below.
4. **Not done until verified.** Phase 6 is not optional. An engagement that emits files but
   never asks the AI a real question has not delivered anything. Trust is the deliverable.
5. **Defer to existing Holistics skills** rather than restating them. For MCP setup use
   `setup-holistics-mcp`; for the AML toolchain use `setup-amql-development` and
   `setup-holistics-cli`; for AML authoring use `develop-amql`; for syntax use
   `search-docs`; for AQL use `write-aql`. Never guess AML syntax from memory.
6. **Partial is fine; vague is not.** 60–70% coverage with precise statements beats 100%
   coverage of hedged ones. When a customer is unsure, record it as an open question with a
   named owner rather than writing a soft guess.

## Phases

Run in order. Each phase writes its artifact into the engagement workspace and updates
`00-onboarding-state.md`. Phases are resumable across sessions — always read the state file
first and resume, never restart.

**You own this table.** Read the phase's reference file, pass it its inputs, and check its gate
before advancing; the reference files do not know their position in the sequence.

| # | Phase | Method | Reads | Writes | Gate to proceed |
| --- | --- | --- | --- | --- | --- |
| 0 | Scope & access | *(this skill)* | customer's existing context doc, if any | `00-onboarding-state.md` | Warehouse reachable or schema supplied |
| 1 | Scaffold the semantic layer | `references/phase-1-scaffold-semantic-layer.md` | `00-` | `01-semantic-layer.md` + models/relationships/datasets and `docs/` in the customer's project | `holistics aml validate` passes · `list_datasets` returns the dataset · a query crossing a relationship executes · every relationship has a confirmed cardinality and a volatility flag · every fact has a recorded canonical date |
| 2 | Profile the warehouse | `references/phase-2-profile-warehouse.md` | `00-`, `01-` | `02-data-inventory.md` + `docs/data-quality/` register | Answerability ledger exists · every non-clean data-quality verdict has a `dq-NNN` entry with a named owner |
| 3 | Interview stakeholders | `references/phase-3-interview-business-context.md` | `02-` | `03-business-context-raw.md` | Core unit + ≥1 segment defined |
| 4 | Define the metric tree | `references/phase-4-define-metric-tree.md` | `02-`, `03-` | `04-metric-tree.md`, `04-metric-specs/` | Every T0 metric has numerator + denominator + exclusions |
| 5 | Route & emit | `references/phase-5-route-context-artifacts.md` | `03-`, `04-`, existing context doc | `05-routing-map.md`, `emit/` | Formula gate passes on `context.aml` |
| 6 | Verify | `references/phase-6-verify-ai-context.md` | `04-`, `05-`, verification seeds in `03-` | `06-question-bank.md`, `06-verification-report.md` | T0 pass rate ≥ 80%, zero traps committed on the customer's own questions |
| 7 | Handoff | *(this skill)* | all | `07-handoff.md` | Owners named for every open item |

Phase 1 is a **build** phase on a new tenant and an **audit and gap-fill** phase on an existing
one; `phase-1-scaffold-semantic-layer.md` handles both. Do not skip it because a customer says
they "already have datasets" — a dataset with no relationships, or a model with no description, breaks Phase 6 in
ways that are very hard to diagnose from the other end.

### Phase 0 — Scope & access

Establish, in this order:

1. **Who is this for** — company, primary stakeholder, their role, and the business question
   they most want answered. Write the last one down verbatim; it becomes the first
   verification question in Phase 6.
2. **Where they are** — brand-new tenant, existing tenant with datasets, or POC on a
   customer branch. This decides whether Phase 1 is a build or an audit, so establish it
   concretely: run `list_datasets`. An empty list means greenfield and Phase 1 is the bulk of
   the early work. Do they already have a context document? If yes, **read it now** — it is
   your richest input and it goes straight into Phase 5's router.
3. **Access** — Holistics MCP configured? Warehouse readable? If MCP is not set up, invoke
   `setup-holistics-mcp` before continuing; for AML authoring and `holistics aml validate`,
   `setup-amql-development` and `setup-holistics-cli` are what Phase 1 needs wired. If you
   cannot get access at all, you may proceed with a supplied DDL/schema dump, but record the
   degradation in the state file — sample data is what catches test rows, soft deletes, and
   currency mislabelling, and you will miss those.
4. **Scope** — which domains are in play (revenue, product usage, marketing, support,
   finance). Pick **one** domain for the first pass. Breadth is how these engagements die;
   a customer who trusts one domain will expand it themselves.

Create the workspace: `{engagement-root}/{YYYY-MM-DD}-{company-slug}/` and write
`00-onboarding-state.md` from the template in
`references/state-file-template.md`.

**Do not skip to a later phase because the customer already has a context doc.** An existing
doc means Phase 3 gets shorter, not that Phases 1, 2, and 4 disappear. The doc tells you what
they *believe*; the layer and the profile tell you what is *true*.

### Phases 1–6

Read the matching `references/phase-N-*.md` in full and follow it. Read its output artifact
before advancing. After each phase:

- Update `00-onboarding-state.md` (phase status, artifact path, open questions, decisions).
- Check the gate in the table above. If the gate fails, say so plainly and either loop within
  the phase or record an explicit, owner-assigned exception. Do not advance silently.

**Loop back freely.** This is not a waterfall. Phase 6 routinely exposes a missing metric
(→ Phase 4) or an ungrounded assumption (→ Phase 2), and Phase 2 routinely exposes a wrong grain
or a fanning join (→ Phase 1). Expect at least one loop; an engagement with zero loops usually
means verification was too easy.

### Phase 7 — Handoff

Write `07-handoff.md` containing:

1. **What was emitted** — every file, its destination in Holistics, and who adopts it.
2. **Adoption steps** — exactly where each artifact goes (`Settings → AI → Context` for
   `context.aml`; dataset/metric `description` fields; AI Skills; the repo's `AGENTS.md`).
3. **Verification result** — the pass rate, and every question that still fails, with the
   specific context bug behind it.
4. **Open questions** — each with a named human owner. Never hand off an unowned question.
5. **The data-quality register** — the open `dq-NNN` entries, their owners, and which metrics each
   one qualifies. This is the part of the handoff the customer keeps using after you leave, and an
   unowned entry is an entry that closes never.
6. **Relationships expected to change** — the non-`stable` joins, their triggers, and what has to be
   rebuilt when one fires. Handing over a join graph without its volatility is handing over a
   surprise.
7. **The maintenance loop** — context is living. State the trigger for revisiting it: a new
   data source, a changed definition, a new team using the AI, a relationship change firing, or a
   failed answer in the wild. Whoever owns the metric owns its description; whoever owns the
   pipeline owns the `dq-NNN` entries against it.

## Engagement workspace layout

This is *your* working folder for the engagement. It is not the customer's AMQL project — that
has its own layout, below.

```
{YYYY-MM-DD}-{company-slug}/
  00-onboarding-state.md           ← phase status, decisions, open questions. Read first, always.
  01-semantic-layer.md             ← models, relationships, datasets built; validation evidence
  02-data-inventory.md             ← entities, grain, coverage, answerability ledger
  03-business-context-raw.md       ← raw interview capture, provisionally tagged
  04-metric-tree.md                ← north star → drivers → guardrails
  04-metric-specs/
    {metric_name}.md               ← one spec per metric
  05-routing-map.md                ← every statement → destination + reason (audit trail)
  06-question-bank.md              ← generated verification questions + expected behaviour
  06-verification-report.md        ← actual answers, scores, context bugs found
  07-handoff.md                    ← adoption steps, owners, maintenance loop
  emit/                            ← the artifacts the customer actually installs
    context.aml
    metrics/{dataset_name}.metrics.aml
    descriptions/{object_name}.md
    skills/{skill-name}/SKILL.md
    AGENTS.md
```

## Default AMQL project layout

This is the folder hierarchy Phase 1 creates in the **customer's own AMQL project**, and the one
Phase 5 documents in the `AGENTS.md` it emits. **This section owns the convention** — the phase
skills and `references/agents-md-scaffold.md` point here rather than restating it.

Start every project from this shape, then prune. It is the layout a mature production Holistics
project converges on, so beginning here saves the customer a reorganisation once a second domain
arrives.

```
{customer-project}/
├── AGENTS.md                # conventions for coding agents (emitted in Phase 5)
├── README.md
├── settings/                # ProjectSettings, Tags — governance lives here
│   ├── settings.aml
│   └── tags.aml
├── models/                  # semantic models, by domain
│   ├── raw/                 #   Layer 1: wrappers over raw tables (type:'query' — the only
│   │                        #     sanctioned SQL). One per raw table loaded.
│   ├── {domain}/            #   e.g. revenue/, product/, marketing/, support/, finance/
│   │   └── {topic}/         #   third level ONLY when a domain grows large (finance/pnl/, …)
│   └── utils/               #   cross-cutting dims: dates, FX rates, calendars — owned by no domain
├── datasets/                # semantic datasets — METRICS LIVE HERE, by domain
│   └── {domain}/            #   mirror models/{domain}/ exactly, including any topic level
├── dashboards/              # *.page.aml report pages, by domain
│   └── {domain}/
├── library/                 # reusable blocks and dashboard templates
├── docs/                    # OPEN CONTEXT — see the next section. Read before building.
│   ├── 00-overview.md       #   what this project is, domains, source systems
│   ├── relationships.md     #   the join graph, why each join is what it is, what may change
│   ├── data-quality/        #   the dq-NNN register + dq-index.yml
│   └── decisions/           #   basis decisions that must not be re-litigated
└── elt/                     # ingestion code, IF the customer has any. Carries its own
                             #   AGENTS.md. No AML, metrics, or business logic here.
```

The rules that make the layout hold up:

1. **Artifact type first, then domain.** `models/{domain}/`, `datasets/{domain}/`,
   `dashboards/{domain}/` — not `{domain}/models/`. The outer axis mirrors the dependency DAG
   (models → datasets → dashboards) and lets a cross-cutting mart fan into several domains without
   living inside any one of them.
2. **Mirror `models/` and `datasets/` for the same domain**, including any topic third level. When
   they diverge, nobody can find the dataset that consumes a given model.
3. **Add the topic third level only when a domain grows large.** Small domains stay flat. Empty
   folders scaffolded in advance teach an agent nothing and get abandoned.
4. **Shared dimensions go in `models/utils/`**, never in a domain folder, so no single domain
   appears to own the date table.
5. **A deliberately separate sub-graph is a top-level sibling, not a nested child.** If a set of
   models must *not* be joined to the main fact graph, nesting it under the domain it resembles
   wrongly implies that join. Give it its own folder and its own `AGENTS.md` stating the exclusion.
6. **`snake_case` everywhere**, with the block name matching the filename:
   `<name>.model.aml` → `Model <name>`, `<name>.dataset.aml` → `Dataset <name>`,
   `<name>.page.aml` → `Dashboard <name>`.
7. **Keep ELT out of the analytics folders and AML out of the ELT folder.** One clean split, in
   both directions.

Where the customer already has a project with a different layout that works, **do not reorganise
it** — record the divergence in `01-semantic-layer.md` and follow their convention. A layout the
team already navigates beats a better one they have to relearn.

## Project `docs/` — open context, and the sensitive-figure gate

`docs/` is the project's **open context**: the reasoning, decisions, and known defects behind the
semantic layer, written for anyone with repository access. It is deliberately not the same thing as
`context.aml` — `context.aml` teaches the in-product AI about the business, while `docs/` teaches the
humans and the coding agents *why the layer is shaped the way it is*. Both are needed and neither
substitutes for the other.

Phases 1 and 2 write into it:

| File | Owner | Contents |
| --- | --- | --- |
| `docs/00-overview.md` | Phase 1 | What this project covers, the domains, source systems, base currency, what is deliberately out of scope |
| `docs/relationships.md` | Phase 1 | The join graph: every relationship, why it is that cardinality, **which ones are expected to change**, and the semantics that are deliberately *not* encoded as dataset state — canonical date per fact, which dimensions describe it, conformed-dimension confirmations |
| `docs/data-quality/` | Phase 2 (Phase 1 opens structural entries) | The `dq-NNN` register — see `references/data-quality-register.md` |
| `docs/decisions/` | any phase | Basis decisions that must not be re-litigated, with date and decider |

### The visibility rule

**Treat `docs/` as readable by everyone in the customer's git organisation, including its full
history.** That is usually what the customer wants — open context is the point — but it makes the
folder the wrong home for anything confidential, and a `git rm` later does not undo it.

So: keep **logic, methodology, structure, thresholds, and shape** in `docs/`. Keep **business
figures** out. The line is the same one the metric rules use — revenue totals, MRR, cash balances,
deal sizes, salaries, headcounts, and customer counts stated as business facts are figures. Row
counts, null rates, unmatched-key percentages, date spans, and load lag are structural measurements
and belong there. `references/data-quality-register.md` has the full table, because DQ docs are where
this line gets crossed most often.

### Before writing any doc — scan, warn, then ask

1. **Scan the draft** for figure-shaped content: currency symbols, thousands-separated numbers,
   percentages attached to a business quantity rather than a row population, and the words revenue,
   MRR, ARR, salary, headcount, valuation, churn rate, deal size.
2. **Warn the requestor explicitly** on any hit. Name the specific line and say who can see it:
   "`docs/data-quality/dq-007` states the affected revenue as a dollar amount. Anyone with read
   access to this repo, now or later, can see that. Options below."
3. **Offer the three options and let them choose** — do not silently redact and do not silently
   commit:
   - **Rewrite as shape** — the usual answer. "Roughly one order in eight", not the dollar figure.
     Nothing is lost, because the amount was never what made the doc useful.
   - **Reference the permissioned layer** — keep the logic in git and point at the governed dataset
     or dashboard where the current number lives. Better than a snapshot anyway: a figure in a doc
     is stale the day after it is written.
   - **Publish the full version to their external wiki** — if they keep confidential documentation
     in Notion, Confluence, or similar and an MCP connection to it is available, write the complete
     version there and leave a redacted stub plus a link in git.

**Never send anything to an external wiki without explicit confirmation for that specific
publish.** It is an outward-facing action: the content leaves the repository, lands somewhere with
its own sharing rules, and may be indexed or cached beyond your reach. Ask for each document, name
the destination page, and never assume permission carries over from a previous one. Where no wiki
MCP is connected, say so plainly and use one of the first two options rather than inventing a
destination.

If the customer decides they want the figure in git anyway, that is their call to make — record the
decision in `docs/decisions/` with their name against it and move on.

## Working style

- **Interview like a consultant, act like an engineer.** Phase 3 rewards hypothesis-driven
  questioning; Phases 1–2 and 4–6 reward pedantic precision about grain and denominators.
- **Build the thinnest layer that answers something.** Phase 1 is where scope creep is cheapest to
  commit and most expensive to carry. One domain, the entities it needs, nothing speculative.
- **Show the customer the routing, not just the output.** `05-routing-map.md` is what makes
  the engagement teachable — it is the artifact that stops them writing another monolith
  six months from now.
- **Prefer their words.** If the team says "bottles", the metric is `bottles_sold`, not
  `units_sold`. Governed metrics named in the customer's own vocabulary are the mechanism by
  which "default question interpretation" stops being needed at all.
- **Timebox the interview.** Two 60-minute sessions beats one open-ended crawl. Send the
  kickoff questions ahead; fill gaps live.
- **When a customer asserts something the data contradicts, surface it.** That contradiction
  is usually the most valuable finding in the whole engagement.

## References

The six phase files are the method you route to; the rest are shared assets the phases fill in.

| Phase | File |
| --- | --- |
| 1 | `references/phase-1-scaffold-semantic-layer.md` |
| 2 | `references/phase-2-profile-warehouse.md` |
| 3 | `references/phase-3-interview-business-context.md` |
| 4 | `references/phase-4-define-metric-tree.md` |
| 5 | `references/phase-5-route-context-artifacts.md` |
| 6 | `references/phase-6-verify-ai-context.md` |

- `references/routing-table.md` — the destination classifier. The core IP of this plugin.
- `references/context-template.md` — fill-in-the-blank business context template.
- `references/metric-spec-template.md` — per-metric specification shape.
- `references/agents-md-scaffold.md` — repo conventions for the customer's AMQL project. Its
  structure section defers to **Default AMQL project layout** above.
- `references/data-quality-register.md` — the `dq-NNN` register: naming, front matter, index, lifecycle.
- `references/state-file-template.md` — engagement state file.
- `references/consulting-moves.md` — the interview methods, stated as behaviours.
