# Ecommerce cohort analysis — parallel build

Cohort layer for the demo4 ecommerce data, built as a **standalone dataset** that reuses the shared table models but declares its own relationships, fields and view. Nothing in `demo_ecommerce_version_2`, its models or its dashboards was modified — this folder is additive and can be adopted, cherry-picked from, or deleted.

It began as a `.extend()` and was decoupled for one concrete reason: a `view` block inside an extend leaks into the base dataset, so the bridge's fields could never reach the field picker while the extend stood. Standalone, the view is its own, and `Category at Acquisition` / `Product at Acquisition` are explorable. The trade is that `Cohort Month`, `Month Number`, `First Order Date` and the revenue definition are declared here rather than inherited — kept deliberately identical to the base, but they will not track a change made there. Verified at parity after the switch: identical user counts and cohort spend across all six categories.

Ported from the Mother Root `cohort_analysis` layer (`~/motherroot/cohort_analysis`). The modelling idea is identical; what changed is the source data and what it can honestly support.

| File | Purpose |
|---|---|
| `datasets/ecom_cohort_analysis.dataset.aml` | the bridge model, then the `.extend()` of the base dataset: 5 cohort dimensions + 10 metrics |
| `dashboards/ecom_cohort_dashboard.page.aml` | two tabs — the cohort dashboard, and a live demonstration of the trap |

There is no `models/` folder. The bridge is declared at the top of the dataset file, above the `Dataset` block — **that order is required**; putting the model after the dataset fails with `Block-scoped variable 'ecom_cohort_first_order_categories' used before its declaration`.

## The core design decision

Cohort membership lives at **user grain**, never in a parameter. It arrives two ways, and the split is deliberate:

**Single-valued attributes are dimensions**, built with `dimensionalize()` — an aggregate over the many side collapsed to one value per user:

```aml
sum(ecommerce_order_items.quantity)
  | where(ecommerce_orders.is_first_order)
  | dimensionalize(ecommerce_users.id)
```

**Multi-valued attributes are the bridge model** — category, sub-category and product of the acquisition basket. A dimension cannot hold these, because a first order contains several of each and `dimensionalize()` collapses to one value per user.

Either way, filtering narrows **who is in the cohort** while every metric still counts that user's whole lifetime. Filtering `Category` on the base path would instead restrict the line items being summed, which is the trap this avoids — quantified under "Why it cannot be removed" below.

What it buys: no `'All'` sentinel and no default that has to resolve to `true` (an unset field filter emits no predicate, so the unfiltered pivot *is* the all-users cohort); one metric set with no `qualified_*` twins; adding a cohort attribute costs one dimension or one bridge column and zero metric changes; and correct "any" semantics — a user whose first order held Clothes *and* Skin Care belongs to both cohorts and is still counted once.

## Mapping from the Mother Root build

| Mother Root | Here |
|---|---|
| customer | `ecommerce_users` |
| `order_sequence_number = 1` | `is_first_order` (day grain — see below) |
| `product_type` (Core / LE / Merch / Mixers / Other) | `map_categories.parent_category` (6 values) |
| `acquisition_month` | inherited `ecommerce_users.cohort_month` |
| `months_since_acquisition` | inherited `ecommerce_orders.month_number` |
| `first_order_country` (order-level) | `ecommerce_countries.name` — already user-grain here, so no new dimension needed |
| CM2 / CM3 / CAC / payback | **omitted** — see below |

### What was deliberately NOT ported

**No margin / CM2 layer.** `ecommerce_products.cost` compiles to `ROUND(price * 0.3)` — a synthetic constant. Any gross-margin metric would be revenue × 0.7 and would carry no information beyond revenue, so it would look meaningful and be nothing of the kind.

**No CAC / CM3 / payback layer.** There is no marketing spend anywhere in this source. The base dataset says so itself: "Marketing Attribution: Traffic sources ... are not tracked here." Mother Root's `cohort_acquisition` model has no analogue to build from.

Revenue basis is therefore the inherited `nmv` — quantity × price × (1 − discount), excluding `cancelled` and `refunded`.

### First order is defined at DAY grain

Mother Root had a real `order_sequence_number`. Here it has to be derived, and the obvious route fails: the inherited `ecommerce_users.first_order_date` is typed `date` while `orders.created_at` is a timestamp, so `created_at == first_order_date` compiles fine and **returns zero rows** — it only matches at midnight. The working comparison is `created_date == first_order_date`, both dates.

