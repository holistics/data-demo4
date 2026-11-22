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
let view;
let inflight;

const ICONS = {
  ai: '<path d="M10 2.5l1.6 4.4 4.4 1.6-4.4 1.6L10 14.5l-1.6-4.4L4 8.5l4.4-1.6L10 2.5zM15.5 13l.7 1.8 1.8.7-1.8.7-.7 1.8-.7-1.8-1.8-.7 1.8-.7.7-1.8z" fill="currentColor"/>',
  dashboards: '<path d="M3 17h14M6 14V9M10 14V5M14 14v-3" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>',
  datasets: '<ellipse cx="10" cy="5" rx="6" ry="2.5" fill="none" stroke="currentColor" stroke-width="1.6"/><path d="M4 5v10c0 1.4 2.7 2.5 6 2.5s6-1.1 6-2.5V5M4 10c0 1.4 2.7 2.5 6 2.5s6-1.1 6-2.5" fill="none" stroke="currentColor" stroke-width="1.6"/>',
};

// Old links used #dashboards for the main dashboard.
const viewFromHash = () => {
  const h = location.hash.slice(1);
  if (h === 'dashboards') return 'rockinfo_program_performance';
  return VIEWS.has(h) ? h : defaultView;
};

function renderNav() {
  const nav = $('analyticsNav');
  nav.innerHTML = '';
  for (const s of sections) {
    const group = document.createElement('div');
    group.className = 'nav-group';
    const label = document.createElement('p');
    label.className = 'nav-section';
    label.textContent = s.label;
    group.appendChild(label);
    for (const item of s.items) {
      const a = document.createElement('a');
      a.className = 'nav-item view-link' + (s.key === 'ai' ? ' home' : '');
      a.href = `#${item.id}`;
      a.dataset.view = item.id;
      a.title = item.sub;
      a.innerHTML =
        s.key === 'ai'
          ? '<img class="nav-icon" src="/assets/rocky-ai.png" alt="" width="22" height="22" />'
          : `<svg viewBox="0 0 20 20" aria-hidden="true">${ICONS[s.key] || ICONS.dashboards}</svg>`;
      const text = document.createElement('span');
      text.className = 'nav-label';
      text.textContent = item.title;
      a.appendChild(text);
      group.appendChild(a);
    }
    nav.appendChild(group);
  }
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
    if (!groups.has(u.tenantName)) groups.set(u.tenantName, []);
    groups.get(u.tenantName).push(u);
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
  current = user;
  document.documentElement.style.setProperty('--tenant', user.accent);
  $('userAvatar').textContent = initials(user.tenantName);
  $('userName').textContent = user.title;
  $('userSub').textContent = user.tenantName;
  renderMenu();
  inflight?.abort();
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
  const item = VIEWS.get(view);
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
  for (const s of sections) for (const item of s.items) VIEWS.set(item.id, item);
  renderNav();
  setView(viewFromHash());
  load(users[0]);
} catch (e) {
  setState(`Could not load config: ${e.message}`, true);
}
