// What the Rockinfo sidebar can open, in order: AI first, then each dashboard, then each
// dataset. Every entry loads on its own at /embed/<key>/objects/<name>. Names must match the
// objects in ../../embeds/rockinfo_client_portal.embed.aml; the server rejects any other view.

export const SECTIONS = [
  {
    key: 'ai',
    label: 'AI',
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
    // Explore is for people who can build; viewers get dashboards and Rocky AI only.
    editorsOnly: true,
    items: [
      {
        id: 'rockinfo_credentialing',
        title: 'Credentialing Analytics',
        sub: 'Explore the governed dataset and build your own charts, scoped to your rows.',
      },
    ],
  },
];

for (const s of SECTIONS) for (const i of s.items) i.path ??= `/objects/${i.id}`;

export const VIEWS = new Map(
  SECTIONS.flatMap((s) => s.items.map((i) => [i.id, { ...i, section: s.key, editorsOnly: !!s.editorsOnly }])),
);

// Sidebar entries this identity may open: viewers never see editor-only sections.
export const canOpen = (identity, viewId) => {
  if (workspaceView(viewId)) return true;
  const v = VIEWS.get(viewId);
  return !!v && (!v.editorsOnly || identity.access === 'editor');
};
// Dashboards the tenant's own editors saved to their shared (org) or personal workspace.
// Holistics lists them in the iframe's embed:loaded event; the sidebar shows them under
// these sections and opens one as view `ws:<uname>`. Holistics enforces who may open it.
export const WORKSPACE_SECTIONS = [
  { key: 'org', label: 'Team reports', empty: 'No team reports yet. Editors build one in Explore and save it to the Shared workspace.' },
  { key: 'personal', label: 'My reports', editorsOnly: true },
];
const UNAME = /^[a-z0-9_]{1,120}$/;
export const workspaceView = (viewId) => {
  const m = /^ws:(.+)$/.exec(viewId || '');
  return m && UNAME.test(m[1]) ? { id: viewId, title: m[1], path: `/objects/${m[1]}` } : null;
};

export const viewsFor = (identity) => [...VIEWS.keys()].filter((id) => canOpen(identity, id));
export const DEFAULT_VIEW = 'ai';
