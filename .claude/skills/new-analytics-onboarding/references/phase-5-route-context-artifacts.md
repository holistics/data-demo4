# Route and emit context artifacts

This is the core of the plugin. Everything before it gathers material; this decides where each
piece lives, which determines whether the AI honours it or ignores it.

## Why routing is the whole game

The characteristic failure looks like success. A customer writes a genuinely excellent 25,000-word
business context document, pastes it into the custom context field, and the AI still produces
wrong-formula answers. Nothing was missing. Roughly 40% of that document was **metric definitions
written as prose** — and prose in the context field is a suggestion, while a governed metric is
enforcement.

The fix is not more writing. It is moving each statement to the layer with the enforcement
strength it needs. Done properly, a 25,000-word monolith becomes a ~4,000-word context overview
plus a dozen governed metric descriptions plus two or three AI Skills — and the AI gets *more*
reliable while the context field gets shorter.

Input: `03-business-context-raw.md`, `04-metric-tree.md`, `04-metric-specs/`, plus **any existing
context document the customer already wrote** — that document is the richest input you have.

## The destinations

| Destination | Enforcement | Contents | Size discipline |
| --- | --- | --- | --- |
| **`context.aml`** custom context | Suggestion — orientation only | Business overview, segments and the do-not-blend rules, reporting conventions (timezone, currency, week), trust hierarchy, answer style, north-star framing | **Lean.** Target under ~400 lines. It is read on every query. |
| **`metric` description + definition** | Ground truth, every query | Anything with a formula, basis, exclusion rule, or counting logic | One per metric. Verbose is fine. |
| **`dataset` / `model` / field description** | Ground truth when that object is used | Per-dataset interpretation, channel-specific rules, what this dataset is for and what not to carry into it | One per object |
| **AI Skill** | Loaded on demand | Repeatable multi-step procedures with defaults and checklists | 1–3 to start |
| **Tags** (`Endorsed` / `Archived`) | Respected by the AI | Trust hierarchy, lifecycle | Applied per object |
| **Repo `AGENTS.md`** | Read by local coding agents | Conventions for the customer's own AMQL repo | One root file |
| **Discard / point at source** | — | Current figures, targets, prices, headcounts | Nothing |

## The classifier

Apply these tests **in order** to every statement. First match wins.

### Test 1 — Is it a number that will change?
Targets, current prices, headcounts, budgets, this quarter's performance, catalogue contents.

→ **Discard from all artifacts.** Replace with a pointer: "retrieve current targets from
governed planning data, not from this file." Record in the routing map that a target exists and
where it is maintained.

*Why first:* stale numbers are the fastest way to destroy trust, and they hide in every section.
A confidently-quoted target from six months ago reads exactly like a hallucination to the customer.

### Test 2 — Does it contain or imply arithmetic?
Scan for: `÷` `/` `×` `%` `+` `-`, and the phrases **"divided by"**, **"per"**, **"ratio"**,
**"sum of"**, **"net of"**, **"gross of"**, **"excluding"**, **"including"**, **"minus"**,
**"expanded to"**, **"after"**, **"adjusted for"**, **"counts only"**, **"where status ="**.

→ **A governed `metric`.** The prose becomes the `description`, the arithmetic becomes the
`definition: @aql`. If the metric does not exist in the tree yet, **return to Phase 4** — do not
smuggle a definition into prose because the metric isn't built.

*This is the single highest-yield test.* It is what converts a suggestion into enforcement, and
it is where most of the reclaimed volume comes from.

### Test 3 — Is it a multi-step procedure?
Does it read as steps, defaults-then-exceptions, or a checklist? "How we analyse cohorts",
"how we evaluate a promotion", "the month-end revenue check", "what to check before calling a
dip weak demand".

→ **An AI Skill.** Task-shaped guidance loaded when relevant, not carried on every query.

### Test 4 — Does it apply to one dataset or model only?
Channel-specific interpretation, "don't apply DTC logic to the partner channel", what a
particular mart is for, a caveat about one source's coverage.

→ **That object's `description`.** Per-object interpretation belongs on the object, where it is
in scope exactly when the object is used.

### Test 5 — Is it org-wide orientation the AI needs everywhere?
The business and its positioning, the segments and what must not be blended, timezone and
currency and week conventions, trust hierarchy, house style, answer shape, the north-star framing.

