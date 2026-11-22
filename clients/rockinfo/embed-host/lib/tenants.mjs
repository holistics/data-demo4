// Server-side registry of the Rockinfo customers (tenants), the analytics plan each one
// buys, and the user roles inside a tenant. The browser only ever sends an identity
// id; tenant, portal and permissions are resolved here, so nobody can switch tenant or
// plan by editing the request.

// Each tenant buys one plan, most expensive first (the persona menu keeps this order), and
// optionally the Data Export add-on.
export const TENANTS = [
  { id: 101, slug: 'adobe', name: 'Adobe', accent: '#EB1000', plan: 'enterprise', dataExport: true },
  { id: 102, slug: 'lenovo', name: 'Lenovo', accent: '#E2231A', plan: 'enterprise', dataExport: true },
  { id: 106, slug: 'f5', name: 'F5', accent: '#E4002B', plan: 'studio', dataExport: true },
  { id: 105, slug: 'nutanix', name: 'Nutanix', accent: '#7855FA', plan: 'studio', dataExport: false },
  { id: 109, slug: 'cloudinary', name: 'Cloudinary', accent: '#3448C5', plan: 'dashboards', dataExport: false },
];

// A fictional person behind each embed_user_id, so "Built by" reads like a real user.
// Keyed by the full id and covering every role, including roles a plan hides from the menu,
// because their earlier reports still name them. The ids themselves never change.
export const PEOPLE = {
  adobe_admin: 'Maya Chen', adobe_editor: 'Daniel Okafor', adobe_analyst: 'Priya Raman', adobe_viewer: 'Tom Becker',
  lenovo_admin: 'Wei Zhang', lenovo_editor: 'Laura Martín', lenovo_analyst: 'Kenji Sato', lenovo_viewer: 'Aisha Bello',
  nutanix_admin: 'Rahul Mehta', nutanix_editor: 'Sofia Rossi', nutanix_analyst: 'James Carter', nutanix_viewer: 'Linh Tran',
  f5_admin: 'Emma Larsen', f5_editor: 'Carlos Mendes', f5_analyst: 'Hana Kim', f5_viewer: 'Noah Fischer',
  cloudinary_admin: 'Olivia Grant', cloudinary_editor: 'Yusuf Demir', cloudinary_analyst: 'Chloé Dubois', cloudinary_viewer: 'Ben Walker',
  rockinfo_internal_admin: 'Sam Rivera',
};

// Every seeded tenant: Adobe, Lenovo, SonicWall, Axway, Nutanix, F5, Gigamon, RStudio, Cloudinary.
export const ALL_CLIENT_IDS = [101, 102, 103, 104, 105, 106, 107, 108, 109];

// One portal for every customer. Per-client branding comes from the data-driven
// header inside the dashboard; tenant isolation comes from rockinfo_client_id.
export const PORTAL = 'rockinfo_client_portal';

// What a customer org buys (the plan sets the limit) versus what a person in it can do (the
// role their admin assigns). Each capability maps to one embed-token field (see ../server.mjs);
// `explore` is enforced by the host sidebar because the dataset stays in the shared portal for
// Rocky AI.
//   ai: Rocky AI for every user.  build: Creators get Explore and My reports.
//   publish: who may publish Team reports: 'none' (no Team reports at all), 'creators' (every
//   Creator) or 'publishers' (only roles the admin names Publisher).
export const PLANS = [
  {
    key: 'dashboards', name: 'Program Dashboards', price: 'Included',
    pitch: 'Your certification program, measured from day one: Rockinfo dashboards, PDF export and scheduled email reports for every user.',
    ai: false, build: false, publish: 'none', roles: ['viewer'],
  },
  {
    key: 'studio', name: 'Analytics Studio', price: 'Add-on · per Creator seat',
    pitch: 'Everyone asks Rocky AI. Creators explore, build their own reports and publish them to the team. Viewers are always free.',
    ai: true, build: true, publish: 'creators', roles: ['editor', 'viewer'],
  },
  {
    key: 'enterprise', name: 'Studio Enterprise', price: 'Premium',
    pitch: 'Analytics Studio with publishing controls: the admin names who publishes, so Team reports stay curated as more people build.',
    ai: true, build: true, publish: 'publishers', roles: ['admin', 'editor', 'viewer'],
  },
];

