# Stage 23 Implementation Plan

## Phase 1
Implement:
- DialogueAction
- DialogueContext
- DialogueRequirement
- DialogueOutcome
- DialogueMemoryEvent

## Phase 2
Connect dialogue to:
- NPC Simulation;
- Faction Simulation;
- Knowledge/Evidence;
- Skills;
- Equipment;
- Mission Runtime.

## Phase 3
Implement:
- persuasion;
- negotiation;
- deception;
- information trading;
- favors/debts.

## Phase 4
Rebuild Nova/Tidari/Lena conversations around actions rather than linear choices.

## Phase 5
Replay QA.

Required playthroughs:
- honest investigator;
- negotiator;
- deceiver;
- faction loyalist;
- independent information broker.

## Acceptance gate

Stage 23 passes when:
- dialogue can create persistent state;
- information is asymmetric;
- NPC memory affects future dialogue;
- persuasion has graded outcomes;
- deception can be detected later;
- favors/debts persist;
- skills and equipment create meaningful options;
- faction pressure affects dialogue;
- branches can converge without losing consequences.
