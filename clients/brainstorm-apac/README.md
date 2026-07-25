# Brainstorm APAC POC

This package rebuilds the Brainstorm APAC POC from deterministic DBML records. It covers one dashboard with 3 sections: Executive adoption, Cases and SpeakUp.

The analytical cutoff is 1 July 2026 at 00:00 UTC. The reporting period is July 2025 to June 2026. All 180 Cases and 120 SpeakUp tickets, their parent dates and their lifecycle events are strictly before the cutoff, so self-service queries, drills and exports use the same fixed population as the dashboard.

## Package contents

- `source/` keeps the byte-identical customer DBML and its checksum
- `database/` contains the corrected POC DBML, read-only assertions and expected results
- `models/` contains private source models and one-row-per-parent lifecycle models
- `datasets/` contains 3 fanout-safe datasets
- `dashboards/` contains the 3-section dashboard
- `brainstorm_apac_embed_portal.embed.aml` exposes the dashboard through an Embed Portal

## Seed manifest

The DBML `records` blocks are the source of truth.

| Table | Rows |
| --- | ---: |
| companies | 6 |
| company snapshots | 78 |
| users | 108 |
| case managers | 6 |
| SpeakUp managers | 6 |
| Cases | 180 |
| Case events | 312 |
| SpeakUp tickets | 120 |
| SpeakUp events | 402 |

Each company has 13 monthly snapshots from July 2025 to July 2026 inclusive. The July 2026 adoption snapshot is valid at the cutoff; the dataset uses it as the latest snapshot and June 2026 as its comparison period.

See `database/expected-results.md` for checksums, monthly totals and reconciliations.

## Validate the DBML locally

Use `@dbml/cli` version 8.3.1. Current npm needs the explicit `--package` form.

Compile to a temporary file from the repository root. This checks the DBML syntax and `records` blocks, including all 18 relationship definitions. The temporary SQL is not a deployment artifact.

```sh
npx --yes --package=@dbml/cli@8.3.1 dbml2sql \
  clients/brainstorm-apac/database/brainstorm-apac-poc.dbml \
  --postgres > /tmp/brainstorm-apac-poc.sql
```

## Deploy and validate in RunSQL

Use the RunSQL PostgreSQL database owned by the Holistics work account. Keep the connection URL and credentials out of Git.

The DBML remains the single source of truth. RunSQL's CSV loader creates the 9 tables in `public`, loads the rows, and does not materialize physical primary-key or foreign-key constraints.

1. Verify `database/brainstorm-apac-poc.dbml` has SHA-256 `5b253d21d155e4d6505195c1f6b2bf8ef7daeddd1625b977b1d0767c5b28fdca`.
2. Compile it with `@dbml/cli@8.3.1`, load the temporary SQL into a fresh PGlite database, and export each table in primary-key order with the exact database headers to `/tmp/brainstorm-apac-runsql-import/`.
3. In an owned RunSQL editor, use Define Data to import each of the 9 temporary CSVs. Keep the header row, verify every preview, and save only after all 9 tables are present. Do not commit the CSVs.
4. Confirm the resulting tables are in `public` and run `database/assertions.sql` as a read-only validation query after all imports finish.

The pinned compiler must report 9 PK and 18 FK definitions. RunSQL cloud is expected to report 0 physical PKs and 0 physical FKs because of its CSV-loader limitation; the assertion script instead checks all 18 relationships logically and raises an exception if any count, relationship, lifecycle, tenant or reconciliation check fails.

RunSQL normalizes `cases.reference_SI` to `reference_si`, represents the date-only `company_snapshots.snapshot_month` and `cases.target_closure_date` columns as timestamps, and represents `companies.adoption_rate_current` as a float. These changes are analytically harmless: `reference_si` is not exposed by AMQL, the 2 date dimensions explicitly cast to `date`, and adoption is calculated from `app_user_hc / headcount` rather than the compatibility float.

## Connect Holistics

Create a PostgreSQL data source called `brainstorm_apac_runsql`. Point it to the owned RunSQL database and use `public` as the schema exposed to Holistics. In its metadata, confirm the 9 public tables, lowercase `cases.reference_si`, timestamp types for `company_snapshots.snapshot_month` and `cases.target_closure_date`, and float type for `companies.adoption_rate_current` before validating queries.

Validate the local AMQL before testing the data source:

```sh
holistics aml validate \
  clients/brainstorm-apac/models/brainstorm_apac.model.aml \
  clients/brainstorm-apac/datasets/brainstorm_adoption.dataset.aml \
  clients/brainstorm-apac/datasets/brainstorm_cases.dataset.aml \
  clients/brainstorm-apac/datasets/brainstorm_speakup.dataset.aml \
  clients/brainstorm-apac/dashboards/brainstorm_apac.page.aml \
  clients/brainstorm-apac/brainstorm_apac_embed_portal.embed.aml \
  -u company_id:number
```

## Test company access

Embed Portal object name: `brainstorm_apac_embed_portal`.

The portal requires these dataset permissions:

| Dataset | Permission field |
| --- | --- |
| `brainstorm_adoption` | `brainstorm_adoption_snapshot.company_id` |
| `brainstorm_cases_dataset` | `brainstorm_cases.company_id` |
| `brainstorm_speakup_dataset` | `brainstorm_speakup.company_id` |

Create `company_id` as a Number user attribute. Pass an array of numeric IDs in the Embed Portal token. For example, use company 1 and company 4 as 2 test identities:

```js
user_attributes: { company_id: [1] }
user_attributes: { company_id: [4] }
```

Company 1 is in Vietnam. Company 4 is in Bangladesh. Test totals, filters, detail tables, drill results and exports for both identities. Admins and analysts with data-source access do not provide valid row-level permission evidence.

## Privacy controls

The analytical models do not expose reporter or accused identities, raw details, sensitive free text, dates of birth, religion, ethnicity or IP addresses. Anonymous SpeakUp users have no synthetic user code.

## POC assumptions

- `cases.reference_SI` stays informational and has no foreign key until the customer confirms its meaning
- the supplied `app_user_hc` is the POC active-user count
- Case classification is `actual` or `duplicate`; every duplicate points to an earlier actual Case in the same company
- Case current status comes from `cases.status` as at 1 July 2026
- final close is the latest close event that is not followed by a reopen
- manager attribution uses the manager assigned to the parent Case or SpeakUp ticket

Announcements, surveys, e-learning, demographics, IP allow-listing and localization are outside this POC build.
