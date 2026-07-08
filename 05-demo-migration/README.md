# Demo migration projects

This folder contains Holistics AMQL migration examples grouped by source BI or analytics platform.

Use one subdirectory per source platform so future migration projects can follow the same shape.

```text
05-demo-migration/
├── power-bi/
│   ├── README.md
│   └── amql/
│       ├── dashboards/
│       ├── datasets/
│       ├── models/
│       └── MIGRATION_NOTES.md
└── superset/        # future migration project
    ├── README.md
    └── amql/
```

## Current projects

- `power-bi/`: AdventureWorks Sales Power BI sample migrated to Holistics AMQL.

## Project convention

- Keep generated Holistics assets under `<source-platform>/amql/`.
- Keep source-system setup notes in `<source-platform>/README.md`.
- Do not commit bulky or generated source project files unless they are needed as reviewed fixtures.
