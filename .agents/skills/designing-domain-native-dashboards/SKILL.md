---
name: designing-domain-native-dashboards
description: "Designs and implements bespoke data dashboards by mapping real domain objects to schema-backed analytical components, then carrying an approved visual concept into production. Use when creating a story-led dashboard where visual identity, motion, and data semantics matter more than a generic BI layout."
---

# Designing Domain-Native Dashboards

Build the dashboard as a coherent world: begin with real data, choose one domain-native metaphor, map every analytical question to an object in that world, prototype in the production medium, then bind and verify the data.

## Workflow

### 1. Frame the experience

Record:

- audience and decision or story the dashboard serves;
- available data and refresh cadence;
- delivery surface: internal analysis, public story, embedded experience, or demo;
- whether visual impact or native analytical interaction has priority;
- target browsers, viewport, accessibility, and sharing requirements.

Choose the interaction budget now. A highly crafted HTML/CSS surface can trade away native drill, chart selection, and cross-filter behavior. Complete this step when the priority and non-negotiable interactions are explicit.

### 2. Establish the data contract

Inspect the source, semantic models, dataset, relationships, fields, and realistic row grain before ideating visuals. List the questions the data can answer honestly.

Model presentation drivers when they encode business meaning or remove template logic, including:

- inclusion flags and featured-item selection;
- ranks and stable sort orders;
- state and status labels;
- display labels for lifecycle states;
- semantic colors;
- relative bar percentages;
- stage or progression state.

Complete this step when every proposed analytical question maps to available fields or to a clearly defined model change.

### 3. Find the world

Read [Strong visual concepts](reference/strong-visual-concepts.md) before proposing directions.

Write the concept in one sentence:

> The dashboard is **[domain-native place or system]**, and each visualization is **[a recognizable object or signal from that world]**.

Create an object map with four columns:

| Analytical question | Data | Domain object | Why the object fits |
|---|---|---|---|

Generate alternatives, then choose one concept. The concept passes only when it:

1. belongs naturally to the domain;
2. explains the page structure;
3. supplies enough distinct objects for the required questions;
4. makes each question easier to understand;
5. fits the available data and lifecycle states;
6. gives motion and interaction a coherent vocabulary.

Do not build the production dashboard until one concept passes all six checks.

### 4. Prototype in the production medium

Use the closest practical medium to the final surface. If production uses dynamic HTML/CSS, prototype in HTML/CSS rather than creating a separate visual artifact that must be reinterpreted.

Give every displayed value a named schema-backed slot. Use representative data for normal, empty, loading, pre-event, live, completed, tied, and unusually long states. Keep the prototype disposable until the concept is approved.

Complete this step when the prototype demonstrates hierarchy, object language, representative data, and edge states at the target viewport.

### 5. Critique and lock the direction

Review the prototype against the concept rather than judging isolated polish:

- Does every component belong to the same world?
- Does each object improve comprehension rather than decorate a generic card?
- Is the most important question visually dominant?
- Does the page tell a deliberate spatial story?
- Are comparisons and baselines present where a number needs context?
- Are unsupported facts absent rather than fabricated?
- Does the design survive thin and incomplete data?

Revise until the object map and prototype agree. Record the approved hierarchy, materials, component states, and interaction budget as the design contract.

### 6. Productize without translating the design twice

Reuse the approved structure and styles. Bind real fields into the prepared slots, move selection logic into the semantic model, and extract only genuine repetitions into reusable components.

Separate responsibilities:

- semantic layer: truth, grain, ranking, selection, states, and display drivers;
- component: fields, template, local states, and local interaction;
- theme: shared tokens and resting materials;
- page: narrative composition, positioning, layers, filters, and drills.

When the target is Holistics, read [Holistics implementation](reference/holistics.md) before writing AML.

Complete this step when every visible value has a semantic source, repeated structures share one implementation, and each component has one clear responsibility.

### 7. Animate the world

Read [Animation and effects](reference/animation-and-effects.md). Derive motion from object behavior:

1. establish the resting material and depth;
2. add one entrance that explains arrival or sequence;
3. add a short hover or focus response where the object is interactive;
4. reserve continuous motion for live state or low-intensity atmosphere;
5. choreograph groups with short, meaningful staggers;
6. provide an equivalent visible state under `prefers-reduced-motion`.

Complete this step when every animation has a semantic or physical rationale and the page remains legible with all animation disabled.

### 8. Verify the experience

Test the smallest matrix that covers the delivery contract:

- representative and sparse data;
- empty and future states;
- filters, drills, hover, focus, and popovers;
- target viewport and mobile behavior;
- target browsers and embedded context;
- authenticated and shared/public rendering;
- reduced motion;
- query size, row caps, and load behavior.

For Holistics AML, run `holistics aml validate` after every AML edit. Complete the work only when the approved concept, data contract, and delivery requirements all survive the real runtime.

## Expected output

Produce the smallest useful set of artifacts:

1. experience brief and interaction budget;
2. one-sentence concept;
3. object map;
4. schema-aware prototype or implementation;
5. verification results and known trade-offs.
