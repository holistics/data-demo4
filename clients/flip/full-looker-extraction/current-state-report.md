# Flip full Looker extraction — current state

Reviewed: 2026-09-17. Scope: `lookml_full.zip` supplied in the Flip Slack evaluation thread and restored under this directory. This is source inventory and migration triage, not a Holistics implementation or parity validation.

## Source handling

| Item | Current state |
|---|---|
| Original archive | `lookml_full.zip` moved from `~/Downloads/lookml_full.zip` into this directory |
| JSON export envelopes | `source-json/` contains 222 JSON wrappers with `original_path`, `target_project`, and `content` |
| Restored LookML | `lookml/` contains 222 native `.lkml` files restored from wrapper `content` |
| Verification | 222 restored files byte-match their JSON `content`; no restore mismatches found |
| Warehouse state from Slack | Darius added empty dummy tables with schemas/data types to the BigQuery POC project; Khai said dummy rows would be useful for result verification |

## Deal and evaluation context

| Area | Readout |
|---|---|
| Buyer/contact | Darius Bruer, Analytics Engineer at Flip GmbH / getflip |
| POC goal | Prove Holistics can migrate enough of Looker for Flip users to self-serve and match Looker numbers |
| Current scope | Internal analytics POC. Embedded analytics is deferred; multi-region is an expansion topic, not current Looker parity |
| Competitive context | Omni and Cube are active alternatives; Omni is positioned as a direct Looker migration path |
| Latest Slack update | Darius accepted Holistics' offer to transfer the full semantic layer, but German legal constraints pushed toward a dummy-schema project for now |
| Validation blocker | Empty schemas allow structure work, but not numeric parity. Need Looker exports and either representative dummy rows or permitted real data access |

## Project size

| Object | Count | Notes |
|---|---:|---|
| Total restored `.lkml` files | 222 | 215 view files + 7 model files |
| Model files | 7 | `internal_all_flipsters`, `internal_marketing`, `internal_cs_all`, `internal_management`, `internal_sales_all`, `internal_data`, `internal_all_flipsters_staging` |
| Base view files | 108 | 127 base view declarations including nested helper views |
| Extended view files | 107 | 113 extended view declarations |
| Unique view declarations | 240 | No duplicate view names detected |
| Explore declarations | 51 by line scan; 40 active top-level model Explores parsed | Some Explore declarations live inside base view files as technical helpers |
| Active model joins parsed | 233 | Mostly left/full outer joins |
| Dimensions / dimension groups | ~5,804 | Regex count; enough for sizing, not a parser-backed contract |
| Measures | ~1,252 | 108 in base views, ~1,144 in extended views |
| Parameters | 20 declared parameter blocks; 69 `parameter:` string occurrences | Liquid usage is much higher than parameter declarations |

## Models and Explore complexity

| Looker model | Business area | Active Explores seen | Highest-risk / priority Explores |
|---|---|---:|---|
| `internal_marketing` | Funnel, demand gen, account scoring, awareness | 5 | `marketing_funnel_allocation` has 26 joins, 23 full outer joins, 9 many-to-many joins; this remains the priority parity slice |
| `internal_all_flipsters` | Company-wide internal analytics and product usage | 26 | Product usage Explores with many joins and always filters; broadest included model |
| `internal_cs_all` | Customer Success, sensitive account/user/post data | 4 | Sensitive user/channel/group Explores; includes PII/original-ID lookup views |
| `internal_management` | Sales repeatability and Customer Delivery dashboards | 3 | Contains an explicit fan-out warning for account scorecard + deal scorecard mixing |
| `internal_sales_all` | Sales historical snapshots | 1 | Low join complexity, but still HubSpot deal-heavy |
| `internal_data` | Query-cost monitoring | 1 | Low semantic risk |
| `internal_all_flipsters_staging` | Staging chat/message analytics | 1 | Lower POC priority unless Flip asks for staging coverage |

## Join and relationship profile

| Join attribute | Count | Migration implication |
|---|---:|---|
| `left_outer` joins | 127 | Usually straightforward only after cardinality is verified |
| `full_outer` joins | 89 | High parity risk; Holistics relationship modelling may need explicit Query Models or redesigned datasets |
| Default/no explicit type joins | 16 | Need Looker default handling reviewed before translating |
| `inner` joins | 1 | Isolated, but still needs filter/root behavior check |
| `one_to_many` relationships | 123 | Fan-out-sensitive; measures must be checked against grain |
| `many_to_one` relationships | 72 | Usually lower risk if keys are actually unique |
| `one_to_one` relationships | 21 | Must not trust labels without profiling keys |
| `many_to_many` relationships | 17 | High risk for totals, distinct counts, and dynamic roots |

