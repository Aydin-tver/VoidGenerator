# Main Story Authoring Schema v1.0

```yaml
story_node:
  id:
  act:
  purpose:

  player_goals: []

  prerequisites:
    knowledge: []
    world_state: []
    faction_state: []
    capabilities: []

  information:
    known_before: []
    discoverable: []
    interpretations: []
    contradictions: []

  approaches:
    - id:
      type:
      requirements: []
      cost:
      risk:
      result:
      evidence_gain: []
      consequences: []

  npc:
    involved: []
    memory_changes: []
    relationship_changes: []

  factions:
    involved: []
    reactions: []

  economy:
    effects: []

  exploration:
    optional_discoveries: []

  failure:
    state:
    recovery_paths: []

  future_hooks: []

  act_progression:
    advances_if: []
```
