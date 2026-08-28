# Dataset contracts

- Preserve the documented grain: adoption is one row per company snapshot; Cases is one row per case; SpeakUp is one row per submitted ticket.
- Keep metrics fanout-safe. Count parent records with `count_distinct`; sum lifecycle event counts only from the one-row-per-parent lifecycle models.
- Keep sensitive identities, free text and raw event models out of dataset views.
- Preserve numeric `company_id` RLS independently on all 3 datasets with `matches_user_attribute`:
  - `brainstorm_adoption_snapshot.company_id`
  - `brainstorm_cases.company_id`
  - `brainstorm_speakup.company_id`
- Give every metric a description that states its population, unit, cutoff, aggregation behaviour and suitable breakdowns.
- After changes, use `fetch_dataset` to confirm descriptions and relationships, then execute at least one real visualization for each changed dataset.
