# Rockinfo embed host

A mock Rockinfo app that embeds the Rockinfo client portal. A customer switcher shows
how each Rockinfo customer (Adobe, Lenovo, Nutanix, F5, Cloudinary) sees only
its own data in the same portal and dashboard. The dashboard brands itself
from the tenant row (client name and colour), so no per-customer copies exist.

- `server.mjs`: Node server with no dependencies. It serves `public/` and signs
  embed tokens at `POST /api/embed-token`. The browser sends only an identity ID.
  Tenant, portal, row-level filter, workspace role and AI are resolved on the
  server from `lib/tenants.mjs`. Ask AI is on for every persona and answers only
  from that customer's rows. The portal lands on Ask AI (`initial_object: 'ai'`); the
  Dashboards tab loads `/objects/rockinfo_program_performance`.
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

## Deploy (proto, https://docs.pages.holistics.dev/)

1. In 1Password, vault **Prototypes**, create item `rockinfo-embed` with fields
   `HOLISTICS_EMBED_KEY_ID`, `HOLISTICS_EMBED_SECRET` and `DEMO_PASSWORD`.
2. Build and deploy:

```sh
docker buildx build --platform linux/amd64 -t ghcr.io/holistics/rockinfo-embed:latest --push .
proto deploy --image ghcr.io/holistics/rockinfo-embed:latest --name rockinfo-embed --port 8080 \
  --secret HOLISTICS_EMBED_KEY_ID --secret HOLISTICS_EMBED_SECRET --secret DEMO_PASSWORD
```

The site is `https://rockinfo-embed.pages.holistics.dev`. It stays live while the
deploy PR on `holistics/prototypes-deploy` is open.

