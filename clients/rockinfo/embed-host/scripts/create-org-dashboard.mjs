// Create an empty dashboard in a tenant's Shared workspace (a Team report) or, with --personal,
// in one embed user's Personal workspace (a My report), as that embed user.
// Holistics registers only dashboards created through the embed, so this is step one; step two
// is writing its content into the generated AML file and publishing. The file lands in
//   Team report: modules/embedding/org_client_<id>/shared_workspace/untitled_<x>.page.aml
//   My report:   modules/embedding/org_client_<id>/personal_workspace/user_<identity>/<x>.page.aml
//
//   node create-org-dashboard.mjs <identity_id> [--personal] [screenshot.png]
//   e.g. node create-org-dashboard.mjs adobe_admin
//        node create-org-dashboard.mjs adobe_editor --personal
//
// Needs Playwright (`npm i playwright` in a scratch folder) and Google Chrome. The identity must
// have org_workspace_role 'editor' (Enterprise plan or internal admin) for a Team report, or
// enable_personal_workspace (Self-service and up, not a viewer) for --personal. If saving fails with
// "production branch has changes ... not published", run the demo4 publish job first
// (docs/deploy.md). Holistics commits the new file to master within a few seconds.
import { chromium } from 'playwright';

const args = process.argv.slice(2);
const personal = args.includes('--personal');
const [identity, shot] = args.filter((a) => a !== '--personal');
if (!identity) {
  console.error('usage: node create-org-dashboard.mjs <identity_id> [--personal] [screenshot.png]');
  process.exit(1);
}
const res = await fetch('https://rockinfo-embed.pages.holistics.dev/api/embed-token', {
  method: 'POST',
  headers: { 'content-type': 'application/json' },
  body: JSON.stringify({ identity_id: identity, view: 'rockinfo_program_performance' }),
});
const { embedUrl, error } = await res.json();
if (!embedUrl) throw new Error(error || `HTTP ${res.status}`);

const browser = await chromium.launch({ channel: 'chrome', headless: true });
const page = await browser.newPage({ viewport: { width: 1500, height: 950 } });
await page.goto(embedUrl.replace('left_panel_state=collapsed', 'left_panel_state=expanded'));
await page.waitForTimeout(10000);
// The "+" sits at the right edge of the workspace row in the Holistics left panel.
const row = page.locator(`text=${personal ? 'Personal' : 'Shared'} workspace`).first();
await row.hover();
const box = await row.boundingBox();
await page.mouse.click(225, box.y + box.height / 2);
await page.waitForTimeout(2500);
await page.getByRole('button', { name: 'Save', exact: true }).click();
await page.waitForTimeout(4000);
if (shot) await page.screenshot({ path: shot });
const errorToast = await page.locator('text=/not been published|error/i').count();
console.log(errorToast ? 'Save may have failed; check the screenshot.' : 'Saved. Pull master to get the new file.');
await browser.close();
