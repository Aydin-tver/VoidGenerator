# Shadow Run 0.6

0.6 turns the previous comparator into an executable shadow-run harness.

## Authority rule

The legacy mission system remains authoritative. The Event Engine observes the
same semantic events and produces a parallel snapshot. The new engine never
credits money, XP, evidence, flags, or world consequences during shadow mode.

## Compared state

After every relevant event compare:

- active/completed/failed;
- objective progress;
- active step IDs;
- named outcome;
- declarative effects emitted by the modern runtime.

## Mismatch taxonomy

- `EVENT_CONTRACT_MISMATCH`
- `PROGRESS_MISMATCH`
- `ACTIVE_STEPS_MISMATCH`
- `COMPLETION_MISMATCH`
- `FAILURE_MISMATCH`
- `OUTCOME_MISMATCH`
- `EFFECT_MISMATCH`

A mismatch is diagnostic data, never an instruction to make the adapter
compensate silently.

## Convoy vertical slice

Run four fixtures:

1. success;
2. convoy destroyed;
3. wrong region / incomplete;
4. duplicate event delivery.

The first production integration should only enable the event producer for
these semantic facts. Keep rewards on the legacy path until the mismatch report
is clean.
