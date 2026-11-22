const $ = (id) => document.getElementById(id);
const frame = $('embedFrame');
const state = $('state');
const dropdown = $('userDropdown');
const userButton = $('userButton');
let users = [];
let current;
// Sidebar entries come from /api/config: AI, then each dashboard, then each dataset.
// Each one opens a single portal object on its own; the hash keeps it across reloads.
let sections = [];
const VIEWS = new Map();
let defaultView = 'ai';
// Team (org) and personal dashboards come from the iframe's embed:loaded event, per identity.
let workspaceSections = [];
let plans = [];
// Who built each workspace report and when: report-meta.json is generated from git at image
// build (scripts/report-meta.mjs); reports saved since then are recorded here in the browser.
let reportMeta = {};
let localMeta = {};
const seenOrg = new Map();
try { localMeta = JSON.parse(localStorage.getItem('rockinfo.reportMeta') || '{}'); } catch {}
const saveLocalMeta = () => { try { localStorage.setItem('rockinfo.reportMeta', JSON.stringify(localMeta)); } catch {} };
let workspaceItems = { org: [], personal: [] };
let embedOrigin = '';
const isWs = (id) => /^ws:[a-z0-9_]+(\.[a-z0-9_]+)?$/.test(id || '');
let view;
let inflight;

const ICONS = {
  about: '<path d="M3 6.5L10 3l7 3.5-7 3.5z" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round"/><path d="M6 8.5v4c0 1.2 1.8 2.5 4 2.5s4-1.3 4-2.5v-4" fill="none" stroke="currentColor" stroke-width="1.6"/>',
  ai: '<path d="M10 2.5l1.6 4.4 4.4 1.6-4.4 1.6L10 14.5l-1.6-4.4L4 8.5l4.4-1.6L10 2.5zM15.5 13l.7 1.8 1.8.7-1.8.7-.7 1.8-.7-1.8-1.8-.7 1.8-.7.7-1.8z" fill="currentColor"/>',
  dashboards: '<path d="M3 17h14M6 14V9M10 14V5M14 14v-3" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>',
  team: '<path d="M4 3.5h8l4 4V16.5H4z" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round"/><path d="M7 13v-2M10 13V9M13 13v-3" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>',
  datasets: '<ellipse cx="10" cy="5" rx="6" ry="2.5" fill="none" stroke="currentColor" stroke-width="1.6"/><path d="M4 5v10c0 1.4 2.7 2.5 6 2.5s6-1.1 6-2.5V5M4 10c0 1.4 2.7 2.5 6 2.5s6-1.1 6-2.5" fill="none" stroke="currentColor" stroke-width="1.6"/>',
};

// Old links used #dashboards for the main dashboard.
const viewFromHash = () => {
  const h = location.hash.slice(1);
  if (h === 'dashboards') return 'rockinfo_program_performance';
  return VIEWS.has(h) || isWs(h) ? h : defaultView;
};

const wsItem = (id) => {
  for (const k of Object.keys(workspaceItems)) {
    const d = workspaceItems[k].find((x) => `ws:${x.uname}` === id);
    if (d) return { id, title: d.title, sub: metaLine(d.uname, k) };
  }
  return { id, title: 'Team report', sub: 'Built by your organisation' };
};

const fmtTime = (iso) =>
  new Date(iso).toLocaleString(undefined, { day: 'numeric', month: 'short', year: 'numeric', hour: 'numeric', minute: '2-digit' });

function personLabel(embedUserId) {
  const u = users.find((x) => x.id === embedUserId);
  return u ? `${u.title} (${u.tenantName})` : 'your team';
}

// "Built by Client admin (Adobe) · Created 22 Nov 2026, 10:50 pm · Last updated …"
function metaLine(uname, workspace) {
  const m = reportMeta[uname] || localMeta[uname];
  const kind = workspace === 'org' ? 'Team report' : 'My report';
  if (!m) return workspace === 'org' ? `${kind} · built by your organisation` : `${kind} · your personal workspace`;
  const parts = [kind, `Built by ${personLabel(m.createdBy)}`, `Created ${fmtTime(m.createdAt)}`];
  if (m.updatedAt && m.updatedAt !== m.createdAt) {
    parts.push(`Last updated ${fmtTime(m.updatedAt)}${m.updatedBy && m.updatedBy !== m.createdBy ? ` by ${personLabel(m.updatedBy)}` : ''}`);
  }
  return parts.join(' · ');
}

