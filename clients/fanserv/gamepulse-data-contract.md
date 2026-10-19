# FanServ GamePulse data contract

Status: draft for source and semantic-layer preparation  
Observed: 16 July 2026  
Source: <https://fanserv.com/gamepulse>

## Decision summary

1. Use the schedule game UUID as the durable game key. It matched all 189 sampled MLB schedule and GamePulse records.
2. Keep a game separate from its GamePulse evaluations. The evaluation grain is **game × focal team × extraction time**; the same NHL game returned scores of 76 and 77 from its two team perspectives.
3. Keep broadcast placements separate from games because a game can have multiple network, medium, locale, and channel combinations.
4. Snapshot schedules and GamePulse evaluations. Broadcasts, scheduled times, team records, component contributions, and final scores can change.
5. Do not treat GamePulse as an impression forecast. The public source describes it as a directional 1–100 modeled score that may affect impressions.
6. Do not add inventory, price, forecast impressions, delivered impressions, or revenue to the first schema. The public endpoints do not expose them.
7. Build two semantic datasets for one dashboard: a one-row-per-game calendar dataset and a team-perspective GamePulse dataset. This prevents hidden fan-out and preserves the score's actual meaning.

## Public source inventory

| Source | Method | Observed grain | Public-page cache | Notes |
|---|---|---:|---:|---|
| `/api/schedule/leagues` | `GET` | One row per league | 24 hours | Returns 12 leagues. GamePulse scoring is currently used by the page for MLB, NBA, and NHL only. |
| `/api/schedule/today` | `GET` | One row per game on the current ET date | 5 minutes | Returns canonical game, league, team, score, and broadcast objects. |
| `/api/schedule/games?teamAlias=&league=&status=` | `GET` | One row per game involving the requested team | 5 minutes | `status` values used by the page are `scheduled`, `closed`, and `all`. The response itself has no status field. |
| `/api/gamepulse/scores` | `POST {"teamName": ...}` | One MLB evaluation per game for the focal team | 15 minutes | Returns current summary fields plus all game evaluations for the requested team. |
| `/api/gamepulse/nba/scores` | `POST {"teamName": ...}` | One NBA evaluation per game for the focal team | 15 minutes | Same response family; the sampled team had no current games. |
| `/api/gamepulse/nhl/scores` | `POST {"teamName": ...}` | One NHL evaluation per game for the focal team | 15 minutes | Same response family, with league-specific component values and labels. |
| Public frontend team registry | JavaScript bundle | One row per team | Deployment-dependent | Contains 92 MLB/NBA/NHL teams and 25 supply-team flags, plus slugs, colors, venue, and request aliases. It is not a stable production API. |

The league-wide schedule endpoint reported the full count but returned only 200 rows. `page`, `offset`, and `limit` did not change the result. A complete pull must therefore query by team and deduplicate by game UUID unless FanServ exposes a supported pagination or bulk endpoint.

## Observed source schemas

### League

Grain: one row per league.

| Field | Type | Meaning |
|---|---|---|
| `uuid` | text | Durable league key. |
| `id` | number | Source-local numeric ID. |
| `alias` | text | Short league code such as `MLB`, `NBA`, or `NHL`. |
| `name` | text | Full league name. |
| `logo_url` | text | Public league logo URL. |
| `has_teams` | boolean | Whether the source represents participants as teams. |

Observed league aliases: `MLB`, `MLS`, `NASCAR`, `NBA`, `NCAAFB`, `NCAAM`, `NCAAW`, `NFL`, `NHL`, `NWSL`, `PGA`, and `WNBA`.

### Team

Grain: one row per team. Use `team_uuid`, not alias, as the key because aliases collide across leagues.

| Field | Type | Source | Meaning |
|---|---|---|---|
| `team_uuid` | text | Schedule API | Durable team key. |
| `source_id` | number | Today endpoint when present | Source-local numeric ID. |
| `league_uuid` | text | Derived from game | Parent league. |
| `alias` | text | Schedule API | Source team code. |
| `name` | text | Schedule API | Team nickname. |
| `market` | text | Schedule API | Team market or location. |
| `full_name` | text | Schedule API | Canonical display name. |
| `logo_url` | text | Schedule API | Public team logo URL. |
| `slug` | text | Frontend registry | GamePulse team-page slug. |
| `request_alias` | text | Frontend registry | Lower-case alias accepted by the schedule endpoint. |
| `primary_color` | text | Frontend registry | Team presentation color. |
| `secondary_color` | text | Frontend registry | Team presentation color. |
| `home_venue` | text | Frontend registry | Fallback venue metadata. |
| `is_supply_team` | boolean | Frontend registry | FanServ is authorized to monetize supply for this team. |