Day grain also reads better commercially: the acquisition basket is what someone bought on the day they became a customer. The cost is that **81 of 7,499 buying users (1.1%) placed more than one order on their first day**, and all of it counts toward their first-order profile.

## The one query model: `ecom_cohort_first_order_categories`

Grain: one row per user per distinct **product** in their first order, carrying that product's sub-category and parent category alongside. It drives both cohort-profile filters:

- **Categories at Acquisition** — multiselect on `parent_category`
- **Products at Acquisition** — multiselect on `product_name` (109 distinct names; `product_id` is 4,543, which is why the label is the filterable field)

Selecting several values in one filter is OR ("first order contained any of these"). Combining the two filters is AND matched *within the same row*, so the chosen product must sit in one of the chosen categories — picking Clothes plus a Groceries product returns nobody, by construction. Filtering categories alone or products alone is the common case and behaves as expected.

Nothing is hardcoded per category or per product: the filters enumerate their own values, so a new category or product needs no AML change at all.

### It is not a table — it is a CTE

`type: 'query'` with no persistence block. Holistics inlines the whole definition as a `WITH` clause in each query and pre-aggregates it to just the columns that query uses, then discards it. There is no object in the warehouse, nothing to refresh, and no storage cost. This is the same mechanism as the existing `map_categories` model.

Because of that pre-aggregation, the finer (user, product) grain does **not** inflate anything when you group by category: the compiled SQL reads `GROUP BY user_id, parent_category`, collapsing a user's several products within one category back to a single row. Verified — user counts are identical to a per-category bridge.

### Why it cannot be removed

Do not spend another afternoon trying. Every route that avoids the model was tested against a known target — the Skin Care cohort is **1,593 users with $1,697,523 of lifetime spend** — and all of them fail:

| Approach | Result |
|---|---|
| Plain filter: `is_first_order == true AND parent_category == 'Skin Care'` | 1,593 users (right) but **$244,667** — lifetime understated 7x |
| `nmv \| of_all(parent_category)` | $1,632,867 — drops the predicate without keeping the user restriction |
| `nmv \| of_all(parent_category, is_first_order)` | $7,122,841 — global lifetime, cohort gone entirely |
| `dimensionalize(users.id, parent_category)` | **Engine refuses**: `Fan-out error. Multiple map_categories rows are associated with the current ecommerce_users row and cannot be returned directly` |
| A first-order product list *without* the user column | "Product P was somebody's first purchase" is not "this user's first order contained P" — matches every line of P, all users, all time |
| Hardcoded `first_order_has_<category>` flags | Correct, but one dimension per value, and no product equivalent |
| Query params | Correct, but reinstates the `'All'` sentinel and `else: true` machinery this design exists to remove |

The plain filter is the instructive failure: membership is right either way, but the predicate also lands inside the revenue CTE (`WHERE parent_category = 'Skin Care' AND is_first_order = TRUE` sits on the `nmv` join), so only the cohort's first-order Skin Care lines are counted rather than everything those users went on to buy. LTV reads ~$154 against a true ~$1,066.

That is the trap the layer exists to avoid — **the filter must select users, not line items**. Revenue reaches users through `order_items`, so membership needs a *second, independent* path from users to categories. AQL cannot hold a multi-valued attribute at user grain (that is the fan-out error above), so that second path has to be a model. It costs no storage — it is a CTE — but it cannot be nothing.

Verified against the earlier per-category implementation — the two agree exactly:

| Category at Acquisition | via (user, product) bridge | via per-category flags |
|---|---|---|
| Clothes | 2,355 | 2,355 ✓ |
| Groceries | 2,200 | 2,200 ✓ |
| Home Entertainment | 1,263 | 1,263 ✓ |
| Home Furniture | 2,956 | 2,956 ✓ |
| Mobiles & Tablets | 941 | 941 ✓ |
| Skin Care | 1,593 | 1,593 ✓ |

Category totals sum to 11,308 against a 7,499 buying-user base — multi-membership working as intended.

### What was removed, and why

An earlier cut of this layer carried six `first_order_has_<category>` flags plus six hidden `first_order_<category>_lines` dimensions backing them, and a `first_order_category_mix` text dimension enumerating combinations. All 13 are gone — the bridge expresses the same membership as data rather than as one hardcoded dimension per value, which halved the dataset (405 → 216 lines) and took the dashboard from 12 filters to 6.

