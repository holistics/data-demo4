# Expected results

## Manifest

All data is deterministic, synthetic, privacy-safe, and interpreted in UTC as at `2026-07-01 00:00:00`. The 13 snapshots per company run from July 2025 through July 2026 inclusive; July 2026 is latest and June 2026 is previous. Compatibility aggregates on `companies` equal the latest snapshot. All 180 Cases and 120 SpeakUp tickets fall inside the default July 2025 to June 2026 reporting window; no parent or lifecycle event is at or after the cutoff.

| Table | Rows |
|---|---:|
| companies | 6 |
| company_snapshots | 78 |
| users | 108 |
| case_managers | 6 |
| speakup_managers | 6 |
| cases | 180 |
| case_events | 312 |
| speakup | 120 |
| speakup_events | 402 |

## RunSQL import contract

Import the temporary CSVs through RunSQL Define Data to create and populate 9 tables in `public`. The CSVs are deterministic derived artifacts, exported in primary-key order from a fresh PGlite database compiled from the DBML. They are not committed and do not replace the DBML as the source of truth.

| Temporary CSV | Rows | SHA-256 | Headers |
|---|---:|---|---|
| `companies.csv` | 6 | `56fa43d2163851e19ed15c988496575b18bead520f9b4f31bc7b895c5b9d1da5` | `id,name,short_name,country,month_start_hc,app_user_hc_current,adoption_rate_current,created_at` |
| `company_snapshots.csv` | 78 | `3a99a4ae5fbadef62dd3f3bc853cd057cf0da94e6acd8ca7ddc81c1992d00bac` | `company_id,snapshot_month,headcount,app_user_hc` |
| `users.csv` | 108 | `ed58e8763f693c7f16c3190a67057bfb32599f530d70c5c003210efb8be5091e` | `id,company_id,role_code,anonymous,synthetic_user_code,created_at,status` |
| `case_managers.csv` | 6 | `5a9a8f47d337434d1db9d4f3fd4324bac3f069951fa756574e185b55e36b82f8` | `id,company_id,role_code,synthetic_manager_code,status` |
| `speakup_managers.csv` | 6 | `a097f5ae1befae006d4b380beb544688f3db757e9ed04e019007e1c0d211d1c3` | `id,company_id,role_code,synthetic_manager_code,status` |
| `cases.csv` | 180 | `c4af8d1e7a2e909064385cf41cdafa501071b839c96465012d32aca824ea9a1a` | `id,company_id,manager_id,created_at,last_updated_at,status,reporter_id,reference_SI,channel,case_type_code,classification,duplicate_of_case_id,allegation_status,accused_id,target_closure_date` |
| `case_events.csv` | 312 | `302766c1f5812331e2e42644b44c7a68130c929f433978a81a68784bb3e66e27` | `id,case_id,actor_user_id,actor_manager_id,admin_action,event_type,created_at` |
| `speakup.csv` | 120 | `2cbe99a61dce83c6e2f9cb1c15d73c4119961240757725abd16231e1bfe67fa3` | `id,user_id,company_id,status,anonymous,manager_id,speakup_type,created_at,submitted_at,closed_at` |
| `speakup_events.csv` | 402 | `ffeac2dbfc781eaf9bb19e13cf2db8fdaf8c8332a42cd5b914b85de8a12a8a1f` | `id,speakup_id,actor_user_id,actor_manager_id,admin_action,event_type,created_at` |

Pinned compilation proves that the DBML contains 9 PK and 18 FK definitions. RunSQL's CSV loader intentionally materializes 0 physical PKs and 0 physical FKs; `assertions.sql` validates all 18 relationships against the imported cloud data, including nullable actors and duplicate lineage.

The accepted RunSQL metadata normalization is analytically lossless:

- all 9 tables are under `public`, which is the schema used by the direct AMQL table models
- `cases.reference_SI` becomes `reference_si`; AMQL does not expose or reference this informational field
- `company_snapshots.snapshot_month` and `cases.target_closure_date` are timestamps; their source dimensions cast to `date`
- `companies.adoption_rate_current` is a float compatibility value; adoption metrics continue to derive from integer `app_user_hc / headcount`

Configure the `brainstorm_apac_runsql` data source to expose `public`, refresh its metadata, and verify those normalized names and types before running AMQL validation against the cloud source.

## Golden totals by company

| company_id | cases | actual | duplicate | speakup | currently closed | anonymous | latest HC | latest app users | June adoption | July adoption | PoP pp |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 30 | 24 | 6 | 20 | 15 | 6 | 1130 | 814 | 0.700000 | 0.720354 | 2.035 |
| 2 | 30 | 24 | 6 | 20 | 15 | 6 | 1230 | 590 | 0.495082 | 0.479675 | -1.541 |
| 3 | 30 | 24 | 6 | 20 | 15 | 6 | 1330 | 878 | 0.655303 | 0.660150 | 0.485 |
| 4 | 30 | 24 | 6 | 20 | 15 | 6 | 1430 | 626 | 0.433803 | 0.437762 | 0.396 |
| 5 | 30 | 24 | 6 | 20 | 15 | 6 | 1530 | 685 | 0.444079 | 0.447712 | 0.363 |
| 6 | 30 | 24 | 6 | 20 | 15 | 6 | 1630 | 698 | 0.424074 | 0.428221 | 0.415 |

Reconciliations: `180 = 144 actual + 36 duplicate`; `120 = 90 currently closed + 30 active`; anonymous SpeakUp is `36`, identified is `84`.

## Expected narrative checks

