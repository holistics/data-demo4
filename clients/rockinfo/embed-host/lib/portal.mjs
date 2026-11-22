// What the Rockinfo sidebar can open, in order: AI first, then each dashboard, then each
// dataset. Every entry loads on its own at /embed/<key>/objects/<name>. Names must match the
// objects in ../../embeds/rockinfo_client_portal.embed.aml; the server rejects any other view.

export const SECTIONS = [
  {
    key: 'ai',
    label: 'AI',
    requires: 'ai',
    items: [
      {
        id: 'ai',
        title: 'Rocky AI',
        sub: 'Ask anything about your own candidates, exams, credentials and vouchers.',
        path: '/ai',
      },
    ],
  },
  {
    key: 'dashboards',
    label: 'Dashboards',
    items: [
      {
        id: 'rockinfo_program_performance',
        title: 'Program Performance',
        sub: 'Completion, pass rates, credentials and vouchers for your organisation.',
      },
      {
        id: 'rockinfo_partner_detail',
        title: 'Partner Detail',
        sub: 'One channel partner: vouchers, orders and candidates.',
      },
      {
        id: 'rockinfo_candidate_record',
        title: 'Candidate Record',
        sub: 'One candidate across learning, exams and credentials.',
      },
    ],
  },
  {
    key: 'datasets',
    label: 'Datasets',
    // Explore is for plans that can build; the others never see the dataset entry.
    requires: 'explore',
    items: [
      {
        id: 'rockinfo_credentialing',
        title: 'Credentialing Analytics',
        sub: 'Explore the governed dataset and build your own charts, scoped to your rows.',
      },
    ],
  },
  {
    key: 'about',
    label: 'Your plan',
    items: [
      {
        id: 'plans',
        title: 'Plans & permissions',
        sub: 'What each analytics plan can and cannot do, and how self-built reports are packaged.',
        native: true,
      },
    ],
  },
];

for (const s of SECTIONS) for (const i of s.items) i.path ??= `/objects/${i.id}`;

export const VIEWS = new Map(
  SECTIONS.flatMap((s) => s.items.map((i) => [i.id, { ...i, section: s.key, requires: s.requires }])),
);

// Sidebar entries this identity's plan may open (`requires` names a plan capability).
export const canOpen = (identity, viewId) => {
  if (workspaceView(viewId)) return true;
  const v = VIEWS.get(viewId);
  return !!v && (!v.requires || !!identity.caps[v.requires]);
};
// Dashboards the tenant's own editors saved to their shared (org) or personal workspace.
// Holistics lists them in the iframe's embed:loaded event; the sidebar shows them under
// these sections and opens one as view `ws:<uname>`. Holistics enforces who may open it.
export const WORKSPACE_SECTIONS = [
  {
    key: 'org', label: 'Team reports',
    empty: 'No team reports yet. Creators build one in Explore and publish it to the team.',
    locked: 'Team reports come with Analytics Studio: your Creators build reports and share them with everyone here.',
  },
  { key: 'personal', label: 'My reports', requires: 'personal' },
];
const UNAME = /^[a-z0-9_]+(\.[a-z0-9_]+)?$/;
export const workspaceView = (viewId) => {
  const m = /^ws:(.+)$/.exec(viewId || '');
  return m && UNAME.test(m[1]) ? { id: viewId, title: m[1], path: `/objects/${m[1]}` } : null;
};

export const viewsFor = (identity) => [...VIEWS.keys()].filter((id) => canOpen(identity, id));
export const DEFAULT_VIEW = 'ai';
// First view for a plan without Rocky AI.
export const homeFor = (identity) => (identity.caps.ai ? 'ai' : 'rockinfo_program_performance');
