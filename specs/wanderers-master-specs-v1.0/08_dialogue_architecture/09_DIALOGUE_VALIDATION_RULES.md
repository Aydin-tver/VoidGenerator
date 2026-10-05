# Dialogue Validation Rules v0.7

## Hard errors

- duplicate dialogue ID;
- missing localization key;
- missing speaker;
- invalid station;
- invalid mission reference;
- condition references nonexistent state;
- choice has no target/effect/follow-up;
- dialogue has no reachable start node;
- effect uses unsupported capability;
- important dialogue has no purpose;
- major choice has no observable downstream difference;
- recurring NPC has no fallback;
- revelation has no evidence/knowledge basis unless explicitly authored as a claim.

## Soft warnings

- dialogue > 15 exchanges;
- repeated lore statement;
- NPC gives more than one major new fact in one short scene;
- choice changes nothing;
- same NPC repeats same line across states;
- station has no local conflict;
- all NPCs agree about a mystery;
- no uncertainty remains after first clue.

## Traceability

```text
Dialogue
 ↓
Condition
 ↓
Choice
 ↓
Effect
 ↓
Event / State
 ↓
Mission / Evidence / Relationship
 ↓
Future Dialogue
```

Every major dialogue should be traceable through this chain.