function navLink(id, title, sub, iconKey) {
  const a = document.createElement('a');
  a.className = 'nav-item view-link' + (iconKey === 'ai' ? ' home' : '');
  a.href = `#${id}`;
  a.dataset.view = id;
  a.title = sub;
  a.innerHTML =
    iconKey === 'ai'
      ? '<img class="nav-icon" src="/assets/rocky-ai.png" alt="" width="22" height="22" />'
      : `<svg viewBox="0 0 20 20" aria-hidden="true">${ICONS[iconKey] || ICONS.dashboards}</svg>`;
  const text = document.createElement('span');
  text.className = 'nav-label';
  text.textContent = title;
  a.appendChild(text);
  return a;
}

function navGroup(labelText) {
  const group = document.createElement('div');
  group.className = 'nav-group';
  const label = document.createElement('p');
  label.className = 'nav-section';
  label.textContent = labelText;
  group.appendChild(label);
  return group;
}

function renderWorkspaceSections(nav) {
  for (const ws of workspaceSections) {
    if (ws.requires && !current?.caps?.[ws.requires]) continue;
    const items = workspaceItems[ws.key] || [];
    if (!items.length && !ws.empty) continue;
    const group = navGroup(ws.label);
    for (const d of items) group.appendChild(navLink(`ws:${d.uname}`, d.title, wsItem(`ws:${d.uname}`).sub, 'team'));
    if (!items.length) {
      const p = document.createElement('p');
      p.className = 'nav-empty';
      p.textContent = ws.empty;
      group.appendChild(p);
    }
    nav.appendChild(group);
  }
}

function renderNav() {
  const nav = $('analyticsNav');
  nav.innerHTML = '';
  const allowed = new Set(current?.views || VIEWS.keys());
  for (const s of sections) {
    // Team and personal reports sit between the published dashboards and the datasets.
    if (s.key === 'datasets') renderWorkspaceSections(nav);
    const items = s.items.filter((item) => allowed.has(item.id));
    if (!items.length) continue;
    const group = navGroup(s.label);
    for (const item of items) group.appendChild(navLink(item.id, item.title, item.sub, s.key));
    nav.appendChild(group);
  }
  if (!sections.some((s) => s.key === 'datasets')) renderWorkspaceSections(nav);
}

const initials = (name) => name.split(/[\s()]+/).filter(Boolean).slice(0, 2).map((w) => w[0]).join('').toUpperCase();

function setState(text, isError = false) {
  state.textContent = text;
  state.hidden = !text;
  state.classList.toggle('error', isError);
}

function setMenu(open) {
  dropdown.hidden = !open;
  userButton.setAttribute('aria-expanded', String(open));
}

function renderMenu() {
  dropdown.innerHTML = '';
  const groups = new Map();
  for (const u of users) {
    const g = u.plan === 'internal' ? u.tenantName : `${u.tenantName} · ${u.planName} plan`;
    if (!groups.has(g)) groups.set(g, []);
    groups.get(g).push(u);
  }
  for (const [tenant, list] of groups) {
    const label = document.createElement('p');
    label.className = 'menu-group';
    label.textContent = tenant;
    dropdown.appendChild(label);
    for (const u of list) {
      const item = document.createElement('button');
      item.type = 'button';
      item.role = 'menuitemradio';
      item.className = 'menu-item' + (current && u.id === current.id ? ' active' : '');
      item.setAttribute('aria-checked', String(current && u.id === current.id));
      item.style.setProperty('--accent', u.accent);
      const av = document.createElement('span');
      av.className = 'avatar sm';
      av.textContent = initials(u.tenantName);
      const text = document.createElement('span');
      text.className = 'menu-text';
      const t1 = document.createElement('span');
      t1.className = 'menu-title';
      t1.textContent = u.title;
      const t2 = document.createElement('span');
      t2.className = 'menu-sub';
      t2.textContent = u.role;
      text.append(t1, t2);
      item.append(av, text);
      item.addEventListener('click', () => {
        setMenu(false);
        load(u);
      });
      dropdown.appendChild(item);
    }
  }
}

