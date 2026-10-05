# Domain-Neutral Vocabulary — 0.13

## Purpose

0.13 standardizes consequence names and payload contracts without taking ownership of game state.

Canonical types:

- `world.consequence` — `{ key: string, delta: number }`
- `faction.reputation` — `{ factionId: string, delta: number }`
- `character.trust` — `{ characterId: string, delta: number }`
- `story.flag` — `{ flag: string, value: boolean }`
- `evidence.add` — `{ evidenceId: string }`
- `economy.telemetry` — `{ metric: string, amount: number }`
- `thread.resonance` — `{ delta: number, source?: string }`

## Ownership rule

The vocabulary describes a portable contract. The engine does not mutate WorldState, FactionState, CharacterState, StoryState, EvidenceSystem, Economy or Thread state.

A game integration owns interpretation and mutation.

## Strict payload validation

Contracts are strict by default. Required fields must exist with the declared primitive type. Unknown fields are rejected so content drift is detected before runtime.

## Why this is separate from effects

`effects.catalog.json` describes the older mission/effect vocabulary. The domain vocabulary is intentionally consequence-oriented and is the contract used by the World Consequence pipeline. A later migration can map legacy effect types into these canonical types.
