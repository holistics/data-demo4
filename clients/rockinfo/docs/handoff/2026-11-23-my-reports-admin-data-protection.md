# Handoff: My reports, Admin tag, Data protection (2026-11-23)

Follows `2026-11-23-admin-reports-names-live-meta.md` (plans v2). Resume with
`ncy --resume e5ada215-d821-4336-9dae-7bde3c1f7829`. Everything below is live on
https://rockinfo-embed.pages.holistics.dev and in demo4 production.

## Done

**My reports seeded.** One private dashboard per Creator persona, created through the embed with
`embed-host/scripts/create-org-dashboard.mjs <identity> --personal`, then filled in AML:

| Person | File (`modules/embedding/…/personal_workspace/`) | Report |
| --- | --- | --- |
| Daniel Okafor `adobe_editor` | `org_client_101/…/user_adobe_editor/untitled_tsvmb.page.aml` | My Partners: Exam Readiness |
| Maya Chen `adobe_admin` | `org_client_101/…/user_adobe_admin/untitled_dbofh.page.aml` | Draft: Program Health Check |
| Laura Martín `lenovo_editor` | `org_client_102/…/user_lenovo_editor/untitled_fbkkj.page.aml` | My Region: Partner Pipeline |
| Sofia Rossi `nutanix_editor` | `org_client_105/…/user_nutanix_editor/untitled_qurjm.page.aml` | Recertification Follow-ups |

Checked in the live embed: each person sees only their own; Maya does not see Daniel's.

**Sidebar follows the plan.** Team reports shows only when `org_workspace_role` is not `no_access`
(hidden on Program Dashboards, no upsell); My reports only for Creators, with an empty state.

**Admin is a tag, not a role.** The first role a plan offers is that tenant's admin (`admin: true`):
Maya, Wei, Carlos, Sofia, Ben, and the internal admin. Shown as a badge in the persona menu.

**Data protection replaces the Data Export add-on.** Raw-row download is on for every user on
Program Dashboards and Analytics Studio. Studio Enterprise's Data protection restricts it to people
the admin names (admin and analyst roles). The menu labels "Studio Enterprise · data protection";
the Plans page has a Raw data download row and a paid Data protection row. The How to use dashboard
(rockinfo-ea's split) carries the same model.

## Notes

- `rockinfo_context.aml` and `settings/ai/context.aml` mention no plans, exports or workspaces, so
  neither needed a change.
- 1Password approval can time out; rerun `op item get rockinfo-embed` while the user is at the Mac.
- Chart sort in generated AML: use `type: 'yaxis'`; `'metric'` fails validation.