function renderPayload(payload) {
  const ids = payload.user_attributes.rockinfo_client_id;
  const facts = [
    ['Portal', payload.embed_portal],
    ['Row-level filter', `rockinfo_client_id = [${ids.join(', ')}]`],
    ['Workspace', `${payload.embed_org_id} · ${payload.permissions.org_workspace_role}`],
    ['Rocky AI', payload.settings.ai.enabled ? 'On' : 'Off'],
    ['Email subscriptions', payload.settings.allow_data_subscribe ? `On → ${payload.embed_user_email}` : 'Off'],
    ['Expires', new Date(payload.exp * 1000).toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' })],
  ];
  $('payloadFacts').innerHTML = '';
  for (const [k, v] of facts) {
    const dt = document.createElement('dt');
    dt.textContent = k;
    const dd = document.createElement('dd');
    dd.textContent = v;
    $('payloadFacts').append(dt, dd);
  }
  $('payloadJson').textContent = JSON.stringify(payload, null, 2);
  $('scopeNote').textContent =
    ids.length > 1 ? `Scoped to all ${ids.length} Rockinfo clients` : `Scoped to ${current.tenantName} only (client ${ids[0]})`;
}

async function load(user) {
  // First load keeps a #ws: deep link; only a real persona switch drops another org's report.
  const switched = !!current && current.id !== user.id;
  // Team reports belong to the tenant, so they survive a plan switch within it; My reports do not.
  if (switched) workspaceItems = { org: current.tenantSlug === user.tenantSlug ? workspaceItems.org : [], personal: [] };
  current = user;
  document.documentElement.style.setProperty('--tenant', user.accent);
  $('userAvatar').textContent = initials(user.tenantName);
  $('userName').textContent = user.title;
  $('userSub').textContent = user.tenantName;
  renderMenu();
  // A plan without this view (e.g. Essentials on Rocky AI) falls back to its own home view.
  if (isWs(view) ? switched : !user.views.includes(view)) {
    setView(user.home);
    history.replaceState(null, '', `#${user.home}`);
  }
  renderNav();
  setView(view);
  inflight?.abort();
  const native = VIEWS.get(view)?.native;
  $('frameWrap').hidden = !!native;
  $('plansView').hidden = !native;
  if (native) {
    renderPlans();
    return;
  }
  inflight = new AbortController();
  setState(`Signing a token for ${user.tenantName}…`);
  frame.classList.add('loading');
  try {
    const res = await fetch('/api/embed-token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ identity_id: user.id, view }),
      signal: inflight.signal,
    });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || `HTTP ${res.status}`);
    renderPayload(data.payload);
    $('openPortal').href = data.embedUrl;
    embedOrigin = new URL(data.embedUrl).origin;
    $('openMailbox').href = data.mailboxUrl || '#';
    $('mailboxLabel').textContent = `Open ${data.payload.embed_user_email} mailbox`;
    const reveal = () => {
      frame.classList.remove('loading');
      setState('');
    };
    frame.onload = reveal;
    frame.src = data.embedUrl;
    // The embed's own spinner takes over; don't wait on onload, which a heavy SPA can delay.
    setTimeout(reveal, 1500);
  } catch (e) {
    if (e.name === 'AbortError') return;
    setState(e.message, true);
  }
}

function setDrawer(open) {
  $('payloadPanel').classList.toggle('open', open);
  $('payloadPanel').setAttribute('aria-hidden', String(!open));
  $('scrim').hidden = !open;
  $('payloadToggle').setAttribute('aria-expanded', String(open));
}

function setView(next) {
  view = next;
  const item = VIEWS.get(view) || wsItem(view);
  $('pageTitle').textContent = item.title;
  $('pageSub').textContent = item.sub;
  document.title = `Rockinfo · ${item.title}`;
  for (const a of document.querySelectorAll('.view-link')) {
    const on = a.dataset.view === view;
    a.classList.toggle('active', on);
    if (on) a.setAttribute('aria-current', 'page');
    else a.removeAttribute('aria-current');
  }
}

