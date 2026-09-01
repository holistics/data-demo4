---
name: verify-ai-context
description: Build a question bank from a customer's metric tree and traps, run it against Holistics AI, and score whether each answer used the right governed metric, stated the right basis, and flagged the right caveats — turning every AI guess into a specific, fixable context bug. Use as Phase 6 of new-analytics-onboarding, or standalone when a customer says the AI's answers are not trusted, when validating context changes, as a regression check after editing metrics or context.aml, or to produce evidence that an AI analytics POC succeeded. Also trigger on 'verify the context', 'test the AI answers', 'why is the AI wrong', 'regression test our metrics', 'context QA', or 'prove the AI is trustworthy'.
---

# Verify AI context

This is Phase 6 of `new-analytics-onboarding`. The method lives in the orchestrator's shared
references so that the sequenced path and this standalone entry point can never drift.

**Read `../new-analytics-onboarding/references/phase-6-verify-ai-context.md` and follow it.**

Running the full engagement rather than this phase alone? Invoke `new-analytics-onboarding`
instead — it owns phase order, inputs, gates, and the engagement state file, and it reads this
same reference at Phase 6.
