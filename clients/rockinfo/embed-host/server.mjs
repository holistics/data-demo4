// Rockinfo embed host: serves the mock Rockinfo app and signs Holistics embed
// tokens server-side. No dependencies. Env:
//   HOLISTICS_EMBED_KEY_ID, HOLISTICS_EMBED_SECRET  demo4 embed credential (secrets)
//   DEMO_PASSWORD   optional; turns on HTTP Basic auth (any username)
//   HOLISTICS_HOST  default https://demo4.holistics.io
//   PORT            default 8080
import { createServer } from 'node:http';
import { createHmac, timingSafeEqual } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import { extname, join, normalize } from 'node:path';
import { fileURLToPath } from 'node:url';
import { identities } from './lib/tenants.mjs';

const env = process.env;
const PORT = Number(env.PORT || 8080);
const HOST = env.HOLISTICS_HOST || 'https://demo4.holistics.io';
const PUBLIC = fileURLToPath(new URL('./public/', import.meta.url));
const TYPES = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript', '.css': 'text/css', '.svg': 'image/svg+xml', '.png': 'image/png' };

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
      title: i.title, role: i.role, portal: i.portal, clientIds: i.clientIds,
    })),
  };
}

function embedToken(identityId, view) {
  const identity = identities().find((i) => i.id === identityId);
  if (!identity) return [400, { error: 'Unknown identity.' }];
  if (!env.HOLISTICS_EMBED_KEY_ID || !env.HOLISTICS_EMBED_SECRET) {
    return [500, { error: 'Embed credential is not configured on this deployment.' }];
  }
  const isEditor = identity.access === 'editor';
  const payload = {
    embed_portal: identity.portal,
    embed_org_id: identity.orgId,
    embed_user_id: identity.id,
    user_attributes: { rockinfo_client_id: identity.clientIds },
    permissions: {
      enable_personal_workspace: isEditor,
      org_workspace_role: isEditor ? 'editor' : 'viewer',
    },
    // Ask AI for every customer persona; it answers only from the user's own rows.
    settings: { ai: { enabled: true } },
    exp: Math.floor(Date.now() / 1000) + 60 * 60,
  };
  const token = signHS256(payload, env.HOLISTICS_EMBED_SECRET);
  // payload is returned for the demo's "What the token says" panel; it holds no secret
  // `/ai` opens the portal on Ask AI instead of its initial dashboard.
  const path = view === 'ai' ? '/ai' : '';
  return [200, { embedUrl: `${HOST}/embed/${env.HOLISTICS_EMBED_KEY_ID}${path}?_token=${token}`, payload }];
}

createServer(async (req, res) => {
  try {
    const url = new URL(req.url, 'http://localhost');
    if (url.pathname === '/healthz') return json(res, 200, { ok: true });
    if (!authorized(req)) {
      res.writeHead(401, { 'WWW-Authenticate': 'Basic realm="Rockinfo demo", charset="UTF-8"' });
      return res.end('Password required');
    }
    if (url.pathname === '/api/config' && req.method === 'GET') return json(res, 200, config());
    if (url.pathname === '/api/embed-token' && req.method === 'POST') {
      let body;
      try { body = await readBody(req); } catch { return json(res, 400, { error: 'Invalid JSON body.' }); }
      const [status, data] = embedToken(body.identity_id, body.view);
      return json(res, status, data);
    }
    if (req.method !== 'GET' && req.method !== 'HEAD') return json(res, 405, { error: 'Method not allowed' });

    const rel = normalize(url.pathname === '/' ? '/index.html' : url.pathname).replace(/^(\.\.[/\\])+/, '');
    const file = join(PUBLIC, rel);
    if (!file.startsWith(PUBLIC)) return json(res, 404, { error: 'Not found' });
    try {
      const data = await readFile(file);
      res.writeHead(200, { 'Content-Type': TYPES[extname(file)] || 'application/octet-stream' });
      res.end(data);
    } catch {
      res.writeHead(404).end('Not found');
    }
  } catch (e) {
    console.error(e);
    json(res, 500, { error: 'Server error' });
  }
}).listen(PORT, () => console.log(`rockinfo-embed listening on :${PORT}`));
