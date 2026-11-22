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
- `dashboards/`:
  - `rockinfo_program_performance`: Overview, Learning & Certification, Vouchers & Revenue, Cohorts
    (KPIs compare the period with the same period a year earlier; candidate journey funnel; program
    scorecard; heat-scaled partner tables; *Act now* lists for recertification outreach and vouchers
    expiring in 90 days, which ignore the Activity Date filter because they are point in time)
  - `rockinfo_partner_detail`: drill-through destination (Partner)
  - `rockinfo_candidate_record`: drill-through destination (Candidate: searchable "Name (#ID)" picker), the single-record view
- `embeds/rockinfo_client_portal.embed.aml`: the one portal every client embeds, with AI enabled.
- `ai/rockinfo_context.aml`: everything Holistics AI knows about Rockinfo (vocabulary, tenant rules,
  metric definitions). `settings/ai/context.aml` only routes to it.

## Demo capabilities

- **One dashboard, every tenant**: the same portal and dashboards show each client only its own data, and
  the header renders that client's name, industry and brand colour from data. No per-client copies.
- **View underlying data**: right-click any KPI or table value for record-level views
  (candidates, enrolments, attempts, credentials, vouchers).
- **Drill-through**: click a partner to open Partner Detail; click a candidate ("Name (#ID)") to open the Candidate Record, or search one by name or ID in its picker.
  Both pages name the selected partner or candidate in the header, and say "All partners" or prompt for a pick when none is chosen.
- **Dynamic cohorts**: Cohort Granularity (Week, Month, Quarter, Year) and Cohort Milestone
  (Started a course, Completed a course, Sat an exam, Certified) re-cut the candidate journey
  cohort. Partner Type, Segment and Region change who is in the cohort. The voucher cohort shows
  how quickly partner-bought vouchers get redeemed.
- **Self-service and AI**: the dataset is in the portal, so client editors can explore, build
  their own dashboards and ask AI, always through the same governed metrics and the same permission.
- **Plans**: each client is on one of four packages (Enterprise, Self-service, Insights, Essentials),
  which differ only in embed-token fields and cap what each user role gets; the embed host's Plans & permissions page shows what each can and cannot do.

See `docs/embed-payloads.md` for the token payloads and `docs/call-prep.md` for the call brief.
Work-in-progress notes between sessions live in `docs/handoff/`.
