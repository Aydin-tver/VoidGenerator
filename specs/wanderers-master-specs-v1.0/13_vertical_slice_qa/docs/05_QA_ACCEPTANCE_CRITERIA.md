# QA Acceptance Criteria v1.1

## Functional

- MSR-01 can be completed through actual gameplay.
- MSR-02 becomes available only after MSR-01.
- MSR-03 requires route evidence.
- MSR-04 requires both independent evidence objects.
- MSR-05 requires the synthesized pattern.
- REPORT and WITHHOLD produce distinguishable persistent context.

## Narrative

- no GPS quest pointer;
- no unsupported interaction;
- critical claims have evidence provenance;
- unresolved mystery remains unresolved;
- dialogue reflects player history.

## Technical

- all content IDs resolve;
- all event IDs resolve;
- all consequences resolve;
- save/load is deterministic;
- replay is idempotent;
- unsupported capabilities are explicit errors.

## Performance

Narrative processing must not:
- run per-frame;
- allocate large transient graphs every frame;
- scan all missions on every gameplay event;
- duplicate authoritative world state.

Use indexed subscriptions / targeted evaluation.
