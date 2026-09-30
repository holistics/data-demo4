# Flip funnel alias Holistics prep

Prepared for the small onboarding demo focused on Darius Bruer's sales-funnel alias question.

## What LookML files are needed

For the proposed Holistics solution, the underlying warehouse inputs are only:

- `fl-bi-p-poc.reports_poc.marketing_filters_allocation`
- `fl-bi-p-poc.datamarts_poc.hubspot_deals_all`

The required LookML evidence is therefore limited to these source files:

| Needed? | File in this folder | Why it is needed |
|---|---|---|
| Required | `source-lookml/model/internal_marketing.model.lkml` | Defines the active `marketing_funnel_allocation` Explore and the 11 role aliases of `hubspot_deals_all_ext`. |
| Required | `source-lookml/base_views/Reports/marketing_filters_allocation_base.view.lkml` | Shows the physical allocation table and root fields such as `primary_key`, `date`, and allocation dimensions. |
| Required | `source-lookml/extended_views/Reports/marketing_filters_allocation_ext.view.lkml` | Adds the business fields/measures on the allocation root. Use only the fields needed for the demo. |
| Required | `source-lookml/base_views/Datamarts/hubspot_deals_all_base.view.lkml` | Shows the physical deals table and the stage-specific foreign keys used by each alias. |
| Required | `source-lookml/extended_views/Datamarts/hubspot_deals_all_ext.view.lkml` | Defines stage counts, volume measures, dynamic parameters, and date dimensions inherited by every role alias. |
| Not needed for the minimal alias demo | `lookml/internal_all_flipsters/**` | Overlapping source copy for other Explores; not needed to prove the allocation funnel alias pattern. |
| Not needed for the minimal alias demo | Legacy `marketing_funnel` using `marketing_filters_ext` | Marked old/unused since 2025; keep out unless Darius asks for legacy parity. |

The source files here are copies for review. Preserve the original source bundle under `../lookml/` as the evidence of record.

## Holistics representation to prepare

Create several AML models pointing to the same physical `hubspot_deals_all` table, one per funnel role needed in the demo. Do not create new warehouse tables.

Minimum useful slice:

| Holistics model role | Physical table | Source alias | Join to allocation root |
|---|---|---|---|
| `flip_funnel_allocation` | `reports_poc.marketing_filters_allocation` | `marketing_funnel_allocation` root | root model |
| `flip_deals_sal` | `datamarts_poc.hubspot_deals_all` | `hubspot_sal` | `flip_funnel_allocation.primary_key = flip_deals_sal.foreign_key_sal_marketing_filters_allocation` plus SAL-local filters |
| `flip_deals_sao` | `datamarts_poc.hubspot_deals_all` | `hubspot_sao` | `flip_funnel_allocation.primary_key = flip_deals_sao.foreign_key_sao_marketing_filters_allocation` |
| `flip_deals_closed_won` | `datamarts_poc.hubspot_deals_all` | `hubspot_closed_won` | `flip_funnel_allocation.primary_key = flip_deals_closed_won.foreign_key_closed_won_marketing_filters_allocation` |

If the demo needs all 11 Looker roles, extend the same pattern with these aliases and keys:

| Source alias | Stage/date role | Stage-specific key on `hubspot_deals_all` |
|---|---|---|
| `hubspot_sal` | SAL | `foreign_key_sal_marketing_filters_allocation` |
| `hubspot_sao` | SAO | `foreign_key_sao_marketing_filters_allocation` |
| `hubspot_solution_design` | Solution Design | `foreign_key_solution_design_marketing_filters_allocation` |
| `hubspot_evaluation` | Evaluation | `foreign_key_evaluation_marketing_filters_allocation` |
| `hubspot_proposal` | Proposal | `foreign_key_proposal_marketing_filters_allocation` |
| `hubspot_negotiation` | Negotiation | `foreign_key_negotiations_marketing_filters_allocation` |
| `hubspot_closing_validation` | Closing Validation | `foreign_key_closing_validation_marketing_filters_allocation` |
| `hubspot_closed_won` | Closed Won | `foreign_key_closed_won_marketing_filters_allocation` |
| `hubspot_closed_lost` | Closed Lost | `foreign_key_closed_lost_marketing_filters_allocation` |
| `hubspot_close_date` | Close Date | `foreign_key_close_date_marketing_filters_allocation` |
| `hubspot_expected_sd_date` | Expected SD Date | `foreign_key_expected_sd_date_marketing_filters_allocation` |

## Demo acceptance case

Use a tiny example where the same deal reaches stages on different dates:

| Deal | Allocation | SAL date | SAO date | Closed Won date |
|---|---|---:|---:|---:|
| A | Marketing | Jan 05 | Jan 20 | Feb 10 |
| B | Marketing | Jan 10 | Feb 02 | null |
| C | Sales | Feb 01 | Feb 15 | Mar 03 |

Expected monthly result:

| Month | SALs | SAOs | Closed Won |
|---|---:|---:|---:|
| Jan | 2 | 1 | 0 |
| Feb | 1 | 2 | 1 |
| Mar | 0 | 0 | 1 |

This catches the main mistake: using one deals model/date role globally makes a deal appear in only one stage month, even though the correct funnel counts the same deal independently at SAL, SAO, and Closed Won dates.

## Files in this prep folder

- `source-lookml/`: copied LookML source needed for the alias proof.
- `reconstructed-11-stage-join.sql`: SQL sketch of the active Looker Explore shape. It is not exact Looker-compiled SQL; it is a readable mapping from LookML joins to SQL aliases.

## Open implementation notes

- The LookML Explore uses `FULL OUTER` joins. Holistics dataset relationships may need an explicit modeling decision or query-level workaround if exact full-outer behavior matters for unmatched rows.
- SAL filters must remain local to the SAL relationship/model. The LookML comments say a global `always_filter` made other stages wrong.
- The seven LookML parameters are defined inside `hubspot_deals_all_ext`; if all aliases are exposed, each role inherits its own parameter field namespace in Looker. Confirm which parameters Darius actually varies before building all 11 roles.
- Do not connect prospect data to Demo4 or create AML assets until the prospect-specific data source is confirmed.
