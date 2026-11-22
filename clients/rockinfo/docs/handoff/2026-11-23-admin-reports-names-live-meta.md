# Handoff: admin-built team reports, persona names, live report metadata (2026-11-23)

Follows `2026-11-22-team-reports-and-plans.md`. Resume with
`ncy --resume 35404290-3458-466a-bc4f-36ba9038a44a`. The plan model changed during this session: session
`rockinfo-ea` replaced it with plans v2 (plan per customer, role per user) and deployed it. Read
`embed-host/lib/tenants.mjs` for the current personas, not the 2026-11-22 plan table.

## Done

**Team reports rebuilt as Client admin (Adobe, Lenovo).** Shells created through the embed as
`adobe_admin` and `lenovo_admin`, bodies copied (new uname and owner kept), published, and the old
dashboards deleted through the embed. The old files are gone from `master`.

| Tenant | Report | Old | New |
| --- | --- | --- | --- |
| Adobe | Partner Voucher Watchlist | `untitled_ykyrv` | `untitled_hpwcc` |
| Adobe | Recertification Pipeline | `untitled_ccgga` | `untitled_sxdwo` |
| Lenovo | Partner Enablement Scorecard | `untitled_ltnux` | `untitled_oytre` |
| Lenovo | Regional Certification Coverage | `untitled_qusqe` | `untitled_nyuyu` |

Nutanix, F5 and Cloudinary keep their Program-manager-built reports (`erdvz`, `tmukg`, `ackig`). Their
plans no longer let the Client admin publish, and Vincent chose to leave them.

**Persona names.** `PEOPLE` in `embed-host/lib/tenants.mjs` names the person behind every
`embed_user_id`, including roles a plan hides; `people()` feeds `/api/config`. "Built by" reads
"Maya Chen (Client admin, Adobe)". The ids are unchanged.

**Live "Last updated".** `embed-host/lib/report-meta.mjs` starts from the baked `report-meta.json`, then
polls the public `holistics/data-demo4` commit history every 90 s, with no credential, and applies each
commit under `modules/embedding/`. It serves the result at `GET /api/report-meta`. The browser refetches it
on every `embed:loaded`. Verified live: a commit made after the image build showed up without a redeploy.

## Not done

1. **Age-band colours.** Per-point colours apply only to legend values, but using the band as both
   x-axis and legend fails at runtime with "Duplicate dimensions are not supported" (`aml validate`
   passes it). That change was published and then reverted. Both charts are single-colour again. Next try:
   add a copy dimension (e.g. `outstanding_age_band_series` on `rockinfo_vouchers`) for the legend, and
   check it on a Development branch (`holistics sync start -b`) before publishing.
2. **Browser checks still open:** Cloudinary Learning Engagement (`ws:embedding.untitled_ackig`
   opened Program Performance as `cloudinary_viewer`; check whether v2 blocks workspace views for that
   persona), CSV download, the AI-only persona, and My reports after a personal save. Re-scope these
   to plans v2.
3. **Empty Adobe shell `untitled_uvxfw`** came from the Cohorts-report session, not this one;
   `rockinfo-ea` said it would delete it.

## Lessons

- Any push to `master`, even docs-only, makes embed saves fail until `submit_publish` runs. Publish right
  after pushing.
- `create-org-dashboard.mjs` can hang after a successful save. Check `origin/master` for the new file
  rather than waiting on the process.
- To delete a team report through the embed, find its sidebar link by uname (`a[href*="<uname>"]`), then
  right-click → Delete. Titles repeat once a copy exists.
