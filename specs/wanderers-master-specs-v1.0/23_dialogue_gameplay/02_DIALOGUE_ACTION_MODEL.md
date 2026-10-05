# Dialogue Action Model v1.0

Dialogue actions:

- ASK
- PROBE
- VERIFY
- PERSUADE
- NEGOTIATE
- BARGAIN
- LIE
- OMIT
- THREATEN
- APPEAL
- PROMISE
- OFFER
- TRADE_INFORMATION
- REVEAL
- CONCEAL
- WITHDRAW

Each action has:

```yaml
action_id:
intent:
requirements:
information_needed:
risk:
target_state:
possible_responses:
success:
partial_success:
failure:
consequences:
memory_event:
```

The player should select an approach based on intent, not merely choose a prewritten "good" answer.
