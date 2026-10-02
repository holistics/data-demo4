# FanServ Game Calendar HTML Layout POC plan

Status: Phase 2 HTML Layout sample implemented and locally validated; awaiting Development synchronization and browser review on 2026-08-14
Logseq task: `3dcaa582-c6d5-4dc6-a3f4-509888612f78`
Planning thread: <https://ampcode.com/threads/T-019fef53-3bab-7379-984c-b87ee56dc0c1>
Implementation thread: <https://ampcode.com/threads/T-019feff6-e12f-732a-9202-9de9822da859>
Ultra review: <https://ampcode.com/threads/T-019ff086-4f98-713b-a9fc-403311dee72a>

## Outcome

Determine whether Holistics can deliver a FanServ-branded Game Calendar with the calendar-browsing and game-detail experience needed by a media buyer, the visual quality implied by FanServ's design system and the World Cup dashboard, and less bespoke frontend work.

The POC succeeds when Alejandro accepts it as a viable direction and can understand:

- the buyer workflow;
- the reusable HTML Layout and Dynamic Content approach;
- supported interactions and platform limits;
- the mock-data and production-data boundary;
- how FanServ can adapt the package in its own tenant.

## Scope

Build one integrated, desktop-first board at 1440px with:

1. a command and filter rail;
2. a full-width month calendar;
3. a persistent selected-game detail section beneath the calendar in a horizontal three-column layout.

The season opportunity rail was removed during internal review and is not part of the approved composition.

Do not rebuild GamePulse's list or today's-games views. Ask Alejandro whether the integrated calendar-and-detail buyer flow proves the direction and whether another buyer workflow is essential.

## Non-goals

- Production schema integration or a zero-change production install.
- Mobile or tablet composition.
- Reporting publication or public dashboard access.
- Holistics AI or `settings/ai/context.aml` changes.
- JavaScript inside HTML Layout or Dynamic Content.
- Inventory, availability, pricing, affordability, forecast-impression, or authoritative live/cancelled claims.
- Exact reproduction of every GamePulse interaction.

## Sources and precedence

Use each source for the responsibility it actually owns:

1. FanServ's `FDS - Web Components` Figma file controls component styling, controls, and spacing. It is a general design system, not a finished calendar design.
2. The FanServ Season Board contract and Texas Rangers GamePulse calendar control calendar structure and information hierarchy.
3. The existing FanServ tokens fill gaps that Figma does not specify.
4. The World Cup dashboard supplies the motion grammar and proof of custom HTML/CSS presentation, not reusable football motifs or proof of HTML Layout interaction.
5. Existing mock models, datasets, CSV data, data contracts, and validated query behavior remain authoritative for the POC data layer.

## Architecture

- Build the new presentation layer from scratch with `HTMLLayout`.
- Mount native filters and query-backed Dynamic Content blocks with `<h-block>`.
- Use `<h-drill row="0" value="{{ Game ID.raw }}">` on calendar cards to cross-filter blocks containing the same Game ID field.
- Use `.h-drill-selected` for the selected-card state.
- Keep the existing validated mock data, models, datasets, and contracts.
- Inventory the old Canvas POC before selectively reusing isolated HTML/CSS components.
- Do not carry Canvas positioning or Canvas-only dependencies into the new page.
- Use CSS only for presentation and motion.

## Worktree and branch

Continue in:

```text
/Users/lelouvincx/Developer/holistics/presales/demo4/.amp/worktrees/fanserv-html-layout
```

The worktree branch is `plan/fanserv-html-layout`, based on `dashboard/fanserv-game-calendar-data`.

Before implementation:

1. Bring the branch up to current `master` without modifying the dirty main checkout.
2. Preserve the validated data assets and contracts.
3. Inventory reusable presentation components.
4. Exclude the old Canvas customer page and disposable runtime harness from the final implementation branch after useful components have been captured. Their history remains on the source branch.

## Phase 0 — Make the workspace safe for local agents

Update `clients/fanserv/AGENTS.md` to distinguish:

- the existing finance-backed Stadium demo;
- the CSV-backed Game Calendar POC.

Add `clients/fanserv/game-calendar/AGENTS.md` with:

- POC outcome and scope boundary;
- authoritative design and data references;
- HTML Layout, Dynamic Content, and `<h-drill>` architecture;
- no-JavaScript and data-claim guardrails;
- desktop-only target;
- exact AML validation and browser-review procedure;
- the explicit decision not to change `settings/ai/context.aml` because the POC does not use Holistics AI.

Keep the parent file short. Put Game Calendar-specific operating instructions in the child file.

## Phase 1 — Design before Holistics implementation

### 1. Inventory in parallel

Use two independent, read-only subagents during the design phase.

#### Old POC component inventory

Inspect the old Canvas customer page and runtime harness. Return a reuse matrix for:

- calendar scaffold;
- game card;
- overflow state;
- selected state;
- selected-day or focus content;
- persistent game detail;
- motion and reduced-motion rules.

For each component, cite its source and classify it as `reuse`, `adapt`, or `rewrite`. Do not edit files.

#### Visual and motion evidence review

Compare:

- FanServ Figma components;
- the Texas Rangers GamePulse calendar;
- the Season Board contract;
- the World Cup dashboard's block-level CSS motion.

Return a compact visual contract covering component precedence, hierarchy, spacing, states, and motion. Do not invent customer scope or edit files.

The parent agent synthesizes both reports and owns the design.

### 2. Build the review artifact

Create one self-contained HTML file with embedded CSS and representative mock data. The design must show:

- upcoming games;
- completed games;
- unknown state;
- `Not scored`;
- empty days;
- multi-game overflow;
- selected-game state and persistent detail.

The HTML prototype is the visual review artifact. It is not evidence that Holistics supports the proposed interaction.

