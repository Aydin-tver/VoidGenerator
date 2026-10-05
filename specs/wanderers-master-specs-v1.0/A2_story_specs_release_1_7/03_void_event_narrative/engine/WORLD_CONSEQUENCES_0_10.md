# Void Event Engine 0.10 — World Consequences

## Goal

Convert immutable gameplay facts into **consequence proposals** without allowing the event engine to mutate Wanderers state directly.

The boundary is:

```text
GameEvent
   ↓
ConsequenceDefinition
   ↓
ConsequenceProposal
   ↓
Authoritative game system
   ↓
WorldState / FactionState / Economy / Story
```

## Why proposals instead of direct mutation

The engine is responsible for interpreting events and determining which rules match. The game remains authoritative over persistent state. This prevents the event engine from becoming a second hidden database and keeps effects testable and replaceable.

## Idempotency

Every proposal has a deterministic id: `eventId:ruleId`.

`oncePerEntity` additionally prevents repeated consequences for the same rule/entity pair. The runtime snapshot stores both processed event IDs and processed rule/entity keys so save/load can preserve behavior.

## Initial consequence vocabulary

The prototype deliberately keeps the vocabulary small:

- `world.consequence`
- `faction.reputation`
- future: `economy.signal`, `story.flag`, `evidence.add`, `character.trust`

The engine does not decide how a host applies those changes.

## Deterministic replay

A replay must consume the same event sequence and produce the same proposal sequence. The authoritative host then decides whether each proposal is accepted. This gives us a clean place to add validation, caps, conflict resolution and audit logging.

## Wanderers integration rule

Do not wire this directly into the game yet. The separate Wanderers integration branch should implement adapters such as:

- `WorldConsequenceSink`
- `FactionConsequenceSink`
- `EconomyConsequenceSink`
- `StoryConsequenceSink`

Each adapter must validate the proposal and perform the actual state mutation through the game's existing authoritative repositories/ledger.
