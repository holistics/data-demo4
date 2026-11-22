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

Each customer tenant is on one analytics plan and has several user roles. A user gets what both
the plan and the role allow. Plans (`PLANS`), roles (`ROLES`) and each tenant's plan (`TENANTS`)
live in `embed-host/lib/tenants.mjs`; the host's **Plans & permissions** page renders the plan
matrix. The persona menu lists tenants from the most expensive plan down, and roles inside a
tenant from most to least permission. A middle role the plan makes identical to one above it is
left out; the homepage opens as the Adobe client admin.

| Tenant | Plan | Personas (`embed_user_id`), admin first |
| --- | --- | --- |
| Adobe | Enterprise (premium) | `adobe_admin`, `adobe_editor`, `adobe_analyst`, `adobe_viewer` |
| Lenovo | Self-service (add-on) | `lenovo_admin`, `lenovo_analyst`, `lenovo_viewer` |
| Nutanix | Insights (add-on) | `nutanix_admin`, `nutanix_viewer` |
| F5 | Essentials (included) | `f5_admin`, `f5_viewer` |
| Cloudinary | Essentials (included) | `cloudinary_admin`, `cloudinary_viewer` |
| Rockinfo | Internal | `rockinfo_internal_admin`, `embed_org_id: rockinfo_internal`, all nine clients |

| Role (`<slug>_<key>`) | `org_workspace_role` | Personal | Ask AI | Explore | PDF | CSV | Schedules |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Client admin (`admin`) | `editor` | yes | yes | yes | yes | yes | yes |
| Program manager (`editor`) | `viewer` | yes | yes | yes | yes | no | yes |
| Program analyst (`analyst`) | `viewer` | no | yes | no | yes | no | yes |
| Partner success viewer (`viewer`) | `viewer` | no | no | no | yes | no | no |

Each cell is then capped by the tenant's plan: only Enterprise allows `editor` and CSV, only
Self-service and up allow Explore and Personal, and only Insights and up allow Ask AI and schedules.

Every client persona uses `embed_org_id: client_<id>` and `rockinfo_client_id: [<id>]`.
Tenants in the embed host: Adobe `101`, Lenovo `102`, Nutanix `105`, F5 `106`, Cloudinary `109`.
Plans without Ask AI open on Program Performance. The host hides Rocky AI and Datasets from plans
without them and refuses to sign those views (`requires` in `embed-host/lib/portal.mjs`). The
dataset is still a portal object because Ask AI needs it, so Explore is a host-side guard, not a
Holistics permission.

**Team reports** are dashboards a tenant's admin saved (org `editor`, so only Enterprise tenants can publish new ones) to their Shared workspace
(`embed_org_id`). The host lists them from the iframe's `embed:loaded` event (`workspace: 'org'`)
and opens one as `/objects/<uname>`; every user in that org sees them. Seeded
reports: Adobe (Partner Voucher Watchlist, Recertification Pipeline), Lenovo (Partner Enablement
Scorecard, Regional Certification Coverage), Nutanix (Exam Performance), F5 (Voucher Sales by
Channel), Cloudinary (Learning Engagement).

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
