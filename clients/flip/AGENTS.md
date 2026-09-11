# Flip PoC

## Scope

- All Flip work lives under `clients/flip/`. Do not touch `01 demo ecommerce/`, shared `library/`, `Datasets Library/`, or another client's folder.
- Namespace all objects with the prefix `flip_` (models, datasets, dashboards).

## Data source

<!-- TODO: fill in once the data source is connected -->
- Data source: TBD
- Schema: TBD

## Directory layout

```
clients/flip/
├── models/        # flip_* models
├── datasets/      # flip_* datasets
├── dashboards/    # flip_* dashboards / pages
└── docs/          # design docs, meeting notes
```

## Completion gate

After every AML edit, run from the repository root:

```sh
holistics aml validate \
  clients/flip/models/*.model.aml \
  clients/flip/datasets/*.dataset.aml \
  clients/flip/dashboards/*.page.aml
```

Ask the operator whether changes should be reflected in `settings/ai/context.aml` before finishing — Flip has no routing block there yet.
