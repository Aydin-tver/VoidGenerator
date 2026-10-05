# Equipment Action Contract v1.0

An equipment capability can expose an action.

```yaml
action_id:
capability_id:
requirements:
cost:
risk:
information_gain:
possible_targets:
allowed_contexts:
success_outcomes:
partial_outcomes:
failure_outcomes:
consequences:
```

## Example

```text
CAPABILITY: Deep Scan
ACTION: scan_anomaly_deeply

Requirements:
Sensors >= 3
Deep Scan module

Cost:
energy + time

Risk:
signal exposure

Possible results:
- normal anomaly profile
- hidden signal
- false lead
- hostile response

Consequences:
knowledge update
faction interest
new discovery
possible NPC mission
```

The equipment does not simply unlock a dialogue option. It enables a gameplay action.
