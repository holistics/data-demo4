// Server-side registry of the Rockinfo customers (tenants) and test personas.
// The browser only ever sends an identity id; tenant, portal and permissions
// are resolved here, so nobody can switch tenant by editing the request.

export const TENANTS = [
  { id: 101, slug: 'adobe', name: 'Adobe', accent: '#EB1000', portal: 'rockinfo_portal_adobe' },
  { id: 102, slug: 'lenovo', name: 'Lenovo', accent: '#E2231A', portal: 'rockinfo_portal_lenovo' },
  { id: 105, slug: 'nutanix', name: 'Nutanix', accent: '#7855FA', portal: 'rockinfo_portal_nutanix' },
  { id: 106, slug: 'f5', name: 'F5', accent: '#E4002B', portal: 'rockinfo_portal_f5' },
  { id: 109, slug: 'cloudinary', name: 'Cloudinary', accent: '#3448C5', portal: 'rockinfo_portal_cloudinary' },
];

// Every seeded tenant: Adobe, Lenovo, SonicWall, Axway, Nutanix, F5, Gigamon, RStudio, Cloudinary.
export const ALL_CLIENT_IDS = [101, 102, 103, 104, 105, 106, 107, 108, 109];

export const NEUTRAL_PORTAL = 'rockinfo_client_portal';

const PERSONAS = [
  { key: 'editor', title: 'Program manager', role: 'Client editor: explore, build dashboards, ask AI' },
  { key: 'viewer', title: 'Partner success viewer', role: 'Viewer: dashboards only, AI off' },
];

export function identities() {
  const list = [];
  for (const t of TENANTS) {
    for (const p of PERSONAS) {
      list.push({
        id: `${t.slug}_${p.key}`,
        tenantSlug: t.slug,
        tenantName: t.name,
        accent: t.accent,
        title: p.title,
        role: p.role,
        access: p.key,
        clientIds: [t.id],
        orgId: `client_${t.id}`,
        portal: t.portal,
      });
    }
  }
  list.push({
    id: 'rockinfo_internal_admin',
    tenantSlug: 'rockinfo',
    tenantName: 'Rockinfo (all customers)',
    accent: '#0B6E4F',
    title: 'Rockinfo internal admin',
    role: 'Sees every customer through the neutral portal',
    access: 'editor',
    clientIds: ALL_CLIENT_IDS,
    orgId: 'rockinfo_internal',
    portal: NEUTRAL_PORTAL,
  });
  return list;
}

// THEMED_PORTALS=off falls back to the neutral portal for every customer,
// for use before the per-customer portals are published on demo4.
export function resolvePortal(identity, env) {
  return env.THEMED_PORTALS === 'off' ? NEUTRAL_PORTAL : identity.portal;
}
