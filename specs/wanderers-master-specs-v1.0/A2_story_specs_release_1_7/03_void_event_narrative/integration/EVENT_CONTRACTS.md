# Wanderers Event Contracts

Canonical event types consumed by the Void Event Engine.

## Flight

`flight.entered_region`

Payload: `regionId: string`

## Station

`station.docked`

Payload: `stationId: string`

## Combat

`combat.started`

Payload: `encounterId: string`, `enemyArchetype: string`

`combat.victory` / `combat.retreat`

Payload: `encounterId: string`, `riskLevel: number`

## Scan

`scan.discovery_completed`

Payload: `targetId: string`, `discoveryId: string`

## Salvage

`cargo.salvaged`

Payload: `sourceId: string`, optional `itemId`, `quantity: number`

## Trade

`trade.completed`

Payload: `stationId`, `itemId`, `quantity`, `side`

## Convoy

`convoy.detected`: `convoyId`, `regionId`

`convoy.escort_tick`: `convoyId`, `integrity`

`convoy.protected`: `convoyId`

`convoy.destroyed`: `convoyId`, `cause`

## Narrative/world

`thread.resonance_detected`: `strength`, `locationId`

`faction.reputation_changed`: `factionId`, `delta`

`world.consequence_changed`: `key`, `delta`

These last two are state-change observations, not commands. The engine must not emit them merely to force state mutation.
