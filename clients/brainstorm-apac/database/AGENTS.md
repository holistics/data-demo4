# Canonical data and reconciliation

- Treat `brainstorm-apac-poc.dbml` records as the canonical mock data. Keep `../source/customer-project-app-structure.dbml` byte-identical to the customer input.
- Compile DBML with `@dbml/cli@8.3.1`. RunSQL is a CSV-derived `public` representation and is expected to have no physical PK or FK constraints.
- Prove integrity with `assertions.sql`, including all 18 logical relationships, tenant consistency, lifecycle ordering and the analytical cutoff at `2026-07-01 00:00:00` UTC.
- When records change, update `expected-results.md` and assertions in the same change. Completion means exact counts reconcile to the seed manifest in the package README.
- Preserve RunSQL normalizations: `reference_SI` becomes `reference_si`; date-only columns arrive as timestamps; `adoption_rate_current` is not the governed adoption calculation.
