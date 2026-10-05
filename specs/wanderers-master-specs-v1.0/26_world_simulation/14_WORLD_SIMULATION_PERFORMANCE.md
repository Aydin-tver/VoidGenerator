# World Simulation Performance v1.0

The simulation must be mobile-safe.

Rules:

- no full continuous simulation for distant actors;
- aggregate low-value entities;
- use regional summaries;
- process only meaningful state changes;
- use bounded queues;
- batch updates;
- persist deltas;
- avoid unnecessary object allocation;
- separate simulation from rendering.

Suggested LOD:

L0: player vicinity — detailed.

L1: active region — summarized actor simulation.

L2: known sector — aggregate economy/security/faction state.

L3: distant universe — statistical strategic state.

Promote entities to higher simulation detail only when relevant.
