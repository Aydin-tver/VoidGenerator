# Journey Events — 1.0 Specification

## Purpose

Non-combat events turn travel into a sequence of small decisions. They must complement, not replace, combat encounters.

## Trigger

- The flight scene checks once per `encounterGraceSeconds`.
- Combat gets the first roll.
- If combat does not trigger, a journey event may trigger.
- After an event, `journeyEventCooldownSec` prevents immediate repetition.
- Events are modal and block docking/second triggers until resolved.

## Content contract

`assets/data/journey_events.json`:

- `id`: stable unique identifier;
- `title`, `text`: localized-ready strings;
- `danger`: `any|low|mid|high|frontier`;
- `choices[]`: player decisions;
- effects: money, reputation, fuel, damage, or cargo.

## Design rules

- At least one choice must have no direct resource gain.
- Risky choices should expose their consequence before selection.
- Damage can never reduce the player to zero through a random event.
- Cargo rewards are rejected when the hold is full rather than silently deleting existing cargo.
- Events must remain understandable without a tutorial.
