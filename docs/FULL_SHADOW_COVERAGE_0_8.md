# Void Event Engine 0.8 — Full Shadow Coverage

## Goal

0.8 expands the shadow migration boundary from the convoy vertical slice to the next gameplay domains without changing player-facing behavior.

Covered producer domains:

- Combat
- Salvage
- Trade
- Station
- Scan
- Convoy (retained from 0.7)

The legacy mission runtime remains authoritative.

## New architecture

### Producer bridges

Each domain gets a small adapter that converts a domain fact into a `GameEvent`:

- `CombatEventBridge`
- `SalvageEventBridge`
- `TradeEventBridge`
- `StationEventBridge`
- `ScanEventBridge`

They contain no mission logic and no rewards. This keeps event production at the gameplay boundary and prevents the event engine from polling or emitting per-frame events.

### Mission authority

`MissionAuthorityMode` supports three explicit states:

- `legacy` — only the existing mission system changes gameplay state.
- `shadow` — both systems observe the same events, but modern effects are captured and never applied.
- `modern` — the event engine is authoritative and modern effects may be applied.

0.8 should use `shadow` in real integration. `modern` is intentionally present as a migration target, not a recommendation to switch immediately.

### Deterministic shadow trace

`ShadowTrace` serializes the event stream and observable modern state after every event. It is intended for:

- CI regression fixtures;
- comparing old/new implementations;
- deterministic replay diagnostics;
- investigating the first divergence rather than only the terminal mismatch.

Timestamps are deliberately excluded from the serialized trace so identical logical input produces identical output.

## Contract validation

The event catalog now validates simple enum-like descriptors such as `side: buy|sell` in addition to primitive types.

The full coverage fixture checks the payload shape for the seven non-convoy event types used by the first migration wave.

## What 0.8 does not do

- It does not migrate the real Wanderers source automatically.
- It does not grant rewards from the modern runtime in shadow mode.
- It does not remove `GameplayMissionUseCase`.
- It does not emit events every frame.
- It does not replace the existing mission UI.

A full Wanderers source tree (`pubspec.yaml`, `lib/`, assets and tests) is still required for a true in-game integration build.
