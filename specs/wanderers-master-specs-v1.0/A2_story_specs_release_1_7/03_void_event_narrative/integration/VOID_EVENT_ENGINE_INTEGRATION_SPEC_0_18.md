# Wanderers 3.18 — Void Event Engine Integration Spec

## Status

Integration release: **3.18.0+100**. Default authority: **Shadow**.

The standalone engine is vendored at `packages/void_event_engine` and remains independently versioned (`0.17.1`).

## Goals

1. Introduce semantic event production without changing player-facing behavior.
2. Keep `PlayerState`/legacy mission rewards authoritative.
3. Journal gameplay facts for deterministic shadow replay.
4. Prepare gradual migration of missions, story, evidence, faction and world consequences.

## Non-goals for 3.18

- Removing `GameplayMissionUseCase`.
- Applying engine effects to the player.
- Replacing save format.
- Introducing quest GPS/autopilot.
- Emitting per-frame events.

## Integration points

`lib/integration/void_event/void_event_runtime.dart` is the application boundary.

`GameplayEventSink` is the domain seam. Domain code knows only that a semantic fact can be emitted; it does not import the engine package.

## First migrated event producers

| Existing gameplay action | Canonical event |
|---|---|
| `combat_win` | `combat.victory` |
| `combat_retreat` | `combat.retreat` |
| `scan_discovery` | `scan.discovery_completed` |
| `cargo_salvage` | `cargo.salvaged` |
| `thread_resonance` | `thread.resonance_detected` |
| `stealth_pass` | `stealth.passed` |
| `mobility_escape` | `mobility.escaped` |

The legacy action continues to execute first. Event emission is observational.

## Mission shadow path

`LegacyMissionShadowAdapter` converts a `GameplayMission` into a neutral `MissionDefinition` and can build a legacy snapshot. A later test harness will feed the same events to the modern runtime and compare completion/progress/outcomes/effects.

## Migration gates

A domain can switch to modern authority only after:

- success/failure/wrong-target/duplicate scenarios match;
- replay is deterministic;
- no duplicate rewards;
- no player-facing regression;
- contract validation passes.

## Next integration releases

### 3.18.x

- wire region/station/trade/convoy producers;
- persistent journal adapter;
- shadow telemetry;
- CI validation of event contracts.

### 3.19

- full mission shadow coverage;
- narrative/evidence shadow observers;
- save/replay checkpoint integration.

### 3.20+

- domain-by-domain authority migration, starting with Convoy/Scan/Salvage.
