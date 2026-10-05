# Dynamic Dialogue Context v1.0

Every important conversation receives a context snapshot:

```yaml
player:
  skills:
  equipment:
  knowledge:
  faction_relations:

npc:
  goals:
  memories:
  relationships:
  secrets:
  beliefs:

world:
  faction_state:
  station_state:
  active_conflicts:
  recent_events:

conversation:
  previous_actions:
  unresolved_promises:
  known_lies:
```

Dialogue authoring selects from this context.

The runtime decides which lines/actions are currently valid.
