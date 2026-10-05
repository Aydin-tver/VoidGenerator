# Dialogue ↔ Mission Effects v0.8

## Effect categories

### Mission
```text
mission.start
mission.advance
mission.complete
mission.fail
mission.unlock
```

### Evidence
```text
evidence.add
evidence.present
evidence.mark_contradicted
```

### Character
```text
character.trust.proposal
character.context.set
```

### Story
```text
story.flag.set
story.flag.clear
```

### Faction
```text
faction.reputation.proposal
faction.context.set
```

### World
```text
world.consequence.proposal
```

All effects must be supported by the adapter/host contract before use.

## Idempotency

One-time effects need stable idempotency keys.

Example:

```text
effect_key:
choice.solaris.report_discrepancy.v1
```

Reloading a save must not apply it twice.

## Branch persistence

C01 must create a persistent fact:

```text
story.solaris_route_decision =
  report
  | withhold
```

Later content reads that fact rather than trying to infer it from dialogue history.
