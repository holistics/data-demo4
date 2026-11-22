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
  const v = VIEWS.get(viewId);
  return !!v && (!v.editorsOnly || identity.access === 'editor');
};
export const viewsFor = (identity) => [...VIEWS.keys()].filter((id) => canOpen(identity, id));
export const DEFAULT_VIEW = 'ai';
