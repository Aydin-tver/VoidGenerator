# Consequence Audit Journal 0.12

The audit journal records the deterministic lifecycle of a consequence proposal:

```text
GameEvent
  ↓
Rule / Proposal
  ↓
Resolution
  ↓
Applied (host-owned)
```

## Principles

- Audit history is diagnostic history, not authoritative game state.
- Audit IDs are deterministic from event, rule, proposal and lifecycle stage.
- Journal sequence is assigned by the journal, not by content authors.
- Runtime version is stored with every entry for support/replay diagnostics.
- The game remains responsible for actual state mutation.

## Stages

- `proposed` — a rule produced a consequence proposal.
- `resolved` — resolver accepted or rejected it, with an optional reason.
- `applied` — the host confirms that the accepted proposal was actually applied.

## Next

0.13 standardizes engine-neutral domain vocabulary. 0.14 builds branching narrative runtime. 0.15 creates the separate Wanderers integration branch.
