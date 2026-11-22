# Rockinfo embed host

A mock Rockinfo app that embeds the Rockinfo client portal. A customer switcher shows
how each Rockinfo customer (Adobe, Lenovo, Nutanix, F5, Cloudinary) sees only
its own data in the same portal and dashboard. The dashboard brands itself
from the tenant row (client name and colour), so no per-customer copies exist.

- `server.mjs`: Node server with no dependencies. It serves `public/` and signs
  embed tokens at `POST /api/embed-token`. The browser sends only an identity ID.
  Tenant, portal, row-level filter, workspace role and AI are resolved on the
  server from `lib/tenants.mjs`. Ask AI is on for every persona and answers only
  from that customer's rows. The sidebar has three sections, in order: AI (Rocky AI, `/ai`),
  Dashboards (one entry per dashboard) and Datasets (one entry per dataset). Each entry opens
  that one object on its own at `/objects/<name>`.
- `lib/portal.mjs`: the sidebar entries. Keep it in step with the `objects` in
  `../embeds/rockinfo_client_portal.embed.aml`; the server signs only views listed here. Sections marked `editorsOnly` (Datasets) are hidden from viewers and refused for them. `WORKSPACE_SECTIONS` adds Team reports (org workspace) and My reports (personal), filled from the iframe's `embed:loaded` event and opened as view `ws:<uname>`.
- `lib/tenants.mjs`: customers (Adobe 101, Lenovo 102, Nutanix 105, F5 106, Cloudinary 109), two personas per customer (editor and
  viewer, both with Ask AI) and a Rockinfo internal admin (all nine seeded tenants, 101–109). Everyone uses `rockinfo_client_portal`.

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