Production ingestion should request a stable team/supply endpoint from FanServ. Parsing the minified frontend bundle is acceptable for a prototype seed, but not as a durable contract.

### Game schedule snapshot

Source grain: one row per game returned by a pull. Warehouse grain: **game × extraction batch**.

| Field | Type | Meaning |
|---|---|---|
| `uuid` | text | Durable game key. |
| `scheduled` | datetime | Scheduled start in UTC. |
| `league.uuid` | text | League key. |
| `home_team.uuid` | text | Home-team key. |
| `away_team.uuid` | text | Away-team key. |
| `home_points` | number, nullable | Home score when supplied. |
| `away_points` | number, nullable | Away score when supplied. |
| `venue` | text, nullable | Scheduled venue. The today endpoint may omit it. |
| `broadcast` | array, nullable | Zero or more broadcast placements. |

The response does not expose a lifecycle status. The website treats games with both point fields populated as completed and games with null points as upcoming. That is not enough to distinguish live, delayed, rescheduled, postponed, or cancelled games.

### Broadcast placement

Grain: one broadcast placement within one game snapshot.

| Field | Type | Meaning |
|---|---|---|
| `network` | text | Network or service name. |
| `type` | text, nullable | Observed values include `TV` and `Internet`. |
| `locale` | text, nullable | Observed values include `Home`, `Away`, and `National`. |
| `channel` | text, nullable | Provider channel identifier. |

MLB samples exposed only `network`. NHL samples exposed up to five placements and could include all four fields. The schema must tolerate both shapes.

### GamePulse response summary

Grain: one current response for one focal team. These fields are derivable from the returned evaluations and should not be stored as independent facts.

| Field | Type | Meaning |
|---|---|---|
| `team` | text | Requested focal-team name. |
| `league` | text | Focal-team league. |
| `totalGames` | number | Number of returned evaluations. |
| `averageScore` | number | Average GamePulse score. |
| `distribution.high` | number | Count of scores at least 70. |
| `distribution.medium` | number | Count of scores from 40 to 69. |
| `distribution.low` | number | Count of scores below 40. |
| `topGames` | array | Derived top-five subset of `games`; do not ingest separately. |

### GamePulse evaluation snapshot

Source grain: one game from one requested focal team's perspective. Warehouse grain: **game × focal team × extraction batch**.

| Field | Type | Meaning |
|---|---|---|
| `uuid` | text | Game UUID; joins directly to the schedule game. |
| `date` | date | Eastern Time game date used by the scoring response. |
| `status` | text | Returned as `unknown` in the sampled MLB and NHL responses; do not use for lifecycle logic. |
| `opponent` | text | Opponent display name relative to the focal team. |
| `home` | boolean | Whether the focal team is the home team. |
| `time` | text | Eastern Time display value. Use schedule UTC for computation. |
| `broadcast` | text | Display network selected by the scoring response. |
| `national` | boolean | Source national flag. Preserve but verify before treating it as authoritative. |
| `score` | number | Final 1–100 GamePulse score. |
| `labels` | array of text | Derived labels such as `Prime Time`, `Divisional`, or `Top Matchup`. |

Observed breakdown fields:

| Field | Type | Meaning |
|---|---|---|
| `baseline` | number | League/model baseline contribution. |
| `seasonType` | number | Season-type contribution. |
| `seasonTypeLabel` | text | Examples include regular season, spring training, and playoffs. |
| `primeBucket` | number | Time-bucket contribution. |
| `primeBucketLabel` | text | Human-readable time bucket. |
| `dayOfWeek` | number | Day-of-week contribution. |
| `dayOfWeekLabel` | text | Human-readable day. |
| `networkExposure` | number | Network-exposure contribution. |
| `networkExposureLabel` | text | Network or local/RSN label. |
| `soloTimeSlot` | number | Solo-time-slot contribution. |
| `rivalry` | number | Rivalry or matchup-structure contribution. |
| `rivalryLabel` | text, nullable | Human-readable rivalry or structure label. |
| `teamPerformance` | number | Legacy or combined team-performance contribution. |
| `teamAdj` | number | Focal-team quality adjustment. |
| `opponentAdj` | number | Opponent-quality or competitiveness adjustment. |
| `headToHead` | number | Head-to-head or team-ranking contribution, depending on league. |
| `seasonProgress` | number | Season-progress contribution. |
| `rawTotal` | number | Raw component total before final scoring adjustment. |
| `teamRecord` | text | Sport-specific focal-team record display. |
| `opponentRecord` | text | Sport-specific opponent record display. |

