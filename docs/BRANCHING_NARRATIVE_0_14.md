# Void Event Engine 0.14 — Branching Narrative Runtime

## Goal

0.14 adds a game-neutral narrative state machine on top of the event/condition/consequence layers.

The runtime owns narrative progression only: nodes, choices, visited nodes and replay-safe event consumption. It does not own Wanderers WorldState, FactionState, StoryState, CharacterState, Evidence or Economy.

## Runtime model

```text
GameEvent
   ↓
Narrative Runtime
   ↓
Narrative State / available choices
   ↓
Player choice
   ↓
Consequence proposals
   ↓
Host-owned domain state
   ↓
Future GameEvents
```

## Node types

A node may be:
- interactive: exposes choices;
- event-gated: waits for a named event type;
- automatic: advances after its event is received;
- terminal: completes the narrative.

## Narrative gates

0.14 intentionally keeps gates generic:
- boolean flags;
- numeric values;
- facts;
- AND / OR / NOT.

The Wanderers adapter can map StoryState, Evidence, Reputation, Trust and Capability into these neutral values later.

## Determinism

- node transitions are explicit;
- choice IDs are stable content IDs;
- consumed event IDs prevent duplicate progression;
- snapshots contain the complete runtime progression state;
- simulation can replay a deterministic choice sequence.

## Consequences

Narrative nodes and choices only emit consequence type IDs. The consequence system remains responsible for resolving proposals. The host remains responsible for actual mutation.

## Validator

The validator catches:
- duplicate node IDs;
- unknown choice targets;
- unknown automatic targets;
- unknown start node;
- missing terminal nodes;
- suspicious automatic loops without an event gate.

## Known limitation

0.14 does not yet provide a generic save-game coordinator across journal + mission + narrative + consequence runtimes. That belongs to the next infrastructure stage.
