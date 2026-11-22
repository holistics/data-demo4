const $ = (id) => document.getElementById(id);
const select = $('identitySelect');
const frame = $('embedFrame');
const state = $('state');
let users = [];
let inflight;

function setState(text, isError = false) {
  state.textContent = text;
  state.hidden = !text;
  state.classList.toggle('error', isError);
}

function renderCustomers(active) {
  const tenants = [...new Map(users.map((u) => [u.tenantSlug, u])).values()];
  $('customerList').innerHTML = '';
  for (const t of tenants) {
    const li = document.createElement('li');
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'customer' + (t.tenantSlug === active.tenantSlug ? ' active' : '');
    btn.style.setProperty('--accent', t.accent);
    btn.innerHTML = `<span class="swatch"></span><span></span>`;
    btn.lastChild.textContent = t.tenantName;
    btn.addEventListener('click', () => {
      const keepAccess = active.id.endsWith('_viewer') ? '_viewer' : '_editor';
      const next = users.find((u) => u.id === t.tenantSlug + keepAccess) || users.find((u) => u.tenantSlug === t.tenantSlug);
      select.value = next.id;
      load(next);
    });
    li.appendChild(btn);
    $('customerList').appendChild(li);
  }
}

function renderPayload(payload) {
  const facts = [
    ['Portal', payload.embed_portal],
    ['Row-level filter', `rockinfo_client_id = [${payload.user_attributes.rockinfo_client_id.join(', ')}]`],
    ['Workspace', `${payload.embed_org_id} · ${payload.permissions.org_workspace_role}`],
    ['AI', payload.settings.ai.enabled ? 'On' : 'Off'],
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
}

async function load(user) {
  document.documentElement.style.setProperty('--tenant', user.accent);
  $('tenantName').textContent = user.tenantName;
  $('tenantRole').textContent = `${user.title} · ${user.role}`;
  renderCustomers(user);
  inflight?.abort();
  inflight = new AbortController();
  setState(`Signing a token for ${user.tenantName}…`);
  frame.classList.add('loading');
  try {
    const res = await fetch('/api/embed-token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ identity_id: user.id }),
      signal: inflight.signal,
    });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || `HTTP ${res.status}`);
    renderPayload(data.payload);
    frame.onload = () => {
      frame.classList.remove('loading');
      setState('');
    };
    frame.src = data.embedUrl;
  } catch (e) {
    if (e.name === 'AbortError') return;
    setState(e.message, true);
  }
}

$('payloadToggle').addEventListener('click', (e) => {
  const panel = $('payloadPanel');
  panel.hidden = !panel.hidden;
  e.currentTarget.setAttribute('aria-expanded', String(!panel.hidden));
});

select.addEventListener('change', () => load(users.find((u) => u.id === select.value)));

try {
  const res = await fetch('/api/config');
  const cfg = await res.json();
  if (!res.ok) throw new Error(cfg.error || `HTTP ${res.status}`);
  users = cfg.users;
  const groups = new Map();
  for (const u of users) {
    if (!groups.has(u.tenantName)) {
      const g = document.createElement('optgroup');
      g.label = u.tenantName;
      groups.set(u.tenantName, g);
      select.appendChild(g);
    }
    const opt = new Option(`${u.tenantName} · ${u.title}`, u.id);
    groups.get(u.tenantName).appendChild(opt);
  }
  load(users[0]);
} catch (e) {
  setState(`Could not load config: ${e.message}`, true);
}
