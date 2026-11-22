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
    embed_portal: client.portal || 'rockinfo_client_portal', // e.g. rockinfo_portal_adobe
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
      ai: { enabled: user.role !== 'viewer' },
    },
    exp: Math.floor(Date.now() / 1000) + 60 * 60, // 1 hour
  };
  const token = jwt.sign(payload, EMBED_SECRET, { algorithm: 'HS256' });
  return `https://demo4.holistics.io/embed/${EMBED_KEY_ID}?_token=${token}`;
}
```

## Test identities for the call

| Persona | `embed_portal` | `embed_org_id` | `rockinfo_client_id` | Workspace role |
| --- | --- | --- | --- | --- |
| Adobe program manager (client editor) | `rockinfo_portal_adobe` | `client_101` | `[101]` | `editor` + personal |
| Lenovo partner manager (viewer) | `rockinfo_portal_lenovo` | `client_102` | `[102]` | `viewer` |
| Nutanix | `rockinfo_portal_nutanix` | `client_105` | `[105]` | `editor` |
| F5 | `rockinfo_portal_f5` | `client_106` | `[106]` | `editor` |
| Cloudinary | `rockinfo_portal_cloudinary` | `client_109` | `[109]` | `editor` |
| Rockinfo internal admin, all clients | `rockinfo_client_portal` | `rockinfo_internal` | `[101, 102, 103, 104, 105, 106, 107, 108, 109]` | `editor` |

Show Adobe, then Lenovo: different theme, programs, partners and AI answers from one
governed dataset. Then send the Lenovo portal with `rockinfo_client_id: [101]`: it shows
Adobe's data in Lenovo's theme, which proves the token, not the portal, decides data access.

## What the token controls

| Concern | Field |
| --- | --- |
| Which rows | `user_attributes.rockinfo_client_id` → dataset permission `client_access` |
| Which content | `embed_portal` → objects listed in `rockinfo_client_portal` |
| Who can build | `permissions.org_workspace_role`, `permissions.enable_personal_workspace` |
| AI on or off | `settings.ai.enabled` |
| Session length | `exp` |

User-built dashboards are saved as AML in the Git-connected project, so client-made reports
use the same governed metrics as Rockinfo's own.
