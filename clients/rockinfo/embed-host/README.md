# Rockinfo embed host

A mock Rockinfo app that embeds the Rockinfo portals. A customer switcher shows
how each Rockinfo customer (Adobe, Lenovo, Nutanix, F5, Cloudinary) sees only
its own data, in its own themed portal, from one governed dataset.

- `server.mjs`: Node server with no dependencies. It serves `public/` and signs
  embed tokens at `POST /api/embed-token`. The browser sends only an identity ID.
  Tenant, portal, row-level filter, workspace role and AI are resolved on the
  server from `lib/tenants.mjs`.
- `lib/tenants.mjs`: customers (Adobe 101, Lenovo 102, Nutanix 105, F5 106, Cloudinary 109), the per-customer
  portal names (`rockinfo_portal_<slug>`), two personas per customer (editor with
  AI, viewer) and a Rockinfo internal admin (all nine seeded tenants, 101–109) on the neutral `rockinfo_client_portal`.

## Env

| Var | Kind | Purpose |
| --- | --- | --- |
| `HOLISTICS_EMBED_KEY_ID` | secret | demo4 embed key ID |
| `HOLISTICS_EMBED_SECRET` | secret | demo4 embed secret |
| `DEMO_PASSWORD` | secret, optional | HTTP Basic auth gate (any username) |
| `THEMED_PORTALS` | env, optional | `off` sends every customer to `rockinfo_client_portal` |
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

The per-customer portals and themes are AML under `clients/rockinfo/`. Until they
are published on demo4, deploy with `--env THEMED_PORTALS=off`.
