# Core demo — Ecommerce

The **ecommerce dashboard and its datasets are the main core demo**. This is what
gets shown on the *first* demo call, when the prospect has not shared their own
database. Everything about it is deliberately generic so it fits any audience.

## Canonical assets

- **Dashboards** — `01 demo ecommerce/dashboards/`. Primary entry point is
  `company_dashboard.page.aml` (`[Demo] Ecommerce Dashboard`).
  `company_dashboard_v2_dont_touch.page.aml` is a frozen reference copy.
- **Datasets** — `01 demo ecommerce/datasets/`. Primary is `demo_ecommerce_version_2`
  (label `Ecommerce Dataset`); its `description` documents what it can and cannot
  answer plus persona guidelines.
- **Models** — `01 demo ecommerce/models/`, all prefixed `ecommerce_*`, on data
  source `demodb`, tables `"ecommerce"."*"`.
- **Metrics** — `01 demo ecommerce/metric_stores/metrics_store.aml`.
- **Runtime business context** — `settings/ai/context.aml`: the marketplace
  narrative (GMV → NMV → Commission; merchants / users / ops; reducing "Empty GMV").

## How to tell whether an asset belongs to the core demo

An asset is part of the core demo when the word **`ecommerce`** appears in its
**name, `label`, `description`, or metadata** (tags, folder path, model prefix,
`table_name`):

```sh
grep -ril 'ecommerce' --include='*.aml' .
```

Cross-check against `settings/ai/context.aml`. The business context described there
is the story the core demo tells — if an asset's semantics line up with it, the
asset is core-demo. If it needs a different vocabulary (turnover, MRR, claims,
wagering…), it belongs in a PoC folder instead, not here.

## Rules for touching the core demo

- Assume a demo is scheduled today. Never leave it broken.
- Do not rename, delete or repoint `ecommerce_*` models, `demo_ecommerce_*`
  datasets, or anything tagged `@tag('Endorsed')` without an explicit ask.
- Do not push client-specific vocabulary into core-demo labels or descriptions.
- New experiments go to `team-folders/<person>/` or `sandbox_dashboard.page.aml`
  first, not straight into `01 demo ecommerce/`.
- `zArchive/` holds dead assets — do not revive or fix them.
- Run `holistics aml validate` on every changed file before finishing.
