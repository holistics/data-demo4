# Profile the warehouse

Study the data before you talk to anyone about it. This phase exists to prevent the
signature failure of consultant-mode AI: producing a beautiful metric framework that the
warehouse cannot populate.

Your output is not a schema dump. It is an **answerability ledger** — a defensible statement
of which questions this data can support today, which need modelling work, and which are
impossible without new source data.

## Precondition — the semantic layer must exist

You profile **through** the semantic layer. `list_datasets`, `fetch_dataset`, `fetch_sample_data`,
and `execute_aql` all read models and datasets, so on a tenant where nothing has been modelled they
return nothing at all. There is no way to list a dataset before someone has created models.

**Check first: run `list_datasets`.**

- **Returns datasets** → proceed. Read `01-semantic-layer.md` if the layer was just built, so you
  know which grains are confirmed and which are still provisional.
- **Returns nothing** → stop and run Phase 1 — `phase-1-scaffold-semantic-layer.md` — to create the models,
  relationships, and datasets. Then come back. Do not attempt to profile by writing raw SQL against
  the warehouse as a workaround — you would be profiling data the AI cannot see, and the whole
  point of this phase is to assess what the AI can actually reach.

The one honest exception is a **pre-sales readiness review** on a warehouse the customer has not
connected yet, where you have only a DDL dump. You can still map entities and hypothesise, but you
cannot sample, so most of section 3 is unverifiable. Mark the whole artifact `structural only` and
say plainly which conclusions are unsupported.

**What you are not doing here:** building or fixing models. Structural reconnaissance and modelling
belong to Phase 1. When profiling reveals a wrong grain, a fanning join, or a model that should
have been two, record it and send it back to Phase 1 (`phase-1-scaffold-semantic-layer.md`) — do not fix it inline, or
the fix goes undocumented and the next profile disagrees with this one.

## Rules

1. **Sample, don't assume.** A column named `is_active` tells you nothing until you see its
   distinct values. `status` may contain `test`, `TEST`, and `Test`. Profile actual data.
2. **Grain first.** For every entity, state what one row *is*, and what makes it unique. Most
   downstream metric errors are grain errors — fan-out from a bad join, or a "count of
   customers" that is really a count of subscription rows.
3. **Never fabricate coverage.** If you cannot query a table, mark it `unverified`. An honest
   gap is worth more than a confident guess, and the customer will find out either way.
4. **Record no actual figures.** Row counts and date ranges are structural and fine. Revenue
   totals, customer counts as business facts, and salary values are not — describe shape,
   not amount.
5. **Flag, don't fix.** You are not modelling in this phase. Note that refunds live in a
   separate table with a negative sign convention; do not build the net-revenue metric yet.
   Structural fixes go back to Phase 1 as named findings.

## Procedure

### 1. Establish what exists

Work through the semantic layer:

- `list_datasets` — every dataset. For each, `fetch_dataset` to get models, metrics,
  relationships, and descriptions.
- **Read the existing metrics closely.** On an existing tenant they matter enormously: they are
  the customer's current definitions and they are what the AI is already enforcing, whether or
  not anyone still agrees with them. Note which have empty descriptions — each one is a context
  bug already in production. On a tenant where Phase 1 just built the layer there will be none
  yet, which is expected, not a finding.
- **Read the relationships as claims to test.** A relationship declared in Phase 1 on a
  plausible-looking key is a hypothesis until you count the unmatched rows.
- `fetch_sample_data` / `execute_aql` — real values. This is where the phase earns its keep;
  everything above is metadata.

Where you were handed a DDL dump instead of a live connection, work from tables and mark the
artifact `structural only` per the precondition above.

Use `search-docs` for any Holistics feature or syntax question. Do not guess.

### 2. Map entities and grain

For each entity that matters to the chosen domain, record:

