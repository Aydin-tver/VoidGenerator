# Wanderers Adapter — 0.4

The adapter is the first integration boundary between Wanderers of the Void and the standalone Event Engine.

## Rules

1. Domain systems publish facts; they do not call mission completion.
2. Event payloads use the catalog as the compatibility contract.
3. Stable event IDs must be supplied by the host when replay/deduplication matters. `WanderersEventAdapter.custom()` exists for this.
4. The adapter contains no Flutter, Flame, PlayerState, repository, or mission UI imports.
5. Legacy mission calls may be translated through `LegacyMissionEventBridge` during migration.
6. Effects are still handled by Wanderers application services; the engine only emits declarative effects.

## First integration targets

- Flight: `flight.entered_region`
- Combat: `combat.started`, `combat.victory`, `combat.retreat`
- Salvage: `cargo.salvaged`
- Trade: `trade.completed`
- Station: `station.docked`
- Scan: `scan.discovery_completed`
- Convoy: `convoy.detected`, `convoy.escort_tick`, `convoy.protected`, `convoy.destroyed`

## Legacy mapping

| Legacy objective | Event |
|---|---|
| `combat_win` | `combat.victory` |
| `cargo_salvage` | `cargo.salvaged` |
| `dock` | `station.docked` |
| `scan_discovery` | `scan.discovery_completed` |
| `convoy_reach` | `flight.entered_region` |
| `convoy_escort` | `convoy.escort_tick` |
| `convoy_protect` | `convoy.protected` |
| `trade_completed` | `trade.completed` |
