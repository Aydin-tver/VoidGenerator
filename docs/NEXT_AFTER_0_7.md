# Roadmap after 0.7

## 0.8 — Full Shadow Coverage

Add producers for Combat, Salvage, Trade, Station and Scan. Do not migrate mission rewards yet.

## 0.9 — Legacy Migration

Migrate one mission family at a time behind a feature flag. New engine becomes authoritative only after its shadow mismatch rate is zero on deterministic fixtures and real play traces.

## 0.10 — Persistent Journal

Persist event sequence, event IDs, mission snapshots and definition versions. Add replay from a saved event boundary and snapshot migration.

## 0.11 — World Consequences

Connect named outcomes to `WorldState`, faction reputation/trust, evidence and character state. Domain systems own mutations; the mission engine emits declarative effects.

## 1.0 — Remove Legacy Mission Runtime

Only after migration coverage, replay, save/load migration, reward deduplication and regression gates are established.

## Parallel AI workstreams

- Event Contract: catalog/schema/fixtures only.
- Mission Content: JSON only; no Dart engine edits.
- Runtime: engine and tests only.
- Wanderers Adapter: domain-to-event bridge only.
- Shadow QA: fixtures/replays/mismatch reports only.
- Narrative: localization, clues, evidence and outcomes only.

No stream may silently invent an event type. Contract changes must precede content changes.
