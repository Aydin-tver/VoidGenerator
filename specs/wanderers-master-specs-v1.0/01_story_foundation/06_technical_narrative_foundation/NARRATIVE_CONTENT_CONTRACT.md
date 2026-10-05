# Wanderers Story — Narrative Content Technical Contract

## Purpose

Every production narrative unit must be technically traceable from story intent to executable gameplay.

## Required sections

```yaml
contentId:
storyId:
version:
owner:

narrative:
  purpose: []
  themes: []

technical:
  capabilities: []
  eventsConsumed: []
  eventsProduced: []
  consequencesRequested: []
  readState: []
  writeState: []

content:
  nodes: []
  choices: []
  outcomes: []

validation:
  fixtures: []
  requiredSystems: []
```

## Example

```yaml
contentId: story.act02.kairos.convoy_01
storyId: act02.kairos
version: 1
owner:
  agentId: narrative.kairos

narrative:
  purpose:
    - introduce_faction_conflict
    - reveal_first_evidence

technical:
  capabilities:
    - flight
    - convoy
    - scan
    - combat
    - docking
  eventsConsumed:
    - convoy.detected
    - scan.discovery_completed
    - combat.victory
    - combat.retreat
    - convoy.protected
    - convoy.destroyed
    - station.docked
  eventsProduced: []
  consequencesRequested:
    - evidence.add
    - faction.reputation
    - story.flag
  readState:
    - faction.reputation
    - evidence
  writeState:
    - evidence
    - faction.reputation
    - story.flag

validation:
  fixtures:
    - fixtures/story/act02/kairos/convoy_01_success.json
    - fixtures/story/act02/kairos/convoy_01_retreat.json
    - fixtures/story/act02/kairos/convoy_01_destroyed.json
```

## Authoring gate

A content unit is not production-ready until:

1. schema validation passes;
2. all capability IDs exist;
3. all event types exist;
4. all consequence types exist;
5. localization keys exist;
6. graph validation passes;
7. critical branch fixtures replay deterministically;
8. required game systems are available in the target release.
