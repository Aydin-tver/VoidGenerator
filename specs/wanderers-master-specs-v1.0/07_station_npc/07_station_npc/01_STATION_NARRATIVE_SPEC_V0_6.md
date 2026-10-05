# Wanderers — Station Narrative Specification v0.6

## Purpose
Stations become small RPG locations without requiring a walkable station interior.

A station is represented through:
- station identity;
- faction presence;
- recurring NPCs;
- services;
- local conflicts;
- rumors;
- evidence;
- mission hooks;
- consequences;
- changing dialogue/context.

## Station identity model

Each station needs:
1. economic function;
2. faction identity;
3. local problem;
4. social atmosphere;
5. recurring characters;
6. rumor network;
7. one hidden layer;
8. main-story connection;
9. gameplay services;
10. state-dependent changes.

## No fake simulation
Do not invent autonomous NPC schedules, station walking, crowds or political simulation unless those systems exist.

"Living station" is achieved through changing information, characters, missions and consequences.

## Station interaction layers

### Layer 1 — Functional
Trade, ship, repairs/upgrades, departure, available missions.

### Layer 2 — People
Named NPCs with persistent relationship/context.

### Layer 3 — Information
Rumors, registry information, local knowledge, clues.

### Layer 4 — Conflict
Two actors want different outcomes.

### Layer 5 — Mystery
A local anomaly connects to the larger story.

## Station state

```text
normal
under_pressure
faction_conflict
shortage
security_alert
story_changed
```

State must be backed by authoritative world/domain state or explicit narrative state.

## Knowledge-based navigation
Stations provide information that can identify:
- destination;
- region;
- approximate route;
- risk;
- required capability.

Do not require artificial quest markers.
