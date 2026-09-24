# Event catalog contract

The event catalog is the public API between game systems and the mission engine.

## Stable naming

Use semantic facts:

- `combat.victory`
- `flight.entered_region`
- `trade.completed`

Avoid implementation details:

- `combat.resolveOutcomeUseCaseFinished`
- `flight.playerPositionUpdated`

## Versioning

Changing the meaning or payload of an existing event requires a new version.
Do not silently reinterpret version 1.

A producer may temporarily publish both versions during migration.

## Payload rules

Payload fields should be:

- primitive values;
- stable IDs;
- small nested records where necessary.

Do not put UI strings in event payloads.
Do not put localization keys in domain events unless the event itself is narrative content.

## Entity identity

If the event refers to an object that may have a lifecycle, include its stable ID:

`convoyId`, `stationId`, `encounterId`, `shipId`, `npcId`.

## Determinism

Mission-critical events should be emitted exactly once for the corresponding domain fact, or carry an idempotency/event ID that lets consumers deduplicate them.

## Example

```json
{
  "id": "evt_01J...",
  "type": "convoy.detected",
  "version": 1,
  "source": "convoy_simulation",
  "entityId": "convoy.kairos_001",
  "payload": {
    "convoyId": "convoy.kairos_001",
    "regionId": "kairos.outer_trade_corridor"
  }
}
```