The one thing the flags could do that the multiselect cannot is a single-filter AND ("bought Clothes *and* Skin Care first time") — a multiselect is OR. If that case comes up, the flags are worth restoring for those categories only; they are in git history.

## Gotchas, each found the hard way

**A `view` block inside `.extend()` leaks into the BASE dataset.** This is the expensive one. Declaring `view { ... }` in the extend broke **83 dashboards project-wide** with `In View{}, Metric 'cohort_user_count' not found` — every dashboard built on `demo_ecommerce_version_2`, none of which had anything to do with this work. The extend's view is not scoped to the extended dataset. Fix: **do not declare a view in an extend at all.** The base view uses empty-braced model blocks (`model ecommerce_users { }` = all fields exposed), so new dataset dimensions surface anyway; new metrics are reachable by reference but are not placed in a curated group.

**`extend()` overrides, it does not append.** `models` and `relationships` declared in the extend replace the inherited lists outright, so both are re-declared here in full — the base's 12 relationships plus the bridge join. Dropping any one of them silently breaks an inherited metric.

**`label` is not a valid property on `Dataset.view.group`.**

**A dimensionalized aggregate is `NULL`, not `0`, when nothing matches.** Any boolean built on one must be wrapped in `coalesce(x, 0)`, or it returns `null` instead of `false` and a `= false` filter silently misses every non-member. This bit the per-category flags before they were removed, and it applies to anything built the same way — `first_order_units` is `NULL` for the 2,765 users who never ordered, which is why `Units Band at Acquisition` has an explicit `else: 'Never ordered'`.

**`where()` goes before `dimensionalize()`.** Applying it after is invalid — you cannot filter a dimension.

**Name collisions with the base dataset.** The base already defines a *dimension* called `cohort_size` and metrics `retention`, `aov`, `nmv`. The cohort metrics are therefore `cohort_user_count` (label 'Cohort Size'), `cohort_retention` (label 'Retention'), `cohort_aov`, and so on. Check the base before naming anything.

**`running_total()` rejects `count_distinct`.** `Cohort Orders` uses plain `count()` so it can be accumulated.

**`running_total` accumulates over the months in scope.** A *range* lifecycle window (0–12) is correct; narrowing to a *single* month leaves the running total one month to accumulate and reports that month alone. This is the one way to misread the dashboard, so the filter is labelled "Lifecycle Window" and the caveat is on the page.

**Sparse lifecycle axis.** `month_number` only exists where an order exists, so a cohort with no orders in a month produces no column and the axis reads `0, 1, 2, 3, 5, 7…`. The three cumulative metrics use `running_total(..., fill_missing: true)`. Non-cumulative metrics stay sparse — read a missing column as zero.

**Running-total metrics are AXIS-BOUND and will break a report that has no lifecycle axis.** `cumulative_cohort_revenue`, `cumulative_cohort_orders`, `cohort_ltv` and `cohort_orders_per_user` all use `running_total(..., ecommerce_orders.month_number, fill_missing: true)`. `fill_missing` has to materialise the lifecycle axis, so putting one of them on a report that does not carry `Month Number` as a dimension fails at query time with:

```
SQL Generation error: Field `ecommerce_orders->month_number` not found in model `aql__t22`
```

`aql__t22` is the pivot presentation CTE, which only ever holds the aliased output columns — so the message means a `month_number` predicate was deferred to a layer that has no such column. It compiles clean and only surfaces when someone filters, which is what makes it easy to ship.

Use the **axis-free** `cohort_ltv_total` (`cohort_revenue / cohort_user_count`) and `cohort_aov` (`cohort_revenue / cohort_order_count`) on summary tables instead. Both cohort summaries do.

This bit twice: `cohort_aov` was originally `cumulative_cohort_revenue / cumulative_cohort_orders` and `cohort_summary_naive` originally used `cohort_ltv`, and both sat on DataTables with no Month Number. Reproduce with *Categories at Acquisition* = Clothes + Groceries.

**`exact_grains()` is not a substitute for `of_all()` here.** `count_distinct(users.id) | exact_grains(cohort_month)` compiles to a literal `NULL` in this dataset. The constant cohort denominator has to stay `of_all(ecommerce_orders.month_number)`.

