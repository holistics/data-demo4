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
| `Dashboards/` | `laasie.theme.aml`, internal page, external page |
| `laasie_portal.embed.aml` | The external embed portal |

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

- User attribute `laasie_owner_group_id` (Number) must exist on the tenant. It does not yet.
- `pii_access` (Number) already exists and gates guest + stakeholder email.
- RLS-as-code must be enabled for the tenant; permissions only take effect after publish.

## Validate

```
holistics aml validate team-folders/Nam/Laasie/
```

Note the repo has 24 pre-existing errors in `01 demo ecommerce/models/9. Others/Claude/`
unrelated to this folder — validate the folder, not the whole repo, to see Laasie's own state.
