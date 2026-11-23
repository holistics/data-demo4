# Rockinfo embedded analytics PoC

Prospect: Rockinfo (rockinfo.com), a credentialing platform spanning Candidate, Learning,
Certification, Vouchers and Credentials modules. Rockinfo would embed Holistics in its app so
each **client** (a technology vendor running certification programs) sees only its own data,
and client editors can self-serve with governed metrics and AI.

## The data (synthetic)

Neon Postgres, project `holistics-demo-pocs` (aws-us-east-1), schema `rockinfo_demo`.
Data runs from Jan 2024 to 21 Nov 2026. Generated deterministically by
`database/seed_rockinfo.py` (seed 20261123).

| Table | Rows | Grain |
| --- | ---: | --- |
| clients | 9 | Tenant: Rockinfo's published customers |
| programs | 25 | Certification, Micro-credential, Learning Path |
| courses | 73 | Course inside a program |
| exams | 20 | Paid exam per certification program |
| partners | 106 | Training partners, resellers, corporate, academic, plus Direct per client |
| candidates | 28,100 | Learner, one acquisition partner |
| enrolments | 69,488 | Candidate x course |
| exam_attempts | 17,003 | Exam sitting (first attempt and retakes), booked with a voucher |
| credentials | 16,806 | Credential issued, including recertifications |
| vouchers | 23,386 | Exam voucher: redeemed, unredeemed (deferred revenue) or expired (breakage) |

Clients and test IDs for the embed token:

Tenants are Rockinfo's customers from the logo strip on rockinfo.com. Programs and all numbers
are synthetic and say nothing about any vendor's real certification results.

| `rockinfo_client_id` | Client |
| ---: | --- |
| 101 | Adobe |
| 102 | Lenovo |
| 103 | SonicWall |
| 104 | Axway |
| 105 | Nutanix |
| 106 | F5 |
| 107 | Gigamon |
| 108 | RStudio |
| 109 | Cloudinary |

Every client and Rockinfo internal users open the **same** portal, `rockinfo_client_portal`, and the
same dashboards. The token's `rockinfo_client_id` decides the data, and the data-driven header brands
the page with the client's name and colour (`rockinfo_clients.brand_color`).

Reseed: `NEON_DEMO_DATABASE_URL=... python database/seed_rockinfo.py --out /tmp/rockinfo --load`.
Holistics reads through the read-only role `holistics_reader`. Its credentials are in
1Password: Demo Databases → "Neon - Holistics demo PoCs (read only)".

## AML

- `models/`: one model per table, plus `rockinfo_credentials` (adds renewed-by and
  first-credential flags), `rockinfo_candidate_milestones` (first time each candidate
  registered, started, completed, sat an exam, certified) and `rockinfo_dates` (shared calendar).
- `datasets/rockinfo_credentialing.dataset.aml`: one governed dataset with 33 metrics, the
  `client_access` permission, dynamic cohort fields, and View Underlying Data record layouts.
- `datasets/rockinfo_cohort_sql.dataset.aml` over `models/rockinfo_cohort_sql_fact.model.aml`: the
  candidate journey cohort as one hand-built SQL query (monthly only, cohort size frozen in the query),
  same `client_access` permission. A comparison exhibit only: it feeds the *My Cohorts: Semantic Layer
  vs Hand-built SQL* My reports and nothing else.
- `dashboards/`:
  - `rockinfo_program_performance`: Overview, Learning & Certification, Vouchers & Revenue, Cohorts
    (KPIs compare the period with the same period a year earlier; candidate journey funnel; program
    scorecard; heat-scaled partner tables; *Act now* lists for recertification outreach and vouchers
    expiring in 90 days, which ignore the Activity Date filter because they are point in time)
  - `rockinfo_partner_detail`: drill-through destination (Partner)
  - `rockinfo_candidate_record`: drill-through destination (Candidate: searchable "Name (#ID)" picker, plus Program, Partner, Partner Type,
    Segment, Region, Course, Enrolment Status, Exam Result and Credential Status), a Matching candidates list and the single-record view
  - `rockinfo_how_to_use` and `rockinfo_glossary`: the host's **Rocky** left-nav section, open to every
    plan. How to use is the onboarding guide written as Rockinfo to its clients' new users, including
    what each plan unlocks; Glossary lists terms, statuses and every metric, with the exact definition
    interpolated from the dataset so it cannot drift
- `embeds/rockinfo_client_portal.embed.aml`: the one portal every client embeds, with AI enabled.
- `ai/rockinfo_context.aml`: everything Holistics AI knows about Rockinfo (vocabulary, tenant rules,
  metric definitions). `settings/ai/context.aml` only routes to it.

## Demo capabilities

- **Self-explaining dashboards**: every KPI, chart and table on all three dashboards carries a block
  `description`, shown as an info icon on its title. Keep it in client language when adding a block.
- **One dashboard, every tenant**: the same portal and dashboards show each client only its own data, and
  the header renders that client's name, industry and brand colour from data. No per-client copies.
- **View underlying data**: right-click any KPI or table value for record-level views
  (candidates, enrolments, attempts, credentials, vouchers).
- **Drill-through**: click a partner to open Partner Detail; click a candidate ("Name (#ID)") to open the Candidate Record, or search one by name or ID in its picker.
  A program, course, partner, segment or region also drills through to the Candidate Record's Matching candidates list.
- **Drill-down** (dataset breakdown groups): Program → Course; Segment → Partner Type → Partner → Candidate; Region → Country.
  Both pages name the selected partner or candidate in the header, and say "All partners" or prompt for a pick when none is chosen.
- **Dynamic cohorts**: Cohort Granularity (Week, Month, Quarter, Year) and Cohort Milestone
  (Started a course, Completed a course, Sat an exam, Certified) re-cut the candidate journey
  cohort. Partner Type, Segment and Region change who is in the cohort. The voucher cohort shows
  how quickly partner-bought vouchers get redeemed.
- **Semantic layer vs hand-built SQL**: every Creator (the admin and editor personas on Analytics Studio
  and Studio Enterprise) has a My report, *My Cohorts: Semantic Layer vs Hand-built SQL*, that shows the
  candidate journey cohort built both ways. Unfiltered they match. Filter Partner Type and the SQL version
  divides by the frozen full cohort; switch granularity and only the semantic version follows.
- **Self-service and AI**: the dataset is in the portal, so client editors can explore, build
  their own dashboards and ask AI, always through the same governed metrics and the same permission.
- **Plans**: each client buys Program Dashboards (included), Analytics Studio (add-on, per Creator seat)
  or Studio Enterprise (premium: publishing controls and Data protection, which restricts raw-row download
  to named people; every other plan lets everyone download); its admin (a tag, not a role)
  assigns Viewer, Creator or Publisher roles. All of it is embed-token fields; the embed host's Plans &
  permissions page shows who gets what.

See `docs/embed-payloads.md` for the token payloads and `docs/call-prep.md` for the call brief.
Work-in-progress notes between sessions live in `docs/handoff/`.
