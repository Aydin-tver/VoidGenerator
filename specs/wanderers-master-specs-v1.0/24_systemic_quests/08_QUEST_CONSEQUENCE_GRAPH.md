# Quest Consequence Graph v1.0

Quest outcomes emit state changes.

```text
QUEST
 ↓
OUTCOME
 ├→ NPC
 ├→ FACTION
 ├→ ECONOMY
 ├→ KNOWLEDGE
 ├→ STATION
 ├→ SECURITY
 ├→ EQUIPMENT
 └→ FUTURE MISSIONS
```

Consequences should be owned by authoritative systems.

The quest runtime emits events.
It must not duplicate world state.

## Consequence horizon

Immediate:
visible after mission.

Medium:
appears after related interactions.

Long:
changes future story/faction/world state.
