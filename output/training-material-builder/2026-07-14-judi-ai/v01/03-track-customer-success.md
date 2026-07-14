# Track — Customer Success

**Who this is for:** Judi.ai Customer Success — the people who put client reporting together and answer
"how are our applications doing?" You **consume and build**, so this track goes all the way from reading
a KPI to building and sharing your own report.

**The one habit we want to build:** when a client question comes in, you **open the Judi Dataset**
first — not a spreadsheet.

## The 7 skills you'll leave with
| # | Skill | You'll be able to… |
|---|---|---|
| 1 | Read KPIs + ⓘ info icons | Trust the headline numbers and know exactly what each means |
| 2 | Ask AI | Type a plain-English question and get a chart |
| 3 | Filter (date, client) | Narrow any dashboard to a client and a period |
| 4 | Drill down / underlying data | See the applications behind a number |
| 5 | Cross-filter & drill-through | Click one chart to filter the rest |
| 6 | Explore + save a personal view | Build your own view and keep it privately |
| 7 | Share a report / link | Send a client-ready view to a colleague |

---

### 1 · Read KPIs + info icons
- **Skill:** Read a KPI tile and open its ⓘ to see the definition.
- **Hook:** "How many applications funded last month, and how much did we fund?"
- **Show:** the KPI row — **Total Applications**, **Funded or Agreement Signed Applications**,
  **Funded or Agreement Signed Loan Amount**, **Funded Rate**.
- **Now you try:** open the ⓘ on **Funded Rate** and read its definition aloud (funded ÷ all applications).
- **Docs:** https://docs.holistics.io/docs/guides/end-users

### 2 · Ask AI
- **Skill:** Ask a question in plain English instead of building anything.
- **Hook:** "Which month had the most funded applications this year?"
- **Show:** the Ask AI box; type the question; it returns a trusted chart from the Judi Dataset.
- **Now you try:** ask *"total requested vs funded loan amount by month this year."*
- **Docs:** https://docs.holistics.io/docs/guides/end-users
- **Note:** Ask AI only uses governed metrics — so the answer matches the glossary.

### 3 · Filter to your client and period
- **Skill:** Use dashboard filters (date, and — once multi-tenant is on — client/tenant).
- **Hook:** "Show me just this client, this quarter."
- **Show:** the date filter + the tenant filter on the dashboard header.
- **Now you try:** set the date filter to last quarter and read Total Applications + Funded Rate.
- **Gotcha:** today the trial is one tenant (vancity); the client filter becomes meaningful once
  the multi-tenant rollout lands.

### 4 · Drill down to the underlying applications
- **Skill:** Click a number → "view underlying data" to see the rows behind it.
- **Hook:** "Which applications make up that funded count?"
- **Show:** right-click a bar / KPI → **View underlying records** → the loan-application rows.
- **Now you try:** drill into last month's funded count and confirm the row count matches the KPI.

### 5 · Cross-filter & drill-through
- **Skill:** Click a segment in one chart to filter every other chart on the page.
- **Hook:** "When I click 'TermLoan', I want the whole dashboard to show only TermLoan."
- **Show:** click a product/industry bar → the KPI row and trend update.
- **Now you try:** click one month in the trend chart and watch the KPIs re-scope.
- **Gotcha:** when slicing by a **decision** attribute (auto-approval, gate, policy), use the
  **Applications (Current Decision)** metric so you don't over-count superseded decisions.

### 6 · Explore + save a personal view (you build here)
- **Skill:** Start an exploration from the dataset, pick fields/metrics, save it to your personal workspace.
- **Hook:** "I want my own 'funded amount by industry' view I can reopen weekly."
- **Show:** New exploration on the Judi Dataset → drag **Funded or Agreement Signed Loan Amount** +
  the business **industry** field → save to **My Workspace**.
- **Now you try:** build "Total Applications by month" and save it as *"My monthly volume"*.
- **Docs:** https://docs.holistics.io/docs/guides/end-users

### 7 · Share a report / explore link
- **Skill:** Share a saved view or an explore link with a colleague.
- **Hook:** "Send this client view to my teammate without exporting a CSV."
- **Show:** the Share button → copy explore link / add a viewer.
- **Now you try:** share your *"My monthly volume"* view with one teammate.

---

## The weekly habit
Every Monday: open the Judi Dataset, filter to last week, read **Total Applications**, **Funded Rate**,
and **Funded or Agreement Signed Loan Amount** — and post the funded amount in your team channel.
That single 60-second habit is the whole goal.

## Quick reference
- **Fund count / amount:** Funded or Agreement Signed Applications · Funded or Agreement Signed Loan Amount
- **Conversion:** Funded Rate · Auto-Approval Rate
- **Slicing by a decision?** switch to **Applications (Current Decision)**
- **What does this number mean?** the ⓘ icon, or `02-judi-metrics-glossary.md`
