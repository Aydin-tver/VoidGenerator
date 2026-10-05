# Host Adapter Responsibilities v1.0

The adapter is the only bridge from narrative intent to Wanderers state.

## Read operations

- `getStoryFlag`
- `getEvidence`
- `getCharacterContext`
- `getStationContext`
- `getFactionContext`
- `getGameplayCapability`
- `getCurrentLocation`

## Narrative operations

- `unlockMission`
- `completeObjective`
- `addEvidence`
- `setStoryFlag`
- `updateCharacterContext`
- `updateStationNarrativeContext`

## Event observation

Adapter subscribes to the canonical event bus/journal and maps domain events into semantic narrative events.

## Forbidden

Adapter must not:
- implement combat;
- calculate cargo;
- modify credits directly;
- bypass domain validation;
- invent events;
- silently swallow unsupported operations.

Unsupported operation = explicit integration error.
