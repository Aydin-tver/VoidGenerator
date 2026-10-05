# Wanderers Story — Technical Narrative Audit v0.1

## Scope

Audit of release 1.7 story/narrative architecture against the requirement that all future RPG content must be implementable by the actual Wanderers gameplay and Void Event Engine.

## Confirmed strengths

- Semantic event architecture is already defined.
- Events are facts rather than commands.
- Mission runtime is separate from game systems.
- Narrative runtime is separate from authoritative game state.
- Consequences use proposals and host-owned sinks.
- Stable IDs and explicit dependencies are already required.
- Deterministic replay and validation are explicit goals.
- Existing gameplay events cover travel, docking, combat, scan, salvage, trade, convoy and Thread resonance.
- Journey events provide additional decision points within the travel loop.
- The one-loop design explicitly requires route/risk/decision/reward/progression/next-route integration.

## Gaps before large-scale RPG authoring

### Gap 1 — Capability catalog

The engine has event contracts, but narrative authoring needs a formal capability registry so authors cannot request unsupported mechanics.

### Gap 2 — Consequence catalog

The engine has a small initial consequence vocabulary. Full RPG story requires explicit contracts for story flags, evidence and character relationships.

### Gap 3 — Domain read adapters

The branching runtime deliberately leaves faction reputation, evidence, trust, capability and world-state resolution to the Wanderers adapter. These adapters must exist before complex story gating is authored.

### Gap 4 — Narrative fixtures

Critical story branches need deterministic fixtures covering success, failure, retreat, duplicate events and replay.

### Gap 5 — Content-to-gameplay traceability

Every narrative unit needs declared gameplay capabilities and technical dependencies.

## Recommended implementation order

1. Freeze capability IDs.
2. Add capability validation to narrative authoring.
3. Freeze consequence IDs for `story.flag`, `evidence.add`, `character.trust` and, if needed, `character.memory`.
4. Implement Wanderers read adapters for reputation/evidence/trust/capabilities.
5. Implement consequence sinks through authoritative systems.
6. Add deterministic narrative fixtures.
7. Migrate a small vertical slice.
8. Only then author the full RPG story bible and content matrix.

## Vertical slice requirement

Before large-scale content production, implement one technically complete story arc using only current gameplay:

`flight -> scan/convoy -> combat or retreat -> salvage/protection/loss -> docking -> dialogue -> evidence -> faction/story consequence -> future mission gate`.

The slice should prove that narrative depth can be achieved without adding unsupported gameplay.

## Decision

The story project should be treated as a data-driven narrative layer over Wanderers gameplay, not as a separate RPG simulation.