Component names are structurally consistent across sampled MLB and NHL responses, but their business meaning and weights vary by league. Keep the source columns; use league-aware labels in the semantic layer.

## Proposed physical and semantic models

### `fs_leagues`

Grain: one row per league.  
Primary key: `league_uuid`.

Store the observed league fields plus:

- `is_schedule_supported`
- `is_gamepulse_supported`
- `first_observed_at`
- `last_observed_at`

### `fs_teams`

Grain: one row per team.  
Primary key: `team_uuid`.  
Foreign key: `league_uuid > fs_leagues.league_uuid`.

Use schedule data as the identity source. Enrich it with the frontend registry only for `slug`, request alias, colors, fallback venue, and supply-team status.

### `fs_game_schedule_snapshots`

Grain: one row per game per extraction batch.  
Primary key: `(game_uuid, extracted_at)`.

Retain raw scheduling and score fields so schedule changes can be reconstructed. Add `source_query_team_uuid` for lineage because complete extraction currently requires team-level calls.

### `fs_games`

Grain: one current row per game.  
Primary key: `game_uuid`.

Derive from schedule snapshots:

- current and first-observed scheduled timestamps;
- `schedule_changed` and original scheduled timestamp;
- current scores;
- conservative lifecycle: `completed`, `upcoming`, or `unknown`;
- first/last observed timestamps;
- home and away role keys;
- calendar date parts in the dashboard timezone.

Do not derive `live`, `cancelled`, or `rescheduled` from missing evidence. `rescheduled` becomes supportable only after at least two snapshots show a changed scheduled timestamp.

### `fs_game_broadcast_snapshots`

Grain: one broadcast placement per game per extraction batch.  
Primary key: `(game_uuid, extracted_at, broadcast_ordinal)`.

### `fs_game_broadcast_summary`

Grain: one current row per game.  
Primary key: `game_uuid`.

Provide card-safe fields without multiplying game rows:

- `broadcast_display`
- `network_count`
- `has_national_placement`
- `has_home_placement`
- `has_away_placement`
- `has_streaming_placement`

### `fs_gamepulse_evaluation_snapshots`

Grain: one game per focal team per extraction batch.  
Primary key: `(game_uuid, focal_team_uuid, extracted_at)`.

Store the score, labels, records, and all component values. Resolve `focal_team_uuid` from the requested team and derive `opponent_team_uuid` from the game roles rather than matching the response's opponent text.

### `fs_gamepulse_latest`

Grain: one current evaluation per game per focal team.  
Primary key: `(game_uuid, focal_team_uuid)`.

Add presentation drivers:

- `pulse_band`: `Hot` for 70+, `Average` for 40–69, `Low` below 40;
- stable pulse color and intensity class;
- focal-team location label;
- component and record display labels;
- deterministic evaluation rank within a game.

### `fs_game_supply_context`

Grain: one game per participating supply team.  
Primary key: `(game_uuid, focal_team_uuid)`.

Join games to participating teams where `is_supply_team = true`, then attach that team's latest GamePulse evaluation. This indicates a potential supply path, not available inventory.

### `fs_game_calendar`

Grain: one current row per game.  
Primary key: `game_uuid`.

This is the card-safe presentation model. Include:

- current game, league, home-team, away-team, schedule, result, and lifecycle fields;
- broadcast summary fields;
- supply-team count and supply-team display;
- minimum, maximum, average, and spread of supply-team GamePulse scores;
- explicit `has_score_perspective_variance`;
- evidence/opportunity state based on conservative lifecycle and schedule time.

Do not expose an unlabeled singular `game_pulse_score` until FanServ chooses a canonical perspective rule. A defensible exploration default is `max_supply_pulse_score`, clearly labeled “Highest supply-side GamePulse”, but this remains a business decision.

## Proposed Holistics datasets

### `fanserv_game_calendar`

Purpose: season rail, month/week calendar, game cards, league/team filters, and schedule state.

Models:

