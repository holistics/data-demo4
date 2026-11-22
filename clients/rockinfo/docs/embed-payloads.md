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

Each customer tenant has the same two personas; only the client ID changes.

| Persona | `embed_org_id` | `rockinfo_client_id` | Workspace role | Sidebar |
| --- | --- | --- | --- | --- |
| Program manager (client editor) | `client_<id>` | `[<id>]` | `editor` + personal | Rocky AI, dashboards, Team reports, My reports, Datasets (Explore) |
| Partner success viewer | `client_<id>` | `[<id>]` | `viewer`, no personal | Rocky AI, dashboards, Team reports; no Datasets |
| Rockinfo internal admin, all clients | `rockinfo_internal` | `[101, 102, 103, 104, 105, 106, 107, 108, 109]` | `editor` + personal | Everything |

Tenants in the embed host: Adobe `101`, Lenovo `102`, Nutanix `105`, F5 `106`, Cloudinary `109`
(`embed-host/lib/tenants.mjs`). The host hides Datasets from viewers and refuses to sign a viewer
token for it (`editorsOnly` in `embed-host/lib/portal.mjs`). The dataset is still a portal object,
so this is a host-side guard, not a Holistics permission.

**Team reports** are dashboards a tenant's editors saved to their Shared workspace
(`embed_org_id`). The host lists them from the iframe's `embed:loaded` event (`workspace: 'org'`)
and opens one as `/objects/<uname>`; every user in that org, viewers included, sees them. Seeded
reports: Adobe (Partner Voucher Watchlist, Recertification Pipeline), Lenovo (Partner Enablement
Scorecard, Regional Certification Coverage), Nutanix (Exam Performance), F5 (Voucher Sales by
Channel), Cloudinary (Learning Engagement).

Show the Adobe editor, then the Lenovo editor: the same dashboard re-brands itself (name, industry, colour) and shows
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
