// Server-side registry of the Rockinfo customers (tenants), the analytics plan each one
// buys, and the user roles inside a tenant. The browser only ever sends an identity
// id; tenant, portal and permissions are resolved here, so nobody can switch tenant or
// plan by editing the request.

// Each tenant is on one plan, most expensive first; the persona menu keeps this order.
export const TENANTS = [
  { id: 101, slug: 'adobe', name: 'Adobe', accent: '#EB1000', plan: 'enterprise' },
  { id: 102, slug: 'lenovo', name: 'Lenovo', accent: '#E2231A', plan: 'enterprise' },
  { id: 105, slug: 'nutanix', name: 'Nutanix', accent: '#7855FA', plan: 'selfservice' },
  { id: 106, slug: 'f5', name: 'F5', accent: '#E4002B', plan: 'insights' },
  { id: 109, slug: 'cloudinary', name: 'Cloudinary', accent: '#3448C5', plan: 'essentials' },
];

// Every seeded tenant: Adobe, Lenovo, SonicWall, Axway, Nutanix, F5, Gigamon, RStudio, Cloudinary.
export const ALL_CLIENT_IDS = [101, 102, 103, 104, 105, 106, 107, 108, 109];

// One portal for every customer. Per-client branding comes from the data-driven
// header inside the dashboard; tenant isolation comes from rockinfo_client_id.
export const PORTAL = 'rockinfo_client_portal';

// Analytics plans, cheapest first. Each capability maps to one embed-token field
// (see tokenFor in ../server.mjs); `explore` is enforced by the host sidebar because the
// dataset stays in the shared portal for Ask AI.
export const PLANS = [
  {
    key: 'essentials', name: 'Essentials', price: 'Included',
    pitch: 'Every user gets the standard dashboards and the reports their team publishes.',
    caps: { ai: false, explore: false, org: 'viewer', personal: false, pdf: true, csv: false, schedules: false },
  },
  {
    key: 'insights', name: 'Insights', price: 'Add-on',
    pitch: 'Adds Rocky AI and scheduled email reports, without building anything.',
    caps: { ai: true, explore: false, org: 'viewer', personal: false, pdf: true, csv: false, schedules: true },
  },
  {
    key: 'selfservice', name: 'Self-service', price: 'Add-on',
    pitch: 'Adds Explore and a private workspace to build their own reports.',
    caps: { ai: true, explore: true, org: 'viewer', personal: true, pdf: true, csv: false, schedules: true },
  },
  {
    key: 'enterprise', name: 'Enterprise', price: 'Premium',
    pitch: 'Publishes self-built reports to the whole team and downloads raw data.',
    caps: { ai: true, explore: true, org: 'editor', personal: true, pdf: true, csv: true, schedules: true },
  },
];

// Roles inside a tenant, most permissions first. A user gets what both the role and the
// tenant's plan allow. Role keys are the embed_user_id suffix, so earlier personas
// (adobe_admin, adobe_editor, ...) keep their personal dashboards.
export const ROLES = [
  {
    key: 'admin', title: 'Client admin', pitch: 'Everything the plan includes, and publishes reports to the whole team.',
    caps: { ai: true, explore: true, org: 'editor', personal: true, pdf: true, csv: true, schedules: true },
  },
  {
    key: 'editor', title: 'Program manager', pitch: 'Builds private reports in Explore.',
    caps: { ai: true, explore: true, org: 'viewer', personal: true, pdf: true, csv: false, schedules: true },
  },
  {
    key: 'analyst', title: 'Program analyst', pitch: 'Asks Rocky AI and schedules email reports.',
    caps: { ai: true, explore: false, org: 'viewer', personal: false, pdf: true, csv: false, schedules: true },
  },
  {
    key: 'viewer', title: 'Partner success viewer', pitch: 'Reads the dashboards and team reports.',
    caps: { ai: false, explore: false, org: 'viewer', personal: false, pdf: true, csv: false, schedules: false },
  },
];

const capsFor = (plan, role) =>
  Object.fromEntries(
    Object.keys(plan).map((k) => [k, k === 'org' ? (plan.org === 'editor' && role.org === 'editor' ? 'editor' : 'viewer') : plan[k] && role[k]]),
  );
const sameCaps = (a, b) => JSON.stringify(a) === JSON.stringify(b);

const INTERNAL_CAPS = { ai: true, explore: true, org: 'editor', personal: true, pdf: true, csv: true, schedules: true };

export function identities() {
  const list = [];
  for (const t of TENANTS) {
    const p = PLANS.find((x) => x.key === t.plan);
    const seen = [];
    for (const r of ROLES) {
      const caps = capsFor(p.caps, r.caps);
      // Skip a middle role the plan makes identical to one above it; admin and viewer always show.
      if (r.key !== 'viewer' && seen.some((c) => sameCaps(c, caps))) continue;
      seen.push(caps);
      list.push({
        id: `${t.slug}_${r.key}`,
        tenantSlug: t.slug,
        tenantName: t.name,
        accent: t.accent,
        title: r.title,
        role: r.pitch,
        plan: p.key,
        planName: p.name,
        caps,
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
    planName: 'Internal',
    caps: INTERNAL_CAPS,
    clientIds: ALL_CLIENT_IDS,
    orgId: 'rockinfo_internal',
    portal: PORTAL,
  });
  return list;
}
