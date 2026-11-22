# Deploying Rockinfo

Rockinfo has two deploy targets. AML changes go to Holistics demo4. Changes under
`embed-host/` go to the proto prototype host. A change that touches both, like a new
portal landing page, needs both deploys.

| Target | What it serves | Live URL |
| --- | --- | --- |
| demo4 production | Models, dataset, dashboards, theme, `rockinfo_client_portal` | https://demo4.holistics.io |
| proto (`rockinfo-embed`) | Mock Rockinfo app that signs embed tokens and iframes the portal | https://rockinfo-embed.pages.holistics.dev |

## demo4 production

demo4 is connected to `holistics/data-demo4`. Pushing to `master` does not publish it.
Production only changes when a publish job runs.

1. Validate (the command is in `../AGENTS.md`), then land on `master` and `git push origin master`.
2. Publish `master` with the API key in `~/.secrets/holistics/demo4.holistics.io/holistics.env`
   (`HOLISTICS_API_KEY`, `HOLISTICS_BASE_URL`):

```sh
set -a; . ~/.secrets/holistics/demo4.holistics.io/holistics.env; set +a
id=$(curl -s -X POST -H "X-Holistics-Key: $HOLISTICS_API_KEY" -H "Content-Type: application/json" \
  "$HOLISTICS_BASE_URL/aml_studio/projects/submit_publish" | python3 -c 'import json,sys;print(json.load(sys.stdin)["job"]["id"])')
curl -s -H "X-Holistics-Key: $HOLISTICS_API_KEY" "$HOLISTICS_BASE_URL/jobs/$id/result"   # poll until status is success
```

3. Check the job result. `result.data.data.objects_status[]` must show no `aml_errors` for
   `rockinfo_*` objects.

The publish ships the whole demo4 `master`, including other sessions' pushed work.
Publishing from Studio (the **Publish** button) does the same.

For live testing before publishing, `holistics sync start -b` syncs the working tree two
ways to a demo4 Development branch named after the git branch. It never touches production.

## Embed host (proto)

- The app is a container image deployed with `proto deploy --image`. Docs: https://docs.pages.holistics.dev/
- Deploy PR: `holistics/prototypes-deploy#203`. The site is live while the PR is open.
  Never merge or close it.
- Images: built to `ghcr.io/vinwoon/rockinfo-embed:<tag>`. Proto copies them into
  `ghcr.io/holistics/prototypes` because personal accounts cannot create packages under
  the holistics org.
- The embed credential is **baked into the image** as a gitignored `secrets.env`. Proto
  secrets were dropped because proto reads only the `kubernetes-internal-prototypes`
  1Password vault, and the item lives elsewhere.
- Credential source: 1Password item `rockinfo-embed` (fields `HOLISTICS_EMBED_KEY_ID`,
  `HOLISTICS_EMBED_SECRET`). The key signs tokens for every demo4 portal, so rotate it in
  demo4 → Embedded Analytics when the PoC ends, then rebuild.
- There is no password gate. `DEMO_PASSWORD` is left out because the gate broke the
  Kubernetes probes, and the site is open to anyone with the link.

Build in a scratch copy so `secrets.env` never sits in the repo, then deploy. Use a new tag
each time: proto deploys by digest, and reusing a tag can serve a stale image.

```sh
B=<scratch dir>; rm -rf $B; mkdir -p $B
cd clients/rockinfo/embed-host && cp -r Dockerfile server.mjs lib public $B/
git -C ../../.. pull --ff-only   # Holistics commits embed saves to master; pick them up first
node scripts/report-meta.mjs "$(git rev-parse --show-toplevel)" > $B/public/report-meta.json   # Team report built-by / created / updated
op item get rockinfo-embed --format json | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const f=Object.fromEntries(JSON.parse(s).fields.map(x=>[x.label,x.value]));process.stdout.write(["HOLISTICS_EMBED_KEY_ID","HOLISTICS_EMBED_SECRET"].map(k=>k+"="+f[k]).join("\n")+"\n")})' > $B/secrets.env
grep -c '=.\+' $B/secrets.env   # must print 2; a 1Password timeout yields an image without the key
(cd $B && docker buildx build --platform linux/amd64 -t ghcr.io/vinwoon/rockinfo-embed:<tag> --push .)
rm -f $B/secrets.env
proto deploy --image ghcr.io/vinwoon/rockinfo-embed:<tag> --name rockinfo-embed --port 8080 -y
```

The baked `report-meta.json` is only the starting point: the server keeps it current from the
public GitHub history of `holistics/data-demo4` (`lib/report-meta.mjs`), so a report edited in the
embed does not need a redeploy. Check `curl -s $U/api/report-meta` for `syncedAt`.

Docker runs on OrbStack (`open -ga OrbStack`). GHCR login uses the GitHub token in proto's
config (`~/Library/Application Support/proto/config.json`, key `github_token`).

Verify after every deploy:

```sh
U=https://rockinfo-embed.pages.holistics.dev
curl -s -X POST -H 'content-type: application/json' -d '{"identity_id":"adobe_viewer","view":"ai"}' $U/api/embed-token
```

A response with `embedUrl` means the key is present. `proto status rockinfo-embed` shows the rollout, and
the new pod can take a few minutes to replace the old one.
