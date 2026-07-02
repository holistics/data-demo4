---
name: localize-dashboard
description: Create a localized (translated) version of a Holistics canvas dashboard (.page.aml) that ALWAYS extends the original via AML Extend (Dashboard new = original.extend({...})) and overrides only the labels, sourced from a central dict.aml translation file. Use when the user asks to translate/localize a dashboard into another language (Spanish, French, etc.), make a multi-language dashboard, or "create a <language> version" of an existing dashboard.
---

# Localize a Holistics dashboard

Produce a localized `.page.aml` dashboard that **extends** the original with AML Extend
(`Dashboard new = original.extend({ ... })`) and overrides ONLY the user-facing text,
every label resolving through one `dict.aml` file — so a translation is edited in a single
place and the original's structure, layout, positions, settings and theme are inherited
(never duplicated).

**ALWAYS use `.extend()` — never copy the whole source file.** Extending means the
localized page stays in sync with the original automatically: add a block or move a tile
in the source and the localized copy inherits it. A full copy silently drifts. This is the
required output shape for both dashboards AND datasets.

ALWAYS follow `AGENTS.md`: develop AML with the holistics CLI/MCP, and run
`holistics aml validate` after every new/edited AML file.

## Mental model: 3 layers of text

A dashboard's visible text comes from three different places. They need different
techniques — diagnose which layer each piece of text belongs to:

1. **Dashboard chrome & explicit labels** — `title:`, VizBlock `label:`, `VizFieldFull.label`,
   `FilterBlock.label`, `MetricHeading.label`, gauge `settings.label`, and text passed to
   library Funcs (`block_ha_heading('…')`, `block_ha_page_header('…','…')`).
   → Override via `dict(...)` in the extending dashboard.
2. **Model/dataset-inherited names** — a viz field with NO explicit `label:` shows the
   model/dataset field label (e.g. "Status", "Sign Up At", "NMV (Net Merchandise Value)").
   → Add an explicit `label: dict(...)` on that viz field inside the block's `viz.extend({...})`.
3. **Auto-generated / data text** — metrics-catalog blocks that read `${dataset.metric.X.__meta__.name}`,
   and dimension **data values** (`United States`, `delivered`, `Female`).
   → Catalog: drive cells from `dict(...)` (or `extend` the dataset and translate metric `label`/`description` — never clone).
   → Data values: ONLY translatable via case-mapped dimensions in the model/dataset — flag this; it's a separate, larger task.

## Step-by-step

### 1. Read & inventory the source dashboard
- Read the whole `.page.aml` (large files: page through it). Find every label:
  `grep -nE "label:|title:" file.aml | grep -v "legend_label\|hide_label\|axis\|font"`.
- List the library Funcs used for headings/text and where they're defined
  (`grep -rln "block_ha_heading\|block_ha_page_header" --include=*.aml`).
- Note which blocks are **MarkdownViz** (their field `label:`s are used as `{{ col_totals.\`Label\` }}`
  binding keys — do NOT translate those field labels or you break rendering; translate the
  prose in `content:` instead).

### 2. Verify AML capabilities before bulk work (de-risk)
These are NOT all documented; confirm with a tiny throwaway file + `holistics aml validate`:
- `const dict = { key: { eng: '…', spa: '…' } }` and curried access `dict('key')('spa')`.
- `${dict('key')('spa')}` interpolation inside `@md` content.
- **Dashboard Extend**: `Dashboard new = original.extend({ block X: original.block.X.extend({ label: … }) })`.
- **Nested viz Extend**: `viz: original.block.X.viz.extend({ value: VizFieldFull { … } })` to relabel a viz field.
- `Dataset .extend({ metric x { label/description } })` (if extending a dataset for a catalog).
Delete the throwaway after. (All of these worked as of last run — Dashboard/viz Extend confirmed.)

