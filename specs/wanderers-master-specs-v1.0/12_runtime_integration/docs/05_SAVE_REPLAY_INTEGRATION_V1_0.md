# Save / Replay Integration v1.0

Narrative state must survive:

- application restart;
- save/load;
- migration;
- event replay.

## Idempotency

Every one-time effect receives a stable effect key.

Example:

```text
effect.msr04.cross_source_pattern
```

Replaying the same source event must not duplicate:
- evidence;
- trust;
- flags;
- mission unlocks.

## Journal principle

Event journal is history.

Narrative state is the projection.

Do not reconstruct authoritative gameplay state from narrative state.
