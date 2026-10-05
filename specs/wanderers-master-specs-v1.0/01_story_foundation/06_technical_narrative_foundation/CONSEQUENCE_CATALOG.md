# Wanderers Story — Consequence Catalog

## Purpose

Defines what narrative content may request after interpreting a gameplay event. The narrative/event engine proposes consequences; authoritative Wanderers systems apply them.

## Existing engine vocabulary

### `world.consequence`

Use for a registered world-state key and delta/structured payload.

Owner: WorldState / authoritative world system.

### `faction.reputation`

Use for faction reputation changes.

Owner: FactionState / authoritative faction system.

## Planned narrative adapter vocabulary

These are required for the full RPG narrative layer but must be implemented as explicit contracts before production content depends on them.

### `story.flag`

Purpose: persistent story progression/gating.

Owner: StoryState.

Suggested payload:

```json
{"flag":"story.act02.signal_found","value":true}
```

### `evidence.add`

Purpose: add a discovered evidence item to the player's persistent journal.

Owner: Evidence/Journal system.

Suggested payload:

```json
{"evidenceId":"evidence.sigma.001","sourceId":"archive.tidari.07"}
```

### `character.trust`

Purpose: modify relationship state for a named narrative character.

Owner: CharacterState.

Suggested payload:

```json
{"characterId":"lena_voss","delta":3,"reason":"protected_convoy"}
```

### `character.memory`

Purpose: record a stable story-relevant memory/event tag.

Owner: CharacterState / Narrative adapter.

Suggested payload:

```json
{"characterId":"lena_voss","memoryId":"player.protected_convoy"}
```

## Consequence design rules

1. Consequences are declarative requests, not direct mutations.
2. Every consequence type has one authoritative owner.
3. Effects must be idempotent or explicitly once-per-entity.
4. Conflicting proposals use deterministic resolver rules.
5. Caps/clamps belong to the authoritative host system.
6. A production narrative may not invent a consequence type locally.
7. Every new consequence requires schema + catalog + fixture + sink contract.

## No text-only major consequences

A major player choice should produce at least one mechanically represented state/evidence/progression change. Flavor-only dialogue choices are allowed, but must not be presented as major world-changing decisions.

## Consequence pipeline

```text
GameEvent
  -> narrative/mission rule
  -> ConsequenceProposal
  -> deterministic resolver
  -> host-owned sink
  -> authoritative game state
  -> future GameEvent
```
