# 04 — Consequence Propagation System v1.0

## Purpose

Make choices propagate through the game.

## Consequence levels

```text
L1 dialogue
L2 mission availability
L3 reward/access
L4 NPC relationship
L5 faction state
L6 station/world state
L7 main-story context
L8 endgame state
```

## Propagation model

```text
PLAYER CHOICE
   ↓
IMMEDIATE EFFECT
   ↓
DOMAIN EVENT
   ↓
AUTHORITATIVE STATE
   ↓
NARRATIVE OBSERVER
   ↓
FUTURE GATE / REACTION
```

The narrative runtime does not become owner of credits, cargo, modules,
combat state or other authoritative gameplay state.

## Delayed consequence

Major choices should often have delayed effects.

Example:

```text
MSR-02: report evidence
 ↓
Tidari trust +10
 ↓
registry access later
 ↓
new evidence
 ↓
OmniCorp notices pattern
 ↓
different MSR-06 setup
```

## Failure

Failure must not automatically mean reload.

Possible outcomes:

- alternative mission;
- lost opportunity;
- changed relationship;
- new rumor;
- harder route;
- different evidence chain.

## One-time effects

Every persistent effect requires a stable idempotency key.
