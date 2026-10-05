# Wanderers — Story State Validation Rules v0.2

## Structural

- every state ID is stable;
- every character/faction/evidence ID is unique;
- every referenced flag exists in the story catalog;
- every consequence type exists in the consequence catalog;
- every event type exists in the event catalog;
- no narrative file declares an unregistered domain field.

## Semantic

- read conditions have no writes;
- every persistent character memory has a source event or authored narrative transition;
- every evidence discovery has a source event/node;
- every faction reputation mutation uses the faction consequence contract;
- every world mutation uses world consequence proposals;
- no duplicate evidence grants produce duplicate records;
- consequence application is idempotent where specified.

## Gameplay binding

For each narrative gate:

1. identify its state source;
2. identify the authoritative owner;
3. identify how that state can change in gameplay;
4. verify that the producer event or consequence is registered.

## Impossible content diagnostics

The validator should report:

- gate references unknown state;
- consequence references unknown sink;
- evidence has no discovery source;
- character memory cannot be produced by any registered event/node;
- faction gate reads a value that no system can mutate;
- story branch depends on an unsupported gameplay capability.

## Scope rule

A missing capability is a design gap, not something to silently simulate with a flag.
