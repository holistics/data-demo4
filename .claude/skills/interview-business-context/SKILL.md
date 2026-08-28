---
name: interview-business-context
description: Run a structured, hypothesis-driven interview to extract a customer's business context — business model, segments, the core commercial unit they count, ambiguous vocabulary, reporting conventions, trust hierarchy, and analytical traps — grounded in what their warehouse can actually support. Use as Phase 3 of new-analytics-onboarding, or standalone when a customer needs help articulating business context, filling in a context template, or preparing for an AI analytics kickoff. Also trigger on 'interview the customer', 'business context questions', 'kickoff questionnaire', 'help them document their business', or 'what should I ask on the context call'.
---

# Interview business context

Extract what the AI needs to know that the schema cannot tell it. Column names carry no
information about which of three revenue figures is the one the board looks at, or that
"active" means something different to the product team than to finance.

You are working from `02-data-inventory.md`. **Read it before you start.** Interviewing
without the profile produces frameworks the data cannot populate.

## How to conduct yourself

Bring the rigour of a top-tier strategy or Big-4 analytics engagement. That rigour is a set
of specific behaviours, not a tone of voice — adopt these:

- **Hypothesis first.** Never ask an open question you could ask as a sharp one. Not "how do
  you think about growth?" but "your schema shows self-serve and partner contracts as
  separate tables — I'd guess those are two different motions with different unit economics.
  Which one is the growth engine right now?" A wrong hypothesis is still faster than a blank
  one, because correcting it is easy and satisfying.
- **MECE decomposition.** When they name a total, decompose it into parts that are mutually
  exclusive and collectively exhaustive. Revenue splits into which segments? Do those sum to
  the total, exactly? If not, what's in the gap? The gap is always interesting.
- **Insist on numerator and denominator.** Every rate, ratio, and "per" metric gets both,
  explicitly. "Retention" is not a definition. "Accounts active in month N ÷ accounts active
  in month 0, by first-paid-month cohort, logo not revenue" is.
- **Apply the so-what test.** For every metric they name: what decision changes when this
  number moves? If nobody can answer, it is a vanity metric — record it as such and don't
  spend modelling effort on it.
- **Push to the second why.** "Churn went up" → why → "enterprise churn went up" → why →
  "the two largest logos didn't renew after their champion left". The third answer is where
  the useful metric lives.
- **Get the counter-example.** For every rule, ask what breaks it. "Revenue is net of
  refunds" — is that true for the partner channel too? Exceptions are where AI answers go
  wrong, and customers rarely volunteer them.
- **Separate fact from belief.** Note who said what and how confident they were. When the
  CFO and the Head of Product define "customer" differently, that is a finding to resolve,
  not an inconsistency to average out.

Two things to avoid. Do not perform expertise — no frameworks-for-their-own-sake, no
restating their business back to them at length. And do not accept the first answer to a
definitional question; the first answer is almost always the casual one, and the casual one
is what has been breaking their AI.

## Rules

1. **Ground every question in the profile.** Do not ask about CAC by channel if spend data
   does not exist. Instead, tell them it doesn't, and ask what they'd want if it did.
2. **Capture verbatim.** Record the customer's actual words, especially their vocabulary. Do
   not paraphrase "bottles" into "units" or "scans" into "transactions". Their words become
   the metric names, which is what makes the AI speak their language.
3. **Tag every statement with a provisional destination** as you capture it (see
   `../new-analytics-onboarding/references/routing-table.md`). You are not doing the final routing here, but tagging as
   you go makes Phase 5 mechanical rather than archaeological.
4. **Never write a formula into the context narrative.** When a customer gives you one —
   and they will — capture it as a **metric candidate** in a separate section, flagged for
   Phase 4. This is the discipline the whole engagement depends on.
5. **No current figures.** When they say "we're targeting 3× LTV:CAC by month 24", record
   that an LTV:CAC target exists, its exact numerator and denominator, and where the current
   target value is maintained. Do not record the value — it will change and the AI will
   confidently quote the stale one.
6. **Partial is fine.** 60–70% of these answers materially improves the AI. Do not stall an
   engagement waiting for a complete set. Mark gaps as open questions with owners.
7. **Timebox.** Send blocks A–D ahead of the call as homework; use live time for E–H, which
   need discussion. Two 60-minute sessions is the right shape.

## The interview

Eight blocks. Work through them in order — later blocks depend on earlier ones, particularly
D (the core unit), which almost everything else references.

### A. Business and positioning
1. In one or two sentences, what does the business do and who is it for?
2. What positioning should the AI reflect — and is there a common **misreading** to avoid?
   ("We are not a discount reseller"; "we are not a synthetic imitation of a spirit".) This
   negative framing is unusually valuable and customers rarely offer it unprompted.
3. House style: UK or US English? How should the brand and products be named?

