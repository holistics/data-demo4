---
name: scaffold-semantic-layer
description: >-
  Stand up the structural semantic layer a Holistics tenant needs before anything else can run — a laid-out AML project, models over the warehouse tables, declared relationships, and assembled datasets, validated and smoke-tested. Use as Phase 1 of new-analytics-onboarding, or standalone when a tenant is brand new and has no datasets yet, when someone asks how to model their warehouse tables in Holistics, when a dataset has no relationships and cannot answer anything cross-entity, or when an existing project needs a structural audit before metrics get built on top of it. Also trigger on 'create models', 'build a dataset', 'set up our semantic layer', 'model my warehouse tables', 'no datasets yet', 'define relationships', 'AML project structure', 'star schema', 'fact and dimension models', 'which date should the metric use', or 'how do I start a Holistics project'.
---

# Scaffold the semantic layer

This is Phase 1 of `new-analytics-onboarding`. The method lives in the orchestrator's shared
references so that the sequenced path and this standalone entry point can never drift.

**Read `../new-analytics-onboarding/references/phase-1-scaffold-semantic-layer.md` and follow it.**

Running the full engagement rather than this phase alone? Invoke `new-analytics-onboarding`
instead — it owns phase order, inputs, gates, and the engagement state file, and it reads this
same reference at Phase 1.
