# Stage 12 — Runtime Integration & Narrative Adapter v1.0

## Result

The boundary between authored RPG content and the real game runtime is now explicit.

The content pack does not own gameplay state.
The host does not own narrative definitions.
The adapter is the controlled bridge.

## Immediate implementation target

Integrate the vertical slice in this order:

```text
events
 ↓
evidence
 ↓
mission objectives
 ↓
dialogue gates
 ↓
consequences
 ↓
save/load
 ↓
replay
```

## Next stage

Stage 13 should be **Vertical Slice In-Game Implementation & QA v1.1**.

That stage should inspect the actual Wanderers repository and produce:
- exact source-file integration points;
- adapter implementation plan;
- event producer map;
- missing capability list;
- migration patches;
- automated tests;
- runtime QA checklist.
