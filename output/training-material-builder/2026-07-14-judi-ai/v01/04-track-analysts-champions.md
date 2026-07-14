# Track — Analysts & Champions (Niina)

**Who this is for:** Niina and any analyst/power-user who will build reports for others and become the
team's first line of support. This track picks up where the CS track ends and goes into calculations,
delivery, and light modelling awareness.

**The one habit we want to build:** you're the person who turns "can we see X?" into a saved,
governed report — and who knows when a request belongs to the data model instead.

## The skills you'll leave with
Explore & save · custom calculations · build & share a dashboard · scheduled delivery & alerts ·
knowing the model well enough to extend it.

---

### 1 · Explore, then save to a workspace
- **Skill:** Full exploration — multiple metrics, dimensions from joined models, saved to a shared or personal workspace.
- **Hook:** "Build the funnel: applied → prequal approved → adjudicated → funded."
- **Show:** New exploration on the Judi Dataset using **Total Applications**, **Prequal Approved**,
  **Prequal Touched**, **Funded or Agreement Signed Applications** by month.
- **Now you try:** add **Prequal Touch Rate** and **Prequal → Funded Rate** as a conversion view.
- **Docs:** https://docs.holistics.io/docs/guides/calculations

### 2 · Custom calculations
- **Skill:** Period-over-period, % of total, running totals on top of governed metrics.
- **Hook:** "Funded amount this month vs last month, and MoM %."
- **Show:** add a period-over-period calc on **Funded or Agreement Signed Loan Amount**.
- **Now you try:** build "% of funded amount by product" (share of total) — and **exclude the test
  products** (`Bruce`, `Jeffry`, `test256`, `CreditCard2`, `VehicleLoan`) so the mix is clean.
- **Docs:** https://docs.holistics.io/docs/guides/calculations

### 3 · The credit-decision view — handle grain correctly
- **Skill:** Report decision outcomes without double-counting.
- **Hook:** "Auto-approval and gate-pass rates by product/policy."
- **Show:** use **Applications (Current Decision)** with adjudication attributes; use **Gate Pass Rate**
  (gate grain) and **Second-Look Approval Rate** (adjudication grain) as-is.
- **Now you try:** build **Auto-Approval Rate** and **In-Review Rate** by month; confirm they sum to 100%.
- **Gotcha:** the score averages (FICO/BNI/Intelliscore/Vantage) exclude no-hits; always show the
  matching **Hit Rate** next to them so consumers read coverage correctly.

### 4 · Build & share a dashboard
- **Skill:** Assemble saved explores into a dashboard, add filters, share with a team.
- **Hook:** "A client-reporting dashboard CS can reuse each month."
- **Show:** a canvas dashboard with the KPI row + trend + product mix + funnel, a date filter, and
  (later) a tenant filter.
- **Now you try:** publish it to a shared folder and add the CS team as viewers.

### 5 · Delivery & alerts (set up with the data team)
- **Skill:** Scheduled email/Slack delivery, data alerts, Google Sheets sync.
- **Hook:** "Email each CS lead their client's numbers every Monday 8am."
- **Show:** a schedule on the dashboard; an alert when Funded Rate drops below a threshold.
- **Now you try:** draft one schedule; confirm delivery mechanics with the data team.
- **Docs:** https://docs.holistics.io/docs/guides/end-users

---

## When a request belongs to the model, not a report
You're the triage point. Route these to the data team as backlog items rather than working around them:
- A metric or field that doesn't exist yet (add it once, everyone gets it).
- The **multi-tenant / row-level-security** rollout so each client sees only their own data.
- The **financial-transaction path** (currently the interim/legacy direct link) — moving to the
  pull-based path once the source FKs are cleaned.
- Repeated "can AI answer X?" gaps that could become a governed AI skill.

## Quick reference
- **Funnel:** Total Applications → Prequal Approved → Prequal Touched → Funded
- **Decisions (no double-count):** Applications (Current Decision) + adjudication attributes
- **Scores:** always pair Avg _Score_ with _Score_ Hit Rate
- **Clean product mix:** exclude the test products
- **Deeper:** the Custom Calculations handbook — https://docs.holistics.io/docs/guides/calculations
