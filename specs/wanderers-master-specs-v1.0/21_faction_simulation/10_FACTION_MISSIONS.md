# Faction Mission Generation v1.0

Faction missions should emerge from faction needs.

Mission sources:
- shortage;
- conflict;
- security threat;
- research goal;
- political problem;
- economic opportunity;
- internal rivalry;
- secret containment.

Mission template:

```yaml
mission_id:
faction:
originating_group:
need:
target:
player_leverage:
available_approaches:
failure:
partial_success:
success:
faction_consequences:
rival_consequences:
future_unlocks:
```

A faction mission should be explainable as:
"This faction wants X because Y changed."
