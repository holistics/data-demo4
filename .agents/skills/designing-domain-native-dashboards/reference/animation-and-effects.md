# Animation and Effects

## Animate object behavior, not decoration

First make the component look like a recognizable object at rest. Then derive motion from how that object would enter, activate, respond, or signal state in its real world.

Use four motion roles:

| Role | Purpose | Typical treatment |
|---|---|---|
| Entrance | Establish hierarchy or arrival | Fade plus small transform |
| Sequence | Explain order or progression | Short stagger or shared delay variable |
| Response | Confirm hover, focus, or activation | Lift, edge contrast, depth change |
| Ambient signal | Communicate live state or atmosphere | Slow pulse, glow, or asymmetric movement |

Most elements should stop moving after entrance. Continuous motion belongs to live indicators, focal rewards, or quiet environmental details.

## Build the resting material first

Combine effects by responsibility:

- gradients create material and lighting;
- inset shadows create bevels, screens, and inner glow;
- external shadows establish weight and elevation;
- pseudo-elements add clips, rails, reflections, scan lines, and structural details;
- `clip-path` creates domain-native silhouettes;
- `filter: drop-shadow()` creates glow around non-rectangular shapes;
- `backdrop-filter` can create glass when browser support and contrast are acceptable.

Use one tight light effect and one broader ambient effect. Keep a stable dark grounding shadow when a glow animates so the object does not appear to float unpredictably.

## Reusable motion primitives

### Deal or place

```css
@keyframes object-in {
  from { opacity: 0; transform: translateY(14px) scale(.985); }
  to { opacity: 1; transform: none; }
}
```

Use for repeated cards and rows. Apply `animation-fill-mode: backwards` when elements have delays so the first keyframe holds during the wait.

### Power on

```css
@keyframes power-on {
  0% { filter: brightness(2.4) saturate(.4); }
  20% { filter: brightness(.4); }
  45% { filter: brightness(1.8); }
  100% { filter: brightness(1); }
}
```

Use on the electronic surface, not its physical frame.

### Meter reveal

```css
.meter {
  transform-origin: left center;
  animation: meter-fill .8s cubic-bezier(.2,.7,.25,1) backwards;
}

@keyframes meter-fill {
  from { transform: scaleX(0); }
  to { transform: scaleX(1); }
}
```

Keep the final data-defined width and reveal it with a transform rather than repeatedly laying out `width`.

### Live pulse

```css
@keyframes live-pulse {
  0% { box-shadow: 0 0 0 0 rgb(220 30 40 / .5); }
  70% { box-shadow: 0 0 0 8px rgb(220 30 40 / 0); }
  100% { box-shadow: 0 0 0 0 rgb(220 30 40 / 0); }
}
```

Tie this animation to a semantic live-state class. Keep idle state still.

### Foil or light sweep

Put the highlight on a pseudo-element and translate it across the object. This isolates the effect from content and avoids changing text brightness.

## Choreography

Use delays to explain hierarchy:

- repeated peers: 30–60 ms increments;
- stages in a process: 100–160 ms increments;
- focal item: reveal supporting items first, then the focal item;
- entrance then ambient motion: start the idle loop only after the entrance settles.

CSS custom properties make progression explicit:

```html
<section style="--delay: .28s">...</section>
```

```css
.item { animation-delay: var(--delay, 0s); }
```

Negative delays are useful for asynchronous ambient loops such as flags or indicators: each instance begins immediately at a different phase.

## Easing and weight

- ordinary UI response: fast ease-out, little or no overshoot;
- a physical card or board: mild overshoot around `1.03–1.08` in the final Bézier control;
- a hero or reward: stronger but brief overshoot;
- ambient motion: slow `ease-in-out` loops.

Keep distance and duration proportional to importance. A permanent header may move 4–8 px; a hero can move 20–30 px; an interaction popover should usually settle within roughly 150–250 ms.

## Interaction effects

On hover or focus, change a small coherent set:

- translate upward slightly;
- strengthen the shadow;
- increase edge contrast;
- optionally add a material-specific reflection;
- raise stacking order when overlap is possible.

Provide an equally clear `:focus-visible` state. Motion should confirm that an object is actionable, not be the only signal.

Native popovers can escape clipped dashboard blocks by entering the browser top layer. CSS anchor positioning can place a popover near its trigger, with a viewport-centered fallback where unsupported.

## Performance

Prefer animating `transform` and `opacity`. Use `filter` and large shadows on a small number of focal elements. Avoid animating layout properties across many rows. Test in the embedded runtime rather than assuming a standalone mockup has the same clipping and stacking behavior.

Remember that independently queried dashboard blocks mount when their own data arrives. Cross-block delays are relative to each block's mount, not necessarily to one global page clock. Keep essential narrative order within one block or tolerate small timing variance.

## Reduced motion

Every motion system needs a visible resting state:

```css
@media (prefers-reduced-motion: reduce) {
  .animated {
    animation: none !important;
    opacity: 1 !important;
    transform: none !important;
  }
}
```

Restore any initial `opacity`, transform, or scale that the animation would have resolved. Preserve semantic state with color, text, shape, or iconography when pulse and movement are removed.

## Motion review

For each animation, record:

1. object and real-world behavior;
2. user meaning;
3. trigger;
4. duration and delay;
5. resting state;
6. reduced-motion equivalent.

Remove an animation when it has no answer for object behavior or user meaning.
