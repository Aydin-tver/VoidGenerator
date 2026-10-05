# Wanderers Story — Technical Story State Model

## Purpose

Keep narrative state compatible with the existing engine boundary. Narrative runtime owns progression mechanics; Wanderers owns authoritative domain state.

## State layers

### Narrative runtime state

Owned by Void Event narrative runtime:

- active narrative content IDs;
- current node IDs;
- visited nodes;
- selected choices;
- consumed event IDs;
- deterministic progression snapshot.

### Host story state

Owned by Wanderers integration:

- main story stage;
- story flags;
- evidence inventory;
- mystery progress;
- character trust/memory;
- faction story access;
- world story states.

### Domain state

Owned by game systems:

- PlayerState;
- FactionState;
- Economy;
- WorldState;
- ShipState;
- station/region state.

## Read/write boundary

Narrative may READ through an adapter:

- story flag;
- evidence fact;
- faction reputation;
- character trust;
- ship capability;
- world consequence value.

Narrative may REQUEST writes only through registered consequence types.

## Recommended aggregate story state

```text
MainStoryState
FactionStoryState
CharacterStoryState
MysteryState
EvidenceState
WorldStoryState
EndingState
```

These are projections over authoritative state, not an independent duplicate database.

## Gating model

A narrative gate may combine:

- boolean flag;
- numeric comparison;
- event fact;
- evidence possession;
- reputation threshold;
- trust threshold;
- ship/gameplay capability;
- AND / OR / NOT.

The adapter must resolve these against current authoritative game state.

## Forbidden

Do not introduce an independent narrative copy of:

- credits;
- cargo;
- ship modules;
- faction reputation;
- economy values;
- world simulation values.

The story reads those values and requests changes through contracts.
