# Client PoC folders

Everything under `clients/` belongs to a **named company's demo or PoC**. Read the
nearest `AGENTS.md` and any `README.md` / `design.md` / `docs/` in the specific
client folder before editing — those override this file within their scope.

## Layout — two kinds of client work

**`clients/branded-themes/`** — demos that are **only dashboard design + theme** and
still read the shared **ecommerce** dataset (`demo_ecommerce_version_2`). They are
re-skins: same numbers, prospect's visual identity. See
`branded-themes/AGENTS.md`.

**`clients/<company>/`** (top level) — clients whose demo does **not** run on ecommerce
data: their own warehouse, their own models, or another demo dataset. These need real
modelling decisions, not just styling.

| Folder | Data | Why it sits where it does |
|---|---|---|
| `dabble/` | `dabble_neon`, own `dabble_*` models | Own data source + `context.aml` routing |
| `brainstorm-apac/` | own seeded Postgres, own models | Own data source, RLS contract |
| `fanserv/` | `demo_finance_extended` | Finance dataset, not ecommerce |
| `iceye/` | `demo_finance` + `demo_finance_extended`, and one ecommerce re-skin | Client has non-ecommerce data, so it stays grouped here whole |
| `branded-themes/*` | `demo_ecommerce_version_2` | Theme + layout only |

**Which side does a new demo go on?** Check the datasets it references. Ecommerce
dataset only, with no models of its own → `branded-themes/`. Anything else → its own
top-level `clients/<company>/`. If a client has a mix, keep **all** of that client's
files together at top level rather than splitting them across both.

## Group a client's files into a folder once there is more than one

Loose `.page.aml` files directly in `clients/` or in `branded-themes/` are fine while a
client has exactly one. **The moment a client has two or more files, create a folder for
that client on the fly and move them all into it** — do this as part of whatever change
introduces the second file, rather than leaving it for later.

- Folder name: the company, lowercase, hyphenated (`aarki`, `iceye`, `sage-dental`).
- Move with `git mv` so history follows the file.
- Keep the existing filenames; do not rename files just because they moved.
- Then update the paths in any `AGENTS.md` validate command that referenced them.

Existing examples: `branded-themes/aarki/` (5 files) and `iceye/` (2 files).

## Baseline rules

Keep changes inside the client's own folder, namespace objects with the company name,
use that client's own data source where it has one, and never touch
`01 demo ecommerce/`, shared `library/`, `Datasets Library/`, or another client's
folder. Anything in `branded-themes/` is a **read-only consumer** of the core ecommerce
dataset — style the dashboard, never edit the dataset or its models to suit one demo.

## Always ask the operator about `settings/ai/context.aml`

`settings/ai/context.aml` is **tenant-wide**: it steers Holistics AI for everyone in
this workspace, and it holds the per-client routing blocks that tell the AI which
business vocabulary to apply. Work in a client folder routinely creates context the
AI has no way to know about.

**So whenever you add or change files in a client folder, ask the operator whether
that information should also go into `settings/ai/context.aml` before you finish.**

Prompt them specifically when the change involves:

- A **new client folder**, or the first PoC assets for a company that has no routing
  block in `context.aml` yet.
- **New or renamed** models, datasets or dashboards — the routing conditions match on
  names, titles and labels, so a rename can silently break a route.
- A **new or changed data source**, schema or table mapping.
- **Business vocabulary or metric definitions** (how a KPI is calculated, which date
  lens applies, what must never be summed or averaged).
- **New, moved or edited client skills** that the routing block should load, or ones
  it references that no longer exist. The client `AGENTS.md` owns their location.
- Anything that makes the client's context **diverge from the default ecommerce
  business context** in `context.aml` — which is the normal case for every top-level
  client folder, and normally *not* the case for `branded-themes/`.

How to raise it:

1. State plainly what changed and what `context.aml` currently says about it.
2. Propose the specific edit — the routing condition, the vocabulary rule, the skill
   reference — as a concrete diff, not a vague suggestion.
3. **Wait for the operator's decision. Do not edit `context.aml` as a side effect of
   client-folder work.** It changes live AI answers for every user in the tenant, so
   the operator decides whether and when to align.
4. If they approve, make the edit and run
   `holistics aml validate settings/ai/context.aml`.
5. If they decline, leave it — but say so in your summary so the drift is on record.

This applies in Holistics BI Development Studio mode and to any CLI session in this
repo. It runs in both directions: if `context.aml` already carries routes, skills or
rules for this client that the folder's own docs do not mention, flag that too.
