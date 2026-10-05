# Stage 17 Implementation Plan

## Deliverables

### A. Runtime foundation
1. RPG state contracts
2. Action contract
3. Consequence contract
4. Capability query contract
5. State ownership rules
6. Idempotency rules

### B. Authoring foundation
1. Mission systemic contract
2. Knowledge schema
3. Faction requirements
4. NPC requirements
5. Discovery requirements
6. Economy requirements

### C. QA foundation
1. Agency Score
2. Systemic Density
3. Mission diversity matrix
4. State transition tests
5. consequence propagation tests
6. replay/idempotency tests

## Implementation order

1. Freeze authoritative state ownership.
2. Introduce generic PlayerAction.
3. Introduce generic Consequence.
4. Add Knowledge service.
5. Add capability queries.
6. Add agency scoring to content QA.
7. Add systemic density scoring.
8. Convert one existing vertical slice mission.
9. Validate save/load and replay.
10. Only then proceed to Stage 18.

## Acceptance criteria

Stage 17 is complete when:
- all RPG systems use a common action/consequence vocabulary;
- no narrative subsystem owns duplicate authoritative gameplay state;
- one mission demonstrates >= 3 approaches;
- one action produces >= 3 propagated consequences;
- one discovery creates a player goal without a quest marker;
- knowledge can be contradictory;
- state changes are idempotent;
- QA can calculate Agency Score and Systemic Density.