| Field | What to capture |
| --- | --- |
| Entity | Business name, then physical name |
| One row is | A single sentence. "One subscription-month for one account." |
| Unique key | The actual key. Note if it is a composite or if you could not find one. |
| Row volume | Order of magnitude, not exact |
| Date span | Earliest → latest, and where the data thins out |
| Grain traps | Soft deletes, versioned rows, SCD2, arrays, header-vs-line splits |

Then draw the relationships: which entity joins to which, on what key, and at what
cardinality. **Explicitly flag name-based joins as fragile** — if two entities join on a
customer name rather than an ID, every metric crossing that join inherits the fragility.

### 3. Run the data-quality checklist

These are the issues that silently corrupt AI answers. Check every one and record the
verdict, even when the verdict is "clean".

**Every issue you find becomes a numbered entry in the customer's data-quality register** —
`docs/data-quality/dq-NNN-{slug}.md` plus the generated `dq-index.yml`. Use
`data-quality-register.md` for the naming, front matter, lifecycle, and index conventions;
this skill owns filling the register, and Phase 1 may already have opened entries for structural
defects, so allocate IDs from the index rather than starting at 001.

Three things make the register worth the effort and all three are easy to skip:

- **The reproducible detection query goes in the entry**, verbatim. An issue nobody can re-run cannot
  be closed with evidence, only assumed away.
- **Every entry has a named human owner.** An unowned data-quality issue closes never. If nobody will
  own it, its honest status is `wontfix` and the affected metric descriptions carry the caveat
  permanently.
- **Shape, not amount.** The register lives in git and is visible to the customer's whole
  organisation. Null rates, unmatched-key percentages, and row counts are structural measurements and
  belong there; revenue totals and customer counts stated as business facts do not. Scan before
  writing and follow the orchestrator's **Project `docs/`** rule on any hit.

Then check every item below:

- **Identity resolution** — is one customer one row? What about the same person across two
  accounts, a company with multiple subscriptions, or a re-registered user?
- **Test and internal data** — internal accounts, QA rows, seeded demo data, employee
  accounts. How are they marked? Can they be excluded?
- **Deletes** — hard or soft? If soft, which flag, and does it mean "deleted" or "inactive"?
- **Status vocabularies** — dump distinct values of every status/type/stage column. Look for
  casing variants, near-duplicates, and legacy values no longer written.
- **Currency** — one currency or many? Is there an FX table? Are amounts stored in base,
  local, or both? **Watch for rows tagged with the wrong currency code** — this is common and
  it inflates converted totals by an order of magnitude.
- **Timezone** — what timezone are timestamps in? Is it consistent across sources? UTC in one
  table and local in another will break every daily comparison.
- **Refunds, cancellations, credits** — separate table or negative rows? Sign convention?
  This determines whether gross and net are separable at all.
- **Tax and shipping** — included in amount columns or separate?
- **Freshness** — when did each source last load? What is the normal lag? A metric on a table
  that lands 3 days late cannot answer "yesterday".
- **Completeness over time** — did a source start mid-history? Did a field become populated
  only after some migration? Backfill gaps make YoY comparisons lie.
- **Duplicates** — an ID collision is not automatically a duplicate. Distinguish genuine
  repeats (a bank transaction id can legitimately recur) from true dupes (identical payload
  hash) from cases needing human review.

### 4. Build the answerability ledger

This is the artifact that gates Phase 3. For each candidate business question, classify:

| Class | Meaning | What to do with it |
| --- | --- | --- |
| **Answerable now** | Data exists at the right grain; a metric can be built | Candidate T0 metric |
| **Answerable with modelling** | Data exists but needs joins, cleaning, or derivation | Size the work; T1 |
| **Answerable with caveats** | Possible but degraded — coverage gap, fragile join, late data | Answerable, but the caveat must live in the metric description, citing the `dq-NNN` behind it |
| **Not answerable** | Required source data does not exist | Tell the customer plainly and early |

