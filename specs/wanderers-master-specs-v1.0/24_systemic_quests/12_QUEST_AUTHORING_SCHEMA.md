# Systemic Quest Authoring Schema v1.0

```yaml
quest_id:
title:
problem:

player_goals: []

stakes: []

information:
known: []
unknown: []
optional_discoveries: []

actors: []

requirements:
skills: []
equipment: []
factions: []
knowledge: []

approaches:
  - approach_id:
    type:
    requirements:
    cost:
    risk:
    actions:
    information_gain:
    success:
    partial_success:
    failure:

outcomes:
  success: []
  partial: []
  failure: []
  exceptional: []

consequences:
  immediate: []
  medium: []
  long_term: []

future_hooks: []

qa:
minimum_approaches:
minimum_outcomes:
has_fail_forward:
has_noncombat_solution:
has_player_agency:
```
