# Dialogue State Machine v0.7

## States

```text
LOCKED
AVAILABLE
ACTIVE
CHOICE
RESOLVED
REVISIT
EXPIRED
```

## Transition examples

```text
LOCKED
  → evidence acquired
AVAILABLE
  → player initiates
ACTIVE
  → NPC/player exchange
CHOICE
  → player selects response
RESOLVED
  → effects accepted
REVISIT
  → same NPC later, different context
```

## Revisit principle

The second meeting must not replay the first meeting verbatim.

Example:

First:
> Lena asks whether the route correction should be reported.

Later:
> Lena reacts to the player's earlier decision.

## Availability contract

Every dialogue definition should identify:

```text
dialogue_id
speaker
station
availability
priority
fallback
nodes
effects
follow_up
```

If multiple dialogues are available, priority resolves which one is shown first.

## Fallback

There must be a safe fallback for every recurring NPC.

A player should never reach a named NPC and receive a broken/no-content state.
