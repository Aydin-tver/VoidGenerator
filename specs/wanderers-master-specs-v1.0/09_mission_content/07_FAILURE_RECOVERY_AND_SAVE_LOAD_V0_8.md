# Failure, Recovery & Save/Load v0.8

## Failure rules

A failed objective must leave a deterministic state.

Possible states:

```text
FAILED
RETRY_AVAILABLE
FAILED_WITH_FOLLOWUP
EXPIRED
```

Never:
- delete evidence accidentally;
- duplicate rewards;
- leave mission permanently active after terminal failure;
- advance story without required event.

## Save requirements

At minimum persist:

```text
active missions
mission objective states
story.solaris_route_decision
evidence states
NPC narrative contexts
station narrative states
one-time effect keys
follow-up unlocks
```

## Reload invariant

After save → load:

```text
same narrative state
same available dialogue
same mission state
same evidence
same branch
```

## Replay invariant

Re-emitting an already processed event must not duplicate:
- evidence;
- one-time consequence;
- mission completion;
- relationship effect.

## Migration

Every persisted narrative state should carry a schema/version identifier.