The last row is the most valuable output of this phase. A customer who learns in week one
that channel CAC is impossible because spend data was never loaded is a customer you have
saved from a failed POC. Write it as a data-acquisition ask, with what would need to land.

Seed the ledger from generic questions any business asks — how are we growing, who is
churning, what does a customer cost to acquire, what does one cost to serve, which segment
is healthiest, what changed last month and why — then extend with anything domain-specific
you can infer from the schema itself.

### 5. Write the register and the docs

Write each issue from section 3 into `docs/data-quality/` per the register convention, then
regenerate `dq-index.yml` from the front matter. Do not maintain the index by hand — two copies of a
status means one is stale, and the stale one is what somebody reads six months from now.

Add to `docs/relationships.md` where profiling changed what is known about a join: an unmatched-key
rate you measured, a cardinality that turned out different in practice, a null-key meaning the data
team confirmed. Phase 1 wrote the reasoning; you are correcting it with evidence.

Scan every doc for business figures before writing, warn on any hit, and let the customer choose
between shape, a pointer at the governed layer, or publishing the full version to their own wiki —
per the orchestrator's **Project `docs/`** section. Ask for each publish specifically.

### 6. Note what the schema implies about the business

Schemas leak strategy. Before the interview, form hypotheses to test — this is what makes
Phase 3 fast:

- A `plan_tier` column with four values implies packaging you should ask about.
- Separate `b2c_orders` and `partner_contracts` tables imply two revenue motions that must
  not be blended.
- A `trial_ends_at` column implies a funnel with a conversion step.
- An empty `marketing_spend` table implies either a channel that does not exist or a data
  gap — and those need very different conversations.

Write these as **hypotheses, explicitly labelled**, not findings. You are guessing from
structure; the customer will correct you, and that correction is the interview working.

## Output — `02-data-inventory.md`

```markdown
# Data inventory — {Company}

**Profiled:** {date} · **Access:** {MCP live / branch / supplied DDL}
**Layer profiled:** {datasets covered · built in Phase 1 or pre-existing}
**Domain scope:** {domain}  ·  **Confidence:** {high / medium / low + why}

## Summary
{3–5 sentences: what data exists, what's strong, what's missing, the single biggest gap.}

## Entities
{table per section 2, plus the relationship map}

## Semantic layer as profiled
{datasets, models, metrics found. Flag empty descriptions and undefined metrics —
these are context bugs already live.}

## Data-quality flags
{every checklist item from section 3, with verdict and evidence. Each non-clean verdict cites the
`dq-NNN` entry that carries the detail — do not restate the issue in two places.}

## Data-quality register
| ID | Title | Class | Severity | Status | Owner | Blocks metrics |
{the register as it now stands, including entries Phase 1 opened. Mirrors
`docs/data-quality/dq-index.yml` — regenerate that file rather than hand-editing it.}

## Project docs written
| File | Contents | Figure scan | Sensitive content handling |
{every file written into the customer's `docs/`, and what the customer chose where the scan hit a
business figure.}

## Modelling defects — back to Phase 1
{grains that turned out wrong, joins that fan out, unmatched-key percentages, models that
should be split. Each one is a Phase 1 task, not something you fix here.}

## Answerability ledger
{the four-class table}

## Data-acquisition asks
{what would need to land to unlock the "not answerable" rows, and roughly why it matters}

## Hypotheses to test in interview
{labelled guesses from section 6}

## Open questions for the data team
{each with a named owner}
```

## Handing off

Phase 3 must read this file before asking a single question. Specifically, the interviewer
uses:

- the **answerability ledger** to avoid asking about metrics that cannot exist;
- the **hypotheses** to open with informed questions instead of blank ones;
- the **data-quality flags** to ask the right disambiguation questions ("I see three refund
  states — which of these count against revenue?").

Anything in **Modelling defects** goes back to Phase 1 first. An interview built on a join you
already know fans out produces metric definitions that will not survive verification.
