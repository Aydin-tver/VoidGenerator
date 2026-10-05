# Simulation Tick v1.0

Simulation should run in bounded steps rather than simulating every entity continuously.

Suggested cycle:

1. collect world pressures;
2. update resources;
3. evaluate faction priorities;
4. evaluate NPC goals;
5. generate candidate actions;
6. resolve conflicts;
7. update routes/security/economy;
8. create events;
9. expose relevant events to player;
10. persist state.

Simulation frequency can differ by subsystem.

High-frequency:
- current combat/security encounter.

Medium-frequency:
- station activity;
- route security;
- market state.

Low-frequency:
- faction strategy;
- long NPC goals;
- regional political/economic shifts.

Mobile performance is a hard constraint.
