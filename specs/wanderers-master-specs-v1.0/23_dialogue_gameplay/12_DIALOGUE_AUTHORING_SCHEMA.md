# Dialogue Gameplay Authoring Schema v1.0

```yaml
dialogue_id:
speaker:
target:

context_requirements:
  knowledge: []
  npc_state: []
  faction_state: []
  skills: []
  equipment: []

actions:
  - action_id:
    intent:
    requirements:
    responses:
      success:
      partial:
      failure:

effects:
  knowledge:
  npc_memory:
  relationship:
  faction:
  mission:
  economy:
  access:

future_hooks:
  - event_id:
```

Authoring must define state effects, not just text.
