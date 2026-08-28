# Embed Portal contract

- Keep the portal limited to `brainstorm_apac_dashboard` and the 3 governed datasets unless the user expands the POC.
- Require each dataset `company_access` permission. Tenant binding uses the numeric `company_id` user attribute and remains server-authoritative.
- Test tenant isolation with non-admin embedded identities. Admin or analyst access is not RLS evidence.
- Acceptance covers company IDs 1 and 4, tenant-only filters, Explore and export controls, rejection of a `company_id=999` override, and HTTP 400 for an unknown identity.
- The host app lives in the separate clean Brainstorm embed worktree. Visual acceptance uses loopback HTTPS because the portal allows HTTPS ancestors and blocks HTTP localhost.
