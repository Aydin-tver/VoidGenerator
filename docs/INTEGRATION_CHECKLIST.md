# Wanderers 0.4 Integration Checklist

Use this checklist against the 3.17.1 source snapshot.

## Flight

After a system/region transition succeeds, publish `flight.entered_region` with the stable region ID.
Do not publish every frame.

## Combat

Publish `combat.started` exactly once per encounter and `combat.victory` or `combat.retreat` exactly once at resolution.
Do not turn projectile hits into mission events unless a future mission contract explicitly needs them.

## Salvage

Publish `cargo.salvaged` after the salvage transaction succeeds. Payload should identify the source and actual quantity received.

## Trade

Publish `trade.completed` after the ledger transaction succeeds, using the actual filled quantity and side.

## Station

Publish `station.docked` after docking is accepted, not on every UI rebuild.

## Scan

Publish `scan.discovery_completed` after the discovery is persisted.

## Convoy

Publish `convoy.detected` once per convoy discovery, `convoy.escort_tick` at meaningful gameplay checkpoints rather than per frame, and `convoy.protected`/`convoy.destroyed` exactly once at resolution.

## Rewards

Do not move existing reward logic into event producers. The mission effect handler must call the existing EconomyLedger/faction/world services.
