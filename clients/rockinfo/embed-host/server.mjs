// Rockinfo embed host: serves the mock Rockinfo app and signs Holistics embed
// tokens server-side. No dependencies. Env:
//   HOLISTICS_EMBED_KEY_ID, HOLISTICS_EMBED_SECRET  demo4 embed credential (secrets)
//   DEMO_PASSWORD   optional; turns on HTTP Basic auth (any username)
//   HOLISTICS_HOST  default https://demo4.holistics.io
//   PORT            default 8080
import { createServer } from 'node:http';
import { createHash, createHmac, timingSafeEqual } from 'node:crypto';
import { readFileSync } from 'node:fs';
import { readFile } from 'node:fs/promises';
import { extname, join, normalize } from 'node:path';
import { fileURLToPath } from 'node:url';
import { ADDONS, PLANS, ROLES, identities, people } from './lib/tenants.mjs';
import * as reportMeta from './lib/report-meta.mjs';
import { DEFAULT_VIEW, SECTIONS, VIEWS, WORKSPACE_SECTIONS, canOpen, homeFor, viewsFor, workspaceView } from './lib/portal.mjs';

// Optional secrets.env next to this file (KEY=VALUE lines), for builds that bake
// the credential into the image. Never commit it; real env vars win.
try {
  for (const line of readFileSync(new URL('./secrets.env', import.meta.url), 'utf8').split('\n')) {
    const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*?)\s*$/);
    if (m && !process.env[m[1]]) process.env[m[1]] = m[2].replace(/^(['"])(.*)\1$/, '$2');
  }
} catch {}

const env = process.env;
const PORT = Number(env.PORT || 8080);
const HOST = env.HOLISTICS_HOST || 'https://demo4.holistics.io';
const PUBLIC = fileURLToPath(new URL('./public/', import.meta.url));
// Cloudflare caches .css/.js at the edge, so index.html points at versioned URLs
// (?v=<content hash>) and every redeploy gets fresh assets.
const ASSET_VERSION = createHash('sha256')
  .update(readFileSync(join(PUBLIC, 'app.js')))
  .update(readFileSync(join(PUBLIC, 'styles.css')))
  .digest('hex')
  .slice(0, 10);
// Team report metadata: baked at build, then kept current from public git history.
reportMeta.start(join(PUBLIC, 'report-meta.json'));
const INDEX_HTML = readFileSync(join(PUBLIC, 'index.html'), 'utf8')
  .replace('href="/styles.css"', `href="/styles.css?v=${ASSET_VERSION}"`)
  .replace('src="/app.js"', `src="/app.js?v=${ASSET_VERSION}"`)
  .replaceAll('href="/assets/rockinfo-mark.png"', `href="/assets/rockinfo-mark.png?v=${ASSET_VERSION}"`);

// Email subscriptions go to public demo inboxes (synthetic data only).
const MAIL_DOMAIN = env.SUBSCRIPTION_MAIL_DOMAIN || 'mailinator.com';
const mailboxFor = (identityId) => `rockinfo-${identityId.replace(/_/g, '-')}`;
const TYPES = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript', '.css': 'text/css', '.svg': 'image/svg+xml', '.png': 'image/png', '.json': 'application/json' };

const b64url = (buf) => Buffer.from(buf).toString('base64url');

function signHS256(payload, secret) {
  const head = b64url(JSON.stringify({ alg: 'HS256', typ: 'JWT' }));
  const body = b64url(JSON.stringify(payload));
  const sig = createHmac('sha256', secret).update(`${head}.${body}`).digest('base64url');
  return `${head}.${body}.${sig}`;
}

function authorized(req) {
  if (!env.DEMO_PASSWORD) return true;
  const auth = req.headers.authorization || '';
  if (!auth.startsWith('Basic ')) return false;
  const decoded = Buffer.from(auth.slice(6), 'base64').toString();
  const given = Buffer.from(decoded.slice(decoded.indexOf(':') + 1));
  const expected = Buffer.from(env.DEMO_PASSWORD);
  return given.length === expected.length && timingSafeEqual(given, expected);
}

function json(res, status, data) {
  res.writeHead(status, { 'Content-Type': 'application/json', 'Cache-Control': 'no-store' });
  res.end(JSON.stringify(data));
}

async function readBody(req) {
  let raw = '';
  for await (const chunk of req) {
    raw += chunk;
    if (raw.length > 10_000) throw new Error('Body too large');
  }
  return JSON.parse(raw || '{}');
}

function config() {
  return {
    users: identities().map((i) => ({
      id: i.id, tenantSlug: i.tenantSlug, tenantName: i.tenantName, accent: i.accent,
      title: i.title, role: i.role, portal: i.portal, clientIds: i.clientIds, views: viewsFor(i),
      name: i.name, plan: i.plan, planName: i.planName, seat: i.seat, admin: !!i.admin, dataExport: !!i.dataExport, caps: i.caps, home: homeFor(i),
    })),
    people: people(),
    plans: PLANS,
    addons: ADDONS,
    roles: ROLES,
    sections: SECTIONS.map((s) => ({ key: s.key, label: s.label, items: s.items.map(({ id, title, sub, native }) => ({ id, title, sub, native: !!native })) })),
    workspaceSections: WORKSPACE_SECTIONS,
    defaultView: DEFAULT_VIEW,
  };
}

function embedToken(identityId, view) {
  const identity = identities().find((i) => i.id === identityId);
  if (!identity) return [400, { error: 'Unknown identity.' }];
  const target = VIEWS.get(view || homeFor(identity)) || workspaceView(view);
  if (!target || target.native) return [400, { error: 'Unknown view.' }];
  view ||= homeFor(identity);
  if (!canOpen(identity, view)) return [403, { error: 'This role cannot open that view.' }];
  if (!env.HOLISTICS_EMBED_KEY_ID || !env.HOLISTICS_EMBED_SECRET) {
    return [500, { error: 'Embed credential is not configured on this deployment.' }];
  }
  // Every permission below is what both the tenant's plan and the user's role allow (lib/tenants.mjs).
  const c = identity.caps;
  const payload = {
    embed_portal: identity.portal,
    embed_org_id: identity.orgId,
    embed_user_id: identity.id,
    embed_user_email: `${mailboxFor(identity.id)}@${MAIL_DOMAIN}`,
    user_attributes: { rockinfo_client_id: identity.clientIds },
    permissions: {
      enable_personal_workspace: c.personal,
      org_workspace_role: c.org,
    },
    settings: {
      ai: { enabled: c.ai },
      allow_dashboard_export: c.pdf,
      allow_raw_data_export: c.csv,
      // Email subscriptions need dashboard export too.
      allow_data_subscribe: c.schedules && c.pdf,
    },
    exp: Math.floor(Date.now() / 1000) + 60 * 60,
  };
  const token = signHS256(payload, env.HOLISTICS_EMBED_SECRET);
  // payload is returned for the demo's "What the token says" panel; it holds no secret
  // Each sidebar entry opens one portal object on its own: Rocky AI, a dashboard or a dataset.
  const path = target.path;
  const mailboxUrl =
    MAIL_DOMAIN === 'mailinator.com'
      ? `https://www.mailinator.com/v4/public/inboxes.jsp?to=${mailboxFor(identity.id)}`
      : null;
  // Collapse the Holistics portal's own left nav: the Rockinfo sidebar is the navigation.
  // Holistics offers only expanded or collapsed, so a small toggle icon stays top-left.
  return [
    200,
    { embedUrl: `${HOST}/embed/${env.HOLISTICS_EMBED_KEY_ID}${path}?_token=${token}&left_panel_state=collapsed`, payload, mailboxUrl },
  ];
}

createServer(async (req, res) => {
  try {
    const url = new URL(req.url, 'http://localhost');
    // Kubernetes probes hit `/` without credentials; answer them before the password gate.
    const isProbe = (req.headers['user-agent'] || '').startsWith('kube-probe/');
    if (url.pathname === '/healthz' || isProbe) return json(res, 200, { ok: true });
    if (!authorized(req)) {
      res.writeHead(401, { 'WWW-Authenticate': 'Basic realm="Rockinfo demo", charset="UTF-8"' });
      return res.end('Password required');
    }
    if (url.pathname === '/api/config' && req.method === 'GET') return json(res, 200, config());
    if (url.pathname === '/api/report-meta' && req.method === 'GET') return json(res, 200, reportMeta.snapshot());
    if (url.pathname === '/api/embed-token' && req.method === 'POST') {
      let body;
      try { body = await readBody(req); } catch { return json(res, 400, { error: 'Invalid JSON body.' }); }
      const [status, data] = embedToken(body.identity_id, body.view);
      return json(res, status, data);
    }
    if (req.method !== 'GET' && req.method !== 'HEAD') return json(res, 405, { error: 'Method not allowed' });

    if (url.pathname === '/' || url.pathname === '/index.html') {
      res.writeHead(200, { 'Content-Type': TYPES['.html'], 'Cache-Control': 'no-store' });
      return res.end(INDEX_HTML);
    }
    const rel = normalize(url.pathname).replace(/^(\.\.[/\\])+/, '');
    const file = join(PUBLIC, rel);
    if (!file.startsWith(PUBLIC)) return json(res, 404, { error: 'Not found' });
    try {
      const data = await readFile(file);
      const versioned = url.searchParams.get('v') === ASSET_VERSION;
      res.writeHead(200, {
        'Content-Type': TYPES[extname(file)] || 'application/octet-stream',
        'Cache-Control': versioned ? 'public, max-age=31536000, immutable' : 'no-cache',
      });
      res.end(data);
    } catch {
      res.writeHead(404).end('Not found');
    }
  } catch (e) {
    console.error(e);
    json(res, 500, { error: 'Server error' });
  }
}).listen(PORT, () => console.log(`rockinfo-embed listening on :${PORT}`));
