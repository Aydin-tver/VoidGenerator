# NPC Memory System v1.0

NPC memory is event-based, not a single reputation score.

Memory records:

```yaml
memory_id:
event_id:
subject:
what_npc_observed:
interpretation:
certainty:
emotional_weight:
importance:
timestamp:
decay:
consequence:
```

## Memory categories

- favor;
- betrayal;
- promise;
- lie;
- rescue;
- threat;
- payment;
- information;
- humiliation;
- shared secret;
- faction action;
- equipment demonstration.

## Memory behavior

Important memories should persist.

Minor memories may decay.

Contradictory evidence can update interpretation without erasing the original event.

Example:

Nova initially believes the player helped OmniCorp.

Later evidence proves the player secretly protected the merchants.

Nova keeps both memories and revises her interpretation.

This enables nuanced NPC reactions.
