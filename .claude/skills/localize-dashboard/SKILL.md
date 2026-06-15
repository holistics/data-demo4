---
name: localize-dashboard
description: Create a localized (translated) copy of a Holistics canvas dashboard (.page.aml) with all labels sourced from a central dict.aml translation file. Use when the user asks to translate/localize a dashboard into another language (Spanish, etc.), make a multi-language dashboard, or "create a <language> version" of an existing dashboard.
---

# Localize a Holistics dashboard

Produce a translated copy of an existing `.page.aml` dashboard whose user-facing
text all resolves through one `dict.aml` file, so a translation is edited in a
single place instead of hunting through dashboard code.

ALWAYS follow `AGENTS.md`: develop AML with the holistics CLI/MCP, and run
`holistics aml validate` after every new/edited AML file.

## Mental model: 3 layers of text

A dashboard's visible text comes from three different places. They need different
techniques — diagnose which layer each piece of text belongs to:

1. **Dashboard chrome & explicit labels** — `title:`, VizBlock `label:`, `VizFieldFull.label`,
   `FilterBlock.label`, `MetricHeading.label`, gauge `settings.label`, and text passed to
   library Funcs (`block_ha_heading('…')`, `block_ha_page_header('…','…')`).
   → Translate directly in the dashboard via `dict(...)`.
2. **Model/dataset-inherited names** — a viz field with NO explicit `label:` shows the
   model/dataset field label (e.g. "Status", "Sign Up At", "NMV (Net Merchandise Value)").
   → Add an explicit `label: dict(...)` on that viz field. No dataset clone needed.
3. **Auto-generated / data text** — metrics-catalog blocks that read `${dataset.metric.X.__meta__.name}`,
   and dimension **data values** (`United States`, `delivered`, `Female`).
   → Catalog: drive cells from `dict(...)` (or clone the dataset and translate metric `label`/`description`).
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
- `Dataset .extend({ metric x { label/description } })` (if cloning a dataset for a catalog).
Delete the throwaway after. (All of these worked as of last run.)

### 3. Confirm scope & naming with the user (AskUserQuestion)
- **Scope:** display labels only / + model-inherited chart names / + data values. Effort differs ~5–10×.
- **Output style (decide with the user):**
  - **Full-target-language page** (preferred here): one copy where every label is `dict('key')('spa')`. Original stays untouched.
  - (Avoid unless asked) bilingual via `dict('key')(H.current_user.language)` — needs a `language`
    user attribute created in the Holistics **admin UI** (can't be declared in AML); the CLI always
    prints `Module 'current_user' has no item 'language'`. The user previously rejected this.
- **Naming:** e.g. `<original>_es` / `_spanish` / `_i18n`.

### 4. Write `dict.aml`
- One `const dict = { … }` keyed by a short slug, each value `{ eng, spa }`.
- Dedupe: identical English strings share one key. `eng` is the source-of-truth reference.
- Use triple-quoted `'''…'''` for values containing quotes/apostrophes/HTML.

### 5. Generate the localized dashboard copy
- Copy the source file; rename the `Dashboard` object.
- **Remove duplicate top-level definitions** (`BlockTheme`s) that already exist in the source file —
  they are project-global; redeclaring them errors `Duplicated name`. Reference the originals instead.
- Replace each in-scope label literal with `dict('key')('spa')`. A line-number-driven Python script
  is reliable for the bulk (regex-replace the quoted string after `label:`/`title:`; full-line replace
  for Func-arg lines with 2 args like page headers).

### 6. Handle the special cases
- **Arrays** (`fields:`, `rows:`, `columns:`, `values:`, `y_axis.series`): if you translate a label
  inside an array, **re-declare the whole field with `ref` + `format` + `uname`/`settings`** — partial
  array merge is unreliable.
- **Singular nested fields that you only relabel** (e.g. FilledMap `location.field`): also fully
  re-declare `ref` + `format` (+ `primary_field`). A label-only override can pass validation but DROP
  the `ref` at RUNTIME → "Cannot read properties of undefined (reading 'model')".
- **MarkdownViz** (`content: @md …`): translate the hardcoded prose / `<p class="label">X</p>` text;
  keep every `{{ … }}` and `col_totals.\`Label\``/`column="Label"` binding EXACTLY (they key off the
  untranslated field labels).
- **Metrics catalog block**: it hardcodes `${dataset.metric.X.__meta__.name}`. Make a localized copy of
  the block whose cells read `${dict('cat_X_name')('spa')}` / `${dict('cat_X_desc')('spa')}`, add the
  `cat_*` keys to `dict.aml`, and point the dashboard's catalog block at the new Func.

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

## Quick reference — what to translate where
| Text | Where | How |
|---|---|---|
| title, block/field/filter labels, metric headings | dashboard | `dict('k')('spa')` |
| heading/page-header Func args | dashboard | `block_ha_heading(dict('k')('spa'))` |
| chart axis/legend/series name with no explicit label | dashboard | add `label: dict('k')('spa')` (re-declare arrays fully) |
| MarkdownViz prose | `content:` | `${dict('k')('spa')}`, keep `{{ }}` bindings |
| metrics catalog Name/Description | localized catalog block | `${dict('cat_x_name')('spa')}` + `cat_*` keys |
<<<<<<< local:.claude/skills/localize-dashboard/SKILL.md
| dimension data values (US, delivered, …) | model/dataset | case-mapped dimension (separate task) |
=======
| dimension data values (US, delivered, …) | model/dataset | case-mapped dimension (separate task) |
>>>>>>> cloud:.claude/skills/localize-dashboard/SKILL.md