### B. Model and segments
4. What are the distinct revenue motions, segments, or markets? Which of these must **never**
   be blended into one number without a caveat?
5. For each: the primary objective, and the **guardrail metric** decisions are judged against.
6. Does any channel or segment **not exist yet**, so the AI must not infer performance from
   empty data? (Cross-check against the profile — an empty table is one of these two things.)
7. What is the single biggest operating lever?

### C. Customers
8. Main customer segments and their core use cases or occasions.
9. Is there an oversimplified label you do **not** want every customer collapsed into?

### D. The core commercial unit
10. What is the one unit the business counts? A subscription, a seat, an active user, a scan,
    an order, a bottle. **This is the most important answer in the interview** — it anchors
    volume, retention, and unit economics.
11. What must be **excluded** from that count? Free and trial units, add-ons, internal and
    test accounts, gifts, cancelled units.
12. Which distinctions matter: gross vs net, paid vs free, per-account vs per-seat vs
    per-end-user? For each, does the team have a default, and do they know they're switching
    between them?
13. Do bundles or multi-unit packs need expanding into underlying units?

### E. Metrics and language
14. List the 5–15 everyday words the team uses that are ambiguous: "sales", "customers",
    "active", "retention", "efficiency", "growth", "LTV", "churn". For each, which governed
    metric should it map to? **Do this as a live exercise, not a homework question** — the
    disagreements that surface in the room are the point.
15. Where more than one definition of a metric exists, which is the default and what are the
    others called?
16. The headline north-star metric, and the main long-term target. Exact numerator and
    denominator, not the value.
17. Which metrics are guardrails (must not degrade) versus diagnostics (explain movement)?

### F. Time, currency, freshness
18. Reporting timezone. Default currency. Does the week run Mon–Sun or Sun–Sat?
19. Default comparison: year-on-year, prior period, or plan? Does it differ by audience —
    board vs weekly trading?
20. What counts as "this week" when the current week is incomplete?
21. Fiscal calendar — does the financial year start in January?

### G. Data and trust
22. Which source systems feed the warehouse? (Confirm against the profile.)
23. When two sources disagree, which wins for official and recognised numbers? This is
    usually finance, but say so explicitly.
24. Which datasets are endorsed today, and who endorses them?
25. What real-world constraints usually explain a dip **before** it is a demand problem?
    Outages, launch timing, data-freshness gaps, onboarding capacity, support backlog,
    stockouts, seasonality.

### H. Traps and guardrails
26. What analytical mistakes have you seen people — or your current AI — make that you want
    explicitly forbidden? Push for specifics; "being wrong" is not a trap, "comparing a
    partial month to a complete one" is.
27. Is there a strategic "don't" — something the business must not optimise itself into?
28. Which questions have you asked an AI where the answer was confidently wrong? **Ask this
    one directly.** Each answer is a ready-made verification case for Phase 6, and it is
    usually where the customer's distrust actually originated.

### Closing question
29. "If the AI could answer only three questions perfectly, which three?" Record verbatim.
    These become the first three verification questions and the definition of success.

## Output — `03-business-context-raw.md`

Structure by block, and keep the four sections at the end separate — they are what Phases 4
and 4 consume:

```markdown
# Business context (raw capture) — {Company}

**Interviewed:** {date} · **Participants:** {name, role} · **Sessions:** {n}
**Profile read:** 02-data-inventory.md @ {date}

## A–H  {captured answers, verbatim where it matters, attributed where sources differ}

## Metric candidates  ← feeds Phase 4
{every formula, definition, or counting rule they gave. One entry each, with their exact
words, the numerator/denominator if stated, exclusions, and which block it came from.
Do NOT resolve these here — Phase 4 does that.}

## Workflow candidates  ← feeds Phase 5 as AI Skills
{multi-step procedures: "how we evaluate a promotion", "how we do cohort analysis",
"our month-end revenue check". Anything with steps or a checklist.}

## Traps and guardrails  ← feeds Phase 5
{the do-not-do list, in their words}

## Verification seeds  ← feeds Phase 6
{Q28 answers, Q29's three questions, and any question they raised during the interview}

## Contradictions and unresolved definitions
{where participants disagreed, or where a stated rule conflicts with the profile.
Name both positions and the owner who must decide.}

## Open questions
{each with a named owner and why it matters}
```

## Anti-patterns

- **Accepting "it depends" and moving on.** It depends on *what*? That answer is the rule.
- **Writing the context document during the interview.** Capture raw; structure in Phase 5.
  Structuring too early loses the customer's phrasing, which is the valuable part.
- **Interviewing only the data team.** They know the tables; they often do not know which
  number the board argues about. Get at least one business stakeholder.
- **Skipping block H because it feels negative.** The traps section prevents more wrong
  answers than the entire positive framing combined.
