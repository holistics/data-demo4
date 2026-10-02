# Laasie — hospitality loyalty PoC

PoC for **Laasie**, an instant-gratification rewards platform for hotels. Prospect is
migrating off **AWS + Stitch + Looker**; their stated frustrations are outdated
visualizations and difficult time-over-time growth analysis, and their stated requirements
are embedded external access plus data governance scoped by user / client ID.

**Data source:** `demo_laasie_nam` (schema `"public"."*"`). Never join Laasie models onto
`demodb` or any other client's source.

**Naming prefix:** `laasie_*` for datasets, dashboards, themes and the portal. The models
keep their generated `public_*` names, which are unique to this data source.

## Scope boundary

Keep every change inside `team-folders/Nam/Laasie/`. Do not touch `01 demo ecommerce/`,
`library/`, `Datasets Library/`, `clients/`, or the sibling `team-folders/Nam/SCSI/` PoC.

## Layout

| Path | Contents |
|---|---|
| `Models/` | 8 table models over `demo_laasie_nam` |
| `Datasets/` | `laasie` (unscoped, internal) and `laasie_client` (scoped derivation) |
| `Dashboards/` | `laasie.theme.aml`, internal page, external page, `laasie_sankey.chart.aml` |
| `laasie_portal.embed.aml` | The external embed portal |

## Editing dashboards: Studio and the syncer fight

`holistics sync-code` and Holistics Studio both write these `.page.aml` files, and Studio wins
whatever it holds in memory. Two consequences, both observed on this folder:

- **Close a dashboard in Studio before editing its AML**, then reopen after the sync settles.
  Otherwise Studio re-serialises the page from its own copy: a block it has no `position` for is
  either dropped (it then renders nowhere) or auto-placed in a corner on top of other blocks.
  This is how `v_metric_sheet`, `t_sheet` and `t_flow` vanished and `v_sankey` landed at
  `pos(0, 0, ...)` — the AML was fine, the round-trip was not.
- **Studio strips comments from inside the `Dashboard { ... }` body**, though it preserves the
  header comment at the top of the file. A comment placed just above `view: CanvasLayout` will
  conflict on every single sync cycle. Put layout notes here instead.

Intended layout, so a mangled page is recognisable: both pages run KPIs → trend → **monthly
metric sheet** → … → **Sankey as the last block**. Internal canvas height 4570 (28 blocks),
portal 2950 (19 blocks). Verify with a quick parse of the `pos(...)` values rather than by eye —
every block must be placed, and none may overlap.

## The two rules that matter most here

1. **One active path to owner group.** `bookings > properties > owner_groups`. The
   `owner_group_id` columns denormalised onto bookings, loyalty transactions and redemptions
   are declared as INACTIVE relationships. Activating one creates a second join path and makes
   owner-group aggregation ambiguous.

2. **Internal and external never share a page.** `laasie` is unscoped, `laasie_client` carries
   `owner_group_scope`. Anything reachable from `laasie_portal` must read `laasie_client`.
   Check the `dataset:` line on every block before shipping a dashboard change — repointing one
   widget at `laasie` turns the portal into a cross-client leak with no error and no warning.

## Prerequisites before the portal works

- Scoping runs on the **borrowed** `company_id` user attribute, which already exists — no Admin
  step needed to demo. It is Brainstorm APAC's id-space, so **do not demo Laasie and Brainstorm
  in one session on the same login.** Upgrade path to a dedicated `laasie_owner_group_id` is
  documented in `Datasets/laasie_client.dataset.aml`; SCSI made the same move in `20912f39`.
- `pii_access` (Number) already exists and gates guest + stakeholder email.
- RLS-as-code must be enabled for the tenant; permissions only take effect after publish.

## Validate

```
holistics aml validate team-folders/Nam/Laasie/
```

Note the repo has 24 pre-existing errors in `01 demo ecommerce/models/9. Others/Claude/`
unrelated to this folder — validate the folder, not the whole repo, to see Laasie's own state.
