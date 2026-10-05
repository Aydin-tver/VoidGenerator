# AI thread workflow

## Repository boundaries

Recommended folders:

- `schema/` — contracts, owned by architecture/runtime thread
- `events/` — event catalog and fixtures
- `missions/` — authored mission JSON
- `effects/` — effect catalog
- `lib/` — engine code
- `test/` — engine tests

## Rules for parallel AI work

1. Never edit another thread's owned folder unless explicitly requested.
2. Never invent identifiers that are absent from the contract.
3. Never embed executable code in JSON.
4. Every mission must validate before merge.
5. Every new event type must have:
   - producer;
   - payload schema;
   - fixture;
   - at least one consumer or explicit `unused` status.
6. Every mission objective must have a deterministic completion event.
7. Every player-facing objective must provide either a location key or a clue key.
8. IDs are immutable once released. Version the definition instead.
9. Do not use localized text as a gameplay identifier.
10. Do not use frame/tick events for ordinary mission progression.

## Suggested prompts for separate AI threads

### Event thread
"You own events/. Propose only semantic event contracts. Do not modify mission JSON. For every event provide producer, payload, version, example fixture and compatibility notes."

### Mission thread
"You own missions/. Use only events defined in events.catalog.json. Do not create new event types. Return valid JSON plus validation notes."

### Validator thread
"You own validation. Detect unknown events, unreachable branches, missing objectives, impossible targets, contradictory prerequisites, missing player-facing clues, and invalid effects. Do not rewrite content unless explicitly asked."

### Runtime thread
"You own lib/. Implement engine behavior only against the versioned schemas. Do not hardcode individual mission IDs or story content."


## 0.3 contract-first rule

AI content threads must work from `events.catalog.json` and `effects.catalog.json`. Unknown event/effect types are validation errors. If a feature needs a new semantic fact, propose the catalog change and fixture first, then write missions against it.

Before merging a mission: validate JSON, run semantic validation, add at least one replay fixture for non-linear/critical behavior, and record expected outcome.
