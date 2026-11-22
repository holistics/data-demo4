# Rockinfo embedded PoC

**Scope.** Embedded-analytics PoC for Rockinfo (credentialing platform; tenants are its
published customers, tech vendors with certification programs). Keep every change inside
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
- Keep one dashboard set and one portal for all tenants. Never copy a dashboard or portal per client;
  per-client branding comes from data (`rockinfo_clients.brand_color` via the header metrics).
- Style every dashboard with the single Rockinfo theme, `themes/rockinfo.theme.aml` (light + dark,
  derived from rockinfo.com; sources cited in the file). Never add per-client themes; keep header
  text colours `inherit` so both modes read.
- Test isolation with an embedded identity, never as an admin or analyst.

**Validate after every AML edit** from the repo root:

```sh
holistics aml validate clients/rockinfo/models/*.model.aml clients/rockinfo/datasets/*.aml \
  clients/rockinfo/dashboards/*.page.aml clients/rockinfo/embeds/*.embed.aml \
  clients/rockinfo/themes/*.theme.aml -u rockinfo_client_id:number
holistics aml validate settings/ai/context.aml clients/rockinfo/ai/*.aml
```

Then run a real query for changed logic.

**AI context.** Holistics AI gets all Rockinfo behaviour from the const `rockinfo_context_routing`
in `ai/rockinfo_context.aml` (vocabulary, bound models, tenant rules, metric definitions).
`settings/ai/context.aml` holds only the routing-table row and the `${rockinfo_context_routing}`
include. The portal's own `ai { }` block covers assistant name, intro and placeholder only.

- Edit Rockinfo AI context in `ai/rockinfo_context.aml`, never in `settings/ai/context.aml`.
  Keep it inline text: the runtime AI cannot read repo files.
- Change it only when the operator asks; it changes live AI answers. Portal, landing-page,
  dashboard and embed-host changes do not need it.
- When you change vocabulary, models, metrics, tenants or what clients are, list the lines in
  `ai/rockinfo_context.aml` that now drift and ask the operator before finishing.
- Validate it with `settings/ai/context.aml` after every edit (below).

**Deploy.** AML and the embed host deploy separately; ship both when a change spans them. Follow
`docs/deploy.md` for commands, credentials and verification.

- demo4: land, `git push origin master`, then run the `submit_publish` job. A push alone does not
  reach production. Publish only after validation passes, and confirm the job shows no `aml_errors`.
- Embed host (https://rockinfo-embed.pages.holistics.dev): build a fresh image tag with the baked
  key, `proto deploy --image`, then check that `/api/embed-token` returns an `embedUrl`. Keep
  `holistics/prototypes-deploy#203` open and unmerged.
- Never commit `embed-host/secrets.env` or print its values.
