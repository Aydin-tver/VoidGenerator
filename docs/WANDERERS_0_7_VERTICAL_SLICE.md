# Wanderers 3.17.2 — Event Engine 0.7 Vertical Slice

## Goal

Run one real Convoy mission through both systems without changing player-facing behaviour.

Legacy `GameplayMissionUseCase` remains authoritative for completion, rewards and world mutation. The Event Engine is observational only.

## Event flow

```text
Flight / Convoy domain
        |
        v
ConvoyEventBridge
        |
        v
GameEvent
        |
   +----+----+
   |         |
Legacy     Event Engine
   |         |
   +----+----+
        |
        v
Shadow Comparator
```

## Integration points

1. Construct one `WanderersEventGateway` at the application/gameplay composition root.
2. Construct `ConvoyEventBridge` with that gateway.
3. Emit `flight.entered_region` when the authoritative region transition succeeds.
4. Emit `convoy.detected` only when the authoritative convoy detection succeeds.
5. Emit `convoy.escort_tick` at meaningful checkpoints, not every Flame frame.
6. Emit `convoy.protected` only when the convoy protection objective actually resolves.
7. Emit `convoy.destroyed` on authoritative failure.
8. After each event, read the legacy mission snapshot and feed it to `ShadowRunSession.publish`.
9. Keep the legacy reward/effect path enabled; keep new effects observational.

## Exit criteria

The slice is ready for 0.8 only when all are true:

- success scenario: zero mismatches;
- destroyed scenario: zero mismatches;
- wrong-region scenario: zero mismatches;
- duplicate event scenario: zero mismatches;
- no duplicate reward/effect is observed;
- no player-facing mission behaviour changes;
- event payload contract passes validation;
- deterministic replay produces the same report.

## Packaging caveat

The supplied 3.17.1 snapshot in this workspace is a flattened documentation/source snapshot and does not contain a runnable Flutter `lib/` tree or `pubspec.yaml`. Therefore this package provides the exact integration layer and host contracts, but it does not claim that a Flutter build was executed against the snapshot.

When the real source tree is available, copy the integration files into the application layer and wire the five bridge calls at the authoritative domain boundaries.
