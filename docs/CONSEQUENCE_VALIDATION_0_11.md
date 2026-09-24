# Consequence Validation & Conflict Resolution — 0.11

## Goal

0.11 makes consequence content safe to scale before Wanderers integration. The engine validates rule definitions and resolves competing proposals deterministically without owning game state.

## New boundaries

```text
GameEvent
   ↓
ConsequenceRuntime
   ↓
ConsequenceProposal[]
   ↓
ConsequenceResolver
   ↓
accepted / rejected decisions
   ↓
host-owned ConsequenceSink
```

The resolver never mutates WorldState, FactionState, StoryState, Economy or other host state.

## Deterministic ordering

Proposals are ordered by:

1. priority descending;
2. ruleId ascending;
3. proposal id ascending.

This ordering is part of the replay contract.

## Conflict policies

### additive

All proposals are accepted. This is the default and is appropriate when the host intentionally combines deltas.

### exclusive

Only the highest-priority proposal in a conflict group is accepted. Stable IDs break ties.

### rejectDuplicate

The first deterministic proposal wins; subsequent proposals in the same conflict group are rejected as duplicates.

## Conflict keys

Content may explicitly define `conflictKey`. If omitted, the resolver derives a stable key from the consequence type and common identity payload (`key`, `factionId`, `characterId`, `flag`).

Explicit keys are recommended for production content.

## Validation

`ConsequenceValidator` detects:

- duplicate rule IDs;
- empty IDs/types/event types;
- empty explicit conflict keys;
- inconsistent policies sharing one explicit conflict key;
- suspicious disabled + once-per-entity rules.

The validator intentionally does not decide whether a game-design rule is good. It checks structural/runtime safety.

## Dry-run

A content pipeline should run:

1. load consequence catalog;
2. validate catalog;
3. generate representative events;
4. create proposals;
5. resolve proposals;
6. emit the resolution JSON report;
7. fail CI on validation errors or unexpected rejected proposals.

## Important design decision

Caps/clamps are not applied by the engine in 0.11. A future host-owned policy may expose allowed state ranges. This avoids silently changing authoritative game state inside the event engine.
