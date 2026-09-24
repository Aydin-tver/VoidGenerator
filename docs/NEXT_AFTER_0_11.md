# Next after 0.11

## 0.12 — Consequence Audit Journal

Persist the full audit chain:

```text
GameEvent → Rule → Proposal → Resolution → Applied/Rejected
```

Include deterministic IDs, sequence, reason, and runtime version. This makes world-state debugging and support tooling practical.

## 0.13 — Domain Vocabulary

Standardize engine-neutral consequence types for:

- world state;
- faction reputation;
- character trust;
- story flags;
- evidence;
- economy telemetry;
- thread/resonance signals.

Keep actual state mutation host-owned.

## 0.14 — Branching Narrative Runtime

Build story conditions, evidence gates, relationship gates, capability gates, and branching outcomes on top of the same event/consequence pipeline.

## 0.15 — Wanderers Integration Branch

Only now create the separate game branch/release. Add adapters for the real game's WorldState, FactionState, StoryState, EvidenceSystem, Economy and Mission runtime. Start in shadow mode.

## 0.16+ — Migration

Migrate one mission family at a time. Convoy remains the first vertical slice, followed by scan, salvage, station, trade, combat, and finally branching story missions.

## 1.0 exit criteria

- no legacy mission runtime required for migrated mission families;
- deterministic replay;
- persistent journal and snapshots;
- consequence audit trail;
- zero shadow mismatches for the migration suite;
- no duplicate rewards/effects;
- content validation in CI;
- game branch owns all player/world state mutations.
