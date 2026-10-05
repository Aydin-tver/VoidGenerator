# Dynamic Quest Generation v1.0

Dynamic missions should emerge from world state.

Sources:
- faction conflicts;
- NPC goals;
- shortages;
- security events;
- piracy;
- exploration discoveries;
- player debts;
- faction obligations;
- failed missions.

Template:

```yaml
source:
problem:
stakes:
target:
available_actors:
player_leverage:
approaches:
outcomes:
consequences:
expiry:
```

Dynamic generation must remain explainable.

A mission exists because something changed.
