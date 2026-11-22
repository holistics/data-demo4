# Rockinfo embed host

A mock Rockinfo app that embeds the Rockinfo client portal. A customer switcher shows
how each Rockinfo customer (Adobe, Lenovo, Nutanix, F5, Cloudinary) sees only
its own data in the same portal and dashboard. The dashboard brands itself
from the tenant row (client name and colour), so no per-customer copies exist.

- `server.mjs`: Node server with no dependencies. It serves `public/` and signs
  embed tokens at `POST /api/embed-token`. The browser sends only an identity ID.
  Tenant, portal, row-level filter, workspace role and AI are resolved on the
  server from `lib/tenants.mjs`. Ask AI follows the tenant's plan and the user's role and answers only
  from that customer's rows. The sidebar has three sections, in order: AI (Rocky AI, `/ai`),
  Dashboards (one entry per dashboard) and Datasets (one entry per dataset). Each entry opens
  that one object on its own at `/objects/<name>`.
- `lib/portal.mjs`: the sidebar entries. Keep it in step with the `objects` in
  `../embeds/rockinfo_client_portal.embed.aml`; the server signs only views listed here. A section's `requires` names a plan capability (`ai`, `explore`, `personal`); plans without it never see or sign that view. `plans` is a host-native page (no token). `WORKSPACE_SECTIONS` adds Team reports (org workspace) and My reports (personal), filled from the iframe's `embed:loaded` event and opened as view `ws:<uname>`.
- `lib/report-meta.mjs`: Team report and My report metadata (built by, created, last updated) for
  `GET /api/report-meta`. It starts from `public/report-meta.json`, baked at build by
  `scripts/report-meta.mjs`, then polls the public `holistics/data-demo4` commit history every
  90 s without a credential and applies each `Embed user <id>` commit, so edits made in the embed
  show without a redeploy. `PEOPLE` in `lib/tenants.mjs` names the person behind each `embed_user_id`.
- `lib/tenants.mjs`: customers (Adobe 101, Lenovo 102, Nutanix 105, F5 106, Cloudinary 109), each buying one plan (`PLANS`: Program Dashboards, Analytics Studio,
  Studio Enterprise) and optionally the Data Export add-on (`ADDONS`), user roles (`ROLES`) turned into token fields by `capsFor`, and a Rockinfo internal admin (all nine seeded tenants, 101–109). Everyone uses `rockinfo_client_portal`.

## Env

| Var | Kind | Purpose |
| --- | --- | --- |
| `HOLISTICS_EMBED_KEY_ID` | secret | demo4 embed key ID |
| `HOLISTICS_EMBED_SECRET` | secret | demo4 embed secret |
| `DEMO_PASSWORD` | secret, optional | HTTP Basic auth gate (any username) |
| `HOLISTICS_HOST` | env, optional | default `https://demo4.holistics.io` |

## Run locally

```sh
HOLISTICS_EMBED_KEY_ID=... HOLISTICS_EMBED_SECRET=... node server.mjs   # http://localhost:8080
```

## Deploy

Follow `../docs/deploy.md`. It covers the baked-key image build, `proto deploy --image`,
and verification. The site is `https://rockinfo-embed.pages.holistics.dev`, and it stays
live while `holistics/prototypes-deploy#203` is open.