// Sold on top of any plan; gives raw rows to the people the admin chooses.
export const ADDONS = [
  {
    key: 'dataExport', name: 'Data Export', price: 'Add-on · any plan',
    pitch: 'Row-level CSV and Excel for the people the admin chooses, to reconcile vouchers or load a CRM.',
    role: 'analyst',
  },
];

// Roles inside a tenant, most permissions first. Keys are the embed_user_id suffix, so earlier
// personas (adobe_admin, adobe_editor, ...) keep their reports and personal dashboards.
export const ROLES = [
  { key: 'admin', title: 'Program manager', creator: true, publisher: true, pitch: 'Builds reports and decides what reaches the whole team.' },
  { key: 'editor', title: 'Partner manager', creator: true, publisher: false, pitch: 'Builds reports with Rocky AI and Explore.' },
  { key: 'analyst', title: 'Channel operations analyst', creator: false, export: true, pitch: 'Pulls the rows behind a report into finance and CRM tools.' },
  { key: 'viewer', title: 'VP partner ecosystem', creator: false, pitch: 'Reads Rockinfo dashboards and team reports, and gets them by email.' },
];

const canPublish = (plan, role) => plan.build && role.creator && (plan.publish === 'creators' || (plan.publish === 'publishers' && role.publisher));

export function capsFor(plan, role, tenant) {
  const build = plan.build && role.creator;
  return {
    ai: plan.ai,
    explore: build,
    personal: build,
    // Program Dashboards has no Team reports at all, so the org workspace is hidden by Holistics.
    org: plan.publish === 'none' ? 'no_access' : canPublish(plan, role) ? 'editor' : 'viewer',
    pdf: true,
    schedules: true,
    csv: !!(tenant.dataExport && role.export),
  };
}

// The seat a person holds: what the plan and their role add up to.
export function seatFor(plan, role, tenant) {
  if (plan.build && role.creator) {
    if (!canPublish(plan, role)) return 'Creator, builds privately';
    return plan.publish === 'publishers' ? 'Creator + Publisher' : 'Creator';
  }
  return tenant.dataExport && role.export ? 'Viewer + Data Export' : 'Viewer';
}

const INTERNAL_CAPS = { ai: true, explore: true, org: 'editor', personal: true, pdf: true, csv: true, schedules: true };

export function identities() {
  const list = [];
  for (const t of TENANTS) {
    const p = PLANS.find((x) => x.key === t.plan);
    const keys = [...p.roles];
    if (t.dataExport) keys.splice(keys.length - 1, 0, 'analyst');
    for (const r of ROLES.filter((x) => keys.includes(x.key))) {
      const seat = seatFor(p, r, t);
      list.push({
        id: `${t.slug}_${r.key}`,
        name: PEOPLE[`${t.slug}_${r.key}`],
        tenantSlug: t.slug,
        tenantName: t.name,
        accent: t.accent,
        title: r.title,
        seat,
        role: `${seat} · ${r.pitch}`,
        plan: p.key,
        planName: p.name + (t.dataExport ? ' + Data Export' : ''),
        dataExport: !!t.dataExport,
        caps: capsFor(p, r, t),
        clientIds: [t.id],
        orgId: `client_${t.id}`,
        portal: PORTAL,
      });
    }
  }
  list.push({
    id: 'rockinfo_internal_admin',
    name: PEOPLE.rockinfo_internal_admin,
    tenantSlug: 'rockinfo',
    tenantName: 'Rockinfo (all customers)',
    accent: '#0B6E4F',
    title: 'Rockinfo internal admin',
    seat: 'Internal',
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

// Every person who may appear as a report author: name, role title and tenant.
export function people() {
  const out = {};
  for (const t of TENANTS) for (const r of ROLES) {
    const id = `${t.slug}_${r.key}`;
    out[id] = { name: PEOPLE[id], title: r.title, tenantName: t.name };
  }
  out.rockinfo_internal_admin = { name: PEOPLE.rockinfo_internal_admin, title: 'Rockinfo internal admin', tenantName: 'Rockinfo' };
  return out;
}
