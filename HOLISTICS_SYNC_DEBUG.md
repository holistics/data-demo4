# Holistics Cloud Git Pointer Debug Brief

Date: 2026-07-30
Repo: `/Users/vincentwoon/repos/work/demo4`
GitHub repo: `holistics/data-demo4`
Holistics project URL: `https://demo4.holistics.io/studio`
Holistics project ID from `sync-code`: `7`

## Pastebin Prompt

You are debugging a Holistics Studio / `holistics sync-code` Git state issue.

Local Git changes were committed, pushed, opened as PR #83, and merged into the remote default branch `master`. However, Holistics Web still shows 11 uncommitted changes on branch `dabble-trading-after-dashboard`, with cloud commit stuck at `5792489df04beeab5a67dc003c0f97fa5b04db7a`.

The key finding: the 11 cloud-uncommitted files exactly match the diff from commit `5792489d` to committed branch tip `210b6a7d`. The content is already in Git and merged to `origin/master`; Holistics Cloud appears to have file contents synced but its cloud Git pointer / working tree status has not been advanced or cleared.

Please determine the correct Holistics-side recovery action to advance/reset the cloud Git state without losing the already-merged Dabble changes.

## Expected State

- `origin/master` should be the source of truth.
- `origin/master` is at merge commit `0675591e53647f1c608151ad042d8c7916ee9184`.
- PR #83 is merged.
- Local repo is clean on `master`.
- Holistics Web should not show the 11 Dabble files as uncommitted.

## Current Local State

Command:

```bash
git status -sb
git branch --show-current
git rev-parse HEAD
git rev-parse origin/master
holistics sync-code --status
```

Observed:

```text
## master...origin/master
master
0675591e53647f1c608151ad042d8c7916ee9184
0675591e53647f1c608151ad042d8c7916ee9184

Sync state - pid 77392 (mode: background)
  Process:      not running
  Started:      2026-07-30T14:19:31.150Z
  Last cycle:   2026-07-30T14:22:06.452Z
  Pending:      0
  Conflicts:    none
  Last error:   none
  Repo:         /Users/vincentwoon/repos/work/demo4
  Project ID:   7

sync process (pid 77392) is not running
```

The sync process was intentionally stopped to avoid re-uploading the already-committed files as cloud-uncommitted changes.

## PR And Git History

PR:

```text
PR #83: Add Dabble AU trading performance dashboard
URL: https://github.com/holistics/data-demo4/pull/83
State: MERGED
Base: master
Head: dabble-trading-after-dashboard
Merged at: 2026-07-30T14:14:32Z
Merge commit: 0675591e53647f1c608151ad042d8c7916ee9184
Merged by: vinwoon
```

Relevant commits:

```text
0675591e (origin/master, origin/HEAD) Add Dabble AU trading performance dashboard
210b6a7d (origin/dabble-trading-after-dashboard) Refine Dabble trading performance dashboard
5792489d Add Dabble executive metric sheet
bd610731 Add Dabble trading after dashboard
9bb1a301 Resolve Dabble sync conflicts
49f60d19 Create: 1 dataset, 7 data models, 1 dashboard, 6 files
```

## Holistics Cloud Symptom

When `sync-code` was started while local branch matched the cloud branch (`dabble-trading-after-dashboard`), it reported:

```text
Repo
  View on browser:    https://demo4.holistics.io/studio
  Path:               /Users/vincentwoon/repos/work/demo4
  Remote:             https://github.com/holistics/data-demo4.git
  Branch:             dabble-trading-after-dashboard
  Local commit:       210b6a7d
  Cloud commit:       5792489d  uncommitted
  Cloud uncommitted:  11
    new       clients/dabble/blocks/dabble_page_header.block.tpl.aml
    new       clients/dabble/dashboards/AGENTS.md
    modified  clients/dabble/dashboards/dabble_au_trading_after.page.aml
    new       clients/dabble/dashboards/dabble_competition_cards.chart.aml
    new       clients/dabble/dashboards/dabble_sport_quadrant.chart.aml
    modified  clients/dabble/datasets/dabble_trading.dataset.aml
    new       clients/dabble/docs/dabble_au_trading_after_audit.md
    new       clients/dabble/docs/issue-01-seed-data-plausibility.md
    modified  clients/dabble/models/dabble_dim_sport.model.aml
    modified  clients/dabble/models/dabble_fact_bet.model.aml
    modified  clients/dabble/models/dabble_fact_bet_leg.model.aml

Initial sync
  Comparing 975 common files...
  Common files: 975 identical
  Ledger initialized with 975 files
Sync active. Watching for changes...
```

This indicates file contents are synced and conflict-free, but Holistics Cloud still considers the diff from `5792489d` to `210b6a7d` as uncommitted in its own development workspace.

## Exact 11-File Diff

Command:

```bash
git diff --name-only 5792489df04beeab5a67dc003c0f97fa5b04db7a..210b6a7df38c0e2765d0123bfffd9f2de74a8768
```

Output:

```text
clients/dabble/blocks/dabble_page_header.block.tpl.aml
clients/dabble/dashboards/AGENTS.md
clients/dabble/dashboards/dabble_au_trading_after.page.aml
clients/dabble/dashboards/dabble_competition_cards.chart.aml
clients/dabble/dashboards/dabble_sport_quadrant.chart.aml
clients/dabble/datasets/dabble_trading.dataset.aml
clients/dabble/docs/dabble_au_trading_after_audit.md
clients/dabble/docs/issue-01-seed-data-plausibility.md
clients/dabble/models/dabble_dim_sport.model.aml
clients/dabble/models/dabble_fact_bet.model.aml
clients/dabble/models/dabble_fact_bet_leg.model.aml
```