## Measure profile

| Measure type | Count | Migration note |
|---|---:|---|
| `count` | 313 | Usually easiest, but affected by joins/root filters |
| `sum` | 274 | Needs grain checks under fan-out |
| `count_distinct` | 215 | Requires exact key preservation |
| `average` | 199 | Often unsafe when rewritten as ratio/average without grouping review |
| `sum_distinct` | 87 | Critical: preserve `sql_distinct_key`; do not replace with `SUM(DISTINCT value)` |
| `number` | 85 | Often ratio-of-sums, measure-of-measures, or raw SQL; manual review required |
| `average_distinct` | 20 | Same distinct-key risk as `sum_distinct` |
| `median` | 15 | Explicit POC question; verify population and grain |
| `max` / `min` | 24 | Usually simple but may hide snapshot semantics |
| `percent_of_total` / `running_total` | 11 | Dashboard/query-result semantics, not just model semantics |
| `median_distinct` | 1 | High risk; verify Holistics equivalent with Darius's expected result |

## Constructs that matter for migration

| Construct | Count / finding | Migration impact |
|---|---:|---|
| Derived tables | 0 | Good: no PDT/native derived table layer found in this export |
| Datagroups / SQL triggers | 5 | Need replacement cache/freshness policy, but not first parity blocker |
| `persist_for` | 31 | Operational behaviour to map later |
| Liquid tags `{% ... %}` | 424 occurrences | Manual/AI-assisted conversion required; deterministic converter alone is insufficient |
| `always_filter` | 23 | Preserve as invariant/default behavior consciously; not all should become security filters |
| `sql_always_where`, `access_filter`, `access_grant` | 0 | No Looker-enforced row access found in LookML, but sensitive views still need governance |
| `left join unnest(...)` | 4 | Nested-array helper joins need explicit modelling or Query Models |
| Sensitive/PII files | 5 files plus model references | Do not expose by default; needs permission design before Holistics datasets |

## Priority migration slices

| Priority | Slice | Why this first | What must be proven |
|---:|---|---|---|
| 1 | `internal_marketing` → `marketing_funnel_allocation` | This is the known 11-stage/role-playing funnel Darius asked about and the core POC risk | SAL/SAO/Closed Won/Closed Lost totals by date and source, role-local filters, targets, full-outer unmatched rows, parameter branches |
| 2 | `hubspot_deals_all_ext` and `hubspot_contacts_all_ext` measures | Largest concentration of distinct-key, median, dynamic, and funnel-stage measures | `sum_distinct` by deal/contact key, median populations, ratio-of-sums, Liquid parameter outputs |
| 3 | Product usage adoption Explores | Important for internal analytics beyond GTM; many snapshot/product grains | Snapshot dates, tenant/user/channel joins, arrays/unnests, no summing across incompatible daily snapshots |
| 4 | CS sensitive user/channel/customer Explores | High business value but permission-sensitive | PII exclusion, customer lifecycle filters, user/channel fan-out, restricted-user behaviour |
| 5 | Management/CD dashboards | Contains explicit source comments about fan-out and merged-result workarounds | Decide whether to redesign as separate datasets/Query Models rather than one dynamic dataset |

## Current recommendation

Do not promise a full automatic migration. The source is structurally restorable and largely table-backed, which is good, but the project is metric-heavy and relationship-heavy: many full outer joins, many-to-many joins, distinct-key measures, Liquid parameters, median metrics, and dashboard-result calculations.

For the next POC step, build a visible partial migration around `marketing_funnel_allocation` plus the underlying `hubspot_deals_all_ext` measures. Ask Darius for one or two redacted Looker exports of the current sales funnel dashboard, including fields, filters, parameter values, timezone, row limits, and totals. If legal still blocks real data, ask for a small synthetic/dummy dataset with rows that exercise duplicate deals, equal amounts, unmatched funnel stages, and multiple marketing touchpoints.

## Open blockers

| Blocker | Why it matters | Suggested ask |
|---|---|---|
| No Looker-rendered baseline exports yet | Cannot claim parity from model inspection or empty schemas | Sales funnel export + one product/CS dashboard export with exact filters/params |
| Empty dummy tables only | Can validate references/compilation, not values | Add representative dummy rows or allow restricted real-data test access |
| Current dashboard layout/screenshots not received in local evidence | We do not know which fields users actually interact with | Redacted screenshots or short recording of funnel dashboard |
| Legal constraints on full data access | Limits Holistics team's ability to verify numbers | Keep source and dummy data separated; document what was tested structurally vs numerically |
| Full automatic converter scope unknown | Explores, Liquid, and dashboard behaviours exceed deterministic conversion | Use converter for eligible views, then manually implement/redesign Explore-level semantics |
