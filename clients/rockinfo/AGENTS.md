# Rockinfo embedded PoC

**Scope.** Embedded-analytics PoC for Rockinfo (credentialing platform; clients are
certification bodies, councils and institutes). Keep every change inside
`clients/rockinfo/`. Read `README.md` for the data story, tenant contract and demo flow.

- Data source `rockinfo_neon` (Neon project `holistics-demo-pocs`, aws-us-east-1),
  schema `"rockinfo_demo"."*"`. Never join it with `demodb`, `dabble_neon` or ecommerce data.
- Prefix every object with `rockinfo_`; label assets "Rockinfo …".
- Synthetic data only. `database/seed_rockinfo.py` is the single source of truth; reseed with
  `--load`, which drops and rebuilds only the `rockinfo_demo` schema. Keep connection strings
  and tokens out of files and output.

**Tenant isolation.** One dataset, `rockinfo_credentialing`, with permission `client_access`
on `rockinfo_clients.client_id` against the Number user attribute `rockinfo_client_id`.

- Give every new model a direct `client_id > rockinfo_clients.client_id` relationship, or one
  unique shortest path to it, so the permission propagates without ambiguity.
- Keep cohort params on `rockinfo_clients` (the permission anchor).
- Test isolation with an embedded identity, never as an admin or analyst.

**Validate after every AML edit** from the repo root:

```sh
holistics aml validate clients/rockinfo/models/*.model.aml clients/rockinfo/datasets/*.aml \
  clients/rockinfo/dashboards/*.page.aml clients/rockinfo/embeds/*.embed.aml -u rockinfo_client_id:number
```

Then run a real query for changed logic. Rockinfo has no routing block in
`settings/ai/context.aml`; ask the operator before adding one (see `clients/AGENTS.md`).
