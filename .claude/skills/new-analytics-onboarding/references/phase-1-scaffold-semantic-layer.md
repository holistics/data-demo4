# Scaffold the semantic layer

**Nothing downstream works until this exists.** `list_datasets` returns an empty list on a new
tenant. `fetch_dataset`, `fetch_sample_data`, and `execute_aql` all read *through* the semantic
layer — so profiling, metric definition, and verification are all blocked until there are models,
relationships, and at least one dataset. Building them is not a preliminary; it is the first
deliverable.

Your output is a **validated structural skeleton**: models that expose correctly-typed dimensions
at a stated grain, relationships that are justified by real keys, and datasets that execute. Not
metrics — those are governed business definitions and they need the interview first.

## Two modes

Decide from Phase 0, and say which one you are in.

| Mode | Situation | What you do |
| --- | --- | --- |
| **Greenfield** | New tenant. No models, no datasets. | Build the layer from the warehouse tables up. |
| **Brownfield** | Existing project with models and datasets. | Audit the structure, fill the gaps, leave working objects alone. |

Brownfield is the more common case and the more dangerous one: an existing layer looks finished.
Audit it against the same checks a greenfield build has to pass, because whatever is structurally
broken here becomes an unexplainable AI answer four phases later.

## The boundary with Phase 2

These two phases both look at the data and the split between them is deliberate — do not do the
other one's work.

- **Here (Phase 1): structural reconnaissance.** Which tables exist, which columns, what type,
  which column is the key, what one row appears to be. Enough to build a model. You may read a
  handful of rows to type a column correctly.
- **Phase 2: profiling.** Distinct values of every status column, identity resolution, soft
  deletes, currency and timezone consistency, freshness, and the answerability ledger. All of it
  runs against the layer you build here.

**Expect Phase 2 to send work back.** A grain you read wrong, a join that fans out, a model that
should have been two. That loop is the process working, not a failure — which is exactly why you
should not gold-plate the layer on the first pass.

## Rules

1. **Structure now, business logic later.** Models expose dimensions and raw additive facts.
   Named business metrics are defined in the dataset in Phase 4, after the interview, in the
   customer's own vocabulary. Defining them now means guessing their definitions and their words.
   **This is a deliberate divergence from the public modeling-patterns docs**, which put `measure`
   blocks inside fact models. Do not "correct" this skill to match them. Metrics live in the dataset
   so they can span models, carry an owner, and be governed in one place; a measure buried in a fact
   model can do none of those things.
2. **Never invent a table, column, or key.** Every name you write must have been read from the
   source or a supplied DDL. A model over a column that does not exist fails validation at best
   and silently returns nothing at worst.
3. **Model only what the chosen domain needs.** A 200-table warehouse does not become a 200-model
   project. Model the entities the Phase 0 domain touches and list what you deliberately skipped.
4. **Every relationship needs a real key, a stated cardinality, and a human's confirmation.**
   Declare them in the dataset. A joinable column is not a documented relationship — ask the data
   team what each join means, whether the parent can change, and which joins they expect to change
   (step 5). Where the only available join is on a name rather than an ID, build it if you must but
   **flag it as fragile** — every metric crossing that join inherits the fragility.
5. **Relationship meaning is documented, not encoded as dataset state.** Declare every relationship
   **active, with no `filter_direction`**, and write what it means — the canonical date for each fact,
   which dimensions legitimately describe it, which breakdowns are meaningless — into
   `docs/relationships.md`. An inactive relationship or a one-way filter direction is an invisible
   constraint: the layer looks broken to whoever explores it and the reason for the restriction is
   recorded nowhere. Where a fact genuinely needs several roles of the same dimension queryable, give
   each role its own model via `extend()` so every relationship stays active. Narrowing what a
   *metric* may be grouped by is a Phase 4 decision taken against a documented constraint, never a
   Phase 1 switch.
