# Wanderers — Branch & Convergence Specification v0.5

## Goal

Create meaningful branching without multiplying the entire content set exponentially.

## Branch layers

### Layer 1 — Local choice
Changes immediate relationship, reward, evidence or access.

### Layer 2 — Arc choice
Changes which faction/character content becomes available.

### Layer 3 — Interpretation choice
Changes what the player believes/which evidence is trusted.

### Layer 4 — End-state choice
Changes final faction/world/identity outcome.

## Branch pattern

```text
             ┌─ local consequence ─┐
MAIN THREAD ─┤                     ├─ CONVERGENCE
             └─ alternative path ──┘
                       ↓
                 new context
                       ↓
                 next mystery
```

## Convergence rules

- Choices should alter context, not necessarily require entirely separate campaigns.
- Two branches may share a location but have different reasons for visiting it.
- The same mission can produce different dialogue/evidence depending on state.
- Reused content must have changed meaning when possible.
- A branch that changes nothing observable is not a meaningful branch.

## Hard validation

For each choice:
- state changed;
- future content can read that state;
- player can observe at least one consequence;
- no impossible prerequisite is created.

## Anti-explosion rule

Do not create:

```text
A/B
 → A1/A2/B1/B2
 → 8 separate campaigns
```

Prefer:

```text
A/B
 ↓
different state
 ↓
shared investigation
 ↓
different interpretation
 ↓
different final state
```
