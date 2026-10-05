# Wanderers — Dialogue Architecture v0.7

## Goal

Dialogue is a stateful narrative interaction, not a text dump.

Every important dialogue must either:
- reveal character;
- reveal/use information;
- create or resolve a choice;
- change relationship;
- create evidence;
- change access;
- advance a mission;
- prepare a consequence.

## Runtime model

```text
DialogueDefinition
      ↓
DialogueAvailability
      ↓
DialogueState
      ↓
Player / NPC lines
      ↓
Choice
      ↓
Effects
      ↓
Event / Narrative State
      ↓
Future DialogueAvailability
```

## Dialogue node types

1. ambient
2. informational
3. character
4. investigative
5. negotiation
6. conflict
7. revelation
8. resolution

## State dimensions

A dialogue may depend on:
- mission state;
- story act;
- NPC relationship;
- faction reputation;
- evidence possession;
- discovered facts;
- previous choice;
- station state;
- ship capability where narratively justified.

Do not gate dialogue on arbitrary hidden numbers.

## Choice quality

A meaningful choice should change at least one:
- information;
- relationship;
- faction context;
- evidence;
- mission path;
- future availability;
- world/narrative consequence.

Not every choice must create a permanent world change.

## Dialogue does not own authoritative domains

Dialogue may propose:

```text
character.trust
story.flag
evidence.add
mission.advance
faction.reputation
world.consequence
```

The appropriate host/narrative owner resolves the change.

## Anti-exposition rule

No important lore fact should be delivered repeatedly in identical wording.

When a fact returns, it should have:
- a new source;
- a new interpretation;
- new evidence;
- a new consequence;
- or a changed character perspective.