// ---------- Plans & permissions (host-native page, no embed token) ----------
const CAP_ROWS = [
  { label: 'Standard dashboards', note: 'Built and maintained by Rockinfo', field: 'embed_portal', cell: () => 'yes' },
  { label: 'Team reports: view', note: 'Reports their own org published', field: 'org_workspace_role: viewer', cell: (c) => (c.org !== 'no_access' ? 'yes' : 'no') },
  { label: 'Team reports: publish', note: 'Build once, share with every user in the org', field: 'org_workspace_role: editor', cell: (c) => (c.org === 'editor' ? 'yes' : 'no'), money: true },
  { label: 'Rocky AI', note: 'Plain-English questions on their own data', field: 'settings.ai.enabled', cell: (c) => (c.ai ? 'yes' : 'no'), money: true },
  { label: 'Explore the dataset', note: 'Drag-and-drop charts on governed metrics', field: 'datasets in portal + host sidebar', cell: (c) => (c.explore ? 'yes' : 'no'), money: true },
  { label: 'My reports', note: 'Private self-built dashboards', field: 'enable_personal_workspace', cell: (c) => (c.personal ? 'yes' : 'no'), money: true },
  { label: 'PDF / PNG export', note: 'Download a dashboard', field: 'allow_dashboard_export', cell: (c) => (c.pdf ? 'yes' : 'no') },
  { label: 'Scheduled email reports', note: 'Dashboards delivered to their inbox', field: 'allow_data_subscribe', cell: (c) => (c.schedules ? 'yes' : 'no'), money: true },
  { label: 'Raw data download', note: 'CSV / Excel of the rows behind a chart', field: 'allow_raw_data_export', cell: (c) => (c.csv ? 'yes' : 'no'), money: true },
  { label: 'Tenant isolation', note: 'Only their own organisation’s rows, always', field: 'user_attributes.rockinfo_client_id', cell: () => 'yes' },
];

const el = (tag, cls, text) => {
  const n = document.createElement(tag);
  if (cls) n.className = cls;
  if (text != null) n.textContent = text;
  return n;
};

// The admin of the first tenant on that plan (users are listed admin first).
const personaFor = (planKey) => users.find((u) => u.plan === planKey);
const tenantsOn = (planKey) => [...new Set(users.filter((u) => u.plan === planKey).map((u) => u.tenantName))].join(', ');

function tryButton(planKey) {
  const u = personaFor(planKey);
  const here = current.plan === planKey;
  const b = el('button', 'plan-try', here ? 'Your tenant is on this plan' : `Try as ${u.tenantName} ${u.title.toLowerCase()}`);
  b.type = 'button';
  b.disabled = here;
  // Land on the plan's home view so the embed loads and its Team reports appear.
  b.addEventListener('click', () => {
    setView(u.home);
    history.replaceState(null, '', `#${u.home}`);
    load(u);
  });
  return b;
}

function renderPlans() {
  const root = $('plansView');
  root.innerHTML = '';
  const intro = el('section', 'plans-intro');
  intro.append(
    el('h2', null, 'Package analytics the way you sell your platform'),
    el('p', null, 'One portal, one governed dataset and one token per user. The plan only changes a few fields in the signed embed token, so Rockinfo can price self-service and AI as add-ons without building anything per customer. Switch persona to feel each plan.'),
  );
  root.appendChild(intro);

  const cards = el('section', 'plan-cards');
  for (const p of plans) {
    const card = el('article', 'plan-card' + (current.plan === p.key ? ' current' : ''));
    const head = el('div', 'plan-head');
    head.append(el('h3', null, p.name), el('span', 'plan-price', p.price));
    card.append(head, el('p', 'plan-persona', tenantsOn(p.key)), el('p', 'plan-pitch', p.pitch), tryButton(p.key));
    cards.appendChild(card);
  }
  root.appendChild(cards);

  const tableWrap = el('section', 'plan-matrix-wrap');
  tableWrap.appendChild(el('h2', null, 'What each plan can and cannot do'));
  const table = el('table', 'plan-matrix');
  const thead = el('thead');
  const hr = el('tr');
  hr.appendChild(el('th', null, 'Capability'));
  for (const p of plans) hr.appendChild(el('th', current.plan === p.key ? 'current' : null, p.name));
  hr.appendChild(el('th', 'field', 'Token field'));
  thead.appendChild(hr);
  const tbody = el('tbody');
  for (const r of CAP_ROWS) {
    const tr = el('tr', r.money ? 'money' : null);
    const th = el('th');
    th.append(el('span', 'cap-label', r.label), el('span', 'cap-note', r.note));
    tr.appendChild(th);
    for (const p of plans) {
      const v = r.cell(p.caps);
      const td = el('td', `cell ${v}` + (current.plan === p.key ? ' current' : ''));
      td.textContent = v === 'yes' ? '✓' : '—';
      td.setAttribute('aria-label', v === 'yes' ? 'Included' : 'Not included');
      tr.appendChild(td);
    }
    tr.appendChild(el('td', 'field', r.field));
    tbody.appendChild(tr);
  }
  table.append(thead, tbody);
  tableWrap.appendChild(table);
  tableWrap.appendChild(el('p', 'plan-legend', 'Rows marked $ are the levers Rockinfo can charge for.'));
  root.appendChild(tableWrap);

  const money = el('section', 'plan-money');
  money.appendChild(el('h2', null, 'Self-built reports: what to give away, what to charge for'));
  const grid = el('div', 'money-grid');
  const col = (title, cls, items) => {
    const c = el('div', `money-col ${cls}`);
    c.appendChild(el('h3', null, title));
    const ul = el('ul');
    for (const t of items) ul.appendChild(el('li', null, t));
    c.appendChild(ul);
    return c;
  };
  grid.append(
    col('Included for every user', 'free', [
      'Viewing every team report their org publishes, so self-built content reaches all seats.',
      'Rockinfo’s standard dashboards and PDF export.',
      'Tenant isolation: the same row-level security on every plan.',
    ]),
    col('Charge for building', 'paid', [
      'Explore and My reports (Self-service): power users answer their own questions.',
      'Publishing to the team (Enterprise): one person builds, the whole org benefits.',
      'Rocky AI and scheduled email reports (Insights and up).',
      'Raw data download (Enterprise): the data leaves the platform, so price it accordingly.',
    ]),
  );
  money.appendChild(grid);
  money.appendChild(el('p', 'plan-legend', 'Explore is hidden from the sidebar for Essentials and Insights. The dataset stays in the shared portal because Rocky AI needs it, so a separate portal per plan would be the hard enforcement.'));
  root.appendChild(money);
}

