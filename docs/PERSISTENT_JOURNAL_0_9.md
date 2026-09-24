# Void Event Engine 0.9 — Persistent Journal

## Goal

0.9 establishes the persistence boundary for the event-driven runtime without turning the event journal into a second gameplay database.

The journal stores **facts that happened**. Mission runtime, world state, economy, faction state and inventory remain derived/authoritative domain state until their migrations are proven.

## Added infrastructure

- `EventJournal` — append-only event API with canonical sequence numbers.
- `InMemoryEventJournal` — deterministic test implementation.
- `JsonLinesEventJournal` — simple durable/tooling representation.
- `EventJsonCodec` — stable event serialization.
- `EventSchemaMigrator` — explicit event-version migrations.
- `SnapshotStore<T>` — snapshot boundary without coupling persistence to gameplay.
- `MissionJournalReplayer` — restore snapshot and replay events after `lastSequence`.
- `JournalCompactor` + retention policies — bounded retention/compaction planning.
- `JournalEventWriter` — explicit append boundary before event publication.

## Sequence rule

The journal assigns a contiguous sequence when an event is appended. Incoming sequence values are not trusted as persistence identity.

Duplicate event IDs are idempotent: appending the same ID returns the existing canonical event.

## Replay rule

Given snapshot S with `lastSequence = N`, replay only:

`events where sequence > N`

This prevents double application of events already represented by the snapshot.

## Migration rule

Event schema migrations are explicit and monotonic:

`type + version N -> type + version N+1`

No silent payload guessing is allowed. Missing migration paths fail loudly.

## Compaction rule

Compaction is an infrastructure operation. It must never rewrite gameplay semantics. A production implementation should retain the latest snapshot boundary plus all events required to reconstruct state after that boundary.

Do not compact events merely because they are old if no authoritative snapshot exists for the aggregate/session that needs them.

## What 0.9 does NOT do

- no automatic replacement of the Wanderers mission runtime;
- no economy/inventory/faction writes from event handlers;
- no player-facing behavior changes;
- no database dependency;
- no distributed event bus;
- no deletion of the legacy runtime.

## Exit criteria

Before 0.10:

1. append/reload preserves event order and sequence;
2. duplicate event IDs are idempotent;
3. replay from snapshot reproduces runtime state;
4. event-version migration is deterministic;
5. retention cannot delete events required by a known snapshot boundary;
6. journal corruption fails loudly rather than silently changing state;
7. deterministic replay produces the same terminal snapshot for the same journal.
