# Dashboard acceptance

- Preserve the 3-tab information architecture unless the user changes scope: Executive Adoption, Cases and SpeakUp.
- Keep Company and Country filters visible on every tab. Maintain explicit interactions to the corresponding blocks in all 3 datasets.
- Use date-typed arrays for `between` filters. A scalar `between` value passed AML and Development checks but failed in Reporting.
- Keep every `MetricKpi` label hidden and its value centred unless the user requests a different presentation.
- After dashboard edits, inspect all tabs in Demo4 Development and then verify Reporting. Completion means every expected block renders, filters propagate, and there are no loading or query errors.
