# Wanderers — Character State Model v0.2

## Goal

Give major NPCs persistent story memory without requiring a full life simulation.

## State

Each major character may have:

- `trust` — willingness to cooperate;
- `respect` — evaluation of player's demonstrated behavior;
- `fear` — whether the character perceives the player as dangerous;
- `dependency` — practical reliance on the player;
- `flags` — named story facts;
- `memories` — authored durable memories;
- `status` — active, unavailable, dead, departed, transformed, etc.

Not every character needs every field.

## Memory model

A memory is an authored fact:

```json
{
  "id": "memory.lena.protected_convoy",
  "characterId": "lena_voss",
  "sourceEventId": "evt_...",
  "tags": ["convoy", "trust"],
  "importance": "major"
}
```

Dialogue can gate on memory IDs.

## Trust changes

Trust changes only through registered consequences. Avoid direct `trust = 50` assignment from dialogue text.

Recommended operations:

- add/subtract bounded delta;
- set named relationship state for exceptional narrative transitions.

## Death / departure

Character availability is authoritative. Narrative may request a consequence such as `character.status`, but the host validates whether the state transition is legal.

## Gameplay binding

Character state is useful only where the game can react to it, for example:

- different dialogue;
- mission availability;
- reward/access changes;
- character departure;
- different outcome branch.

Do not add invisible relationship statistics that never affect gameplay or narrative.
