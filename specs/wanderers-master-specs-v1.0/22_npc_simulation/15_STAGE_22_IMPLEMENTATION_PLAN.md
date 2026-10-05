# Stage 22 Implementation Plan

## Phase 1
Implement:
- NPCState
- NPCMemory
- NPCGoal
- NPCRelationship
- NPCSecret
- NPCIntent

## Phase 2
Create deterministic event-driven reaction engine.

## Phase 3
Connect to:
- Faction Simulation;
- NarrativeState;
- Knowledge/Evidence;
- Skills;
- Equipment;
- Mission Runtime;
- Dialogue Runtime.

## Phase 4
Implement Nova, Tidari and Lena vertical slice.

## Phase 5
Replay QA.

Required simulations:
- loyalist;
- independent;
- information broker;
- covert investigator.

## Acceptance gate

Stage 22 passes when NPCs:
- remember specific player actions;
- have independent goals;
- can disagree with their faction;
- can generate requests;
- can change relationships;
- can conceal or reveal information;
- can react differently on revisits;
- affect future missions and world state.
