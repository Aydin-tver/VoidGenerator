# Wanderers Story — Gameplay Capability Bible

## Purpose

This document is the hard technical boundary for narrative design. Story content may only require gameplay capabilities that exist in the game or are explicitly approved as a small, separately tracked implementation feature.

## Core rule

> No narrative requirement may depend on an invented gameplay mechanic.

A narrative designer must express player action through registered gameplay capabilities and their semantic events.

## A. Confirmed capabilities from release 1.7

| Capability | Evidence / contract | Story use |
|---|---|---|
| Travel to region | `flight.entered_region` | arrival, search, interception, exploration |
| Station docking | `station.docked` | dialogue, mission turn-in, investigation |
| Combat | `combat.started`, `combat.victory`, `combat.retreat` | attack, defense, survival, escort |
| Scanning / discovery | `scan.discovery_completed` | investigation, clues, identification |
| Salvage | `cargo.salvaged` | recovery, evidence, resources |
| Trade | `trade.completed` | commerce, faction relations, economic stories |
| Convoy detection | `convoy.detected` | escort, interception, investigation |
| Convoy escort progress | `convoy.escort_tick` | protection over time |
| Convoy protection | `convoy.protected` | success outcome |
| Convoy destruction | `convoy.destroyed` | failure and consequences |
| Thread resonance | `thread.resonance_detected` | mystery progression |
| Faction reputation observation | `faction.reputation_changed` | gates and consequences |
| World consequence observation | `world.consequence_changed` | persistent world feedback |
| Stealth pass | `stealth.passed` | only where the existing gameplay implementation exposes it |
| Mobility escape | `mobility.escaped` | escape outcomes where supported |
| Journey event choices | journey event contract | short decisions during travel |
| Ship progression | modules/upgrades in existing gameplay | gated capabilities, progression |
| Fuel-gated route progression | One Loop / star map contract | access and progression |

## B. Narrative capabilities built from existing systems

These are not new gameplay mechanics. They are narrative compositions of existing capabilities.

### Investigation

`flight -> scan -> evidence -> docking -> dialogue`

### Escort

`flight -> convoy.detected -> convoy.escort_tick -> combat -> protected/destroyed`

### Recovery

`flight -> combat/salvage -> cargo.salvaged -> docking`

### Commerce

`docking -> trade.completed -> faction/world consequence`

### Mystery

`flight -> resonance/scan -> evidence -> narrative branch`

### Faction conflict

`mission choice -> existing gameplay event -> reputation/world consequence -> future content gate`

## C. Not currently safe to assume as gameplay

Unless separately implemented and registered, story specifications MUST NOT require:

- free-form dialogue skill checks;
- hacking gameplay;
- stealth movement through physical station interiors;
- walking through stations/cities;
- physical pickpocketing or inventory theft;
- diplomacy as a standalone simulation;
- social combat / persuasion minigames;
- autonomous NPC travel between locations;
- NPC schedules or daily routines;
- territorial conquest simulation;
- player-owned settlements;
- procedural political simulation;
- cinematic combat actions that do not exist in the combat system;
- arbitrary manipulation of economy, reputation or world state from narrative JSON.

A story may describe these concepts in lore, but the player action must map to available gameplay.

## D. Proposed adapter-level capabilities

These may be added without changing the core narrative architecture if the Wanderers host exposes authoritative state for them:

- character trust read/write;
- story flags;
- evidence acquisition;
- mission availability gates;
- station state flags;
- NPC relationship state.

These are narrative-state adapters, not new gameplay loops.

## E. Capability registration rule

Every new gameplay capability requires:

1. stable capability ID;
2. owning game system;
3. semantic event(s);
4. payload definition;
5. authoritative state owner;
6. test fixture;
7. narrative usage examples;
8. migration/versioning rule if an existing event changes.

## F. Quest authoring rule

Every production quest must declare its gameplay capabilities. A validator must reject a quest whose capability is not registered.

## G. Design philosophy

Morrowind-scale depth is achieved through combinations of existing mechanics, information, branching, persistent consequences and world-state changes—not by pretending the game has mechanics it does not have.
