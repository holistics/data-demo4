# Handoff: team reports, plans and report metadata (2026-11-22)

Status at end of day 2026-11-22. Everything below is live on
https://rockinfo-embed.pages.holistics.dev and in demo4 production (`master` pushed and published).
Resume the session with `ncy --resume 007184ae-e610-4b37-840f-6c1c158cbf1a`, or start fresh from
this file.

## What exists now

**Four plans per customer** (`embed-host/lib/tenants.mjs`, `PLANS`). The plan sets the embed token
fields and the sidebar.

| Plan | Persona (`embed_user_id`) | Ask AI | Explore | Team reports | My reports | PDF | CSV | Schedules |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Essentials (included) | Partner success viewer (`<slug>_viewer`) | no | no | view | no | yes | no | no |
| Insights (add-on) | Program analyst (`<slug>_analyst`) | yes | no | view | no | yes | no | yes |
| Self-service (add-on) | Program manager (`<slug>_editor`) | yes | yes | view | build | yes | no | yes |
| Enterprise (premium) | Client admin (`<slug>_admin`) | yes | yes | publish | build | yes | yes | yes |

Plus the Rockinfo internal admin (all nine clients, own workspace `rockinfo_internal`).
The full mapping to token fields is in `docs/embed-payloads.md`.

**Plans & permissions page.** A page built into the host itself (not the embed; no token), under
"Your plan" in the sidebar. It has plan cards with "Try as …" buttons, a capability matrix with
the token field behind each row, and a section on which self-built-report features to include
free and which to charge for.

**Team reports.** Seven client-owned dashboards in each tenant's Shared workspace, on
`rockinfo_credentialing` with the Rockinfo theme:

| Tenant | Report | File (`modules/embedding/…/shared_workspace/`) |
| --- | --- | --- |
| Adobe | Partner Voucher Watchlist | `org_client_101/…/untitled_ykyrv.page.aml` |
| Adobe | Recertification Pipeline | `org_client_101/…/untitled_ccgga.page.aml` |
| Lenovo | Partner Enablement Scorecard | `org_client_102/…/untitled_ltnux.page.aml` |
| Lenovo | Regional Certification Coverage | `org_client_102/…/untitled_qusqe.page.aml` |
| Nutanix | Exam Performance | `org_client_105/…/untitled_erdvz.page.aml` |
| F5 | Voucher Sales by Channel | `org_client_106/…/untitled_tmukg.page.aml` |
| Cloudinary | Learning Engagement | `org_client_109/…/untitled_ackig.page.aml` |

Generated names are kept on purpose (Holistics forbids renaming them).

**Sidebar sections.** The host lists Team reports (org) and My reports (personal) from the
iframe's `embed:loaded` event and opens one as view `ws:<uname>`. Unames look like
`embedding.untitled_ykyrv`.

**Report metadata.** A team report's page subtitle reads "Built by … · Created … · Last updated …".
It comes from the `Embed user <id> (Org: …)` git commits, read at image build by
`embed-host/scripts/report-meta.mjs` into `public/report-meta.json` (gitignored). Reports saved
after the build are recorded in the viewer's browser.

## How things work (lessons from today)

- **Creating a team report:** Holistics registers only dashboards created through the embed.
  Run `embed-host/scripts/create-org-dashboard.mjs <identity>` as an org editor, pull `master`,
  write the content into the new `untitled_<x>.page.aml`, validate, push, publish. Hand-made
  files in `modules/embedding/` are ignored.
- **Saving in the embed fails** with "production branch has changes … not published" whenever
  `master` is ahead of production. Run the publish job first (`docs/deploy.md`).
- **Embed events reach the host only from the deployed domain.** demo4 refuses to be framed by
  localhost, so test anything iframe-related on the live host. The Plans page and token logic can
  be tested locally (`PORT=… HOLISTICS_EMBED_KEY_ID=x HOLISTICS_EMBED_SECRET=y node server.mjs`).
- **Holistics exposes no creator or timestamps** for embed dashboards: not in embed events, not in
  AML. The API has only `last_edited_at_epoch` and needs an admin key, which must not go into the
  public image. Git is the source of truth.
- **Explore is a host-side guard for Essentials and Insights.** The dataset stays in the shared
  portal because Ask AI needs it; a portal per plan would be the hard enforcement, but
  `clients/rockinfo/AGENTS.md` mandates one portal.
- **Browser checks** used Playwright with system Chrome (`channel: 'chrome'`), installed in a
  scratch folder. Wait about 15 s for the embed to load before asserting.

## Open items for tomorrow

1. **Recreate the seven team reports as each tenant's Client admin.** Every seeded report says
   "Built by Program manager" because the `*_editor` users created them, but Program manager is now
   Self-service and cannot publish. Steps: create shells as `<slug>_admin`
   (`create-org-dashboard.mjs`), copy each old file's body into the new one (keep the new uname and
   owner lines), publish, then delete the old dashboards through the embed UI as the admin.
   Generated names change. Vincent has not yet said yes; ask first.
2. **Age-band colours on the Adobe watchlist chart** (amber / red for older bands) did not render;
   the order fix worked. Compare with the same chart on `rockinfo_program_performance`.
3. **Not yet checked in a browser:** the Nutanix, F5 and Cloudinary team reports; the Insights
   persona; CSV download on Enterprise; My reports appearing after a personal save.
4. **"Last updated" lags until the next host deploy** for edits made in the embed. If that matters
   in demos, add a refresh endpoint or rebuild before each call.
5. **Optional:** give each persona a person's name so "Built by" reads like a real user.

## Deploy reminders

- AML: validate, land, `git push origin master`, run `submit_publish`, confirm no `aml_errors`.
- Embed host: follow `docs/deploy.md` (pull `master`, generate `report-meta.json`, bake the key,
  new image tag, `proto deploy`). Keep `holistics/prototypes-deploy#203` open.
- No `settings/ai/context.aml` or `ai/rockinfo_context.aml` change was needed for any of this.
