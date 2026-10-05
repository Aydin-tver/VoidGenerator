# Integration Sequence v1.0

## Phase 1 — Read-only

1. Load content pack.
2. Validate schemas.
3. Validate event IDs against the event catalog.
4. Subscribe to real gameplay events.
5. Produce narrative telemetry.
6. Do not alter player state.

## Phase 2 — Evidence

1. Observe route event.
2. Observe Ferrum scan event.
3. Add evidence through narrative adapter.
4. Save/load.
5. Replay event journal.
6. Verify idempotency.

## Phase 3 — Mission progression

Enable:
- objective completion;
- mission unlock;
- dialogue availability.

## Phase 4 — Consequences

Enable only approved consequences:
- story flags;
- evidence;
- character narrative context.

## Phase 5 — Full vertical slice

Run:
MSR-01 → MSR-05
with fresh save, save/load, branch, replay and failure cases.
