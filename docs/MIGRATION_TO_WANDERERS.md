# Migration plan for Wanderers of the Void

Current project has a `GameplayMission` model with objectives containing `type`, `target`, `amount`, `clue`, `locationLabel` and `informationSource`.

Do not replace it in one large rewrite.

## Phase 1 — adapter

Map old mission objective types to semantic events:

`combat_win` -> `combat.victory`
`cargo_salvage` -> `cargo.salvaged`
`dock` -> `station.docked`
`scan_discovery` -> `scan.discovery_completed`
`convoy_reach` -> `flight.entered_region`
`convoy_escort` -> `convoy.escort_tick`
`convoy_protect` -> `convoy.protected`

Keep the old JSON working during migration.

## Phase 2 — event producers

Add publishers to:

- flight;
- combat;
- trade;
- salvage;
- station/docking;
- NPC interaction;
- Thread/resonance;
- faction reputation;
- world consequences.

No mission code inside those systems.

## Phase 3 — mission JSON

Move one mission family at a time into `missions/*.json`.

Start with convoy because it currently exposes the clarity problem most clearly.

## Phase 4 — runtime replacement

Run old and new mission engines in shadow mode and compare progress results.

Only after parity is demonstrated should the old `GameplayMissionUseCase.record()` path be removed.

## Phase 5 — external package

The engine can then be extracted into its own repository with no Wanderers-specific imports.

The Wanderers project becomes an adapter/content repository over the engine.
