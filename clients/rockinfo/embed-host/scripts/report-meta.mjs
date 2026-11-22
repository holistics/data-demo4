// Build-time metadata for Team reports and My reports: who built each one, when, and when it
// last changed. Holistics commits every embed save as "Embed user <embed_user_id> (Org: <org>)",
// so git history is the record; the embed events and AML expose none of it.
//
//   node scripts/report-meta.mjs <demo4 repo root> > <build dir>/public/report-meta.json
//
// Run it in the image build (docs/deploy.md). The server (lib/report-meta.mjs) then follows newer
// commits from the public GitHub repo, so saves after the build show without a redeploy.
import { execFileSync } from 'node:child_process';
import { readdirSync, existsSync } from 'node:fs';
import { join } from 'node:path';

const root = process.argv[2];
if (!root) {
  console.error('usage: node scripts/report-meta.mjs <demo4 repo root>');
  process.exit(1);
}
const EMBED = /^Embed user (\S+) \(Org: ([^)]+)\)$/;
const git = (...args) => execFileSync('git', ['-C', root, ...args], { encoding: 'utf8' });

const out = {};
const base = join(root, 'modules/embedding');
for (const org of readdirSync(base).filter((d) => d.startsWith('org_client_'))) {
  for (const ws of ['shared_workspace', 'personal_workspace']) {
    const dir = join(base, org, ws);
    if (!existsSync(dir)) continue;
    const files = execFileSync('find', [dir, '-name', '*.page.aml'], { encoding: 'utf8' }).split('\n').filter(Boolean);
    for (const file of files) {
      const rel = file.slice(root.length + 1);
      // Oldest first: author name and ISO time of every commit touching the file.
      const log = git('log', '--reverse', '--format=%an%x09%aI', '--', rel).trim().split('\n').filter(Boolean);
      if (!log.length) continue;
      const commits = log.map((l) => {
        const [author, at] = l.split('\t');
        const m = EMBED.exec(author);
        return { at, user: m ? m[1] : null };
      });
      const created = commits[0];
      const lastEmbedEdit = [...commits].reverse().find((c) => c.user);
      const uname = `embedding.${file.split('/').pop().replace(/\.page\.aml$/, '')}`;
      out[uname] = {
        org: org.replace(/^org_/, ''),
        createdBy: created.user,
        createdAt: created.at,
        updatedAt: commits.at(-1).at,
        updatedBy: lastEmbedEdit && lastEmbedEdit !== created ? lastEmbedEdit.user : null,
      };
    }
  }
}
// The newest commit under modules/embedding: the server's live sync applies only commits after it.
const head = git('log', '-1', '--format=%H', '--', 'modules/embedding').trim() || null;
process.stdout.write(JSON.stringify({ generatedAt: new Date().toISOString(), head, reports: out }, null, 2) + '\n');
