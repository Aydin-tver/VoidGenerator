# Vertical Slice Execution Plan

## Pass 0 — Compile and baseline

- build current branch;
- run existing tests;
- record baseline failures;
- do not modify gameplay.

## Pass 1 — Event observation

Verify:

```text
convoy.detected
convoy.escort_tick
convoy.protected
scan.discovery_completed
station.docked
thread.resonance_detected
```

## Pass 2 — Narrative projection

Verify:
- MSR-01 objective progression;
- MSR-02 availability;
- route discrepancy evidence;
- MSR-03 evidence gate;
- MSR-04 synthesis;
- MSR-05 signal gate.

## Pass 3 — Choices

Verify:
- REPORT branch;
- WITHHOLD branch;
- branch context survives revisit;
- no branch silently erases prior evidence.

## Pass 4 — Persistence

For each checkpoint:
- save;
- terminate;
- reload;
- continue.

## Pass 5 — Replay

Replay source events.
Expected:
- no duplicate evidence;
- no duplicate consequence;
- no duplicate mission unlock;
- no duplicate relationship update.

## Pass 6 — Failure

Force:
- combat retreat;
- failed convoy;
- missing evidence;
- invalid event;
- unsupported effect.

The runtime must fail safely rather than manufacture success.
