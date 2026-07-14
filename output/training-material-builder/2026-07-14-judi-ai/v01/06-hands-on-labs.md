# Hands-On Labs — Judi Dataset

Drop-in exercises, each on the real **Judi Dataset** (`test_v3`), grouped by capability with an answer
key so the trainer can validate. Pull any lab into any session.

> Answer keys describe the *shape* of the correct answer (which metric, which filter). Exact numbers
> depend on the data at session time — validate live.

## A · Read & trust (Ask AI + KPIs)
**A1 — Last month's funding.** Ask AI: *"How many applications funded last month and how much did we fund?"*
- *Answer key:* Funded or Agreement Signed Applications + Funded or Agreement Signed Loan Amount, date = last month.

**A2 — Definition check.** Open the ⓘ on **Funded Rate**. Write it in your own words.
- *Answer key:* funded/signed applications ÷ all applications, current filter.

**A3 — Spot the trap.** Ask AI: *"auto-approval rate by policy."* Then rebuild it with **Applications
(Current Decision)**. Do the numbers change?
- *Answer key:* yes — the plain count over-counts superseded decisions; current-decision is correct.

## B · Filter & drill
**B1 — Quarter view.** Filter to last quarter; read Total Applications and Funded Rate.
- *Answer key:* both KPIs re-scope to the quarter.

**B2 — Behind the number.** Drill into the funded count → view underlying records.
- *Answer key:* row count of loan-application records equals the KPI.

**B3 — Cross-filter.** Click one month in the trend; confirm the KPI row updates to that month.

## C · Build (CS + champions)
**C1 — Personal view.** Build "Total Applications by month," save to My Workspace as *My monthly volume*.

**C2 — Product mix.** Build "Funded or Agreement Signed Loan Amount by product," **exclude** test
products (`Bruce`, `Jeffry`, `test256`, `CreditCard2`, `VehicleLoan`).
- *Answer key:* ~12 real products remain (LOC, TermLoan, CreditCard, CebaMicroloan, CoLending, etc.).

**C3 — The prequal funnel.** Build Prequal Approved → Prequal Touched → Funded by month, add
Prequal Touch Rate and Prequal → Funded Rate.

## D · Scores & coverage (champions)
**D1 — Score with coverage.** Show Avg FICO Score next to FICO Hit Rate by month.
- *Answer key:* two series; hit rate explains any average that looks thin.

**D2 — Sparse warning.** Add Avg Intelliscore Plus. Why is it noisy?
- *Answer key:* ~1.2k-app coverage — small sample; caveat before quoting.

## E · Decision & ops (champions)
**E1 — Rejection reasons.** Use Rejection Reasons (count), sliced by the explanation name — find the top 3.

**E2 — Bank-data health.** Show Transaction Pull Success Rate and Avg Scraping Time (s) by month.

## F · Share & deliver
**F1 — Share.** Share your *My monthly volume* view with a teammate (viewer or explore link).

**F2 — Schedule (with data team).** Draft a Monday 8am email of the client dashboard; confirm
delivery mechanics with the data team.
