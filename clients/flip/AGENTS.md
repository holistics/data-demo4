# Flip — Looker migration preparation

- Scope: confidential source exports, restored LookML, schema and migration notes for Flip GmbH. This folder has no deployed Holistics models or datasets yet.
- Before migration work, read `lookml-holistics-mapping.md` for the inventory, alias semantics, missing dependencies and parity checks.
- Source data: Flip's BigQuery project `fl-bi-p-poc`, schemas `datamarts_poc` and `reports_poc`. A Demo4 data-source binding is not established; confirm the prospect-specific connection before implementing AML.
- Preserve `poc_lookml/` and `lookml/` as source evidence. Keep implementation within this folder, with `flip_` identifiers and “Flip” labels; use only the prospect's data source.
- Validate schema edits from this folder with `dbdiagram validate flip-lookml-schema.dbml --json`. For future AML edits, run `holistics aml validate <changed-file>` after confirming CLI authentication to `demo4.holistics.io`.
- Tenant AI context currently has no Flip route. These are preparation assets only; obtain approval before adding a route bound to actual Flip models and their data source.
