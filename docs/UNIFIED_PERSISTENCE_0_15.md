# Void Event Engine 0.15 — Unified Persistence & Replay Coordinator

## Goal

Provide one host-neutral save boundary for mission, narrative, consequence and future runtime components.

The coordinator owns **ordering and orchestration**, not domain state.

## Save model

```text
EngineSessionSnapshot
├── sessionId
├── schemaVersion
├── lastEventSequence
├── correlationId
└── components
    ├── mission.*
    ├── narrative.*
    ├── consequence.*
    └── host-owned future components
```

Each component stores its own versioned state. Unknown components are ignored during restore so newer saves can be inspected by older hosts without inventing state.

## Restore order

1. Validate session and snapshot schema.
2. Restore registered runtime components.
3. Start replay strictly after `lastEventSequence`.
4. Publish journal facts in canonical sequence order.
5. Let each runtime's idempotency rules reject already-consumed events.
6. Return a deterministic replay report.

## Important boundary

The event journal remains the source of facts. A session snapshot is a checkpoint of derived runtime state, not a replacement for the journal.

```text
Journal facts ────────────────┐
                             ▼
Snapshot checkpoint → replay → derived runtime state
```

## Wanderers integration

The standalone engine must not depend on `WorldState`, `FactionState`, `StoryState`, `EvidenceSystem` or other Wanderers classes. The future integration branch should register callback components around those systems.

## Next

### 0.16 — Narrative Content Toolchain
- graph validation;
- unreachable/dead-end detection;
- impossible gates;
- event producer coverage;
- duplicate consequence detection;
- graph export;
- deterministic content diagnostics.

### 0.17 — Narrative Authoring Format
- stable JSON schemas;
- one story/arc per file;
- merge-friendly IDs;
- content contracts for parallel AI/human authoring.

### 0.18 — Wanderers Integration Branch
- real Flutter source;
- adapters only;
- Shadow Mode first;
- no legacy removal.

### 0.19 — Authority Migration
Convoy → Scan → Salvage → Station → Trade → Combat → Story → World consequences.

### 1.0
Stable event, mission, consequence and narrative contracts with persistent replay and a documented host adapter API.
