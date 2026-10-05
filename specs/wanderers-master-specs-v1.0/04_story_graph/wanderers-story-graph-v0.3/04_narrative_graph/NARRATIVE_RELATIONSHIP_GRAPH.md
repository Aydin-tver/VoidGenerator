# Narrative Relationship Graph v0.3

## Core graph

```text
WORLD
 ├── FACTIONS
 │    ├── goals
 │    ├── resources
 │    ├── conflicts
 │    └── access
 │
 ├── CHARACTERS
 │    ├── faction affiliation
 │    ├── relationships
 │    ├── knowledge
 │    └── missions
 │
 ├── MYSTERIES
 │    ├── questions
 │    ├── evidence
 │    └── revelations
 │
 └── LOCATIONS
      ├── stations
      ├── regions
      └── story hooks

ALL ABOVE
      ↓
MISSIONS / EVENTS
      ↓
PLAYER ACTION
      ↓
CONSEQUENCE PROPOSALS
      ↓
AUTHORITATIVE STATE
      ↓
NEW ACCESS / KNOWLEDGE / CONFLICT
```

## Required edge types
- `faction -> character`: affiliation, conflict, patronage, distrust.
- `character -> character`: trust, rivalry, dependency, knowledge exchange.
- `character -> mission`: issuer, participant, witness, antagonist.
- `mission -> mystery`: introduces, advances, tests, resolves.
- `mission -> evidence`: creates, confirms, contradicts.
- `choice -> consequence`: explicit deterministic mapping.
- `consequence -> future content`: gate, dialogue variation, mission availability, world-state hook.
- `station -> faction`: presence or influence.
- `station -> character`: home/recurring/story location.

## Anti-island rule
A major node is an island if it has fewer than 3 meaningful outgoing/incoming relationships. Such nodes require rewrite, promotion to minor content, or explicit removal.

## No fake edges
Do not create relationships merely to satisfy the graph. Every edge must have a narrative or gameplay function.
