# Call brief: Rockinfo, Alex Beros (CTO)

23 Nov 2026, 02:00 UTC (13:00 Sydney), 45 min, Holistics Discovery Call (ANZ).
Rockinfo, 51-200 staff, AU number. Found us via "LLM Reporting Comparison". ISO 27001 certified.
Data store: "Database" (unspecified: confirm the engine).

## What he asked for, and what to show

| His priority | What to show in demo4 | Watch-outs |
| --- | --- | --- |
| 1. AI-first for admins and client editors; plain-English questions; build or change reports; governed metrics; can never reach another client's data | Portal as client 101 → Ask AI ("which partners have the most unredeemed vouchers older than 6 months?") → save to dashboard. Switch token to 102 and ask again. | Answers come from the same `rockinfo_credentialing` metrics and the same permission as the dashboards. |
| 2. Secure multi-tenant embedding: white-label, SSO via signed tokens, RLS per tenant | `docs/embed-payloads.md`: one portal, one dataset permission, `rockinfo_client_id` in a signed JWT. | Admin preview bypasses RLS. Demo with tokens, not the studio. |
| 2b. Single source of truth, metrics as code in version control | Open `rockinfo_credentialing.dataset.aml` and the Git history. Client-built dashboards are saved as AML too. | |
| 3. Predictable cost, not per client user; AI usage and caps | Embedded pricing, plus AI credits and caps. | Pricing: Vincent to lead. |
| 5. Compliance and US hosting of data, metadata and AI | SOC 2 (Year 5 audit, Prescient). US region `us.holistics.io`. | **Confirm before claiming:** ISO 27001 status; whether AI processing (OpenAI and Anthropic sub-processors) can be pinned to the US. Do not promise either on the call. |

## Demo flow (25 min)

1. **Framing (2 min)**: one governed model → many client tenants → dashboards, self-service and AI on top.
2. **Program Performance → Overview** as Adobe (101, `rockinfo_portal_adobe`): KPIs, monthly activity, partner leaderboard.
   Right-click Recognised Revenue → View Underlying Data → voucher records.
3. **Drill-through**: click a partner → Partner Detail (orders for invoice reconciliation) →
   click a Candidate ID → Candidate Record. This is the "single record" view from their brief.
4. **Learning & Certification**: course completion, pass rate by attempt, credential status,
   the recertification outreach list (expiring in 90 days).
5. **Vouchers & Revenue**: sales vs recognised vs deferred vs breakage; outstanding age; partner reconciliation.
6. **Cohorts**: candidate journey cohort. Switch Milestone from Certified to Sat an exam, and
   Granularity from Month to Quarter. Filter Partner Type to Corporate Account. Then the voucher
   redemption cohort: how fast partner stock is used.
7. **Tenant switch**: token for Lenovo (102, `rockinfo_portal_lenovo`, dark theme). Different
   programs, partners and branding, no Adobe data anywhere, AI included. These are Rockinfo's
   own customers, with synthetic numbers: say so up front.
8. **Self-service**: as a client editor, build a chart in Explore and save it to the org workspace.
9. **Code**: dataset AML, permission block, Git.

## Discovery questions

- Which database: Postgres, SQL Server, MySQL? One schema per client, or a shared schema with a tenant column?
- How many client tenants now and in 12 months? How many end users per client, and how many editors?
- Today's reporting: built in-house or another BI tool? What breaks?
- Client editors: who are they (program managers, finance)? What do they build today?
- AI: which questions must be right? Who signs off metric definitions?
- White-label depth: custom domain, theme per client, hiding Holistics branding?
- SSO: existing IdP? Is a signed token from their backend acceptable?
- US hosting: a contractual requirement for all clients, or US-based clients only? What do AU clients need?
- Timeline, decision process, budget owner. Who else evaluates (security review, procurement)?

## Cohort: why it fits Rockinfo

- **Time-to-certify by registration cohort** is a program health KPI that certification bodies
  report to boards. It shows whether a new course or exam change made candidates faster.
- **Voucher redemption by issue cohort** is a finance and partner question: how quickly bulk
  partner purchases turn into exam bookings, and how much will become breakage.
- **Recertification** is shown as a rate and an outreach list rather than a cohort. Keep it
  simple unless he asks.
