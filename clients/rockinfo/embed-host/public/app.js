const $ = (id) => document.getElementById(id);
const frame = $('embedFrame');
const state = $('state');
const dropdown = $('userDropdown');
const userButton = $('userButton');
let users = [];
let current;
const VIEWS = {
  ai: ['Rockinfo Insights', 'Ask questions about your own candidates, exams, credentials and vouchers.'],
  dashboards: ['Dashboards', 'Program performance, learning, credentials and vouchers for your organisation.'],
};
let view = VIEWS[location.hash.slice(1)] ? location.hash.slice(1) : 'ai';
let inflight;

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
    ['AI', payload.settings.ai.enabled ? 'On' : 'Off'],
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
  $('pageTitle').textContent = VIEWS[view][0];
  $('pageSub').textContent = VIEWS[view][1];
  for (const a of document.querySelectorAll('.view-link')) {
    const on = a.dataset.view === view;
    a.classList.toggle('active', on);
    if (on) a.setAttribute('aria-current', 'page');
    else a.removeAttribute('aria-current');
  }
}

window.addEventListener('hashchange', () => {
  const next = location.hash.slice(1);
  if (VIEWS[next] && next !== view) {
    setView(next);
    if (current) load(current);
  }
});
setView(view);

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
  load(users[0]);
} catch (e) {
  setState(`Could not load config: ${e.message}`, true);
}
