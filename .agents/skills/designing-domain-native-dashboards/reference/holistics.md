# Holistics Implementation

Use this reference after the concept and schema-backed prototype are approved. Verify current syntax with Holistics documentation and MCP tools; AMQL capabilities evolve.

## Tooling workflow

1. Use `holistics mcp fetch_dataset` to inspect dataset models, fields, and relationships.
2. Use `holistics mcp search_docs` for current AML, visualization, interaction, and theme syntax.
3. Use Holistics generation tools where available for AQL and native visualizations.
4. Run `holistics aml validate` after every AML edit.
5. Test in the target authenticated, embedded, or shareable-link runtime.

## Responsibility boundaries

### Semantic layer

Owns data truth and presentation drivers:

- relationships and grain;
- measures and comparisons;
- featured-item selection;
- rank and sort order;
- state labels and classes;
- semantic colors;
- relative percentages;
- lifecycle display fields.

Prefer a model field over repeating conditional business logic in HTML templates.

### Reusable `Func`

Parameterize true repetitions such as one card per group or one component per stage. Keep structurally distinct cases separate when generalization would add conditionals or hide meaning.

### Block

Use a data-bound visualization block for schema-backed content and a `TextBlock` for static scenery, labels, or structure. In projects that expose `MarkdownViz`, the common data-driven shape is:

```aml
Func component_name() {
  VizBlock {
    viz: MarkdownViz {
      dataset: dataset_name
      rows: [/* dimensions */]
      values: [/* measures */]
      content: @md
        <!-- scoped HTML/CSS and field bindings -->
      ;;
    }
  }
}
```

Official documentation may describe this family as Dynamic Content Blocks. Follow the syntax supported by the target project and current docs rather than assuming names across versions.

### Theme

Owns shared tokens and resting materials:

- colors and typography;
- panel, board, paper, metal, and turf materials;
- shared static component styles;
- stable semantic selectors.

Prefix custom classes to avoid collisions with Holistics or sibling blocks. Prefer documented semantic classes over internal utility selectors.

### Dashboard page

Owns:

- block instances;
- `CanvasLayout` or `TabLayout` composition;
- `pos(left, top, width, height)` placement;
- layers and backdrops;
- filter and drill interactions;
- runtime settings.

Treat canvas coordinates as narrative structure, not only alignment.

## Binding and formatting

Keep raw and formatted values distinct:

- use raw values for filters, widths, colors, classes, interaction values, and calculations;
- use formatted values for displayed labels and numbers.

Name visualization fields explicitly when the template depends on stable labels. Design empty-state markup deliberately; test null names, images, scores, and measures.

## Filters and interactions

Dashboard filters can auto-map across compatible blocks, including blocks on other tabs. Define explicit mappings or disable lists when a filter should remain local to one experience.

Use native interaction mechanisms when analytical exploration matters. Dynamic HTML can support links, hover, popovers, and documented drill wrappers, but it may not reproduce every native chart selection or drill behavior. Decide that trade-off before choosing a crafted surface.

For documented Dynamic Content Block drill behavior, use `<h-drill>`, pass raw values to the interaction, and style the selected child state with the documented `.h-drill-selected` class.

## Row selection and shared rendering

Do not treat pagination as business selection. Encode important caps in the query or semantic layer:

- rank the candidates;
- filter to the required rank range;
- add explicit eligibility guards;
- sort deterministically.

This is more stable for crafted templates and shareable rendering than relying only on a visualization row limit. A known project-specific failure mode is a MarkdownViz row limit not surviving a shareable-link path; rank-and-filter logic avoids coupling correctness to that UI setting.

## CSS and animation runtime

Keep CSS scoped with component prefixes. Use pseudo-elements for material details and place shared tokens in the theme.

Verify keyframes in the actual Holistics runtime. In the World Cup implementation, keyframes in theme `custom_css` did not animate visualization-block content, so a block rendered on every tab hosted shared `@keyframes`. Treat this as an observed runtime workaround, not a universal guarantee; test the target version before adopting it.

Blocks query and mount independently. Cross-block animation timing can drift with data arrival. Keep tightly choreographed sequences within one MarkdownViz block or make the sequence robust to mount variance.

Native popovers are useful when a crafted detail card must escape block `overflow: hidden`, but verify browser support, top-layer behavior, focus, and embedded restrictions.

## Verification matrix

- `holistics aml validate` passes;
- field references and relationships preserve intended grain;
- normal, sparse, empty, future, live, and completed states render;
- filter mappings affect only intended blocks;
- raw and formatted values are used correctly;
- repeated cards have deterministic sorting and query-level caps;
- shared/public links preserve content and filters;
- target browsers load external images and advanced CSS;
- reduced-motion mode leaves every component visible;
- mobile and embedded layouts preserve hierarchy;
- query volume and refresh cadence are acceptable.

## Documentation

- AML Dashboard: https://docs.holistics.io/reference/aml/dashboard
- AML CanvasLayout: https://docs.holistics.io/reference/aml/canvas-layout
- TextBlock: https://docs.holistics.io/reference/aml/text-block
- Reusable Canvas components: https://docs.holistics.io/docs/canvas-dashboard/reusable-components
- Dynamic Content Blocks syntax: https://docs.holistics.io/docs/charts/dynamic-content-blocks/syntax-reference
- Dashboard themes and custom CSS: https://docs.holistics.io/docs/admin/dashboard-themes
- Dashboard filters: https://docs.holistics.io/docs/filter-data
- Row limits: https://docs.holistics.io/docs/admin/row-limits
