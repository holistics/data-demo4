# Leo Messi — Argentina career demo

Sports-analytics demo built on Lionel Messi's senior international career with Argentina
(207 caps, 125 goals, 17 Aug 2005 – 19 Jul 2026). Shows semantic modelling, metric
definitions and AI-readable field descriptions on a small, well-known dataset.

**Data source:** `demo_nam_leo_messi` (Postgres, schema `"public"."*"`, 7 tables). Never join
these models onto `demodb` or any other source.

**Naming prefix:** `messi_*` for every model, dataset and metric. The prefix is required, not
cosmetic: `public_matches` already exists elsewhere in the repo.

## Scope boundary

Keep every change inside `team-folders/Nam/LeoMessi/`. Do not touch `01 demo ecommerce/`,
`library/`, `Datasets Library/`, `clients/`, or the sibling `Laasie/` and `SCSI/` folders.

## Layout

| Path | Contents |
|---|---|
| `Models/` | 7 table models, one per source table, plus `messi_params` (metric-switcher param, no data) |
| `Datasets/messi_argentina.dataset.aml` | The dataset, relationships and all metrics |
| `Dashboards/messi_albiceleste.page.aml` | Five-chapter story dashboard (`HTMLLayout`) built from the "Messi · Albiceleste 2005–2026" HTML mockup |
| `Dashboards/messi.theme.aml` | Albiceleste theme: tokens, palette, Google Fonts and the shared `mx-*` CSS classes (hero, chapter heads, photo slots, footer) |

## Dashboard notes

- **`HTMLLayout`, not canvas.** Editorial content (hero, chapter heads, photo slots, footer) is
  plain HTML in `view: HTMLLayout`. Data blocks are placed with `<h-block name="…" />` inside a
  12-column CSS grid. It is one scrolling page with a sticky chapter bar (`#ch1`–`#ch5`).
  Native tabs are not possible, because a `TabLayout` tab must be a `CanvasLayout`.
- **Every block must be placed.** A block that has no `<h-block>` tag does not render. Each
  slot gets an explicit height, and the block fills it.
- **Bespoke cards are `MarkdownViz`:** KPI strips, World Cup road, hat-tricks, match tiles,
  finals, shootouts, awards and timeline. They have no frame (transparent `BlockTheme`,
  `hide_label`) and draw their own card.
  - Dimensions go in `rows:` and metrics in `values:`. A metric in `rows` fails with "Not expect
    a measure". In the template, read metrics with `values.`Label``.
  - Templates have no `{% if %}`. Colour by result through a CSS class taken from the value,
    e.g. `class="mx-pill {{ `Result`.raw }}"`. Each template carries its own `<style>`.
  - Row order comes from `SortSetting { key: '<field uname>' }`, so sorted fields need a `uname`.
- **Native blocks stay native:** stacked columns, coach table, match log, heatmap pivot,
  victims bar, goal climb, continents 100% bar, countries bar, and the metric-switcher chart.
- **Filters are chapter-local** through `explicit_interactions`. A new block does not respond to
  filters until you add it to the right `FilterInteraction.to` list. `f3_type` (goal type)
  targets only goal-grain blocks.
- **Static figures:** the hero stats and the Assists card (65) are hard-coded. Assists exist
  only in `messi_career_summary` as text.
- **Still not possible:** reference lines at 55 and 100 on the goal-climb chart (the block
  description gives them), and milestone markers on the year chart.
- **Photo / GIF slots** are `.mx-media` placeholders in the layout HTML. Add an `<img src="…">`
  to use a real image.
- **The page is generated** by `tools/build_messi_dashboard.py`. Regenerate with
  `python3 team-folders/Nam/LeoMessi/tools/build_messi_dashboard.py team-folders/Nam/LeoMessi/Dashboards/messi_albiceleste.page.aml`,
  then validate. Edit the script rather than the AML, or the next regeneration will overwrite
  your edits. Close the dashboard in Studio before editing this
  file, because the syncer and Studio both write it (see `../Laasie/AGENTS.md`).

## Modelling rules

1. **`messi_matches` is the central fact** (one row per cap). `messi_goals` is finer (one row per
   goal), so caps must be counted distinctly — `messi_caps` does this.
2. **One active path from goals to tournaments:** `goals > matches > tournaments`. The
   `goals.tournament_id` relationship is declared INACTIVE; activating it makes the path ambiguous.
3. **Result convention:** `result` / `result_label` is the 90/120-minute result, so a shootout is
   a draw (134 W / 43 D / 30 L). `result_incl_shootout` resolves penalties.
4. **Non-additive columns:** `messi_tournaments.messi_apps / messi_goals / messi_penalty_goals` are
   pre-aggregated per tournament. `messi_career_summary` is a text key-value table, and it is the
   only place assists exist.
5. **Trophies:** `counts_as_trophy` includes the 2019 Superclásico friendly, so it gives 5 senior
   trophies. Use `messi_major_senior_trophies` for the "4 senior trophies" headline.

## Reconciliation figures

The metrics were checked against `messi_career_summary`, and these totals must still hold after
any edit: caps 207, wins 134, draws 43, losses 30, goals 125, penalty goals 25, hat-tricks 11,
major senior trophies 4, individual awards 15, tournaments 20.

## AQL gotchas found while building this

- Boolean fields: `field is true` / `is false`, not `== true`.
- Null checks: `field is not null`. There is no `is_not_null()` function.
- `fetch_sample_data` is disabled on this tenant. Profile data with `execute_aql` instead.

## Validate

```
holistics aml validate team-folders/Nam/LeoMessi/
```
