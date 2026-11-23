# Rockinfo embed payloads

The Rockinfo backend signs one token per signed-in user and returns the iframe URL. The
browser never sees the embed secret. `rockinfo_client_id` comes from Rockinfo's own session,
never from the browser, so a user cannot switch tenants by editing the URL.

## Prerequisites in Holistics (demo4)

- Data source `rockinfo_neon` (read-only role `holistics_reader`)
- Number user attribute `rockinfo_client_id`
- Published Embed Portal `rockinfo_client_portal`
- An embed credential: Settings → Embedded Analytics → embed key ID and secret

## Node.js (Express) example

```js
import jwt from 'jsonwebtoken';

const EMBED_KEY_ID = process.env.HOLISTICS_EMBED_KEY_ID;
const EMBED_SECRET = process.env.HOLISTICS_EMBED_SECRET;

// user: the signed-in Rockinfo user; client: their organisation (tenant)
function holisticsEmbedUrl(user, client) {
  const payload = {
    embed_portal: 'rockinfo_client_portal',  // one portal for every client
    embed_org_id: `client_${client.id}`,     // workspace boundary per Rockinfo client
    embed_user_id: `user_${user.id}`,        // stable per person, for personal dashboards
    user_attributes: {
      rockinfo_client_id: [client.id],       // row-level security; values are always arrays
    },
    permissions: {
      enable_personal_workspace: user.role !== 'viewer',
      org_workspace_role: user.role === 'client_editor' ? 'editor' : 'viewer',
    },
    settings: {
      ai: { enabled: true },                 // required: the portal lands on Ask AI
    },
    exp: Math.floor(Date.now() / 1000) + 60 * 60, // 1 hour
  };
  const token = jwt.sign(payload, EMBED_SECRET, { algorithm: 'HS256' });
  return `https://demo4.holistics.io/embed/${EMBED_KEY_ID}?_token=${token}`;
}
```

## Test identities for the call

Every persona uses `embed_portal: 'rockinfo_client_portal'`. Only the identity changes.

Each customer buys one plan, optionally plus the Data Export add-on; its admin gives each person a
role. Plans (`PLANS`), the add-on (`ADDONS`), roles (`ROLES`) and each tenant's purchase
(`TENANTS`) live in `embed-host/lib/tenants.mjs`; `capsFor` turns plan + role + add-on into token
fields and the host's **Plans & permissions** page renders the same model.

| Plan | Rocky AI | Explore, My reports | Publish to Team reports | Team reports | Raw data (with Data Export) |
| --- | --- | --- | --- | --- | --- |
| Program Dashboards (included) | no | no | no | hidden (`org_workspace_role: no_access`) | everyone |
| Analytics Studio (add-on, per Creator seat) | every user | Creators | every Creator | everyone sees | everyone |
| Studio Enterprise (premium) | every user | Creators | named Publishers only | everyone sees | named by the admin |

Every plan includes Rockinfo dashboards, PDF export and scheduled emails. **Data Export** (add-on,
any plan) sets `allow_raw_data_export`: for every user below Studio Enterprise, and only for the
people the admin names on Studio Enterprise (the control is what premium pays for).

**Admin is a tag, not a role.** The first role a plan offers is that tenant's admin (`admin: true`
in `identities()`): the person who assigns roles in Rockinfo's app. Holistics never sees it; it
only receives the token fields the admin's choices produce.

Data Export is the norm, so the persona menu labels a customer **without** it ("· no data export")
rather than one with it, and only Studio Enterprise seats say "+ Data Export" (a per-person grant).

| Tenant | Purchase (menu label) | Personas (`embed_user_id`) and seat |
| --- | --- | --- |
| Adobe | Studio Enterprise | `adobe_admin` Admin, Creator + Publisher + Data Export; `adobe_editor` Creator (private); `adobe_analyst` Viewer + Data Export; `adobe_viewer` Viewer |
| Lenovo | Studio Enterprise | same four roles as Adobe |
| F5 | Analytics Studio (exports on for everyone) | `f5_editor` Admin, Creator; `f5_viewer` Viewer |
| Nutanix | Analytics Studio · no data export | `nutanix_editor` Admin, Creator; `nutanix_viewer` Viewer |
| Cloudinary | Program Dashboards · no data export | `cloudinary_viewer` Admin, Viewer |
| Rockinfo | Internal | `rockinfo_internal_admin`, `embed_org_id: rockinfo_internal`, all nine clients |

Role keys stay the `embed_user_id` suffix so earlier reports keep their authors: `admin` Program
manager (Creator, Publisher), `editor` Partner manager (Creator), `analyst` Channel operations
analyst (Viewer, exports), `viewer` VP partner ecosystem (Viewer).

Every client persona uses `embed_org_id: client_<id>` and `rockinfo_client_id: [<id>]`.
Tenants in the embed host: Adobe `101`, Lenovo `102`, Nutanix `105`, F5 `106`, Cloudinary `109`.
Plans without Rocky AI open on Program Performance. The host hides Rocky AI and Datasets from people
without them and refuses to sign those views (`requires` in `embed-host/lib/portal.mjs`). The
dataset is still a portal object because Ask AI needs it, so Explore is a host-side guard, not a
Holistics permission.

**Team reports** are dashboards a tenant's admin saved (org `editor`, so only the Enterprise tenants Adobe and Lenovo can publish new ones) to their Shared workspace
(`embed_org_id`). The host lists them from the iframe's `embed:loaded` event (`workspace: 'org'`)
and opens one as `/objects/<uname>`; every user in that org sees them. Seeded
reports: Adobe (Partner Voucher Watchlist, Recertification Pipeline), Lenovo (Partner Enablement
Scorecard, Regional Certification Coverage), Nutanix (Exam Performance), F5 (Voucher Sales by
Channel), Cloudinary (Learning Engagement).

**My reports** are dashboards a Creator saved to their Personal workspace
(`enable_personal_workspace`, path `modules/embedding/org_client_<id>/personal_workspace/user_<embed_user_id>/`).
Holistics lists only the viewer's own (`workspace: 'personal'`), so nobody else in the org, admin
included, sees them. The sidebar shows **Team reports** only when `org_workspace_role` is not
`no_access` (hidden on Program Dashboards) and **My reports** only for Creators, with an empty
state when they have none. Seeded My reports: Daniel Okafor `adobe_editor` (My Partners: Exam
Readiness), Maya Chen `adobe_admin` (Draft: Program Health Check), Laura Martín `lenovo_editor`
(My Region: Partner Pipeline), Sofia Rossi `nutanix_editor` (Recertification Follow-ups). Create
more with `embed-host/scripts/create-org-dashboard.mjs <identity> --personal`, then write the
AML into the generated file.

The page subtitle of a team report reads "Built by … · Created … · Last updated …". Holistics
exposes none of this to the embed, so `embed-host/scripts/report-meta.mjs` reads it from the
`Embed user <id> (Org: …)` commits at image build. A report saved after the build is recorded in
the viewer's browser (built by the current persona, now) until the next deploy.

Show the Adobe client admin, then the Lenovo client admin: the same dashboard re-brands itself (name, industry, colour) and shows
only that client's programs, partners and AI answers. The internal admin sees "All Rockinfo clients".

## What the token controls

| Concern | Field |
| --- | --- |
| Which rows | `user_attributes.rockinfo_client_id` → dataset permission `client_access` |
| Which content | `embed_portal` → objects listed in `rockinfo_client_portal` |
| Who can build | `permissions.org_workspace_role`, `permissions.enable_personal_workspace` |
| AI on or off | `settings.ai.enabled` (keep `true`: the portal's `initial_object` is `'ai'`) |
| Landing page | portal `initial_object: 'ai'`; append `/objects/rockinfo_program_performance` to the embed URL to open the dashboard instead |
| Session length | `exp` |

User-built dashboards are saved as AML in the Git-connected project, so client-made reports
use the same governed metrics as Rockinfo's own.
