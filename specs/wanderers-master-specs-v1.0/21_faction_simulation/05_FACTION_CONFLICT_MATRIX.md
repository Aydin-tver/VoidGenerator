# Faction Conflict Matrix v1.0

Conflicts should be multi-dimensional.

Types:
- territorial;
- economic;
- technological;
- ideological;
- informational;
- security;
- personal;
- historical.

Each conflict has:

```yaml
conflict_id:
participants:
stakes:
public_position:
hidden_position:
resources:
escalation_triggers:
deescalation_options:
player_leverage:
possible_outcomes:
```

## Example

OmniCorp vs Free Merchants:

Public:
trade-route security.

Hidden:
control over route telemetry.

Player leverage:
evidence proving route manipulation.

Possible outcomes:
- OmniCorp gains control;
- merchants expose the manipulation;
- compromise agreement;
- player keeps evidence secret;
- third party exploits the conflict.
