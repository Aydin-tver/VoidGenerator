# World Actors v1.0

Actors are entities capable of changing the world.

## Actor types

- player;
- NPC;
- faction;
- station;
- merchant group;
- pirate group;
- security force;
- convoy;
- research operation;
- economic actor.

Each actor has:

```yaml
actor_id:
type:
goals:
resources:
capabilities:
constraints:
relationships:
current_intentions:
```

An actor should not perform actions outside its capabilities.
