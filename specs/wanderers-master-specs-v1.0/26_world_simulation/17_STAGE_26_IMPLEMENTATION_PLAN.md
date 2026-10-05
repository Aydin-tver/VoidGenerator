# Stage 26 Implementation Plan

## Phase 1 — State
Implement:
- WorldState;
- WorldEvent;
- ActorState;
- RouteState;
- SecurityState;
- StationState.

## Phase 2 — Simulation
Implement:
- simulation tick;
- intention evaluation;
- action resolution;
- bounded queues.

## Phase 3 — Connections
Connect:
- NPC;
- faction;
- economy;
- security;
- piracy;
- routes;
- stations;
- exploration;
- missions.

## Phase 4 — Vertical Slice
Implement Ferrum Trade Corridor.

## Phase 5 — Persistence
Persist meaningful state deltas.

## Phase 6 — Observability
Add:
- simulation event log;
- causal trace;
- state diff;
- debug world inspector.

## Acceptance

- [ ] world actors have goals;
- [ ] actors have constraints/resources;
- [ ] actions have causes;
- [ ] routes react to economy;
- [ ] piracy reacts to opportunity;
- [ ] security reacts to threats;
- [ ] stations react to state;
- [ ] NPCs react to world;
- [ ] factions react to world;
- [ ] exploration feeds simulation;
- [ ] simulation creates missions;
- [ ] player actions create downstream effects;
- [ ] state is persistent;
- [ ] simulation is mobile-safe;
- [ ] causal chain is inspectable.
