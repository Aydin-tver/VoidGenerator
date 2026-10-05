# Performance & Runtime Polish v1.0

Systemic RPG depth must not compromise mobile performance.

## Rules

- simulate only relevant detail levels;
- aggregate distant entities;
- batch world updates;
- avoid per-frame narrative logic;
- use event-driven state changes;
- persist deltas;
- pool transient objects;
- keep simulation separate from rendering;
- instrument expensive systems.

## Debug metrics

Track:
- simulation tick duration;
- NPC updates;
- faction updates;
- economy updates;
- event queue size;
- narrative state updates;
- memory usage;
- frame time;
- dropped frames.

Target:
No systemic subsystem should create uncontrolled frame-time spikes.
