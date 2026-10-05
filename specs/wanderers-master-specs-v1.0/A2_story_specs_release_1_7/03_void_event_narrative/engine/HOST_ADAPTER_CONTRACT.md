# Host Adapter Contract

Wanderers adapters are the only layer allowed to translate game state/actions into `GameEvent` objects.

## Ownership

- Wanderers owns gameplay state and mutations.
- Void Event Engine owns event processing, mission/narrative evaluation, journal/replay infrastructure and validation.
- Adapters own translation only.

## Forbidden

- engine code importing `space_rpg_mvp`;
- engine effects mutating `PlayerState` in shadow mode;
- direct WorldState mutation from an event factory;
- per-frame event emission;
- inventing event types outside the catalog.

## Required adapter tests

Every adapter must cover:

- payload shape;
- stable semantic type;
- duplicate event id behavior;
- correlation/causation propagation;
- deterministic replay;
- shadow comparison.
