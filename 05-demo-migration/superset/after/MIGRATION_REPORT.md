# Superset → Holistics migration report

Source: `05-demo-migration/superset/before/`
Target: `05-demo-migration/superset/after/`
Source dashboard: **Slack Dashboard** (uuid `9726d8b0-222f-eb2c-034a-02b9f51ef5fd`)
Data source: `demodb`, schema `slack` (user-supplied; not derived from Superset export).
AML validate: ✅ `No validation errors found.` (full `after/` folder).

## Dataset mapping

| Superset dataset | UUID | Holistics model | File |
|---|---|---|---|
| `messages` | `e032c69e-716e-d700-eff7-07800d0f9989` | `messages` | `models/messages.model.aml` |
| `messages_channels` | `6e533506-fce6-4f6a-b116-d139df6dbdea` | `messages_channels` | `models/messages_channels.model.aml` |
| `threads` | `d7438be6-6078-17dd-cf9a-56f0ef546c80` | `threads` | `models/threads.model.aml` |
| `users` | `7195db6b-2d17-7619-b7c7-26b15378df8c` | `slack_users` *(renamed to avoid collision with `team-folders/khai/models/base/users.model.aml`)* | `models/slack_users.model.aml` |
| `new_members_daily` | `9dd99cda-ff6b-4575-9a74-684d06e871ab` | `new_members_daily` | `models/new_members_daily.model.aml` |

All five models bundled into one thin dataset with no relationships:
- `datasets/slack_dashboard.dataset.aml` → `Dataset slack_dashboard`

## Metric mapping

| Superset metric | Source dataset | Holistics measure | Notes |
|---|---|---|---|
| `count` (`COUNT(*)`) | messages | `messages.count` | `@sql count(*)` with `aggregation_type: 'custom'`. |
| `count` (`count(*)`) | messages_channels | `messages_channels.count` | same |
| `count` (`COUNT(*)`) | threads | `threads.count` | same |
| `count` (`COUNT(*)`) | users | `slack_users.count` | same |
| `count` (`count(*)`) | new_members_daily | `new_members_daily.count` | same |
| ad-hoc `SUM(new_members)` (from `New Members per Month` chart) | new_members_daily | `new_members_daily.total_new_members` | Added because Superset only had `count`, but chart used SUM. AQL: `sum(new_members_daily.new_members)`. |

## Chart → VizBlock mapping

All in `dashboards/slack_dashboard.page.aml` (`Dashboard slack_overview`).

| Superset chart | viz_type | Holistics block | Holistics viz | Notes |
|---|---|---|---|---|
| Number of Members (72) | `big_number_total` | `kpi_members` | `MetricKpi` `display_mode: 'single'` | Subheader "Slack Members" dropped — not a separate viz prop. |
| Weekly Messages (74) | `big_number` w/ WoW | `kpi_weekly_messages` | `MetricKpi` `compare_by_percent`, weekly compare on `messages.ts` | `compare_lag: 1` + `compare_suffix: WoW` → `duration: 1, granularity: 'week'`. |
| Weekly Threads (75) | `big_number` w/ WoW | `kpi_weekly_threads` | `MetricKpi` `compare_by_percent`, weekly compare on `threads.ts` | Superset's hard-coded `time_range: '2020-08-05 : 2020-09-06'` **dropped**. See human review. |
| New Members per Month (71) | `big_number` w/ MoM | `kpi_new_members_monthly` | `MetricKpi` `compare_by_percent`, monthly compare on `new_members_daily.date` | Uses `total_new_members` (sum). |
| Top Timezones (73) | `table` | `top_timezones` | `DataTable` row_limit 10 | Override `sliceNameOverride: 'Top Timezones for Members'` used as label. Sort order desc by count: relying on default. |
| Messages per Channel (70) | `echarts_area` | `messages_per_channel` | `AreaChart` x=ts(day), legend=name, y=count | Superset filter `name != 'github-notifications'` **dropped**. Superset stream-stacking + rolling mean (14 periods) **not applied**. See human review. |

The Superset `MARKDOWN` block (Slack logo) is replaced with `block header: TextBlock` containing a gradient banner. The original Slack logo URL was external (`cdn.brandfolder.io`); not re-embedded to avoid hotlinking. See human review.

## Files produced

```
05-demo-migration/superset/after/
├── MIGRATION_REPORT.md
├── datasets/
│   └── slack_dashboard.dataset.aml
├── dashboards/
│   └── slack_dashboard.page.aml
└── models/
    ├── messages.model.aml
    ├── messages_channels.model.aml
    ├── new_members_daily.model.aml
    ├── slack_users.model.aml
    └── threads.model.aml
```

## ⚠ Items needing human review

1. **Data source mapping.** Superset DB was `examples` (Postgres) with schema `public`. User supplied `demodb` / `slack`. Verify these tables exist in `demodb.slack.*`. None of the column types in models were derived from a live data-source introspection — they came purely from the Superset YAML.
2. **No primary keys.** Superset export carries no PK info. No PK was fabricated; `count` measures use `count(*)` via custom SQL aggregation. AQL fan-out protection is weaker without PKs.
3. **No relationships.** Per instructions, dataset has `relationships: []`. Cross-model AQL (e.g. messages × users) is currently not joinable. Add `relationship(...)` entries in the dataset once join keys are confirmed.
4. **Reserved-word columns.** Both `messages.user`/`messages.type` and `threads.user`/`threads.type` map a reserved Postgres keyword. Dimensions are renamed (`user_id`, `message_type`/`thread_type`) but the SQL definition is `{{ #SOURCE.user }}` / `{{ #SOURCE.type }}`. If Postgres rejects the unquoted reference at query time, rewrite the definitions to use quoted identifiers (e.g. `definition: @sql "user";;`).
5. **Dropped Superset features:**
   - `Weekly Threads` had a hard-coded `time_range: '2020-08-05 : 2020-09-06'`. Not migrated — add a dashboard-level date filter or a viz filter if you still want this restriction.
   - `Messages per Channel` had an `adhoc_filter` `name != 'github-notifications'`. Not migrated — add via `filter { ... }` on the viz or a FilterBlock.
   - `Messages per Channel` also used `rolling_periods: 14`, `rolling_type: mean`, `stacked_style: stream`, color scheme `supersetColors`, and per-channel `label_colors`. Holistics AreaChart settings for those were not applied.
   - `Number of Members` had a `subheader: 'Slack Members'` displayed under the big number. Holistics MetricKpi has no direct equivalent of a free-text subheader — currently the field label carries the text.
6. **Top Timezones sort.** Superset had `order_desc: true` and grouped by `tz`. DataTable here relies on default ordering. If the table doesn't come back sorted by count desc, add an explicit sort.
7. **Markdown / logo block.** The Slack logo (`https://cdn.brandfolder.io/.../Slack_RGB.svg`) was replaced with a gradient banner. Swap to your branding asset if needed.
8. **Dashboard name vs dataset name collision.** Both were `slack_dashboard`. The dashboard was renamed to `slack_overview` (title remains 'Slack Dashboard'). Update any external references.
9. **Naming collision avoidance.** `Model users` would have collided with `team-folders/khai/models/base/users.model.aml`. Renamed to `slack_users`. Re-evaluate if you want it in a different namespace.
10. **Time granularity for KPIs.** Superset's `time_grain_sqla: P1W` / `P1M` were used to bucket the trend line under the big number. Holistics MetricKpi compare uses period-over-period duration only; the embedded trend line is not configured. If you want the sparkline, switch the viz from `MetricKpi` to a chart variant that supports trend lines.
