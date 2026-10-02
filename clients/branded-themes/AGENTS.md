# Branded theme demos

Read `clients/AGENTS.md` first for the client-folder baseline.

Everything here is a **re-skin of the core ecommerce demo**: dashboard design + theme
only, reading the shared `demo_ecommerce_version_2` dataset. The pitch is "here is your
brand on our demo" — same numbers, prospect's visual identity. No models, no data
sources, no metric logic of its own.

## The one rule that matters

These folders are **read-only consumers** of the core ecommerce demo. Never edit
`demo_ecommerce_version_2`, the `ecommerce_*` models, or anything in
`01 demo ecommerce/` to make a branded demo look better. If a demo needs different
numbers, it is no longer a theme demo — raise it with the operator and move it to its
own top-level `clients/<company>/` folder.

## Working here

- Keep each client's work inside its own folder or file. A theme, block or colour change
  for one prospect must not leak into another.
- Take colours from the client's `design.md` tokens or `*.theme.aml` where they exist;
  avoid hardcoding hex values inline.
- Where a client has light/dark/midnight variants (see `buyco/`), a layout change to one
  usually belongs in all of them. Say which variants you changed.
- Titles marked "(Sample)" mean the numbers are the generic demo dataset, not the
  client's own. Keep that qualifier.
- Assume the core demo is scheduled today: a broken shared dataset breaks every folder
  here at once.

## Growing past one file

Per `clients/AGENTS.md`: a client with a single loose `.page.aml` can sit directly in
this folder, but **as soon as it has a second file, `git mv` them into
`branded-themes/<company>/`** as part of that change. `aarki/` is the worked example.

## AI context

Because these demos read the ecommerce dataset, the default ecommerce business context
in `settings/ai/context.aml` already describes their numbers correctly, and they need no
routing block. That is the *only* reason it is safe to skip the `context.aml` prompt
here. If a branded demo ever gains its own models, dataset or vocabulary, the exemption
ends — ask the operator about adding a route.

## Completion

`holistics aml validate` the files you changed, then confirm each affected dashboard
renders in Development.
