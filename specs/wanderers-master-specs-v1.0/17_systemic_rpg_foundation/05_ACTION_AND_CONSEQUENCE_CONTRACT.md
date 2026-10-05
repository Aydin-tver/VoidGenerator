# Action & Consequence Contract v1.0

## PlayerAction

```text
action_id
actor
intent
target
approach
required_capabilities
risk
evidence_used
source_context
```

## Consequence

```text
consequence_id
action_id
target_domain
target_id
operation
magnitude
visibility
delay
conditions
follow_up_events
idempotency_key
```

## Consequence classes

### Immediate
Visible immediately.

### Delayed
Appears after another action, time window or event.

### Hidden
Not immediately explained to the player.

### Propagated
Changes another system.

### Opportunity
Creates a new possibility.

### Loss
Removes or blocks a possibility.

## Design rule

Major consequences should prefer propagation:

ACTION
→ direct consequence
→ secondary reaction
→ new opportunity/problem.

Avoid:
ACTION
→ credits
→ reputation
→ next quest.
