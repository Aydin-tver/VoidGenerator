# World Event Model v1.0

World events are explicit state transitions.

Examples:

- route_blocked;
- convoy_attacked;
- station_shortage;
- security_crackdown;
- faction_patrol_deployed;
- pirate_base_discovered;
- technology_restricted;
- market_price_shift;
- npc_departed;
- station_service_closed.

Event schema:

```yaml
event_id:
type:
timestamp:
cause:
actors:
location:
inputs:
outcome:
state_changes:
player_relevance:
future_hooks:
```

Events must be traceable to causes.
