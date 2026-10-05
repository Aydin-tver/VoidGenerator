# Stage 16 — Runtime Integration v1.0

## Status

**SOURCE-INTEGRATION PACKAGE / PATCH-READY**

The current environment does not contain the actual Wanderers Dart repository.
Therefore this stage does NOT invent file paths, classes, or line numbers.

It provides concrete Dart contracts and implementation skeletons that should be
mapped onto the real repository once its source is attached.

## Goal

Connect the Stage 15 RPG vertical slice to the actual event-driven runtime.

## Architecture

```text
Gameplay
  ↓
Semantic Game Event
  ↓
Event Journal / Bus
  ↓
Narrative Observer
  ↓
Narrative State
  ↓
Mission / Dialogue Gates
  ↓
Host Adapter
  ↓
Authoritative Gameplay State
```

Flame's current architecture is compatible with this separation: `FlameGame`
is the game-loop/root component and a custom `World` can own world-level
gameplay components. citeturn0search1turn0search2

The narrative state should remain outside render components; Flame components
should consume state rather than become the owner of narrative truth.
