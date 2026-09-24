# What comes after 0.8

## 0.8 exit criteria

Before calling 0.8 complete in the real game, every covered scenario should report:

1. zero legacy/modern state mismatches;
2. zero duplicate progress from repeated event IDs;
3. zero duplicate effects/rewards;
4. valid event payload contracts;
5. deterministic shadow traces for the same input sequence;
6. no player-facing behavior change.

## 0.9 — Persistent journal and migration boundary

After coverage is proven, add a persistent event journal abstraction. It should support:

- append-only event records;
- sequence numbers;
- mission/session correlation IDs;
- replay from a known snapshot;
- schema/version migration;
- bounded retention/compaction policy.

The journal should be infrastructure, not a second gameplay database.

## 0.10 — World consequences

Move consequence observation onto the event stream:

`GameEvent -> condition -> consequence/effect proposal -> authoritative game system`.

Keep the actual economy, faction, world-state and inventory mutations in their existing domain systems until shadow comparison proves equivalence.

## 0.11 — Selective legacy migration

Migrate one mission family at a time. Recommended order:

1. convoy;
2. scan/discovery;
3. salvage;
4. station interaction;
5. trade contracts;
6. combat contracts;
7. branching story missions.

For each family, run a shadow period before changing authority.

## 1.0 — Legacy mission runtime removal

Only remove the old mission runtime after:

- all mission families are covered;
- save/load migration is proven;
- replay is deterministic;
- rewards are idempotent;
- telemetry shows no unexplained divergence;
- old and new completion statistics agree over representative play sessions.

## Parallel AI workflow

The architecture is deliberately split so parallel agents can work on isolated areas:

- Agent A: event contracts/catalog/schema;
- Agent B: domain event producers;
- Agent C: mission definitions/content;
- Agent D: shadow/replay/CI tooling;
- Agent E: real Wanderers integration;
- Agent F: UX migration only after runtime parity.

No agent should directly rewrite the same mission runtime files while another agent is changing authority semantics. Integration should happen through event contracts and fixtures.