let toastTimer;
for (const b of document.querySelectorAll('.module')) {
  b.addEventListener('click', () => {
    const t = $('toast');
    t.textContent = `${b.textContent} is a Rockinfo app module, outside this analytics PoC. Try Rocky AI, a dashboard or a dataset.`;
    t.hidden = false;
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => (t.hidden = true), 3500);
  });
}

// Holistics lists every dashboard this identity can open, tagged org or personal.
window.addEventListener('message', (e) => {
  if (!embedOrigin || e.origin !== embedOrigin || e.source !== frame.contentWindow) return;
  if (e.data?.eventName !== 'embed:loaded') return;
  const dashboards = e.data.payload?.objects?.dashboards || [];
  const pick = (w) => dashboards.filter((d) => d.workspace === w && d.uname).map(({ uname, title }) => ({ uname, title: title || uname }));
  workspaceItems = { org: pick('org'), personal: pick('personal') };
  // A report that appears since the last load for this tenant was just saved by this user.
  const key = current.tenantSlug;
  const before = seenOrg.get(key);
  const now = new Date().toISOString();
  // Org reports only: personal lists differ per persona, so a switch would look like new saves.
  for (const d of workspaceItems.org) {
    if (before && !before.has(d.uname) && !reportMeta[d.uname] && !localMeta[d.uname]) {
      localMeta[d.uname] = { createdBy: current.id, createdAt: now, updatedAt: now };
    }
  }
  saveLocalMeta();
  seenOrg.set(key, new Set(workspaceItems.org.map((d) => d.uname)));
  renderNav();
  setView(view);
});

window.addEventListener('hashchange', () => {
  const next = viewFromHash();
  if (next !== view) {
    setView(next);
    if (current) load(current);
  }
});

$('payloadToggle').addEventListener('click', () => setDrawer(!$('payloadPanel').classList.contains('open')));
$('payloadClose').addEventListener('click', () => setDrawer(false));
$('scrim').addEventListener('click', () => setDrawer(false));
userButton.addEventListener('click', (e) => {
  e.stopPropagation();
  setMenu(dropdown.hidden);
});
document.addEventListener('click', (e) => {
  if (!dropdown.hidden && !dropdown.contains(e.target)) setMenu(false);
});
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') {
    setMenu(false);
    setDrawer(false);
  }
});

try {
  const res = await fetch('/api/config');
  const cfg = await res.json();
  if (!res.ok) throw new Error(cfg.error || `HTTP ${res.status}`);
  users = cfg.users;
  sections = cfg.sections;
  defaultView = cfg.defaultView;
  workspaceSections = cfg.workspaceSections || [];
  try {
    const m = await fetch('/report-meta.json');
    if (m.ok) reportMeta = (await m.json()).reports || {};
  } catch {}
  plans = cfg.plans || [];
  for (const s of sections) for (const item of s.items) VIEWS.set(item.id, item);
  setView(viewFromHash());
  // The homepage opens as the first persona: the Enterprise tenant's Client admin.
  load(users[0]);
} catch (e) {
  setState(`Could not load config: ${e.message}`, true);
}
