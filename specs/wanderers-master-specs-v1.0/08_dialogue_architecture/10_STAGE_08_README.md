# Stage 8 — Dialogue Architecture v0.7

## What this stage establishes

Dialogue is now a production system with:
- state;
- conditions;
- choices;
- evidence awareness;
- relationship context;
- consequences;
- revisits;
- localization keys;
- validation.

## Vertical slice

The first real dialogue package covers:

```text
Solaris
  Lena
  Dispatcher Tidari
      ↓
  Report / Withhold
      ↓
Ferrum
  Engineer Nova
      ↓
  Evidence comparison
      ↓
Nova / next mystery lead
```

## Important design result

The player does not receive the whole lore explanation.

Instead:

```text
ordinary work
   ↓
anomaly
   ↓
rumor
   ↓
lead
   ↓
evidence
   ↓
choice
   ↓
consequence
   ↓
second independent clue
   ↓
competing interpretations
```

This is the intended RPG investigation loop.

## Next stage

Stage 9 should turn the vertical slice into a **complete mission/content package**:
- mission JSON;
- dialogue JSON;
- evidence JSON;
- character state transitions;
- faction consequences;
- station state transitions;
- success/failure paths;
- replay/save cases;
- content QA matrix.
