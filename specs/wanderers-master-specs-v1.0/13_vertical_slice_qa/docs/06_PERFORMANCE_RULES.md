# Narrative Runtime Performance Rules

## Event-driven only

Narrative evaluation happens on relevant events.

Bad:

```text
every frame:
  scan all missions
  scan all dialogue
  scan all evidence
```

Good:

```text
event:
  lookup subscribers
  evaluate affected objectives
  update projection
```

## Indexes

At minimum index:
- event_id → objectives;
- evidence_id → dependent content;
- story_flag → dependent content;
- station_id → local content;
- character_id → dialogue/content.

## Mobile constraint

Content graphs can be large, but runtime evaluation must remain incremental.
