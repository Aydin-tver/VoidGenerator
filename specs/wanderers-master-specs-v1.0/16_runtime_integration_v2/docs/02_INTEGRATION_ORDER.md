# Integration Order

## Phase 1 — Event bridge

Add semantic events only for the slice:

- `convoy.detected`
- `flight.entered_region`
- `scan.discovery_completed`
- `station.docked`

Do not migrate all gameplay events at once.

## Phase 2 — Narrative state

Add:

- knowledge;
- faction story state;
- NPC memory;
- station narrative state.

## Phase 3 — Consequences

Connect REPORT / WITHHOLD to the adapters.

## Phase 4 — Dialogue gates

Make revisit dialogue read narrative state.

## Phase 5 — Save/load

Persist narrative state and effect keys.

## Phase 6 — Runtime QA

Run the Stage 15 tests.

## Phase 7 — Only then scale content.