→ **`context.aml`.** This is the residue after tests 1–4, and it should be a small fraction of
what you started with.

### Test 6 — Anything left?
Genuinely ambiguous statements go to the routing map flagged `unrouted`, with a named owner. Do
not force a placement you cannot defend, and do not default to `context.aml` as a dumping ground.

## The formula gate (hard, mechanical)

Before emitting `context.aml`, scan the draft for the Test 2 signals. Every hit is either:

- **a violation** → route it to a metric and remove it from `context.aml`; or
- **a deliberate, recorded exception** → a *pointer* to a definition is allowed
  ("use the governed `net_revenue` metric; state gross vs net"), an actual formula is not.

Record the scan result in `05-routing-map.md`. **Do not emit `context.aml` with an unresolved
violation, and do not report the gate as passed without running it.**

The distinction that matters: `context.aml` may say *which* metric to reach for and *what to
state alongside it*. It may not say *how to compute it*.

## Procedure

1. **Decompose the source into atomic statements.** One rule per statement. A paragraph
   containing an overview sentence and a counting rule is two statements with two destinations —
   this is exactly where monolithic documents hide their definitions.
2. **Classify each** through tests 1–6. Record the destination **and the reason** — the reason is
   what makes the map teachable.
3. **Draft `context.aml`** from the Test 5 set only, using `context-template.md`.
4. **Run the formula gate.** Resolve every hit.
5. **Write metric descriptions** into the specs from Phase 4, folding in the prose captured here.
6. **Write dataset/model descriptions** for the Test 4 set.
7. **Write AI Skills** for the Test 3 set. Each references governed metrics by name rather than
   restating their formulas — a skill that recomputes a metric defeats the enforcement.
8. **Apply tags.** `Endorsed` on certified objects, `Archived` on superseded ones. Never both.
9. **Scaffold the repo `AGENTS.md`** from `agents-md-scaffold.md` if the customer has
   an AMQL repo.
10. **Validate.** Use `develop-amql` to author and `holistics aml validate` on everything emitted.
    Report the actual result.
11. **Write `05-routing-map.md`.** The audit trail, including before/after size.

## Emitted artifacts

```
emit/
  context.aml                            ← lean overview only
  metrics/{dataset_name}.metrics.aml     ← governed metric blocks with descriptions
  descriptions/{object_name}.md           ← dataset/model description text to paste
  skills/{skill-name}/SKILL.md            ← AI Skills
  AGENTS.md                               ← repo conventions for their AMQL project
```

Emit `.md` alongside `.aml` where it helps adoption — markdown is a portable staging step a
customer can review before committing to AML, and it lowers the barrier to the first install.
Say clearly which file goes where.

## `05-routing-map.md`

The teaching artifact. Without it you have fixed one document; with it the customer stops
producing monoliths.

```markdown
# Routing map — {Company}

## Before / after
| | Before | After |
|---|---|---|
| context.aml | {n} words | {n} words |
| Governed metrics | {n} | {n} |
| Dataset/model descriptions | {n} | {n} |
| AI Skills | {n} | {n} |
| Discarded (stale figures) | — | {n} |

## Statement routing
| # | Statement (abbrev.) | Source | Destination | Test | Why |
|---|---|---|---|---|---|

## Formula gate
{scan result on context.aml: hits found, each resolved or exception-recorded}

## Unrouted
{statements needing an owner decision}

## Adoption steps
{exactly where each emitted file goes in Holistics, in order}
```

## Anti-patterns

- **Routing by section heading instead of by statement.** A "Metric interpretation" section is
  obviously metrics; the dangerous definitions are the ones buried inside "Business overview".
- **Leaving a formula in `context.aml` because it feels like helpful background.** This is the
  exact failure the phase exists to prevent. Helpful background that computes a number is a
  metric.
- **Emitting a `context.aml` roughly as long as the input.** If you did not substantially shrink
  it, you did not route — you reformatted. Check the before/after table honestly.
- **Writing an AI Skill that restates metric formulas.** Reference the metric by name.
- **A skill or description that quotes a current target.** Test 1 applies everywhere, not just to
  `context.aml`.
- **Silent placement.** Every statement gets a recorded reason. "It seemed like overview" is not
  a reason.
