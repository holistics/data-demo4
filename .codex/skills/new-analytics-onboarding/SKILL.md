---
name: new-analytics-onboarding
description: >-
  Codex wrapper for the local Claude skills that onboard a Holistics customer or prospect's AI analytics context: semantic-layer scaffolding, warehouse profiling, stakeholder interview, metric-tree definition, context routing, verification, and dashboard widget spacing. Use when Codex is asked to set up or improve Holistics AI business context, run an analytics onboarding engagement, split a large context document into enforceable Holistics artifacts, build or audit a new semantic layer, define governed metrics, verify AI answers, or author `.page.aml` dashboards with correct widget spacing.
---

# New Analytics Onboarding Wrapper

This is a thin Codex adapter. The source of truth is the local Claude skill set under:

```text
/Users/vincentwoon/repos/work/demo4/.claude/skills/
```

Do not duplicate those instructions here. Load the relevant Claude `SKILL.md` file completely, then follow it as the operative workflow.

## Required First Reads

1. Read `/Users/vincentwoon/repos/work/demo4/AGENTS.md`.
2. For end-to-end onboarding, read `.claude/skills/new-analytics-onboarding/SKILL.md`.
3. For a direct phase or utility request, read the matching Claude skill below.
4. When a Claude skill points to `../new-analytics-onboarding/references/*.md`, resolve that path from the Claude skill folder and read only the referenced file needed for the task.

## Claude Skill Map

| User intent | Claude skill to read |
|---|---|
| Run the full engagement, start or resume onboarding, coordinate phases | `.claude/skills/new-analytics-onboarding/SKILL.md` |
| Build or audit models, relationships, datasets, AMQL project structure | `.claude/skills/scaffold-semantic-layer/SKILL.md` |
| Profile the warehouse through Holistics datasets and create the answerability ledger | `.claude/skills/profile-warehouse/SKILL.md` |
| Interview stakeholders for business context and metric candidates | `.claude/skills/interview-business-context/SKILL.md` |
| Define north-star, driver tree, metric specs, governed metric descriptions | `.claude/skills/define-metric-tree/SKILL.md` |
| Route a context document into `context.aml`, governed object descriptions, AI Skills, and repo docs | `.claude/skills/route-context-artifacts/SKILL.md` |
| Build the question bank and verify Holistics AI answers | `.claude/skills/verify-ai-context/SKILL.md` |
| Size Holistics canvas dashboard widgets and set explicit filter defaults | `.claude/skills/holistics-widget-spacing/SKILL.md` |

## Codex Runtime Rules

- Treat the Claude skill body as authoritative after loading it.
- Keep phase order and gates in `new-analytics-onboarding`; do not restate or reorder them in phase work.
- Use Holistics CLI/MCP tools for AMQL work, as required by `AGENTS.md`.
- Run `holistics aml validate` after every new or edited AMQL file.
- If the work creates customer-facing AI Skills, emit them where the Claude skill says, not inside this wrapper.
