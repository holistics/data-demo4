# FanServ Season Board design contract

- Status: direction approved
- Decision: Direction A — The Season Board
- Approved: 16 July 2026
- Requirements: `fanserv-season-board-design-brief.md.pdf`
- Data contract: `gamepulse-data-contract.md`

## Approved concept

> The dashboard is a broadcast media planner's Season Board, and every game is an evidence card, an on-air signal, or an opportunity card.

`Season Board` is the design concept, not replacement product copy. The dashboard title remains **Game Calendar** as required by the brief.

The concept treats time as one continuous planning surface:

```text
PAST GAMES                       TODAY                       FUTURE GAMES
Evidence                                                     Opportunity
Results and observed signals                                Forecast and modeled signals
Blue treatment                                              Green treatment
```

## Experience brief

### Audience and decision

The primary user is a media buyer or planner at a brand or agency. The intended decision is:

> Given my budget and flight window, which games should I buy inventory on?

The first public data release can identify opportunity candidates, but it cannot claim budget fit or availability until inventory and pricing facts are supplied.

### Delivery surface

- Customer-facing analytical dashboard.
- Desktop-first at a 1440px review viewport.
- Suitable for authenticated or embedded Holistics delivery.
- Calendar comprehension and visual impact take priority over generic chart selection.
- Native filters, stable sharing, keyboard access, and game-level drill remain non-negotiable.

### Success criteria

A buyer can:

1. see where high-GamePulse opportunity concentrates across the season;
2. move from season to month or day without losing context;
3. distinguish historical evidence from future opportunity immediately;
4. compare games without opening every detail view;
5. inspect one game's schedule, supply context, and GamePulse breakdown;
6. recognize unavailable or unsupported facts as absent rather than estimated.

## Narrative hierarchy

### 1. Command rail

The command rail establishes the active planning frame:

- `Game Calendar` title;
- search or searchable game/team picker;
- flight/date range;
- league and team filters;
- supply-team filter;
- month and day/list view choice;
- export where supported.

Use a dark green command surface with restrained contrast. It should feel like a planning console, not a decorative hero banner.

### 2. Season opportunity rail

A compact year-level strip answers “when should I look?” before the full calendar asks “which game?”

Each month has schema-backed slots for:

- game count;
- supply-affiliated game count;
- hot/average/low GamePulse distribution;
- highest and average supply-side GamePulse;
- future versus completed state.

The rail is not a row of generic KPIs. It is a navigational overview of concentration across time.

### 3. Calendar continuum

The primary month view is a seven-column programming grid. Today is the hinge between two information modes:

- completed games use evidence treatment;
- upcoming games use opportunity treatment;
- unknown-state games stay neutral;
- actual live state is reserved until the source provides authoritative status.

Month cells should remain readable when they contain multiple games. Compact cards show only the information needed to decide whether to inspect further.

### 4. Day/list board

The expanded list preserves the same order and language but provides more room for:

- full team names and logos;
- venue and broadcast placements;
- game result when complete;
- supply-team context;
- GamePulse score and band;
- compact labels from the GamePulse breakdown.

### 5. Game planning sheet

Selecting a game opens a dedicated detail surface. Before inventory data exists, call this **Game detail**, not Buy sheet.

The first source-backed version can show:

- schedule, teams, venue, result, and broadcasts;
- participating supply teams;
- one evaluation per focal team;
- score, band, labels, and model-component breakdown;
- perspective differences when both teams have evaluations.

The future commercial version may add forecast impressions, avails, price, CPM, delivered impressions, and revenue without changing the page's conceptual structure.

## Object map

| Analytical question | Data and grain | Season Board object | Why it fits | Lifecycle behavior |
|---|---|---|---|---|
| When does opportunity concentrate? | Game calendar summary by month | Season opportunity rail | A planner scans time before individual placements | Future months emphasize opportunity; past months become evidence |
| What games occur in my flight window? | One row per game | Programming grid | A schedule is the native planning object | Today divides evidence from opportunity |
| Which future game deserves attention? | Game plus supply-side GamePulse summary | Opportunity card | A compact candidate can be compared with neighboring games | Uses score and supply context; never claims availability |
| What happened in a completed game? | Completed game plus observed signals | Evidence card | The same event becomes proof rather than a bet | Result replaces kickoff emphasis; future-only claims disappear |
| What is happening now? | Authoritative live state, not yet sourced | On-air signal | Broadcast operations use explicit live indicators | Hidden until a reliable live source exists |
| Why is a GamePulse score high or low? | Game × focal team evaluation | Signal breakdown | Contribution rows explain the modeled signal | Labels and weights vary by league and perspective |
| What can FanServ potentially monetize? | Game × supply team | Supply affiliation marker | It identifies the commercial relationship without inventing avails | Can show zero, one, or two participating supply teams |
| Should I inspect this game further? | Game summary and GamePulse evaluation | Game planning sheet | A planning sheet is the natural handoff from scan to evaluation | Handles missing network, score, or second perspective explicitly |

## Card hierarchy

### Compact month card

Display in this order:

1. league and schedule state;
2. team matchup;
3. GamePulse signal or explicit unavailable state;
4. supply affiliation marker;
5. primary broadcast when available.

