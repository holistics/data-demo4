// Server-side registry of the Rockinfo customers (tenants) and test personas.
// The browser only ever sends an identity id; tenant, portal and permissions
// are resolved here, so nobody can switch tenant by editing the request.

export const TENANTS = [
  { id: 101, slug: 'adobe', name: 'Adobe', accent: '#EB1000' },
  { id: 102, slug: 'lenovo', name: 'Lenovo', accent: '#E2231A' },
  { id: 105, slug: 'nutanix', name: 'Nutanix', accent: '#7855FA' },
  { id: 106, slug: 'f5', name: 'F5', accent: '#E4002B' },
  { id: 109, slug: 'cloudinary', name: 'Cloudinary', accent: '#3448C5' },
];

// Every seeded tenant: Adobe, Lenovo, SonicWall, Axway, Nutanix, F5, Gigamon, RStudio, Cloudinary.
export const ALL_CLIENT_IDS = [101, 102, 103, 104, 105, 106, 107, 108, 109];

// One portal for every customer. Per-client branding comes from the data-driven
// header inside the dashboard; tenant isolation comes from rockinfo_client_id.
export const PORTAL = 'rockinfo_client_portal';

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
        portal: PORTAL,
      });
    }
  }
  list.push({
    id: 'rockinfo_internal_admin',
    tenantSlug: 'rockinfo',
    tenantName: 'Rockinfo (all customers)',
    accent: '#0B6E4F',
    title: 'Rockinfo internal admin',
    role: 'Sees every customer in the same portal',
    access: 'editor',
    clientIds: ALL_CLIENT_IDS,
    orgId: 'rockinfo_internal',
    portal: PORTAL,
  });
  return list;
}

