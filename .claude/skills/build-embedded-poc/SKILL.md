---
name: build-embedded-poc
description: >-
  Stand up a customized embedded-analytics PoC demo for a prospect that wants to embed Holistics
  in its own product, like rockinfo-embed.pages.holistics.dev: database decision, prospect
  research, mock multi-tenant data, tenant-isolated dashboards with drill-through, council review,
  embed roles and plans, AI setup, a proto-hosted mock app, and Chrome testing. Use for "build an
  embed demo for <prospect>", embedded or white-label demos, or multi-tenant row-level security demos.
---

# Embedded PoC (pointer)

The method lives in the `holistics/onboarding-presales` repo, so it is maintained in one place.

1. Find a clone of it: `../onboarding-presales` next to this repo, or clone
   `https://github.com/holistics/onboarding-presales` there.
2. Read `.claude/skills/build-embedded-poc/SKILL.md` from that clone and follow it, loading its
   `references/` per phase. Copy the host app from its `assets/embed-host/`.
3. Build the prospect's work here, in `clients/<prospect>/`, under `clients/AGENTS.md` and this
   repo's `AGENTS.md`. Never write prospect work into `onboarding-presales`.

If no clone is reachable, say so and stop; do not reconstruct the method from memory.
`clients/rockinfo/` is the worked example.