Command:

```bash
git diff --stat 5792489df04beeab5a67dc003c0f97fa5b04db7a..210b6a7df38c0e2765d0123bfffd9f2de74a8768
```

Output:

```text
 .../dabble/blocks/dabble_page_header.block.tpl.aml |   54 +
 clients/dabble/dashboards/AGENTS.md                |   28 +
 .../dashboards/dabble_au_trading_after.page.aml    | 1675 +++++++++++++-------
 .../dashboards/dabble_competition_cards.chart.aml  |  164 ++
 .../dashboards/dabble_sport_quadrant.chart.aml     |  147 ++
 clients/dabble/datasets/dabble_trading.dataset.aml |   24 +
 .../dabble/docs/dabble_au_trading_after_audit.md   |  362 +++++
 .../dabble/docs/issue-01-seed-data-plausibility.md |  266 ++++
 clients/dabble/models/dabble_dim_sport.model.aml   |    9 +-
 clients/dabble/models/dabble_fact_bet.model.aml    |   29 +-
 .../dabble/models/dabble_fact_bet_leg.model.aml    |   13 +
 11 files changed, 2140 insertions(+), 631 deletions(-)
```

This is exactly the same file list and change size as the cloud-uncommitted state.

## Branch Mismatch Reproduction

When local was switched to `master` and `holistics sync-code --background` was started, the CLI failed because the cloud branch was still `dabble-trading-after-dashboard`:

```text
Repo
  Branch:             master
  Local commit:       0675591e
  Cloud commit:       5792489d  uncommitted
  Cloud uncommitted:  11
    [same 11 Dabble files]

Branch mismatch: local=master cloud=dabble-trading-after-dashboard
Please make sure the branch on Holistics Cloud is the same as your local branch
Error: Branch mismatch: local branch is not the same as the branch on Holistics Cloud
```

This is why simply syncing from local `master` cannot currently fix it. Holistics Cloud must first be moved off the stale branch/uncommitted state, or the cloud uncommitted changes must be cleared/pulled in Studio.

## Validation

Dabble-scoped validation passes:

```bash
holistics aml validate --root-path . clients/dabble
```

Output:

```text
Validating AQL
No validation errors found.
```

Full repo validation is not useful as a blocker for this issue because it fails on pre-existing non-Dabble files. The Dabble files in the 11-file diff pass validation.

## What Was Tried

1. Committed all local uncommitted Dabble files.
2. Pushed branch `dabble-trading-after-dashboard`.
3. Created PR #83 against `master`.
4. Merged PR #83 into `origin/master`.
5. Fast-forwarded local `master` to `origin/master`.
6. Started `holistics sync-code --background` on local `master`.
   - Failed with branch mismatch because cloud branch remained `dabble-trading-after-dashboard`.
7. Switched local back to `dabble-trading-after-dashboard`.
8. Started `holistics sync-code --background`.
   - Sync showed cloud commit `5792489d` with 11 uncommitted files, but no conflicts and common files identical.
9. Searched Holistics docs via `holistics mcp search_docs`.
   - Found no documented CLI command to advance/reset cloud Git state.
   - Docs point to Studio Git UI actions such as aborting uncommitted changes and pulling from production.
10. Stopped `sync-code`.
11. Checked local back out to `master`.

## Current Recommended Recovery

Because the 11 uncommitted cloud files are already committed and merged in Git, the intended recovery should be safe:

1. In Holistics Studio, stay on branch `dabble-trading-after-dashboard`.
2. Use the Studio Git UI to abort/discard the 11 uncommitted changes.
3. Pull latest / pull from production, or switch the Studio workspace branch to `master`.
4. Confirm Studio no longer shows those 11 changes as uncommitted.
5. Locally, with `master` checked out, restart sync:

```bash
holistics sync-code --background
holistics sync-code --status --wait
```

Expected post-recovery status:

```text
Branch: master
Local commit: 0675591e
Cloud commit: 0675591e
Cloud uncommitted: 0
Conflicts: none
```

## Questions For Holistics Developers

1. Is there a CLI/API equivalent for Studio's "abort uncommitted changes" or "pull from production" action?
2. Why does `sync-code` report "up-to-date" when cloud file contents match local committed files but cloud commit remains stale with uncommitted changes?
3. Should `sync-code` be able to detect that the cloud uncommitted diff equals `cloud_commit..local_commit` and auto-clear or advance the cloud commit pointer?
4. Is the expected manual fix to abort the cloud uncommitted changes, then pull/switch to `master`?
5. Can the CLI status output include a clearer message for this state, such as "cloud has uncommitted changes equivalent to local commit; use Studio Git UI to discard/pull"?

## Important Safety Note

Do not force-push or rewrite Git history. Holistics docs warn that history rewrites can cause unexpected behavior with Git sync.

Discarding the 11 cloud-uncommitted changes should be safe only because they have been verified to match committed Git content already present in:

- branch commit `210b6a7df38c0e2765d0123bfffd9f2de74a8768`
- merged `origin/master` commit `0675591e53647f1c608151ad042d8c7916ee9184`
