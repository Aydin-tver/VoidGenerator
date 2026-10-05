# Stage 7 — Station & NPC RPG Layer v0.6

## Result

Stations are now defined as RPG nodes rather than decorative destinations.

The production model is:

```text
STATION
  ↓
FACTION
  ↓
NPC NETWORK
  ↓
LOCAL CONFLICT
  ↓
RUMOR / LEAD
  ↓
GAMEPLAY ACTION
  ↓
EVIDENCE
  ↓
CHOICE
  ↓
CONSEQUENCE
  ↓
CHANGED STATION CONTEXT
```

## First implementation target

Solaris → Ferrum → Nova.

The slice should be built around:
- Lena;
- Dispatcher Tidari;
- Engineer Nova;
- one OmniCorp representative;
- one cross-faction conflict;
- one mystery;
- recurring station dialogue/context.

## Next stage

Stage 8 should create the **dialogue architecture and actual dialogue packages** for the vertical slice, including:
- conversation states;
- dialogue conditions;
- player choices;
- evidence-aware dialogue;
- relationship changes;
- localization keys;
- JSON authoring examples.
