// Server-side registry of the Rockinfo customers (tenants), the analytics plans Rockinfo
// could sell them, and one test persona per plan. The browser only ever sends an identity
// id; tenant, portal and permissions are resolved here, so nobody can switch tenant or
// plan by editing the request.

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

// Analytics plans, cheapest first. Each capability maps to one embed-token field
// (see tokenFor in ../server.mjs); `explore` is enforced by the host sidebar because the
// dataset stays in the shared portal for Ask AI. Persona keys are the embed_user_id
// suffix, so existing editor and viewer users keep their personal dashboards.
export const PLANS = [
  {
    key: 'essentials', name: 'Essentials', price: 'Included', persona: 'viewer', title: 'Partner success viewer',
    pitch: 'Every user gets the standard dashboards and the reports their team publishes.',
    caps: { ai: false, explore: false, org: 'viewer', personal: false, pdf: true, csv: false, schedules: false },
  },
  {
    key: 'insights', name: 'Insights', price: 'Add-on', persona: 'analyst', title: 'Program analyst',
    pitch: 'Adds Rocky AI and scheduled email reports, without building anything.',
    caps: { ai: true, explore: false, org: 'viewer', personal: false, pdf: true, csv: false, schedules: true },
  },
  {
    key: 'selfservice', name: 'Self-service', price: 'Add-on', persona: 'editor', title: 'Program manager',
    pitch: 'Adds Explore and a private workspace to build their own reports.',
    caps: { ai: true, explore: true, org: 'viewer', personal: true, pdf: true, csv: false, schedules: true },
  },
  {
    key: 'enterprise', name: 'Enterprise', price: 'Premium', persona: 'admin', title: 'Client admin',
    pitch: 'Publishes self-built reports to the whole team and downloads raw data.',
    caps: { ai: true, explore: true, org: 'editor', personal: true, pdf: true, csv: true, schedules: true },
  },
];

const INTERNAL_CAPS = { ai: true, explore: true, org: 'editor', personal: true, pdf: true, csv: true, schedules: true };

export function identities() {
  const list = [];
  for (const t of TENANTS) {
    for (const p of PLANS) {
      list.push({
        id: `${t.slug}_${p.persona}`,
        tenantSlug: t.slug,
        tenantName: t.name,
        accent: t.accent,
        title: p.title,
        role: `${p.name} plan · ${p.pitch}`,
        plan: p.key,
        caps: p.caps,
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
    plan: 'internal',
    caps: INTERNAL_CAPS,
    clientIds: ALL_CLIENT_IDS,
    orgId: 'rockinfo_internal',
    portal: PORTAL,
  });
  return list;
}
