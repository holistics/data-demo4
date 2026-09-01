# Consulting moves — the interview methods, as behaviours

Used by `interview-business-context`. Also worth reading before any live context call.

## Why this file exists

The instinct is to prompt an agent with "act as a McKinsey / Big-4 consultant." That buys
register — confident framing, structured output, an executive voice. It does not reliably buy
**behaviour**, and behaviour is what extracts a usable metric definition out of a vague answer.

Worse, consultant register without consultant rigour produces the characteristic failure of this
whole exercise: a beautiful MECE framework that the customer's warehouse cannot populate. It looks
like the best deliverable in the engagement and it is worthless.

So: name the moves, not the firm. Adopt the register if it helps the customer take the session
seriously; depend on the moves below for the actual work.

## The moves

### 1. Hypothesis first
Never ask an open question you could ask as a sharp one.

- Weak: "How do you think about growth?"
- Strong: "Your schema has self-serve orders and partner contracts in separate tables — I'd guess
  those are two motions with different unit economics, and that partner is the one with a sales
  cycle. Which is the growth engine this year?"

A wrong hypothesis is faster than a blank question, because correcting someone is easier and more
satisfying than composing an answer from nothing. Being wrong out loud is the technique, not a
failure of it.

### 2. MECE decomposition
When someone names a total, break it into parts that are **mutually exclusive** (no
double-counting) and **collectively exhaustive** (they reconstruct the parent).

Then run the sum test: do the parts actually add to the whole? If not, name the residual. The
residual is nearly always interesting — an unnoticed segment, a data gap, or a grain error.

### 3. Numerator and denominator, every time
The most valuable pedantry available to you.

- "Retention" → *of what, over what window, against what denominator, logo or revenue?*
- "Efficiency" → *which spend, divided by which outcome?*
- "LTV" → *cumulative what, per what, observed or forecast, over what horizon?*

Do not accept a metric name as a definition. Customers routinely use one word for three different
calculations and switch between them mid-sentence without noticing — which is precisely why their
AI is inconsistent.

### 4. The so-what test
For every metric: **what decision changes when this number moves, and who makes it?**

If nobody can answer, it is a vanity metric. Record it as considered-and-rejected rather than
arguing about it — the written rejection is what stops it coming back next quarter.

### 5. The second and third why
- "Churn is up." → why?
- "Enterprise churn is up." → why?
- "Our two largest accounts didn't renew after their champion left."

The third answer is where the useful metric lives — in this case something like champion-coverage
or single-threaded-account risk, which nobody would have named at the first level.

### 6. Get the counter-example
For every rule, ask what breaks it. "Revenue is net of refunds" — is that true for the partner
channel? For annual prepay? For the legacy plan?

Customers state rules as universal and mean them as typical. Exceptions are exactly where AI
answers go wrong, and they are almost never volunteered.

### 7. Separate fact from belief, and attribute both
Record who said what and how confident they were. When the CFO and the Head of Product define
"customer" differently, that is a **finding**, not an inconsistency to smooth over. It is often
the single most valuable thing the engagement surfaces, because it explains why two dashboards
have never agreed.

Do not resolve it yourself. Name both positions, name the owner who decides, and move on.

### 8. Quantify the shape, never the value
Ask about magnitude and direction — "is that a rounding difference or a third of the business?" —
because it tells you what to prioritise. Do **not** record the figure. Figures go stale and a
stale figure quoted confidently is indistinguishable from a hallucination.

### 9. Ground everything in the profile
Before every question about a metric, know whether the data supports it. Two good outcomes:

- It does → ask the definitional question.
- It does not → say so, and ask what they would want if it did. That answer becomes a
  data-acquisition ask, which is a genuine deliverable.

Never ask a question whose answer you cannot act on. It teaches the customer the session is
theatre.

### 10. Close the loop out loud
End each block by playing back the rule in one sentence and asking "have I got that right?"
Customers correct a concrete restatement far more readily than they volunteer a correction to an
open question. This is where you catch the misunderstanding that would otherwise ship into a
metric description.

## What not to do

- **Do not perform expertise.** No frameworks introduced for their own sake, no lengthy
  restatement of their own business back to them. It burns the goodwill you need for block H.
- **Do not accept the first definitional answer.** The first answer is the casual one, and the
  casual one is what has been breaking their AI.
- **Do not fill silence with a guess.** "I'm not sure" is a legitimate answer that becomes an
  owned open question. A soft guess becomes a wrong metric that someone trusts.
- **Do not interview only the data team.** They know the tables. They frequently do not know
  which number the board argues about, or which definition finance actually signs off.
- **Do not skip the traps block because it feels negative.** The do-not-do list prevents more
  wrong answers than the entire positive framing combined.
- **Do not design the metric tree in the room.** Capture raw, structure later. Designing live
  loses the customer's phrasing, and their phrasing is what makes the metric names work.
