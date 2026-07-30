# Model invariants

- Keep one `Model` per `.model.aml` file. Match the filename to the model uname.
- Point table models at `public.*`; the DBML `Project` block does not create a PostgreSQL schema.
- Cast `company_snapshots.snapshot_month` and `cases.target_closure_date` to `date`. Derive adoption from `app_user_hc / headcount`, not `adoption_rate_current`.
- Keep lifecycle query models at one row per parent and bounded by `2026-07-01 00:00:00` UTC. Include every non-aggregated SQL expression in `GROUP BY`.
- Give every dimension, including hidden IDs and join fields, a description that says what it represents and when to use it.
- A query-model change is complete only after AML validation and a real cloud execution. The previous Case lifecycle `GROUP BY` defect passed AML validation but failed against PostgreSQL.
