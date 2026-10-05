# Wanderers Story State Foundation v0.2

Intermediate milestone 2 of the RPG narrative architecture.

## Purpose

Define the persistent narrative state required for a large RPG while preserving the Void Event Engine's engine-agnostic boundary and Wanderers' authoritative domain systems.

## Documents

- `01_state/STORY_STATE_MODEL.md`
- `01_state/CHARACTER_STATE_MODEL.md`
- `01_state/EVIDENCE_AND_THEORY_MODEL.md`
- `01_state/FACTION_STORY_STATE.md`
- `02_contracts/STORY_STATE_ADAPTER_CONTRACT.md`
- `02_contracts/CONSEQUENCE_CATALOG_V0_2.md`
- `02_contracts/GATING_MODEL.md`
- `03_validation/STATE_VALIDATION_RULES.md`

## Architectural rule

Narrative runtime orchestrates. Wanderers domain systems own authoritative gameplay state.

No story feature is considered complete until its read/write path can be mapped to real game systems and registered events/consequences.

## Next milestone

Build the full Story Bible v1 architecture: world canon, timeline, faction architecture, character architecture, main acts, mystery architecture and ending model — each with explicit technical bindings.
