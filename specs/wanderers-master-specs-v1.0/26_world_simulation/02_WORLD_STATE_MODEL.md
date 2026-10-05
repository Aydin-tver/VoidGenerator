# World State Model v1.0

Authoritative world state should be separated from narrative presentation.

```yaml
world:
  time:
  regions:
  stations:
  routes:
  security:
  economy:
  faction_states:
  npc_states:
  active_conflicts:
  active_events:
  discoveries:
  player_impact:
```

The narrative layer reads world state.

It must not silently create authoritative world facts.

State changes must be emitted as explicit domain events.
