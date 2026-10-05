# 05 — World / Station Reactivity System v1.0

## Purpose

Make the world remember events visibly.

## Station narrative state

```text
stable
disturbed
under_investigation
faction_pressure
restricted
recovered
transformed
```

Actual state names may vary by station.

## What can change

- NPC dialogue;
- mission pool;
- rumors;
- available evidence;
- faction presence/context;
- merchant opportunity;
- access;
- local description;
- follow-up events.

## Example

Ferrum anomaly becomes public:

Before:
Nova offers technical investigation.

After:
- Nova has additional evidence;
- Tidari asks about the anomaly;
- another faction disputes the interpretation;
- a local mission becomes unavailable;
- a new optional discovery appears.

## Revisit test

A station is not reactive if returning after a major event produces exactly
the same narrative context.

## Scope rule

No autonomous population simulation is required.

Use explicit state transitions driven by authoritative events.
