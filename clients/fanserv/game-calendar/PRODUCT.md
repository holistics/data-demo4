# FanServ Game Calendar POC

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

The primary user is a media buyer deciding which games or time periods may be relevant for advertising. Chinh is the internal reviewer. Alejandro is the customer stakeholder who decides whether the workflow is a viable direction for FanServ.

## Product Purpose

Determine whether Holistics can deliver a FanServ-branded Game Calendar that gives a buyer a clear calendar-browsing and game-detail workflow with less bespoke frontend development. The POC succeeds when Alejandro accepts the direction and understands the workflow, reusable implementation approach, platform limits, and mock-to-production data boundary.

## Operating Context

The approved composition is a desktop-first 1440px board with a command and filter rail, full-width month calendar, and persistent selected-game detail below it. The self-contained HTML/CSS artifact passed internal and customer visual review before the mock-data Holistics sample was authorised.

## Capabilities and Constraints

- Represent upcoming, completed, and unknown lifecycle states; null GamePulse scores render as `Not scored`.
- Show empty days, multi-game overflow, one selected game, and persistent matching detail.
- The static artifact demonstrates the visual contract, not supported Holistics interaction.
- The POC architecture uses HTML Layout, Dynamic Content, native filters, and Game ID drill selection with the validated mock data layer.
- Keep essential facts visible without hover or motion and provide complete reduced-motion behavior.
- Do not claim inventory, availability, pricing, affordability, forecast impressions, or authoritative live/cancelled status.
- Production integration, mobile/tablet layouts, Reporting publication, Holistics AI, and full GamePulse parity are outside scope.
- Development implementation and synchronization were authorised on 2026-08-14. Deployment, Reporting publication, push, pull request, and customer sharing still require separate approvals.

## Brand Commitments

FanServ's `FDS - Web Components` Figma file controls component styling and spacing. The Season Board design contract and Texas Rangers GamePulse capture control structure and information hierarchy. Existing FanServ design and theme tokens fill visual gaps. The World Cup dashboard supplies motion grammar only, not interaction proof.

## Evidence on Hand

- `fanserv-html-layout-poc-plan.md`
- `../CONTEXT.md`
- `../fanserv-season-board-design-contract.md`
- `../gamepulse-data-contract.md`
- `../DESIGN.md`
- `fanserv-game-calendar-html-prototype.html`

The available Figma captures show brand direction and named components but do not provide complete component dimensions, tokens, or specifications. Future work must not invent unavailable Figma details.

## Product Principles

1. Make the buyer's calendar-to-game-detail workflow immediately understandable.
2. Separate proven platform behavior from static visual intent.
3. Preserve data meaning and state uncertainty instead of fabricating precision.
4. Use FanServ evidence according to its recorded authority.
5. Stop at each internal, customer, and side-effect approval gate.

## Accessibility & Inclusion

Use semantic controls and labels, keyboard-visible focus, sufficient contrast, and a complete `prefers-reduced-motion` fallback. Essential content must remain visible without animation or hover.