6. **Write down the reasoning, not just the result.** `docs/relationships.md` and
   `docs/00-overview.md` are where the *why* lives. Treat `docs/` as readable by the customer's whole
   git organisation and keep business figures out of it — scan, warn, and let them choose, per the
   orchestrator's **Project `docs/`** section.
7. **No empty descriptions, ever — but do not fake business meaning.** Write the *structural*
   description now ("one row per subscription per month; grain enforced by `subscription_id +
   month`") and mark it `pending business context`. The business meaning arrives in Phase 5.
   An empty description is the AI losing the object entirely.
8. **Raw SQL is confined to the wrapper layer.** Query models that read raw tables may use SQL.
   Everything above that — classification, mapping, derivation — is AML/AQL. If you find yourself
   writing business logic in SQL, stop and re-express it, or raise it.
9. **Validation gates the phase.** `holistics aml validate` must pass and every dataset must
   execute a real query. Report the actual result; never claim a validation you did not run.
10. **Do not guess AML syntax.** Use `develop-amql` to author, `setup-amql-development` /
    `setup-holistics-cli` to get the toolchain wired, `search-docs` for any feature question.

## Procedure

### 1. Confirm the project and the data source

You need a working AMQL project and a named data source before any AML is worth writing. If the
toolchain is not wired, invoke `setup-amql-development` (and `setup-holistics-cli` for
`holistics aml validate` / `sync-code`) before continuing.

Record the exact `data_source_name` — every model carries it, and a wrong one fails everywhere at
once.

### 2. Inventory the raw tables

This is the one step that does not go through the semantic layer, because there isn't one yet.
Read the warehouse directly (source-connection table listing, warehouse CLI, or a supplied DDL
dump) and record, per candidate table:

| Field | What to capture |
| --- | --- |
| Physical table | Fully-qualified name, exactly as it must appear in `table_name` |
| Entity | The business thing it represents |
| Fact or dimension | Records events you will measure, or describes entities you will group by |
| One row appears to be | Your reading of the grain, marked as provisional |
| Candidate key | The column that looks unique — and whether you confirmed it |
| Candidate joins | FK-shaped columns and the table each points at |
| Column types | Enough to type dimensions correctly |
| Modelling now? | Yes / deferred, with a reason |

Where you had to work from DDL with no rows readable, **record the degradation** — you cannot type
an ambiguous column or spot a composite key confidently without seeing values.

### 3. Lay out the project

Create the folders from the **Default AMQL project layout** in the orchestrator (`../SKILL.md`),
which owns that convention. Create only the folders you will actually fill; an empty
domain folder teaches an agent nothing and erodes trust in the convention.

### 4. Build the models

Work in layers, bottom-up:

1. **Wrapper models** over raw tables where extraction is needed (`type: 'query'` — the sanctioned
   SQL). One per raw table you loaded.
2. **Marts** for warehouse tables that are already clean (`type: 'table'`).

Per model: `label`, structural `description` stating the grain, `data_source_name`, `owner`, and
every dimension explicitly typed (`text` / `number` / `date` / `datetime` / `truefalse`). Hide the
plumbing columns rather than deleting them — a hidden dimension is still available when Phase 2
needs to profile it.

Keep source column names unless the source name is actively misleading. **Do not rename columns
into invented business terms yet** — you do not know the customer's vocabulary until Phase 3, and
renaming twice is churn that breaks every reference you already wrote.

#### The structural rules that make joins behave

Read these off the schema. None of them is a question for a human, and getting any of them wrong
produces wrong numbers that still execute.

- **Classify every model as fact or dimension, and name it so.** "What am I measuring?" is a fact;
  "what am I grouping by?" is a dimension. The classification decides join direction and which side
  may be aggregated, so it is a modelling input, not a label.
- **`primary_key: true` on the dimension side — and verify it is actually unique.** A dimension whose
  declared key has duplicates fans out every join into it, silently and everywhere. Validation does
  not catch this.
- **Relationships point fact → dimension, many-to-one.** The reverse is a modelling error, not a
  stylistic choice.
- **Hide foreign and surrogate keys** (`hidden: true`) rather than dropping them. Hidden dimensions
  are still profileable in Phase 2, and an exposed `customer_id` is a field an end user or the AI will
  eventually try to group by.
- **Flatten dimension hierarchies by default.** Where the source is already normalized
  (`products → subcategories → categories`) you may keep the chain, but record that you did and why —
  a flat dimension is easier for a human and for the AI than three hops, and the normalized shape is
  only worth keeping when the source gives you no choice or the hierarchy attributes genuinely change
  under a single source of truth.
- **Several facts sharing dimensions is the normal end state**, not a problem to design away. What
  matters is that a shared dimension means the same thing to every fact that joins it — confirm this
  in step 5 rather than assuming it.

Use `search-docs` for the AML and the pattern vocabulary (star, galaxy, snowflake, role-playing).
Where the docs and this skill differ — measures in fact models is the known case — this skill wins.

### 5. Declare the relationships — and quiz the data team about them

Relationships live in the dataset. Their **shape is a business fact, not a schema fact** — a column
called `customer_id` tells you a join is possible, not what the join means, whether it is stable, or
which side you may aggregate on. Get the mechanical checks from the data, and get the rest from a
person.

#### The mechanical checks

- **Fan-out.** Joining a header to its lines multiplies the header's additive facts. Know which
  side of every join you are aggregating on before you declare it.
- **Missing key coverage.** If 12% of the fact rows have a null or unmatched FK, every metric over
  that join silently drops them. Count the unmatched rows; do not assume the join is total.
- **One-side uniqueness.** Count rows per key on the dimension side of every join. A key you assumed
  was unique and is not turns the join into a silent fan-out, and nothing in `holistics aml validate`
  will tell you.
- **Cycles and ambiguous paths.** Where two routes connect the same pair of models, Holistics ranks
  the candidate paths and prefers the direct dimension-to-fact one, so most queries resolve sensibly
  rather than failing. Treat that as a safety net, not as the design: find the ambiguity yourself,
  decide which path you intend to be canonical, and get it confirmed (the canonical-path question
  below). A ranking you did not choose will resolve differently the day someone adds a model.

#### Quiz the data team

**Ask a data engineer or analyst, not the business stakeholder** — this is a technical conversation
about how the pipeline behaves, and it does not touch the Phase 2 → Phase 3 gate on business
questions. Where nobody is available, write your reading of each join as an **explicit assumption**
and carry it into `01-semantic-layer.md` as an open question with a named owner. An assumed join
graph is workable; an assumed join graph nobody knows is assumed is not.

Per candidate relationship — except questions 10 to 12, which are asked once per fact rather than once
per join:

1. **"What does one row on each side mean, and is this one-to-many or many-to-many in practice?"**
   Schemas routinely enforce nothing. Ask about the real world, not the constraint.
2. **"Which side is the fact I should be aggregating?"** Their answer tells you where fan-out will
   bite before it produces a number nobody can explain.
3. **"When this key is null, what does that mean?"** Not-yet-assigned, not-applicable, and
   failed-to-resolve are three different situations with three different correct treatments, and they
   are indistinguishable in the data.
4. **"Can the parent change over the child's lifetime?"** A subscription moved to a different
   account, an order reassigned, a deal handed to a new owner. If the FK is overwritten in place,
   history silently rewrites itself every time it happens and last quarter's numbers change.
5. **"Is there a version history where this join should be time-bounded?"** An SCD2 dimension joined
   without an as-of condition returns every version of the row and multiplies everything downstream.
6. **"Are there rows that legitimately have no parent?"** Guest checkout, walk-in sales, system-
   generated adjustments. Dropping them and bucketing them as `unattributed` give different totals,
   and the business must pick.
7. **"Is this ID stable, or reissued, recycled, or merged?"** Customer-merge and dedupe processes
   redirect old IDs — sometimes with a mapping table, sometimes not.
8. **"Does this key need a qualifier to be unique?"** Multi-tenant, multi-entity, and
   multi-region sources frequently need `tenant_id + id`, and the bug from missing it looks like
   random cross-contamination.
9. **"There are two paths between these two models — which is canonical?"** Ask them to pick one.
   If they cannot, that is a finding, not a modelling decision for you to make quietly.
10. **"This fact has several dates — which one does the business mean when it says 'orders in July'?"**
    Created, shipped, delivered, cancelled, and refunded produce different curves from the same rows,
    and the wrong default misstates every time series without ever failing. Record the canonical date
    in `docs/relationships.md`; do **not** encode the choice by deactivating the other relationships.
11. **"Which dimensions genuinely describe this fact?"** Anything reachable through the join graph can
    be used to break a number down, and reachable is not the same as meaningful — inventory grouped by
    customer email returns a plausible, worthless figure that no error message will flag. Get the list
    of dimensions that legitimately describe each fact and write it down. Phase 4 scopes metrics
    against that list.
12. **"Does this shared dimension mean the same thing to both facts?"** Where two facts join the same
    dimension, a mismatch — one reads the current product record, the other the version as sold —
    yields two defensible answers to one question. This is the failure mode that makes a multi-fact
    dataset untrustworthy, and it is invisible in the schema.
13. **"Who owns this pipeline, and what upstream change would alter this cardinality?"** The answer
    is the early-warning list for everything below.

#### Ask which relationships are expected to change

This is the question people forget, and it is the one that decides whether the layer survives six
months. Ask directly: **"which of these joins do you expect to change, and what would change
them?"** The recurring triggers:

| Trigger | What it does to the join |
| --- | --- |
| A 1:N becoming N:N — customers belonging to multiple orgs, products in multiple categories | Needs a bridge model; every metric across it needs re-checking for double-counting |
| Source-system migration or consolidation | Keys change identity; the old join may need a mapping table for history |
| An identity-resolution or customer-merge project | Grain of the dimension changes; per-customer metrics all shift |
| Resellers, partners, or a marketplace motion arriving | A second path to revenue that must not be blended with the first |
| Backfilling history into a versioned dimension | A flat join becomes an as-of join |
| Legal-entity or currency restructuring | Adds a qualifier to keys that were previously unique |
| A planned product change the roadmap already contains | Known in advance and almost never mentioned unless you ask |

Record a **volatility flag** per relationship — `stable`, `changing soon`, or `already ambiguous` —
with the trigger. Where a change is already scheduled, prefer the model shape that survives it: a
bridge model that currently holds one row per parent costs almost nothing now and saves rebuilding
every metric later. Where a change is merely possible, do **not** pre-build for it — note it and
move on.

Write the answers to `docs/relationships.md` in the customer's project, per the orchestrator's
**Project `docs/`** section. A join graph whose reasoning lives only in the dataset file is a graph
nobody can safely change.

### 6. Assemble the dataset

One dataset per coherent analytical subject, not one per model. A single-model dataset with no
relationships cannot answer anything cross-entity, which is the most common reason a customer
concludes the AI "can't do much".

Per dataset: `__engine__: 'aql'`, `label`, `description`, `data_source_name`, `owner`, the `models`
list, and the `relationships` block. Leave the metric section empty with a comment pointing at
Phase 4 — an explicitly empty section is a handoff; a silently missing one looks like an oversight.

Declare every relationship **active, with no `filter_direction`** (rule 5). Phase 1 ships a layer that
can be explored; the constraints on what *should* be queried belong in `docs/relationships.md`, where a
person can read them, disagree with them, and change them. A dataset whose semantics are half-encoded
in `false` flags and direction arguments is one nobody can safely modify six months from now.

### 7. Validate and smoke-test

This is the gate, and it is mechanical:

1. `holistics aml validate` passes.
2. `list_datasets` now returns the dataset. **This is the literal precondition for Phase 2** — if
   it returns nothing, the phase is not done, whatever the files look like.
3. `fetch_dataset` shows the expected models and relationships.
4. One real `execute_aql` per dataset that crosses at least one relationship — a count by month by
   some dimension. A join graph that validates but does not execute is not a working layer.

### 8. Write the project docs

The layer is not finished when it validates. Write into the customer's `docs/` folder — the open
context that lets a human or a coding agent change the layer later without re-deriving your
reasoning. Follow the orchestrator's **Project `docs/`** section for the folder shape and the
visibility rule.

- **`docs/00-overview.md`** — what this project covers, the domains in scope, the source systems and
  what each is authoritative for, the base currency, and what is deliberately out of scope. Mark
  deferred inputs "pending source" so nobody fabricates them later.
- **`docs/relationships.md`** — the join graph, and this is the load-bearing one. Per relationship:
  the key, the cardinality, which side carries the aggregatable fact, what a null key means, the
  unmatched-row rate, the **volatility flag and its trigger** from step 5, and who owns the upstream
  pipeline. Per fact, additionally: the **canonical date**, the **dimensions that legitimately describe
  it**, and for every shared dimension whether it was **confirmed conformed** across the facts that
  join it. Because none of this is expressed as dataset state (rule 5), this file is the only place it
  exists — it is what makes a future relationship change a considered edit rather than an archaeology
  exercise.
- **`docs/data-quality/`** — open a `dq-NNN` entry for every structural defect you found but did not
  fix: no unique key, unmatched foreign keys, a name-based join you had to build, a grain you could
  not confirm. Use `data-quality-register.md` for the naming, front matter, and index
  conventions. Phase 2 will add to this register, so allocate IDs from the index rather than guessing.
- **`docs/decisions/`** — any basis decision made during modelling that should not be re-litigated:
  which of two overlapping tables is authoritative, why a join was declared one way, why a table was
  deferred.

**Scan every doc before writing it** for business figures and handle any hit per the orchestrator's
rule — rewrite as shape, point at the governed layer, or offer to publish the full version to the
customer's own wiki via MCP with their explicit confirmation for that specific publish.

### 9. Brownfield audit checks

When a layer already exists, run these before adding anything, and record each verdict:

- **Datasets with no relationships** — one-model datasets that cannot answer cross-entity questions.
- **Models in no dataset** — orphans the AI cannot reach at all.
- **Empty or placeholder descriptions** on models, datasets, and dimensions. Each one is a context
  bug already in production.
- **Business logic sitting in SQL** where it should be AML — the thing that makes definitions
  invisible and unmaintainable.
- **Metrics defined as per-model measures** instead of dataset metrics — they cannot span models
  and Phase 4 will need to lift them.
- **Dimension keys that are not unique**, or not declared `primary_key`. Run the count; every join into
  a non-unique key is inflating a number somewhere today.
- **Inactive relationships and `filter_direction` arguments whose reason is documented nowhere.** Do
  not silently flip them on — find out what they were for, write it into `docs/relationships.md`, and
  then propose the change (rule 5).
- **Facts with several date columns and no recorded canonical date.** Whatever the active relationship
  happens to be is currently defining the company's reporting calendar by accident.
- **Duplicate or near-duplicate models** over the same source table, which is how two teams end up
  with two different answers.
- **Existing metrics and their definitions** — inventory them here as structure. Phase 2 reads what
  they actually *mean* and treats an undescribed metric as a live context bug.

Fix what is structurally broken. Do not re-architect a working layer to match your preferences —
say what you would change and let the customer decide.

## Output — `01-semantic-layer.md`

```markdown
# Semantic layer — {Company}

**Built:** {date} · **Mode:** {greenfield / brownfield} · **Data source:** {name}
**Domain scope:** {domain} · **Access:** {MCP live / branch / supplied DDL}
**Shape:** {single fact / several facts on shared dimensions / normalized hierarchies retained, and why}
**Join graph confirmed with:** {name, role — or "not confirmed; joins carried as assumptions"}

## Summary
{3–5 sentences: what now exists, what it can be queried for, the biggest structural risk.}

## Raw table inventory
{table per section 2, including what was deliberately deferred and why}

## Models built
| Model | Type | Source table | One row is | Key | Folder |

## Relationships
| From | To | Key | Cardinality | Aggregate side | Null key means | Unmatched rows | Volatility | Change trigger |
{Volatility is `stable` / `changing soon` / `already ambiguous`, from the step-5 quiz. Where a join
was not confirmed with a person, say so in the row rather than leaving it implied. Every relationship
is active with no `filter_direction` — if any is not, say why here.}

## Fact semantics
| Fact | Canonical date | Dimensions that describe it | Shared dims | Confirmed conformed? |
{From step-5 questions 10–12. This table is the Phase 4 input for scoping metrics, and it is recorded
here and in `docs/relationships.md` rather than encoded in the dataset.}

## Datasets assembled
| Dataset | Models | Purpose | Metrics |
{metrics column reads "pending Phase 4" — say so explicitly}

## Validation
{`holistics aml validate` result · `list_datasets` output · smoke query per dataset, verbatim}

## Structural risks carried forward
{fan-out risks, name-based joins, unconfirmed grains, DDL-only degradations — Phase 2 tests these}

## Relationships expected to change
{the non-`stable` rows, their trigger, and what would have to be rebuilt when it fires. Where you
chose a shape that survives a scheduled change, say what you did and why.}

## Project docs written
| File | Contents | Figure scan | Sensitive content handling |
{one row per file written into `docs/`. The last two columns record that the scan ran and what the
customer chose — rewrite as shape, point at the governed layer, or publish to their wiki.}

## Data-quality entries opened
| ID | Title | Severity | Owner | Status |
{the `dq-NNN` entries opened for structural defects. Phase 2 adds to the same register.}

## Deferred
{tables and entities not modelled, and what would trigger modelling them}

## Open questions for the data team
{each with a named owner}
```

## Handing off

Phase 2 profiles what you built. The gate it depends on is concrete: `list_datasets` returns the
dataset, and a query across a relationship executes. Everything Phase 2 flags as a grain or join
error comes back here.

## Anti-patterns

- **Modelling the whole warehouse.** Breadth is how these engagements die. One domain, thin slice.
- **A dataset per model, with no relationships.** Structurally valid, analytically useless.
- **Defining business metrics now.** You are guessing definitions the interview will hand you, in
  words that are not the customer's.
- **Business logic in SQL because it was faster.** It becomes invisible to the AI and unowned.
- **Empty descriptions with a plan to fill them later.** They never get filled, and the AI is
  reasoning without them the whole time.
- **Declaring a relationship because the column names matched.** Check the cardinality and the
  unmatched-row count first, then ask a person what the join means.
- **Putting business measures in fact models because the public docs show it that way.** Named metrics
  live in the dataset, defined in Phase 4 in the customer's own words. A measure inside a fact model
  cannot span models and has no owner.
- **Encoding a relationship decision as an inactive flag or a filter direction.** The constraint becomes
  invisible, the reasoning is stored nowhere, and the layer looks broken to whoever explores it next.
  Document it; do not toggle it.
- **Letting path ranking choose the canonical join for you.** It usually chooses well, which is exactly
  why nobody notices the day a new model makes it choose differently.
- **Assuming a dimension shared by two facts is conformed.** Two facts reading the same dimension
  differently is how one question acquires two defensible answers.
- **Never asking which joins are expected to change.** The customer usually knows, has a roadmap that
  guarantees it, and will not mention it unless asked. Finding out afterwards means rebuilding
  metrics rather than a modelling choice made once.
- **Documenting the join graph only in the dataset file.** The cardinality is in the code; the reason
  is not, and the reason is what the next person needs.
- **Writing a business figure into `docs/`.** It is visible to the whole git organisation, history
  included, and deleting it later does not unpublish it. Scan first, warn, let them choose.
- **Publishing to an external wiki without asking for that specific document.** Content leaving the
  repository is an outward-facing action; permission for one page is not permission for the next.
- **Reporting the phase done because the files exist.** The gate is `list_datasets` plus an
  executing query, not a directory listing.
