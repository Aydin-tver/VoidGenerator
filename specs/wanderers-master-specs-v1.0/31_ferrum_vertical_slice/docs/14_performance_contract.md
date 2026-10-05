# Performance Contract

Ferrum must be tested on mobile-class hardware.

## Measure

- frame time;
- simulation tick;
- event queue;
- NPC updates;
- faction updates;
- economy updates;
- narrative updates;
- memory;
- entity count.

## Rules

Distant simulation uses lower LOD.

Narrative logic is event-driven.

No expensive full-world scan every frame.

Transient FX are pooled.

The slice must remain playable while systemic simulation is active.
