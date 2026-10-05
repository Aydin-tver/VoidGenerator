# Flame Boundary

Flame should remain responsible for real-time game presentation and component
lifecycle.

The narrative subsystem should not be implemented as a large tree of Flame
components.

Use:

```text
Flutter / Flame
   ↓
Game Systems
   ↓
Narrative Event Adapter
   ↓
Narrative Runtime
```

Flame's component system is designed for encapsulated visual/game behavior,
while game-level state can live in the `FlameGame`/World architecture. citeturn0search1turn0search2

Interactive Flame components can emit input events through the component event
APIs, but those UI events should be translated into semantic player actions
before narrative state changes. citeturn0search4