### 3. Confirm scope & naming with the user (AskUserQuestion)
- **Scope:** display labels only / + model-inherited chart names / + data values. Effort differs ~5–10×.
- **Output style — ALWAYS extend, never copy:** the localized page is
  `Dashboard <orig>_<lang> = <orig>.extend({ … })`. Every in-scope label becomes
  `dict('key')('spa')`. The original stays untouched and its structure is inherited.
  - (Avoid unless asked) bilingual via `dict('key')(H.current_user.language)` — needs a `language`
    user attribute created in the Holistics **admin UI** (can't be declared in AML); the CLI always
    prints `Module 'current_user' has no item 'language'`. The user previously rejected this.
- **Naming:** e.g. `<original>_es` / `_spanish` / `_fr` / `_i18n`.
- **Note the trade-off:** a dashboard using AML Extend can no longer be edited in the UI builder —
  it must be maintained as code. Mention this if the user edits dashboards via the UI.

### 4. Write `dict.aml`
- One `const dict = { … }` keyed by a short slug, each value `{ eng, spa }`.
- Dedupe: identical English strings share one key. `eng` is the source-of-truth reference.
- Use triple-quoted `'''…'''` for values containing quotes/apostrophes/HTML.

### 5. Generate the localized dashboard as an Extend (NOT a copy)
Write a NEW file containing ONLY the extend — do not copy block bodies, the layout, positions,
settings or theme; all of that is inherited.

```
Dashboard <orig>_<lang> = <orig>.extend({
  title: dict('dashboard_title')('spa')
  description: dict('dashboard_description')('spa')

  // relabel a block (chrome label only):
  block country_filter: <orig>.block.country_filter.extend({
    label: dict('country')('spa')
  })

  // relabel a block AND a field inside its viz:
  block kpi_gmv: <orig>.block.kpi_gmv.extend({
    label: dict('gmv')('spa')
    viz: <orig>.block.kpi_gmv.viz.extend({
      value: VizFieldFull { ref: r(ds.gmv) label: dict('gmv')('spa') format { … } }
    })
  })
})
```

Rules:
- Include a `block X: <orig>.block.X.extend({ … })` entry **only** for blocks that have in-scope
  text. Blocks with no translatable text are inherited untouched — omit them.
- **Do NOT redeclare** the `view:`/`CanvasLayout`, block `position`s, `theme:`, or any `settings {}`
  you aren't translating — they inherit. (This is the whole point of extend.)
- **Do NOT redeclare project-global top-level defs** (`BlockTheme`s, etc.) — they live in the source
  project; redeclaring errors `Duplicated name`.
- Carry the original's `@tag(...)` annotation onto the new `Dashboard` if you want it tagged.

### 6. Handle the special cases (all inside `block X.extend({ viz: ….viz.extend({ … }) })`)
- **Nested viz field labels** (e.g. MetricKpi `value`, chart `x_axis`/`legend`): relabel via
  `viz: <orig>.block.X.viz.extend({ <field>: VizFieldFull { ref + label: dict(…) + format } })`.
  Always include `ref` + `format` in the re-declared field — a label-only field can pass validation
  but DROP the `ref` at RUNTIME → "Cannot read properties of undefined (reading 'model')".
- **Arrays** (`y_axis.series`, `fields:`, `rows:`, `columns:`, `values:`): partial array merge is
  unreliable — re-declare the WHOLE array block (every `series {}` with its `field` + `settings`)
  inside the `viz.extend({ … })`, translating the labels you need and copying the rest verbatim.
- **TextBlock / MarkdownViz `content: @md …`**: `content` is one blob — re-declare the entire content
  inside `block X.extend({ content: @md … })`, swapping hardcoded prose for `${dict('k')('spa')}`.
  Keep every `{{ … }}` and `col_totals.\`Label\``/`column="Label"` binding EXACTLY (they key off the
  untranslated field labels).
- **Metrics catalog block**: it hardcodes `${dataset.metric.X.__meta__.name}`. Override the block's
  cells inside `.extend({ … })` to read `${dict('cat_X_name')('spa')}` / `${dict('cat_X_desc')('spa')}`,
  add the `cat_*` keys to `dict.aml`.

### 6b. Localizing a dataset (same rule: extend, don't clone)
- If the scope includes model/dataset-inherited names or metric catalog text, create
  `Dataset <orig>_<lang> = <orig>.extend({ metric x { label: dict('k')('spa') description: … } })`
  and point the localized dashboard's blocks at the extended dataset. Never copy the dataset file.

### 7. Validate iteratively, filtering pre-existing noise
- After each file: `holistics aml validate`. This repo has heavy **pre-existing** noise from a broken
  model (`current_user.pii_access`) that cascades to every dataset/dashboard.
- Filter to YOUR new errors:
  `holistics aml validate 2>&1 | grep "<yourfile>" | grep -ivE "Expression is not evaluated to model|Cannot interpret file"`
- A clean result = empty. Watch specifically for: syntax/parse, `Duplicated name`, `cannot find`,
  and (if using the attribute approach) `has no item '<attr>'`.
- Validation does NOT catch every runtime issue (see FilledMap gotcha) — recommend a quick visual check.

### 8. Report
- State what's translated vs. not (esp. dimension **data values**, which stay in source language
  unless case-mapped dimensions are added — offer that as a follow-up).

<<<<<<< HEAD
## Quick reference — what to translate where (all via `.extend()`)
| Text | Override point | How |
|---|---|---|
| dashboard title / description | top of `.extend({ … })` | `title: dict('k')('spa')` |
| block / filter / metric-heading label | `block X: <orig>.block.X.extend({ label })` | `label: dict('k')('spa')` |
| heading/page-header Func args | `block X.extend({ … })` | `block_ha_heading(dict('k')('spa'))` |
| chart axis/legend/series field label | `block X.extend({ viz: ….viz.extend({ … }) })` | `VizFieldFull { ref + label + format }` (re-declare arrays fully) |
| MarkdownViz / TextBlock prose | `block X.extend({ content: @md … })` | `${dict('k')('spa')}`, keep `{{ }}` bindings |
| metrics catalog Name/Description | `block X.extend({ … })` | `${dict('cat_x_name')('spa')}` + `cat_*` keys |
| dataset/metric inherited labels | `Dataset <orig>_<lang> = <orig>.extend({ metric x { label } })` | point blocks at extended dataset |
| dimension data values (US, delivered, …) | model/dataset | case-mapped dimension (separate task) |
=======
## Quick reference — what to translate where
| Text | Where | How |
|---|---|---|
| title, block/field/filter labels, metric headings | dashboard | `dict('k')('spa')` |
| heading/page-header Func args | dashboard | `block_ha_heading(dict('k')('spa'))` |
| chart axis/legend/series name with no explicit label | dashboard | add `label: dict('k')('spa')` (re-declare arrays fully) |
| MarkdownViz prose | `content:` | `${dict('k')('spa')}`, keep `{{ }}` bindings |
| metrics catalog Name/Description | localized catalog block | `${dict('cat_x_name')('spa')}` + `cat_*` keys |
| dimension data values (US, delivered, …) | model/dataset | case-mapped dimension (separate task) |
>>>>>>> origin/dong-ln-dev
