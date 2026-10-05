# Wanderers — Mission Content Integration v0.8

## Goal

Stage 9 converts the Solaris → Ferrum → Nova vertical slice into a coherent production content package.

The package must prove that:

```text
Mission
  ↕
Dialogue
  ↕
Evidence
  ↕
Choice
  ↕
Character / Faction State
  ↕
Future Mission
```

## Authoritative ownership

Narrative content proposes narrative effects.

Host domains remain authoritative for:
- credits;
- cargo;
- equipment;
- combat;
- ship capability;
- faction reputation when owned by gameplay;
- world state when owned by gameplay.

Narrative runtime owns:
- story flags;
- evidence;
- character relationship context;
- narrative mission state;
- narrative consequences not duplicated elsewhere.

## Vertical slice

```text
MSR-01 Convoy Irregularity
    ↓
MSR-02 Registry Report
    ↓
CHOICE C01
   ↙      ↘
REPORT   WITHHOLD
   ↓        ↓
MSR-03 Ferrum Anomaly
    ↓
MSR-04 Nova Interpretation
    ↓
MSR-05 SIGMA Signal / next lead
```

The branches reconverge but preserve different context.

## Required proof

The slice must demonstrate:
1. a mission can start from gameplay;
2. dialogue can gate/advance it;
3. evidence can alter later dialogue;
4. a choice creates observable downstream difference;
5. a later NPC remembers the choice;
6. failure does not corrupt narrative state;
7. save/load preserves all relevant state;
8. replay does not duplicate one-time consequences.
