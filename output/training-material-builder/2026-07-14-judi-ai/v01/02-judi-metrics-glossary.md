# Judi Dataset — Metrics Glossary

Every headline metric in the **Judi Dataset** (`test_v3`), in plain English, with its exact definition
and the trap to watch for. This is the single most important handout — read it before trusting a number.

> **Two gotchas everyone must know**
> 1. **One application can have many credit decisions over time.** If you slice a plain application
>    count by an *adjudication* attribute (auto-decision outcome, policy, gate…), the default join
>    counts every superseded decision and **over-counts**. When you want "the decision that counts",
>    use **Applications (Current Decision)** — it pins each application to its most-recent adjudication.
> 2. **Credit scores are partial and come from different bureaus.** Every score average **excludes
>    nulls / no-hits (0)**, so it's an average of *scored* applications only. Some scores are sparse
>    (Intelliscore / VantageScore ≈ 1.2k apps); the matching **Hit Rate** tells you the coverage.
>    Also: this trial is **one tenant (vancity)** and the product catalog still contains test rows
>    (`Bruce`, `Jeffry`, `test256`…) — filter those out for clean product reporting.

**Status codes used below:** `500` = Funded, `404` = Agreement Signed. `auto_decision_outcome` ∈
{Approved, InReview}. `pre_qualification_outcome` / `appeal_outcome` ∈ {Approved, Denied}.
`second_look_status`: 1 = Approved, 2 = InReview.

---

## Volume & value (headline)

### Total Applications
The number of loan applications in view.
**Defined as:** `count(etl_loan_application.id)`.
**Gotcha:** respects your dashboard/date filters. Safe to slice by *application* attributes; be careful
slicing by *adjudication* attributes (see gotcha #1).

### Funded or Agreement Signed Applications
Applications that reached the money — funded or with a signed agreement.
**Defined as:** `count(...id)` where `application_status in [500, 404]`.
**Gotcha:** counts both Funded (500) and Agreement Signed (404) together.

### Total Requested Loan Amount
Total dollars applicants asked for.
**Defined as:** `sum(requested_loan_amount)`. Format `$`.
**Gotcha:** *requested*, not approved — pair with the funded amount to see the gap.

### Funded or Agreement Signed Loan Amount
Total dollars actually funded / signed.
**Defined as:** `sum(loan_amount)` where `application_status in [500, 404]`. Format `$`.
**Gotcha:** uses `loan_amount` (the booked figure), not `requested_loan_amount`.

### Avg Requested Loan Amount / Avg Funded Loan Amount
Average requested, and average funded/signed, per application.
**Defined as:** `avg(requested_loan_amount)` · `avg(loan_amount) where status in [500,404]`.

---

## Funnel & conversion

### Applications (Current Decision)
Counts each application against **only its most-recent adjudication** — the anti-double-count metric.
**Defined as:** `count(id)` with the relationship re-pointed to `loan_adjudication_id` (current) and
the default collection join switched off.
**Gotcha:** use *this*, not Total Applications, whenever you slice by an adjudication attribute.

### Funded Rate
Share of all applications that funded/signed.
**Defined as:** `funded_or_signed / total_applications`. Format `%`.

### Auto-Approval Rate
Of applications the system auto-decisioned, the share initially **Approved**.
**Defined as:** `Approved / (Approved + InReview)` on `auto_decision_outcome`. Format `%`.
**Gotcha:** denominator excludes applications that were never auto-decisioned.

### In-Review Rate
The complement of Auto-Approval Rate — share routed to manual review.
**Defined as:** `InReview / (Approved + InReview)`. Format `%`.

### Appeal Approval Rate
Of applications with an appeal decision, the share approved on appeal.
**Defined as:** `Approved / (Approved + Denied)` on `appeal_outcome`. Format `%`.
**Gotcha:** only counts applications that actually had an appeal.

---

## Pre-qualification funnel

### Prequal Approved
Applications with a pre-qualification outcome of Approved.
**Defined as:** `count(id) where pre_qualification_outcome == "Approved"`.

### Prequal Touched (Adjudicated)
Prequal-approved applications that went on to a main adjudication.
**Defined as:** prequal Approved **and** `auto_decision_outcome in [Approved, InReview]`.

### Prequal Touch Rate
Share of prequal-approved applications that became adjudicated.
**Defined as:** `Prequal Touched / Prequal Approved`. Format `%`.

### Prequal Funded
Prequal-approved applications that reached Funded / Agreement Signed.
**Defined as:** prequal Approved **and** `application_status in [500, 404]`.

### Prequal → Funded Rate (of Touched)
Of prequal-approved apps that were touched, the share that funded.
**Defined as:** `Prequal Funded / Prequal Touched`. Format `%`.

### Prequal Approval Rate
Of applications with a pre-qualification outcome, the share approved.
**Defined as:** `Approved / (Approved + Denied)` on `pre_qualification_outcome`. Format `%`.

---

## Credit scores (bureau)

> All averages **exclude nulls and 0** (missing / no-hit). VantageScore also excludes exception codes
> 1–3. Report as aggregates, not per-row. Pair each average with its **Hit Rate** for coverage.

### Avg FICO Score — coverage ≈ 40k apps
Average FICO (via Equifax; business-owner personal credit).
**Defined as:** `avg(fico_score) where fico_score > 0`.

### Avg BNI Score (Equifax Business) — coverage ≈ 40k
Average Equifax Business Navigator Index (commercial credit).
**Defined as:** `avg(bni_score) where bni_score > 0`.

### Avg Intelliscore Plus (Experian Business) — sparse ≈ 1.2k
Average Experian Intelliscore Plus (commercial credit).
**Defined as:** `avg(intelliscore_plus) where > 0`.
**Gotcha:** small sample; confirm 998/999 no-score handling with Engineering before quoting externally.

### Avg VantageScore — sparse ≈ 1.2k
Average Experian VantageScore (business-owner personal credit).
**Defined as:** `avg(vantage_score) where vantage_score > 3` (excludes exception codes 1–3).

### FICO / BNI / Intelliscore / VantageScore Hit Rate
Share of pulls for that bureau that returned a **valid** score.
**Defined as:** `count(score > 0 [>3 for Vantage]) / count(score >= 0)`. Format `%`.
**Gotcha:** this is *coverage*, not credit quality — a low hit rate means many no-hits, not bad credit.

---

## Policy, gates & decisioning

### Gate Pass Rate
Share of evaluated credit-policy gates that passed.
**Defined as:** `count(gated_metrics where passed) / count(gated_metrics)`. Format `%`.
**Gotcha:** gate/adjudication grain — not one row per application.

### Rejection Reasons (count)
How many rejected-credit-model explanation records exist.
**Defined as:** `count(rejected_credit_model_explanation.id)`.
**How to use:** slice by the explanation name / severity to see the **top rejection reasons**.

### Second-Look Approval Rate
Of adjudications sent to second look, the share approved.
**Defined as:** `count(second_look_status == 1) / count(second_look_status in [1,2])`. Format `%`.
**Gotcha:** adjudication grain, not application grain.

---

## Banking & operations

### Transaction Pull Success Rate
Share of attempted bank-data pulls that succeeded.
**Defined as:** `count(status_code == 0) / count(status_code >= 0)` on transaction pulls. Format `%`.

### Avg Scraping Time (s)
Average transaction-pull scraping time in seconds.
**Defined as:** `avg(elapsed_scraping_time)`.

---

*All definitions above are taken verbatim from the `test_v3` metric definitions (source of truth), not
from memory. If a metric's meaning ever looks off in a chart, check it here first before assuming the
number is wrong.*
