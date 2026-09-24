# Next after 0.12

## 0.13 — Domain-Neutral Vocabulary

Standardize consequence types and payload contracts without owning game state:

- `world.consequence`
- `faction.reputation`
- `character.trust`
- `story.flag`
- `evidence.add`
- `economy.telemetry`
- `thread.resonance`

Add schema validation and content fixtures for each vocabulary family.

## 0.14 — Branching Narrative Runtime

Build reusable narrative primitives:

- story conditions;
- evidence/knowledge gates;
- relationship gates;
- capability gates;
- branching outcomes;
- mission activation/deactivation;
- deterministic replay of narrative state transitions.

Keep authoritative StoryState and CharacterState outside the engine.

## 0.15 — Separate Wanderers Integration Branch

Create a separate game branch/release. The engine API is consumed through adapters; the existing mission runtime remains authoritative initially.

## 0.16 — Shadow Migration

Run the real game and new runtime side-by-side. Cover Convoy, Scan, Salvage, Station, Trade, Combat, then branching story.

## 0.17 — Authority Switching

Introduce per-domain feature flags for legacy/shadow/modern authority. Do not switch a domain to modern authority until its shadow suite has zero mismatches.

## 0.18 — Production Hardening

Persistence performance, crash recovery, journal compaction, migration tooling, telemetry, CI validation and mobile memory constraints.

## 1.0

Stable engine API, deterministic replay, persistent audit trail, validated content pipeline and a completed migration path. Wanderers-specific state mutation remains in the game branch.