- `fs_game_calendar`
- `fs_leagues`
- `fs_home_teams` extending `fs_teams`
- `fs_away_teams` extending `fs_teams`

Relationships:

```text
fs_game_calendar.league_uuid > fs_leagues.league_uuid
fs_game_calendar.home_team_uuid > fs_home_teams.team_uuid
fs_game_calendar.away_team_uuid > fs_away_teams.team_uuid
```

Core metrics:

- distinct games;
- upcoming, completed, changed-schedule, and unknown-state games;
- games with FanServ supply affiliation;
- average and maximum supply-side GamePulse, explicitly named;
- hot/average/low opportunity-candidate counts;
- national and streaming broadcast counts.

### `fanserv_gamepulse`

Purpose: focal-team GamePulse analysis, game buy-sheet preparation, component breakdown, and score evolution.

Models:

- `fs_gamepulse_latest`
- `fs_games`
- `fs_leagues`
- `fs_focal_teams` extending `fs_teams`
- `fs_home_teams` extending `fs_teams`
- `fs_away_teams` extending `fs_teams`

Relationships:

```text
fs_gamepulse_latest.game_uuid > fs_games.game_uuid
fs_gamepulse_latest.focal_team_uuid > fs_focal_teams.team_uuid
fs_games.league_uuid > fs_leagues.league_uuid
fs_games.home_team_uuid > fs_home_teams.team_uuid
fs_games.away_team_uuid > fs_away_teams.team_uuid
```

Core metrics:

- evaluations and distinct games;
- average, minimum, maximum, and median GamePulse score;
- hot/average/low evaluation counts;
- average contribution by component;
- score change since prior extraction;
- score spread between participating-team perspectives.

Using two datasets keeps the calendar at one row per game while preserving the team-relative scoring grain. Dashboard filters can map league, team, game UUID, and schedule date explicitly between the two datasets.

## Extraction plan

1. Pull leagues daily.
2. Pull `/api/schedule/today` every five minutes for near-term freshness.
3. Pull each supported team's `status=all` schedule daily and deduplicate by game UUID. Do not rely on the truncated league-wide response.
4. Refresh upcoming and recently completed team schedules every 15 minutes if the prototype needs schedule/result freshness.
5. Pull GamePulse by focal team. Start with the 25 observed supply teams; pull all 92 teams only if comparison across all teams is required.
6. Stamp every raw row with `extracted_at`, `extraction_batch_id`, endpoint, and requested focal/source team.
7. Retain raw JSON for replay while publishing typed current and snapshot tables.
8. Treat public endpoints as a prototype contract. Before production, confirm permission, rate limits, versioning, and supported bulk endpoints with FanServ.

## Data-quality tests

- Game, team, and league UUIDs are non-null and valid UUIDs.
- A game has different home and away team UUIDs.
- Home and away teams belong to the game's league.
- Team-level schedule pulls deduplicate to one game per UUID per extraction batch.
- Every GamePulse evaluation resolves to a schedule game and focal team.
- Each `(game_uuid, focal_team_uuid, extraction_batch_id)` is unique.
- GamePulse scores are between 1 and 100 when present.
- `pulse_band` thresholds reconcile to the API summary distribution.
- Completed games have both scores; null or partial scores remain `unknown` rather than being labeled live.
- Broadcast parsing tolerates null, empty, network-only, and multi-placement arrays.
- Latest models choose rows deterministically by extraction timestamp and batch ID.

## Missing contracts required for the full brief

The public source does not currently support these required planning facts:

- forecast impressions;
- delivered impressions;
- revenue;
- inventory units or avails;
- price, CPM, or package cost;
- booking or reservation state;
- live period and clock;
- authoritative live, postponed, cancelled, or rescheduled status;
- GamePulse model version and score-effective timestamp;
- a stable team/supply registry endpoint.

Add these later as separate facts at their natural grains. In particular, inventory and performance should not be columns on `fs_games`: one game can have multiple supply owners, products, placements, price points, campaigns, and delivery observations.

## Decisions still needed

1. Which focal-team score should a one-card-per-game calendar emphasize when both teams have evaluations?
2. Does `is_supply_team` mean all of that team's games are potential FanServ supply, or only home games and specific broadcast placements?
3. Which timezone should control buyer-facing calendar dates when the buyer is not in Eastern Time?
4. How long should schedule and GamePulse snapshots be retained?
5. Should non-supply teams appear as context only, or as filterable opportunity candidates?
