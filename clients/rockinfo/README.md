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

| `rockinfo_client_id` | Client | Themed portal |
| ---: | --- | --- |
| 101 | Adobe | `rockinfo_portal_adobe` |
| 102 | Lenovo | `rockinfo_portal_lenovo` (dark theme) |
| 103 | SonicWall | neutral portal only |
| 104 | Axway | neutral portal only |
| 105 | Nutanix | `rockinfo_portal_nutanix` |
| 106 | F5 | `rockinfo_portal_f5` |
| 107 | Gigamon | neutral portal only |
| 108 | RStudio | neutral portal only |
| 109 | Cloudinary | `rockinfo_portal_cloudinary` |

`rockinfo_client_portal` is the neutral portal for any client and for Rockinfo internal users.
A themed portal changes only the look: data scope always comes from the token's `rockinfo_client_id`.

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
  - `rockinfo_partner_detail`: drill-through destination (Partner)
  - `rockinfo_candidate_record`: drill-through destination (Candidate ID), the single-record view
- `themes/` and `dashboards/customers/`: one theme per showcase customer and `.extend()` copies of the 3 dashboards with that theme.
- `embeds/`: `rockinfo_client_portal` (neutral) and `rockinfo_portal_<slug>` per showcase customer, all with AI enabled.

## Demo capabilities

- **Tenant isolation**: the same portal shows different clients purely from the token's `rockinfo_client_id`.
- **View underlying data**: right-click any KPI or table value for record-level views
  (candidates, enrolments, attempts, credentials, vouchers).
- **Drill-through**: click a partner to open Partner Detail; click a Candidate ID to open the Candidate Record.
- **Dynamic cohorts**: Cohort Granularity (Week, Month, Quarter, Year) and Cohort Milestone
  (Started a course, Completed a course, Sat an exam, Certified) re-cut the candidate journey
  cohort. Partner Type, Segment and Region change who is in the cohort. The voucher cohort shows
  how quickly partner-bought vouchers get redeemed.
- **Self-service and AI**: the dataset is in the portal, so client editors can explore, build
  their own dashboards and ask AI, always through the same governed metrics and the same permission.

See `docs/embed-payloads.md` for the token payloads and `docs/call-prep.md` for the call brief.
