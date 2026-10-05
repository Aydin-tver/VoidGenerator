# Wanderers — Story State Model v0.2

## Purpose

Define the minimum persistent narrative state required for a large RPG story while preserving the existing Void Event Engine boundary.

The model is intentionally split into three authorities:

```text
Void Event Engine Runtime
  - narrative node/progress
  - mission progress
  - consumed event ids

Wanderers Narrative Domain
  - StoryState
  - EvidenceState
  - CharacterState
  - FactionStoryState

Wanderers Gameplay Domains
  - ship / inventory / economy / combat / world systems
```

The narrative layer may read domain state through adapters and may emit consequence proposals, but it does not become the authoritative database for gameplay.

## Core rule

A value belongs to the smallest domain that can authoritatively enforce its meaning.

Examples:

- mission step progress -> Mission Runtime
- narrative node -> Narrative Runtime
- player reputation -> Faction system
- credits -> Economy
- cargo -> Cargo/Inventory
- evidence discovered -> Narrative/Evidence domain
- character trust -> Narrative/Character domain
- world consequence -> World domain

## State categories

### 1. NarrativeRuntimeState

Owned by the Void Event Engine.

```json
{
  "narrativeId": "story.act02.signal",
  "version": 1,
  "currentNodes": ["..."],
  "visitedNodes": ["..."],
  "selectedChoices": ["..."],
  "consumedEventIds": ["..."],
  "status": "active"
}
```

This is mechanical progression only. It must not contain faction reputation, credits, ship stats or arbitrary lore.

### 2. StoryState

Owned by Wanderers narrative integration.

Recommended shape:

```json
{
  "mainArc": "act02",
  "chapters": {
    "act01": "completed",
    "act02": "active"
  },
  "flags": {},
  "milestones": [],
  "revealedFacts": [],
  "activeStoryThreads": []
}
```

`flags` are named narrative facts, not a generic dumping ground. Every production flag must have an owner, definition and lifecycle.

### 3. EvidenceState

Stores discoveries that can support, contradict or refine narrative theories.

```json
{
  "evidenceId": "evidence.sigma.archive_fragment",
  "status": "discovered",
  "source": "tidari.archive_17",
  "reliability": "unknown",
  "tags": ["sigma", "registry"],
  "contradicts": [],
  "supports": []
}
```

Evidence is not automatically truth. The narrative can expose competing interpretations.

### 4. CharacterState

Stores only durable story-relevant memory.

```json
{
  "characterId": "lena_voss",
  "trust": 18,
  "respect": 11,
  "fear": 0,
  "dependency": 3,
  "flags": [],
  "memories": [
    "memory.protected_convoy"
  ],
  "status": "active"
}
```

Do not model every conversation as a persistent memory. Only authored story memories survive.

### 5. FactionStoryState

The authoritative faction reputation remains in the faction domain. Narrative stores only story-specific information such as:

```json
{
  "factionId": "free_merchants",
  "storyFlags": [],
  "completedArcs": [],
  "knownSecrets": []
}
```

If reputation already exists in gameplay, do not duplicate it here.

### 6. WorldStoryState

Stores narrative-level world facts whose authoritative effects belong to the World domain.

Examples:

- `world.frontier_security_high`
- `world.convoy_route_closed`
- `world.thread_activity_rising`

A story flag is not itself a physical world mutation. A consequence proposal must be accepted by the authoritative world system.

## Read model

Narrative conditions may read:

```text
StoryState
EvidenceState
CharacterState
Faction reputation / story state via adapter
World state via adapter
Player capabilities via adapter
```

The adapter returns a stable, engine-neutral value representation.

## Write model

Narrative content can only request:

```text
story.flag
story.milestone
 evidence.add
character.trust
character.memory
faction.reputation
world.consequence
```

where each type is registered in the consequence catalog and routed to its authoritative sink.

## No hidden writes

Narrative conditions must never mutate state while evaluating.

Conditions are pure reads.

## Save/load

Persist enough information to reconstruct:

1. narrative runtime snapshot;
2. mission runtime snapshot;
3. StoryState;
4. EvidenceState;
5. CharacterState;
6. narrative-specific faction/world projections;
7. journal checkpoint.

Do not serialize derived caches.

## Versioning

Every persisted narrative domain has a schema version. Migrations are explicit and deterministic.

## Design target

This model supports a large RPG without requiring a general-purpose RPG-stat engine. New state types are added only when a concrete story/gameplay requirement exists.
