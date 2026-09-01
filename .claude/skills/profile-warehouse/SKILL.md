---
name: profile-warehouse
description: Profile a customer's warehouse through their semantic layer before interviewing them, producing an entity map, grain and coverage assessment, data-quality flags, and an "answerability ledger" of which business questions their data can and cannot support. Requires models and at least one dataset to already exist — build them with scaffold-semantic-layer first if list_datasets is empty. Use as Phase 2 of new-analytics-onboarding, or standalone when someone asks what their data can actually answer, whether their schema supports a metric, or wants a data-readiness assessment ahead of an AI analytics POC. Also trigger on 'profile the warehouse', 'what can our data answer', 'schema review', 'data readiness', or 'can we build metric X'.
---

# Profile the warehouse

This is Phase 2 of `new-analytics-onboarding`. The method lives in the orchestrator's shared
references so that the sequenced path and this standalone entry point can never drift.

**Read `../new-analytics-onboarding/references/phase-2-profile-warehouse.md` and follow it.**

Running the full engagement rather than this phase alone? Invoke `new-analytics-onboarding`
instead — it owns phase order, inputs, gates, and the engagement state file, and it reads this
same reference at Phase 2.
