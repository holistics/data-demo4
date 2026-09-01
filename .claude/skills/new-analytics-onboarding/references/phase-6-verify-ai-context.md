# Verify AI context

Emitting artifacts is not the deliverable. **Trust is the deliverable**, and trust is earned by
asking the AI real questions and showing that the answers hold up.

This phase reframes vague dissatisfaction — "the insights feel disjointed", "we don't fully trust
it yet" — into a list of specific context bugs with specific fixes. Every place the AI guesses is
a bug in a named layer, and every bug routes back to a destination from Phase 5.

Input: `04-metric-tree.md`, `04-metric-specs/`, `05-routing-map.md`, and the **Verification
seeds** section of `03-business-context-raw.md`.

## Rules

1. **Do not grade your own homework loosely.** A wrong-metric answer that reads well is still a
   failure. Score against the spec, not against plausibility.
2. **Capture the reasoning, not just the answer.** You need the AQL the AI generated and which
   metric it reached for. An answer that lands on the right number via the wrong formula will
   break next month, and it is a failure now.
3. **Report the real result.** Never claim a pass rate you did not measure. A 60% first-run pass
   rate honestly reported is a good engagement; a fabricated 95% is a lost customer.
4. **Every failure gets a routed fix.** Not "improve the context" — name the destination, the
   object, and the text to change.
5. **Re-run after fixing.** A fix that is not re-verified is a hypothesis.

## Procedure

### 1. Build the question bank

Generate questions from five sources. Aim for 25–40 total, of which 10–15 cover T0 metrics.

**a. From the customer, verbatim (highest priority).** The three questions from interview Q29,
and every question from Q28 where the AI was previously confidently wrong. These decide whether
the customer believes you. Put them first.

**b. One or more per T0 metric.** A direct question ("what was net revenue last month?"), and a
question using each **alias** ("how were sales last month?") to confirm the everyday word
resolves to the governed metric.

**c. Ambiguity probes.** Ask using a deliberately ambiguous word where two definitions exist. The
correct behaviour is usually to name the metric used, or to ask which the user meant when the
choice would materially change the answer — *not* to silently pick one.

**d. Trap questions, one per trap.** From interview block H and the metric-tree guardrails.
These are adversarial by design:
- a partial-period comparison ("how's this month vs last month?" mid-month);
- a cross-segment blend ("what's our overall CAC?" when segments must not be blended);
- a multi-currency sum;
- an attribution-summing question ("total revenue from our ad platforms?");
- a cohort question on an immature cohort;
- a metric on a stale source ("what happened yesterday?" on a table that lands 3 days late);
- a request for a current target ("what's our LTV:CAC goal?") — the AI should retrieve it from
  governed data, not quote a figure from context.

**e. Negative-space questions.** Something the data genuinely cannot answer. Correct behaviour is
saying so. Confidently answering an unanswerable question is the most damaging failure mode
there is, and it is the one customers remember.

For each question record: the question, the **expected metric**, the **expected basis**, the
**required caveats**, and the **failure modes to watch for**.

### 2. Run

Ask each question through the customer's actual Holistics AI — the same surface their users will
use, with the same context installed. Capture the full answer, the generated AQL, the metrics and
datasets referenced, and any skill loaded.

Run against the real tenant, not a local approximation. Local agents reading markdown behave
differently from in-product AI reading governed objects; a pass locally is not a pass.

### 3. Score

Five independent checks per question. Partial credit is meaningful — record each separately.

| Check | Pass condition |
| --- | --- |
| **Right metric** | Used the governed metric, not a reconstruction from raw fields |
| **Right basis** | Stated date range, comparison, segment scope, currency, and which cut (gross/net, paid/free) |
| **Caveats** | Flagged partial periods, immature cohorts, stale data, coverage gaps |
| **Traps avoided** | Did not commit the failure mode the question baited |
| **Honest limits** | Said so when the data could not answer; asked when ambiguity was material |

