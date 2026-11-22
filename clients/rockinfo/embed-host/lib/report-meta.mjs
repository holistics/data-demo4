// Live "Built by / Created / Last updated" for Team reports and My reports, with no credential.
//
// Holistics commits every embed save to holistics/data-demo4 as "Embed user <id> (Org: <org>)",
// and that repo is public. The image bakes public/report-meta.json at build
// (scripts/report-meta.mjs); this module then follows newer commits under modules/embedding
// through the unauthenticated GitHub REST API and applies them in memory. A 304 on the
// conditional list request is free, so polling stays far inside the 60 requests/hour limit.
// If GitHub is unreachable, the baked file still answers.
import { readFileSync } from 'node:fs';

const REPO = 'holistics/data-demo4';
const API = `https://api.github.com/repos/${REPO}`;
const PATH = 'modules/embedding';
const FILE = /^modules\/embedding\/org_(client_[^/]+)\/(shared|personal)_workspace\/(?:.*\/)?([^/]+)\.page\.aml$/;
const EMBED = /^Embed user (\S+) \(Org: ([^)]+)\)$/;
const POLL_MS = 90_000;
const HEADERS = { accept: 'application/vnd.github+json', 'user-agent': 'rockinfo-embed-demo' };

const state = { generatedAt: null, syncedAt: null, head: null, reports: {}, error: null };
const applied = new Set();
let etag = null;
let backoffUntil = 0;
let running = null;

export function loadBaked(file) {
  try {
    const baked = JSON.parse(readFileSync(file, 'utf8'));
    state.generatedAt = baked.generatedAt || null;
    state.head = baked.head || null;
    state.reports = baked.reports || {};
  } catch {}
}

export const snapshot = () => ({ generatedAt: state.generatedAt, syncedAt: state.syncedAt, reports: state.reports });

async function gh(path, extra = {}) {
  const res = await fetch(`${API}${path}`, { headers: { ...HEADERS, ...extra }, signal: AbortSignal.timeout(10_000) });
  if (res.status === 403 || res.status === 429) {
    const reset = Number(res.headers.get('x-ratelimit-reset')) * 1000;
    backoffUntil = reset > Date.now() ? reset : Date.now() + 15 * 60_000;
    throw new Error(`GitHub rate limited until ${new Date(backoffUntil).toISOString()}`);
  }
  return res;
}

// Same rules as scripts/report-meta.mjs: the first commit creates, every later commit updates,
// and only embed commits name who updated.
function apply(commit) {
  const user = EMBED.exec(commit.commit.author.name)?.[1] || null;
  const at = commit.commit.author.date;
  for (const f of commit.files || []) {
    const prev = f.previous_filename && FILE.exec(f.previous_filename);
    if (prev) delete state.reports[`embedding.${prev[3]}`];
    const m = FILE.exec(f.filename);
    if (!m) continue;
    const uname = `embedding.${m[3]}`;
    if (f.status === 'removed') {
      delete state.reports[uname];
      continue;
    }
    const cur = state.reports[uname];
    if (!cur || f.status === 'added') {
      state.reports[uname] = { org: m[1], createdBy: user, createdAt: at, updatedAt: at, updatedBy: null };
    } else if (Date.parse(at) >= Date.parse(cur.updatedAt)) {
      cur.updatedAt = at;
      if (user) cur.updatedBy = user;
    }
  }
}

async function poll() {
  if (Date.now() < backoffUntil) return;
  // Newest first. Everything above the baked head (or the last applied commit) is new.
  const since = state.generatedAt ? new Date(Date.parse(state.generatedAt) - 86_400_000).toISOString() : '';
  const res = await gh(`/commits?sha=master&path=${PATH}&per_page=100${since ? `&since=${since}` : ''}`, etag ? { 'if-none-match': etag } : {});
  if (res.status === 304) return;
  if (!res.ok) throw new Error(`GitHub ${res.status}`);
  const list = await res.json();
  const fresh = [];
  for (const c of list) {
    if (c.sha === state.head) break;
    if (!applied.has(c.sha)) fresh.push(c);
  }
  // Oldest first. A merge repeats its branch's commits, so skip it.
  for (const c of fresh.reverse()) {
    if (c.parents.length > 1) {
      applied.add(c.sha);
      continue;
    }
    const d = await gh(`/commits/${c.sha}`);
    if (!d.ok) throw new Error(`GitHub ${d.status}`);
    apply(await d.json());
    applied.add(c.sha);
  }
  // Only remember the ETag once every new commit is applied, so a failure retries them.
  etag = res.headers.get('etag');
}

export function sync() {
  running ??= poll()
    .then(() => {
      state.syncedAt = new Date().toISOString();
      state.error = null;
    })
    .catch((e) => {
      if (state.error !== e.message) console.error('report-meta sync:', e.message);
      state.error = e.message;
    })
    .finally(() => (running = null));
  return running;
}

export function start(file) {
  loadBaked(file);
  sync();
  setInterval(sync, POLL_MS).unref();
}
