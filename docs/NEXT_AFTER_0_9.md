# What comes after 0.9

## 0.10 — World Consequences

Introduce a read/observe side of the event stream:

`GameEvent -> Condition -> Effect Proposal -> Authoritative Domain System`

The important boundary is that consequences are **proposals**, not direct mutation from the event engine.

Examples:

- `convoy.destroyed` -> increase piracy pressure proposal;
- `trade.completed` -> update economy telemetry proposal;
- `faction.reputation_changed` -> unlock technology proposal;
- `thread.resonance_detected` -> world-state observation proposal.

The existing domain systems remain authoritative until shadow comparison proves parity.

## 0.11 — Selective migration

Migrate mission families one at a time:

1. convoy;
2. scan/discovery;
3. salvage;
4. station;
5. trade;
6. combat;
7. branching story.

Each family needs shadow coverage, replay coverage, save/load coverage and reward idempotency tests.

## 0.12 — Persistent world/event projections

Only after 0.10/0.11 should persistent projections be introduced for:

- world state;
- faction state;
- evidence/journal;
- economy telemetry;
- story state.

The event journal remains the fact log; projections are rebuildable views.

## 1.0 — Legacy removal

Remove the legacy mission runtime only after representative save files and long play sessions show deterministic equivalence.
