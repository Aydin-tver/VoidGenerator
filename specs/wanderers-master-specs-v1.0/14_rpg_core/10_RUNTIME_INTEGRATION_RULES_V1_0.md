# 10 — Runtime Integration Rules

## Authority

Gameplay systems remain authoritative for:

- credits;
- cargo;
- modules;
- combat;
- ship stats;
- travel;
- economy;
- physical world state.

Narrative runtime owns:

- narrative progression;
- dialogue state;
- mission projection;
- narrative gates;
- narrative observations.

Narrative domain adapters expose:

- NPC memory;
- faction story state;
- evidence/knowledge;
- station narrative state;
- narrative capabilities.

## Event flow

```text
GAMEPLAY
 ↓
SEMANTIC EVENT
 ↓
EVENT JOURNAL
 ↓
NARRATIVE OBSERVER
 ↓
STATE UPDATE
 ↓
FUTURE GATE
```

## Forbidden

- narrative engine directly modifying authoritative credits;
- fake combat success;
- fake travel;
- fake stealth;
- fake scanning;
- hidden side effects outside event contracts.
