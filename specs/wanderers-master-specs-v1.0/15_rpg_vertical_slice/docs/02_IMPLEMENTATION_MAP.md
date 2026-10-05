# Runtime Implementation Map

```text
Gameplay event
  ↓
Event Journal
  ↓
Narrative Observer
  ↓
Knowledge/Faction/NPC/World state
  ↓
Mission/Dialogues gates
  ↓
Future gameplay
```

## Authoritative domains

Gameplay remains authoritative for:
- travel;
- combat;
- scan;
- cargo;
- modules;
- credits.

Narrative systems consume semantic events and update narrative state.

## Required adapters

- KnowledgeAdapter
- FactionStoryAdapter
- CharacterMemoryAdapter
- ConsequenceAdapter
- StationNarrativeAdapter
- CapabilityQueryAdapter
