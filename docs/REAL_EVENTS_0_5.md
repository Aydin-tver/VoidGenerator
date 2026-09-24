# 0.5 Real Wanderers Events

0.5 defines the first production-facing event contract layer. It deliberately
keeps Wanderers-specific domain classes outside the standalone engine.

## Vertical slice

The first end-to-end slice is Convoy:

`flight.entered_region -> convoy.detected -> convoy.escort_tick x N -> convoy.protected`

Failure is represented by `convoy.destroyed` and is a fact, not a command.

## Producer rule

A domain subsystem emits an event only after its own state transition is
accepted. The mission engine must never poll or mutate that subsystem.

Examples:
- Combat publishes `combat.victory` after combat resolves.
- Salvage publishes `cargo.salvaged` using actual granted quantity.
- Trade publishes `trade.completed` after the transaction is committed.
- Convoy publishes `convoy.protected` only when its own protection rule says so.

## Determinism

Production adapters should inject event-id and clock providers. Fixtures always
supply explicit IDs. This makes replay and shadow comparisons reproducible.

## Do not emit per-frame events

`convoy.escort_tick` is meaningful only at a gameplay checkpoint. Do not emit
an event every Flame frame. High-frequency simulation belongs to the domain;
mission events are semantic facts.
