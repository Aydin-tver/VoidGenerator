# Next after 0.14

## 0.15 — Narrative persistence and replay coordinator

Unify Event Journal, NarrativeSnapshot, MissionSnapshot and Consequence audit into one deterministic session/save boundary.

Requirements:
- snapshot versioning;
- event sequence checkpoints;
- restore order;
- replay from snapshot;
- idempotent event consumption;
- cross-runtime correlation IDs;
- deterministic diagnostics.

## 0.16 — Narrative content toolchain

Add stronger static analysis:
- unreachable nodes;
- dead-end non-terminal nodes;
- mutually impossible gates;
- choice coverage;
- duplicate consequence emissions;
- event-gated nodes with no producer contract;
- cycle reports;
- story graph export.

## 0.17 — Narrative authoring format

Stabilize JSON schema and provide content validation suitable for parallel AI/human authoring. Content should be merge-friendly: one story/arc per file, stable IDs, no generated IDs.

## 0.18 — Wanderers integration branch

Create a separate integration branch/release. Do not modify the standalone engine API to accommodate game internals. Build adapters for existing Wanderers systems and start in Shadow mode.

## Migration order

1. Convoy
2. Scan
3. Salvage
4. Station
5. Trade
6. Combat
7. Story arcs
8. World consequences

Legacy remains authoritative until each domain reaches zero shadow mismatches.

## 1.0 target

Stable event, mission, consequence and narrative contracts; persistent replay; validated content pipeline; documented host adapter API; no dependency on Wanderers-specific domain classes.
