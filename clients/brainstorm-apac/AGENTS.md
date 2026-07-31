# Brainstorm APAC package

## Start from the contract

- Read `README.md` before editing. It is the source of truth for the cutoff, privacy boundary, seed manifest, RLS contract and validation commands.
- Keep changes inside `clients/brainstorm-apac/**` unless the user explicitly expands the scope. Preserve unrelated Demo4 and FanServ work.
- Keep secrets, connection values, signed URLs and tokens out of files and command output. Use 1Password references for credentials.
- Use hyphens rather than em dashes in labels and descriptions.

## Use a clean Demo4 session

- Before code sync, check `git status`. Sync only a clean clone or worktree on the intended branch so unrelated tracked or untracked files cannot reach Development.
- Authenticate to `https://demo4.holistics.io` with an isolated CLI `HOME`. Confirm project ID 7 before starting `holistics sync-code`.
- Use the existing visible Chrome through `agent-browser --cdp 9222` for Demo4 checks. Confirm the Demo4 origin before acting.
- Stop sync before git reconciliation. Review the final PR diff and confirm every changed path is intended.

## Completion gate

After every AML edit, run from the repository root:

```sh
holistics aml validate \
  clients/brainstorm-apac/models/*.model.aml \
  clients/brainstorm-apac/datasets/*.dataset.aml \
  clients/brainstorm-apac/dashboards/*.page.aml \
  clients/brainstorm-apac/embeds/*.embed.aml \
  -u company_id:number
```

- Run `git diff --check`.
- Treat AML validation as syntax and semantic validation, not runtime acceptance. For changed model or dataset logic, execute a real cloud query or visualization before completion.
- Every new or changed field and metric needs a plain-language description covering meaning, grain or units, intended use and any cutoff or aggregation caveat.
- Ask the operator whether the change should be reflected in tenant-wide `settings/ai/context.aml` — see `clients/AGENTS.md`. Brainstorm APAC has no routing block there yet, so new models, datasets, metric definitions or vocabulary are invisible to Holistics AI until one is added. Never edit `context.aml` without the operator's go-ahead.
