# Wanderers ↔ Void Event Engine Integration Specification 0.18

## Purpose

This document defines the host contract between **Wanderers of the Void** and the standalone `void_event_engine` package.

The engine is a domain-neutral runtime. Wanderers owns authoritative gameplay state (`PlayerState`, `WorldState`, faction/reputation, story/evidence, economy). The engine observes facts, evaluates missions/narrative/consequence rules, journals events and produces proposals. In Shadow mode it MUST NOT mutate player-facing state or grant rewards.

## Authority modes

- `legacy`: existing Wanderers mission/runtime is authoritative; engine is disabled.
- `shadow`: legacy remains authoritative; engine receives the same semantic events and is compared against legacy snapshots.
- `modern`: engine becomes authoritative only for an explicitly migrated domain.

Default integration mode for 0.18 is **shadow**.

## Event flow

```text
Wanderers gameplay action
        ↓
semantic event adapter
        ↓
Void Event Engine
   ┌────┴──────────┐
   ↓               ↓
Journal          Runtime
   ↓               ↓
Shadow trace    mission/narrative/consequence
        \         /
         \       /
          comparison
              ↓
       legacy remains authority
```

## Canonical event vocabulary

| Gameplay fact | Event type |
|---|---|
| region entered | `flight.entered_region` |
| station docked | `station.docked` |
| combat started | `combat.started` |
| combat victory | `combat.victory` |
| combat retreat | `combat.retreat` |
| cargo salvaged | `cargo.salvaged` |
| trade completed | `trade.completed` |
| convoy detected | `convoy.detected` |
| convoy escort tick | `convoy.escort_tick` |
| convoy protected | `convoy.protected` |
| convoy destroyed | `convoy.destroyed` |
| scan completed | `scan.discovery_completed` |
| Thread resonance | `thread.resonance_detected` |

Mission gameplay aliases such as `combat_win`, `scan_discovery` are legacy action names. The integration layer translates them to canonical events.

## Payload rules

- IDs are stable strings.
- Numeric values are JSON numbers.
- `occurredAt` is UTC.
- `sequence` is assigned by the journal.
- `correlationId` groups one gameplay interaction across events.
- `causationId` links a derived event to its source event.
- Per-frame events are forbidden. Emit semantic checkpoints only.

## Save/replay

Wanderers save state remains authoritative. The engine journal/checkpoint is an auxiliary deterministic record. A future production integration may register host-owned snapshot components with `RuntimePersistenceCoordinator`.

## Rewards and mutations

In Shadow mode:

- engine effects are captured only;
- no money/xp/reputation/world-state mutation comes from engine effects;
- no duplicate mission rewards may occur;
- legacy `GameplayMissionUseCase` continues to apply rewards.

## Migration gate

A domain may move from `shadow` to `modern` only after:

1. success scenario: 0 mismatches;
2. failure scenario: 0 mismatches;
3. wrong-target scenario: 0 mismatches;
4. duplicate-event scenario: 0 mismatches;
5. replay is deterministic;
6. no duplicate rewards/effects;
7. player-facing behavior is unchanged during shadow validation.

## Integration branch policy

The Wanderers integration is maintained separately from standalone engine releases. Engine API changes are consumed through the vendored package under `packages/void_event_engine` and documented in this file before migration work proceeds.
