# Capability → Judi Example Map

Trainer reference. For any Holistics capability, the exact Judi Dataset (`test_v3`) example that shows
it best — so you can answer "show me where I'd use this" instantly with real data.

| Capability | Best Judi example | Metric / model / field to use |
|---|---|---|
| **Read KPIs + ⓘ info icons** | The funded headline row | Total Applications · Funded or Agreement Signed Applications · Funded or Agreement Signed Loan Amount · Funded Rate |
| **Ask AI (plain English)** | "Funded applications by month this year" | Funded or Agreement Signed Applications, `created_date_time` |
| **Filter — date** | Last quarter's volume | date filter on `etl_loan_application.created_date_time` |
| **Filter — client/tenant** | One client's numbers (post multi-tenant) | `etl_domain` / `tenant_identifier` |
| **Drill down / underlying data** | Applications behind the funded count | `etl_loan_application` rows |
| **Cross-filter** | Click a product → whole page re-scopes | `etl_product.name` (exclude test products) |
| **Drill-through** | Application → its adjudication detail | `etl_loan_application` → `etl_loan_adjudication` |
| **Explore + save personal view** | "Funded amount by industry" | Funded or Agreement Signed Loan Amount × business industry |
| **Share a report / link** | Client-ready monthly view | any saved explore |
| **Calculation — period-over-period** | Funded amount MoM % | Funded or Agreement Signed Loan Amount |
| **Calculation — % of total** | Product mix of funded amount | Funded amount by `etl_product.name` |
| **Correct grain — current decision** | Auto-approval by policy without over-count | Applications (Current Decision) + `etl_loan_adjudication` attributes |
| **Rates at non-application grain** | Gate pass / second look | Gate Pass Rate (gate grain) · Second-Look Approval Rate (adjudication grain) |
| **Coverage-aware averages** | Credit scores | Avg FICO/BNI/Intelliscore/Vantage **+** matching Hit Rate |
| **Funnel analysis** | Prequal → adjudicated → funded | Prequal Approved · Prequal Touched · Prequal Touch Rate · Prequal → Funded Rate |
| **Ops monitoring** | Bank-data reliability | Transaction Pull Success Rate · Avg Scraping Time (s) |
| **Delivery / alerts** | Monday client email; Funded-Rate drop alert | dashboard schedule / alert |
| **Governance — RLS (roadmap)** | Each client sees only their data | `etl_domain` / `tenant_identifier` scoping |

**Model quick map (the 20 models, by subject area):**
- **Loan Applications:** loan_application, loan_application_product, application_type, product, domain, page_visit
- **Credit Decision:** loan_adjudication, loan_adjudication_product, application_gated_metrics, metric, rejected_credit_model_explanation, policy, gate
- **Banking & Transactions:** bank_statement, transaction_pull, financial_account, financial_transaction, financial_transaction_metrics
- **Borrower & Business:** business, address (geography via `address.state_or_province_code`)
