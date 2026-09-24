# Void Event Engine 0.17.0

Standalone, host-neutral event, mission, consequence, persistence and branching narrative runtime for a future RPG integration.

## 0.17 — Narrative Authoring Contract

This release freezes a deterministic authoring envelope for parallel AI/human narrative development.

Highlights:
- explicit content ownership (`owner.agentId`);
- stable namespace and node/choice ID prefixes;
- explicit event, consequence and narrative dependencies;
- explicit localization key declarations;
- authoring contract schema and semantic validator;
- CI-friendly authoring validation CLI;
- merge rules and reproducible source metadata;
- authoring fixtures and tests.

The contract is intentionally game-neutral. Faction reputation, capabilities, world state, evidence and other domain-specific reachability remain the responsibility of the future Wanderers integration branch.

See `docs/NARRATIVE_AUTHORING_0_17.md` and `docs/NEXT_AFTER_0_17.md`.


## Wanderers 0.18 integration contract

See `docs/WANDERERS_INTEGRATION_SPEC_0_18.md` and `docs/HOST_ADAPTER_CONTRACT.md`. The standalone package remains game-agnostic; Wanderers integration uses Shadow authority by default.