Use abbreviations where necessary, but preserve accessible names in labels or detail views. Do not place full model breakdowns, venue details, or multiple networks inside the compact card.

### Expanded day/list card

Display in this order:

1. date and Eastern Time schedule;
2. full matchup and result;
3. broadcast display;
4. supply context;
5. GamePulse score, band, and selected labels;
6. action to inspect game detail.

### GamePulse signal

Use the source's business bands:

- `Hot`: 70–100;
- `Average`: 40–69;
- `Low`: 1–39.

The signal must include its numeric value and label. Color and iconography are supporting cues, not the only encoding.

Do not expose an unlabeled singular score when both team perspectives exist. The calendar may later use **Highest supply-side GamePulse** if that rule is approved.

## Lifecycle states

| State | Current source support | Treatment |
|---|---|---|
| Upcoming | Derivable from future schedule with null points | Green opportunity card |
| Completed | Derivable when both point fields are present | Blue evidence card |
| Unknown | Required for incomplete or contradictory source data | Neutral card with explicit state |
| Rescheduled | Derivable only after schedule snapshots show a change | Amber operations stamp with original time |
| Live | Not authoritatively sourced | Designed but inactive |
| Cancelled/postponed | Not authoritatively sourced | Designed but inactive |
| No GamePulse evaluation | Supported | Neutral signal slot: `Not scored` |
| Multiple supply perspectives | Supported | Show perspective count; detail view exposes each evaluation |
| No broadcast | Supported | Use `Broadcast TBC`, not an empty gap |
| Empty day | Supported | Quiet grid cell; do not render a fake card |

## Visual system

### Palette

The brief's supplied palette is the dashboard-specific source of truth:

| Role | Color |
|---|---|
| Opportunity/action | `#00AB55` |
| Opportunity dark anchor | `#005249` |
| Opportunity tint | `#C8FACD` |
| Evidence/comparison | `#3366FF` |
| Evidence dark anchor | `#091A7A` |
| Evidence tint | `#D6E4FF` |
| Live/cancelled exception | Existing accessible danger red |
| Rescheduled/attention exception | Existing accessible warning amber |

Use green and blue as modes, not decoration: green means future opportunity; blue means historical evidence. Neutral surfaces carry shared schedule information.

### Materials

- Light planning-board surface for the dense calendar.
- Dark command rail for orientation and controls.
- Thin grid rules and quiet day cells.
- Cards use subtle elevation, one-pixel borders, and 8–12px radii.
- Reserve glow and continuous motion for verified live state.
- Do not use turf, goal, scoreboard bezel, betting slip, or financial-terminal materials.

### Typography

- Inter/Manrope system from the existing FanServ theme.
- Strong but compact page title.
- Tabular numerals for scores, dates, and GamePulse values.
- Uppercase micro-labels only for league, status, and compact operational labels.
- Minimum readable card text should remain 12px at the target desktop viewport.

## Interaction budget

Retain:

- native date, league, team, and supply filters;
- explicit cross-dataset filter mappings;
- month and day/list views through stable dashboard composition;
- single-game selection and dedicated detail;
- keyboard-visible focus and accessible names;
- native export when it preserves the active filter context.

Accept:

- crafted calendar cards will not behave like native chart marks;
- card hover can reveal affordance but not essential facts;
- a quick popover may preview a score, while full analysis remains in game detail.

Avoid:

- arbitrary client-side state that cannot survive sharing or refresh;
- hidden pagination as business selection;
- free-form cross-field search unless the platform can map it reliably;
- card clicks that change unrelated tabs or filters implicitly.

## Motion language

- The season rail settles left to right once, reflecting chronological scan.
- Calendar cards enter with a short, low-distance stagger within one block.
- Hover raises an interactive card slightly and strengthens its border.
- Verified live state may use one low-intensity pulse.
- Rescheduled state changes through a stamped label, not animated disruption.
- `prefers-reduced-motion` removes entrances, pulses, and transforms while retaining all visible states.

## Data and implementation boundaries

- Semantic layer owns grain, lifecycle, perspective, ranking, score bands, display labels, colors, and deterministic selection.
- Reusable blocks own compact card, expanded card, season rail, and GamePulse breakdown markup.
- Theme owns palette, typography, surfaces, focus, and resting materials.
- Dashboard page owns narrative composition, filter mappings, view structure, and selected-game flow.
- Unsupported commercial facts remain absent until their own source models exist.

## Concept gate

The Season Board passes the concept gate because:

1. it belongs to media planning rather than generic sports fandom;
2. the time continuum determines the full page structure;
3. every required question maps to a planning-board object;
4. evidence and opportunity become visually distinguishable without changing worlds;
5. the public GamePulse schema can populate the first version honestly;
6. future inventory and performance facts have prepared slots rather than fabricated values;
7. motion follows schedule and broadcast behavior rather than generic effects.

## Open decisions

The approved direction does not yet resolve:

1. the canonical one-card GamePulse perspective when both teams have evaluations;
2. whether every game involving a supply team is commercially relevant or only specific home/broadcast placements;
3. buyer-facing timezone beyond the source's Eastern Time convention;
4. whether non-supply teams remain context-only or filterable candidates.
