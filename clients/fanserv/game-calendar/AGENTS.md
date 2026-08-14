# FanServ Game Calendar POC

Read `../AGENTS.md`, `fanserv-html-layout-poc-plan.md`, `../CONTEXT.md`,
`../fanserv-season-board-design-contract.md`, and `../gamepulse-data-contract.md`
before changing this POC.

## Outcome and scope

Build a desktop-first 1440px Game Calendar / Season Board for a media buyer. The
approved composition is one command/filter rail, a full-width month calendar, and a
persistent selected-game detail panel below it. Preserve the CSV-backed mock models,
datasets, and source contracts; production integration, mobile/tablet layouts,
Reporting publication, and full GamePulse parity are outside this POC.

## Design and data authority

Use sources only for the responsibility they own, in this order:

1. FanServ's `FDS - Web Components` Figma file controls components and spacing.
2. `../fanserv-season-board-design-contract.md` and the captured Texas Rangers
   GamePulse calendar control structure and information hierarchy.
3. `../design.md` and `../fanserv.theme.aml` fill visual-token gaps.
4. The World Cup dashboard supplies motion grammar, not interaction proof.
5. This folder's CSV files, AML models/datasets, and `../gamepulse-data-contract.md`
   control data meaning and supported claims.

## Implementation boundary

- Build the presentation layer with `HTMLLayout`; mount native filters and
  query-backed Dynamic Content with `<h-block>`.
- Select calendar games with `<h-drill row="0" value="{{ Game ID.raw }}">`, cross-filter
  detail blocks on the same Game ID field, and style selected cards with
  `.h-drill-selected`.
- Use HTML and CSS only inside HTML Layout and Dynamic Content. Keep essential facts
  visible without hover or motion, retain keyboard-visible focus, and provide complete
  `prefers-reduced-motion` fallbacks.
- Represent only `upcoming`, `completed`, and `unknown` lifecycle states. Render null
  GamePulse scores as `Not scored`. Never claim inventory, availability, pricing,
  affordability, forecast impressions, or authoritative live/cancelled status.
- Keep the POC in Development. Do not sync, publish, deploy, push, or open a PR without
  explicit authority for that side effect.

## Validate and review

After every AML edit, run this from the repository root with the edited path:

```sh
holistics aml validate clients/fanserv/game-calendar/<changed-file>.aml
```

Before review, validate the complete FanServ AML surface together:

```sh
holistics aml validate clients/fanserv/*.aml clients/fanserv/game-calendar/*.aml
```

After validation and explicit sync authority, review the Development-branch dashboard
at a 1440px viewport. Verify native filters; empty days; multi-game overflow;
upcoming, completed, unknown, and `Not scored` states; game selection and persistent
detail; keyboard-visible focus; and reduced-motion rendering. Record the branch and
viewport with the review evidence.

This POC does not use Holistics AI. Keep `settings/ai/context.aml` unchanged unless the
operator separately authorises tenant-wide AI routing.