**`aml validate` does not check SQL passthrough against the database, and compilation is not execution.** Every block here was executed, not just compiled — and the axis-bound bug above passes validation.

## The second tab: the trap, demonstrated

The dashboard's second tab exists to make one failure mode visible rather than described. It runs **the same dataset, the same metrics and the same pivots** as the first; the only difference is that its two profile filters point at `Products` / `Product Categories` on the order-line path instead of at the acquisition bridge.

That is the thing to be suspicious of in any cohort model: **a filter that trims output rows rather than cohort membership.** What makes it dangerous is that it looks correct until someone filters — unfiltered, both tabs return byte-identical pivots, which is exactly how such a bug survives review.

Clear the month filters on both tabs and set `Skin Care` on each:

| | Cohort users | Revenue | LTV |
|---|---|---|---|
| Tab 1 — filtered on the bridge | 1,593 | $1,697,523 | **$1,065.61** |
| Tab 2 — filtered on the line-item path | 1,593 | $244,667 | **$153.59** |

Membership is right in both — the cohort really is 1,593 users either way. Only the lifetime is wrong, by 7x, because the predicate lands inside the revenue CTE and counts just the cohort's first-order Skin Care lines instead of everything those users went on to buy.

## Theme

`library/themes/holistics_brand.theme.aml` — a reusable Holistics brand theme, applied to this dashboard with `theme: holistics_brand`. It lives in `library/themes/` per repo convention rather than in this folder, because it is brand styling, not cohort logic; it is the only part of this work not self-contained here.

Colours are the canonical Holistics design tokens — the same light-gray / light-blue / light-green / light-red scales the product and `holistics-remotion` ship. No invented hexes. It replaced `theme: buyco_light`, which had arrived on this dashboard from a Studio edit and was a client's branding.

**It is built for cohort grids specifically**, where meaning lives in cell colour, so every competing source of colour is suppressed:

- `banding_color: transparent` — zebra striping shifts the perceived value of identical cells across alternating rows, which is exactly the misreading a cohort table must not invite.
- `hover_color` is a pale neutral, not brand blue — a blue hover sits mid-ramp and reads as data.
- `grid_color` one step lighter than the border, so the grid separates cells without cutting the gradient into stripes.
- Ramps stop at the 300-level tints (`#8DBEF2`, `#7AD1AE`) so the near-black cell text stays legible in the hottest cell. A ramp running to `light-blue-600` (`#1B7CE4`) would need the text to flip to white per cell, which Holistics conditional formatting will not do.

Eight pivots carry `ScaleFormat` heatmaps: Retention (`0 / 0.5 / 1`, blue), LTV and LTV by Category (`0 / 500 / 1000`, green), and Orders Per User (`0 / 1.5 / 3`, blue) — on both tabs. The bounds are tuned to the default 12-month lifecycle window; cohorts older than that clamp at max, which is normal heatmap behaviour.

**Cumulative Cohort Revenue is deliberately left unformatted.** It is an absolute total, so a heatmap over it would largely encode cohort size rather than cohort quality — the biggest cohorts would simply be the hottest, which tells you nothing you did not already know from `Cohort Size`.

## The null cohort

2,765 of 10,264 users have never ordered, so they form a `null` cohort row with null revenue. The dashboard's `Cohort Month` filter defaults to `last 12 months`, which excludes them; clear that filter and the null row appears at the bottom of every pivot. It is real signal (signed up, never bought), not a modelling fault.

## Verification

- `holistics aml validate` — **the whole project validates clean**, 0 errors. It was clean before this work too; the 83 errors described above were introduced and then removed during the build.
- All six dashboard blocks execute, not just compile.
- Month-0 retention is exactly **100.0%** for every cohort checked.
- Cohort size is constant across the lifecycle axis (Jan 2026 = 381 at every month).
- LTV is monotonically increasing.
- The (user, product) bridge and the earlier per-category implementation agree to the user across all six categories, and the finer grain inflates neither user counts nor revenue.
- Cross-membership visible: filtering to the Skin Care cohort returns 1,593 users and still shows $197,572 of *Clothes* spend, proving the filter selects users rather than line items. The generated SQL confirms the category predicate is pushed **inside** the membership CTE and the population is cut before `COUNT(DISTINCT ...)`.
- The no-bridge alternative was tested head to head and understates cohort lifetime by 7x — see "Why it cannot be removed".
