---
name: route-context-artifacts
description: Classify every piece of a customer's business context to the Holistics layer that actually enforces it — lean context.aml overview, governed metric/dataset/model descriptions, AI Skills, or discard — then emit the installable artifacts plus an audit trail. Use as Phase 5 of new-analytics-onboarding, or standalone when a customer has written a large business context document and needs to know where each part belongs, when AI answers use wrong formulas despite documented definitions, or when a context field has become an unmanageable monolith. Also trigger on 'where should this context go', 'restructure our context doc', 'context.aml too long', 'split up our context file', 'route this context', or 'my context doc isn't working'.
---

# Route and emit context artifacts

This is Phase 5 of `new-analytics-onboarding`. The method lives in the orchestrator's shared
references so that the sequenced path and this standalone entry point can never drift.

**Read `../new-analytics-onboarding/references/phase-5-route-context-artifacts.md` and follow it.**

Running the full engagement rather than this phase alone? Invoke `new-analytics-onboarding`
instead — it owns phase order, inputs, gates, and the engagement state file, and it reads this
same reference at Phase 5.
