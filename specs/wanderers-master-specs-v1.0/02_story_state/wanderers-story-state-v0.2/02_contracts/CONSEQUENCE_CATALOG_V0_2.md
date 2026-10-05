# Wanderers — Narrative Consequence Catalog v0.2

This is the proposed RPG extension of the existing small consequence vocabulary. It remains declarative and host-owned.

## Existing / foundational

- `world.consequence`
- `faction.reputation`

## Required for full RPG narrative

### story.flag
Payload:

```json
{"flagId":"story.example.flag","operation":"set"}
```

### story.milestone

Marks a durable narrative milestone. Idempotent by milestone ID.

### evidence.add

Adds a discovered evidence record. Duplicate evidence is idempotent.

### character.trust

Bounded delta or named transition for a character relationship.

### character.memory

Adds a durable authored memory.

### character.status

Requests a legal story status transition. Host validates whether transition is allowed.

### faction.reputation

Already planned in the existing consequence vocabulary; faction system remains authoritative.

### world.consequence

Already planned; world system remains authoritative.

## Not allowed

- arbitrary Dart code;
- arbitrary database writes;
- direct inventory mutation from narrative runtime;
- direct economy mutation from narrative runtime;
- direct ship stat mutation from narrative runtime;
- unregistered effect IDs.

## Future only if gameplay requires them

- `station.story_state`
- `mission.unlock`
- `capability.unlock`
- `route.state`

These must not be added merely for narrative convenience.