- Company 1 has sustained monthly case growth and shifts from suggestion-box to hotline intake.
- Company 1 adoption improves; company 2 adoption declines; Vietnam adoption is higher than Bangladesh.
- SpeakUp manager 101 has a 72-hour first response versus 12 hours for other managers.
- SpeakUp manager 102 owns four closed tickets with reopenings and slower 15-day final closure.
- Every duplicate points to an earlier actual case in the same company. Final close means the latest close is not followed by reopen.

## Golden monthly parent volumes

Zeroes are explicit so each company/month reconciliation covers the complete 13-month snapshot span. July 2026 parent activity is zero because the analytical cutoff is the start of that month.

| company_id | month | cases created | speakup submitted |
|---:|:---|---:|---:|
| 1 | 2025-07 | 1 | 2 |
| 1 | 2025-08 | 1 | 2 |
| 1 | 2025-09 | 1 | 1 |
| 1 | 2025-10 | 1 | 2 |
| 1 | 2025-11 | 2 | 1 |
| 1 | 2025-12 | 2 | 2 |
| 1 | 2026-01 | 2 | 1 |
| 1 | 2026-02 | 3 | 2 |
| 1 | 2026-03 | 3 | 1 |
| 1 | 2026-04 | 3 | 2 |
| 1 | 2026-05 | 3 | 1 |
| 1 | 2026-06 | 8 | 3 |
| 1 | 2026-07 | 0 | 0 |
| 2 | 2025-07 | 2 | 2 |
| 2 | 2025-08 | 2 | 2 |
| 2 | 2025-09 | 3 | 1 |
| 2 | 2025-10 | 3 | 2 |
| 2 | 2025-11 | 3 | 1 |
| 2 | 2025-12 | 3 | 2 |
| 2 | 2026-01 | 2 | 1 |
| 2 | 2026-02 | 2 | 2 |
| 2 | 2026-03 | 2 | 1 |
| 2 | 2026-04 | 2 | 2 |
| 2 | 2026-05 | 2 | 1 |
| 2 | 2026-06 | 4 | 3 |
| 2 | 2026-07 | 0 | 0 |
| 3 | 2025-07 | 2 | 2 |
| 3 | 2025-08 | 2 | 2 |
| 3 | 2025-09 | 2 | 1 |
| 3 | 2025-10 | 3 | 2 |
| 3 | 2025-11 | 3 | 1 |
| 3 | 2025-12 | 3 | 2 |
| 3 | 2026-01 | 3 | 1 |
| 3 | 2026-02 | 2 | 2 |
| 3 | 2026-03 | 2 | 1 |
| 3 | 2026-04 | 2 | 2 |
| 3 | 2026-05 | 2 | 1 |
| 3 | 2026-06 | 4 | 3 |
| 3 | 2026-07 | 0 | 0 |
| 4 | 2025-07 | 2 | 2 |
| 4 | 2025-08 | 2 | 2 |
| 4 | 2025-09 | 2 | 1 |
| 4 | 2025-10 | 2 | 2 |
| 4 | 2025-11 | 3 | 1 |
| 4 | 2025-12 | 3 | 2 |
| 4 | 2026-01 | 3 | 1 |
| 4 | 2026-02 | 3 | 2 |
| 4 | 2026-03 | 2 | 1 |
| 4 | 2026-04 | 2 | 2 |
| 4 | 2026-05 | 2 | 1 |
| 4 | 2026-06 | 4 | 3 |
| 4 | 2026-07 | 0 | 0 |
| 5 | 2025-07 | 2 | 2 |
| 5 | 2025-08 | 2 | 2 |
| 5 | 2025-09 | 2 | 1 |
| 5 | 2025-10 | 2 | 2 |
| 5 | 2025-11 | 2 | 1 |
| 5 | 2025-12 | 3 | 2 |
| 5 | 2026-01 | 3 | 1 |
| 5 | 2026-02 | 3 | 2 |
| 5 | 2026-03 | 3 | 1 |
| 5 | 2026-04 | 2 | 2 |
| 5 | 2026-05 | 2 | 1 |
| 5 | 2026-06 | 4 | 3 |
| 5 | 2026-07 | 0 | 0 |
| 6 | 2025-07 | 2 | 2 |
| 6 | 2025-08 | 2 | 2 |
| 6 | 2025-09 | 2 | 1 |
| 6 | 2025-10 | 2 | 2 |
| 6 | 2025-11 | 2 | 1 |
| 6 | 2025-12 | 2 | 2 |
| 6 | 2026-01 | 3 | 1 |
| 6 | 2026-02 | 3 | 2 |
| 6 | 2026-03 | 3 | 1 |
| 6 | 2026-04 | 3 | 2 |
| 6 | 2026-05 | 2 | 1 |
| 6 | 2026-06 | 4 | 3 |
| 6 | 2026-07 | 0 | 0 |

The July 2025 to June 2026 monthly totals reconcile to all 180 Cases and 120 SpeakUp tickets.

## Checksums

SHA-256 source: `06e09784585b91719e980d30344a66eafd6bbcf2b29a3abd7516fe7c771466bc`
SHA-256 DBML: `5b253d21d155e4d6505195c1f6b2bf8ef7daeddd1625b977b1d0767c5b28fdca`

Pinned local compilation check (modern npm requires explicit `--package`):

```sh
npx --yes --package=@dbml/cli@8.3.1 dbml2sql \
  clients/brainstorm-apac/database/brainstorm-apac-poc.dbml \
  --postgres > /tmp/brainstorm-apac-poc.sql
```