### 3. Apply the FanServ motion grammar

“Motion rich” means purposeful choreography rather than constant movement:

- settle the command rail;
- stage calendar-card entrances by calendar sequence;
- use material-specific transitions;
- give cards clear hover, press, and selected feedback;
- settle the persistent detail section after the calendar and transition its interactive states;
- provide complete `prefers-reduced-motion` fallbacks.

Do not add continuous ambient motion. The source has no authoritative live state.

### 4. Internal review gate

Chinh accepted the no-rail composition, the “Choose a game, then inspect its signal” copy, and the full-width calendar with detail below during the review session. Chinh must still explicitly approve the final Ultra-reviewed artifact before it is shared externally. Hung Do may provide an optional design review at Chinh's discretion.

Do not deploy with `proto` before Chinh approves the artifact.

### Phase 0/1 outcome — 2026-08-11

- Merged current `master` into `plan/fanserv-html-layout` without changing the dirty main checkout or rewriting history.
- Scoped the operating guidance so the finance-backed Stadium demo and CSV-backed Game Calendar POC have separate data, claim, implementation, and validation boundaries.
- Inventoried the old POC and visual/motion evidence independently. Adapt the seven-column calendar scaffold, card hierarchy, focus treatment, and persistent detail hierarchy; rewrite the overlapping Canvas composition and do not treat runtime harness behavior as platform support.
- Built `fanserv-game-calendar-html-prototype.html` as a self-contained HTML/CSS review artifact with the official light-background FanServ wordmark, 42 calendar cells, 15 representative game cards, empty and overflow days, all approved lifecycle states, one selected HOU at TEX game with matching persistent detail, visible focus, and a complete reduced-motion fallback.
- Removed the season opportunity rail. The accepted composition is the command rail, a full-width calendar, and selected-game detail below in three columns.
- Applied the Ultra review fixes: removed invalid ARIA grid roles and obsolete season-rail CSS, changed the detail container to a section, and raised the completed-card `Not scored` and out-of-month date contrast to 7.44:1 and 4.67:1.
- Validated at 1440×1100 and 1280×900 with no horizontal overflow, containment failures, duplicate IDs, invalid grid roles, or card overflow. A 208-element contrast scan and a 25-element reduced-motion check had zero failures; `git diff --check` and SVG validation passed. The final review capture is `.amp/in/artifacts/fanserv/fanserv-game-calendar-ultra-reviewed-final.png`.
- Made no AML, Holistics AI, synchronization, deployment, publication, push, pull-request, or customer-facing change.
- The deliverables remain uncommitted on `plan/fanserv-html-layout`.

Next action: Chinh reviews the static artifact and either approves it for a separately authorised `proto` deployment or returns specific design changes. Approval does not authorise Phase 2 or customer sharing.

### 5. Customer design and scope gate

After approval, deploy the self-contained HTML with `proto`:

- use password access;
- keep the password outside Git and share it separately;
- remember that deployment pushes an image and opens a PR in `holistics/prototypes-deploy`;
- obtain confirmation immediately before this external side effect;
- remove the site after 30 days unless the review is still active.

Ask Alejandro whether the integrated calendar-and-detail buyer flow proves the direction and whether another buyer workflow is essential. Positive visual feedback alone is not scope confirmation.

Stop before Phase 2 until Alejandro explicitly confirms the buyer workflow.

## Phase 2 — Build the Holistics feasibility POC

After customer scope confirmation:

1. Translate the approved composition into a new HTML Layout dashboard.
2. Mount native filters and Dynamic Content blocks through `<h-block>`.
3. Implement Game ID selection with `<h-drill>`.
4. Cross-filter the persistent detail block on the same Game ID field.
5. Reuse approved old HTML/CSS components selectively.
6. Bind the existing validated models and datasets.
7. Preserve all source and claim guardrails.
8. Keep the dashboard in Development.

The implementation is feasible only when:

- HTML Layout renders correctly at 1440px;
- native filters work;
- `<h-drill>` selects a game and cross-filters detail;
- all representative states from Phase 1 render correctly;
- CSS motion works and reduced-motion behavior removes non-essential movement;
- AML validation passes;
- browser review passes.

Demonstrate the working POC through a call or recording. Do not publish to Reporting without separate approval.

## Phase 3 — Freeze and hand off

After the working POC is accepted:

- freeze the approved static HTML as the visual contract;
- treat validated AML as the implementation source of truth;
- do not maintain the prototype and AML as two live implementations;
- prepare a ZIP archive for Alejandro.

The exact ZIP contents are deliberately deferred until the review shows what is useful. The portability promise is limited: the package must run with its included mock data, and FanServ must adapt semantic mappings for production data.

## Validation

The implementation thread must use the Holistics CLI authenticated to `demo4.holistics.io` and run targeted AML validation after every AML edit. Before review, validate all changed FanServ AML together and inspect the rendered dashboard in the browser.

Do not start code synchronization, publish to Reporting, deploy with `proto`, push a branch, or open a pull request without the authority required for that side effect.

## Timing

Phase 0 and Phase 1 are complete. The remaining work is not urgent.

- Chinh review and any separately authorised `proto` deployment: up to one working day, excluding review wait time.
- Pause for Alejandro's response.
- HTML Layout implementation and validation: two to three working days after explicit scope confirmation.

## Fresh-thread pickup

The next thread should begin in this worktree, read this plan and the canonical Logseq task, and start at Chinh's final review gate; it must not repeat Phase 0 or Phase 1. If Chinh requests revisions, update and revalidate only the static artifact. If Chinh explicitly authorises `proto`, reconfirm the external side effect immediately before deployment. Stop again at Alejandro's scope gate before AML implementation.