Verdict per question: **pass** / **partial** / **fail**. Any wrong metric or committed trap is a
**fail**, regardless of how good the prose was.

### 4. Diagnose — every failure is a routed bug

This is where the phase earns its place. Map each failure to a cause and a destination:

| Symptom | Cause | Fix destination |
| --- | --- | --- |
| Invented a formula | Definition exists only as prose, or not at all | `metric.definition` + `description` |
| Used a near-neighbour metric | Missing "never confuse with" in the description | `metric.description` |
| Right number, wrong route | Metric not discoverable — bad name, no description | `metric.label` / `description` |
| Blended segments | Do-not-blend rule missing or too weak | `context.aml` segments section |
| Wrong currency or timezone | Convention missing | `context.aml` conventions |
| Compared partial to complete | Period rule missing | `context.aml` conventions + trap skill |
| Summed attributed revenue | Diagnostic-vs-guardrail distinction missing | `metric.description` |
| Quoted a stale target | A figure survived Test 1 in Phase 5 | Remove from artifact; point at governed source |
| Right metric, right basis, wrong number | Not a context bug — a known data defect | Cite the `dq-NNN` entry; fix belongs to the pipeline owner, not the context. Add the caveat to the metric description in the meantime |
| Answered an unanswerable question | Coverage limit not stated | `dataset.description` + ledger |
| Ignored a documented rule | Rule is in a suggestion layer, needs enforcement | Re-route prose → governed object |
| Skipped a procedure | Skill not loaded — description doesn't match how people ask | AI Skill `description` |

The last two rows are the pattern to watch for. **A rule that is documented and still ignored is
almost always in the wrong layer.** That is not a wording problem; re-route it.

### 5. Fix, re-run, report

Apply fixes at the diagnosed destination. Re-run the failed subset plus a sample of passes (to
catch regressions). Two or three rounds is normal.

**Gate:** T0 pass rate ≥ 80%, and **zero** committed traps on the customer's own Q28/Q29
questions. Those are the questions that broke trust originally; they must pass.

Below the gate, do not declare success. Report the rate, the remaining bugs, and what unblocking
them needs — often data acquisition rather than context work, which is a legitimate and useful
finding.

## Output

### `06-question-bank.md`

```markdown
# Question bank — {Company}

| # | Question | Source | Tier | Expected metric | Expected basis | Required caveats | Failure modes |
|---|---|---|---|---|---|---|---|
```

### `06-verification-report.md`

```markdown
# Verification report — {Company}

**Run:** {date} · **Round:** {n} · **Surface:** {tenant / env}

## Result
| Tier | Questions | Pass | Partial | Fail | Rate |
|---|---|---|---|---|---|

**Customer's own questions (Q28/Q29): {n}/{n} pass** ← the number that matters most

## Per-question detail
{question, answer summary, AQL used, metric referenced, five checks, verdict}

## Context bugs found
| # | Symptom | Cause | Fix destination | Fix applied | Re-verified |
|---|---|---|---|---|---|

## Still failing
{each with the blocker, and whether it needs context work or data acquisition}

## Round-over-round
{pass rate by round — this trend is the evidence the engagement worked}
```

## Using this as a regression suite

The question bank is durable. Re-run it whenever a metric definition changes, a new data source
lands, `context.aml` is edited, or a new team starts using the AI. Keep it in the customer's repo
so the loop survives the engagement — a context layer with no regression suite decays quietly,
and the decay only surfaces when someone stops trusting an answer.

## Anti-patterns

- **Only asking easy questions.** A bank with no traps and no negative-space questions produces a
  meaningless pass rate.
- **Scoring on plausibility.** Check the AQL. A good-sounding answer from the wrong metric is the
  failure this phase exists to catch.
- **Fixing by adding prose to `context.aml`.** The default reflex, and usually wrong — if a rule
  was already documented and ignored, more prose in the same layer will be ignored too.
- **Declaring success at 60% because the customer seemed happy.** They will not stay happy.
- **Not re-running.** An unverified fix is a hypothesis.
