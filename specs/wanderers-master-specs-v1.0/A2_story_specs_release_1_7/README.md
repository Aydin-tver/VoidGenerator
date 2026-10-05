# Wanderers — Story Creation Specs (release-1-7)

Curated from `wanderers-release-1-7-code-spec.zip`.

## Purpose
This package contains the documents and schemas needed to DESIGN and AUTHOR the RPG story: canon, lore, story graph, missions, narrative branching, consequences, event contracts, authoring rules, persistence/replay, and representative story examples.

## Contents
- `01_lore/` — canon, lore bible, terminology, story graph, mission inventory.
- `02_gameplay_story/` — journey events and gameplay loop constraints relevant to narrative.
- `03_void_event_narrative/` — branching narrative, authoring, consequences, vocabulary, event catalog, persistence, integration.
- `04_schemas/` — machine-readable authoring/mission/event schemas.
- `05_story_examples/` — representative narrative units from the current engine.

## Intentionally excluded
Combat/rendering/Flame/UI/economy/ship implementation docs that do not define narrative content or narrative state.

## Recommended authoring order
1. LORE_CANON + LORE_BIBLE + TERMINOLOGY
2. STORY_GRAPH
3. MISSION_INVENTORY
4. BRANCHING_NARRATIVE + NARRATIVE_AUTHORING
5. CONTENT_TOOLCHAIN + schemas
6. EVENT_CONTRACTS + WORLD_CONSEQUENCES
7. Story examples as templates
8. PERSISTENT_JOURNAL / UNIFIED_PERSISTENCE when implementing save/replay

## Important
The package is a curated extraction, not a new design. Existing canon/content remains authoritative unless changed in the project's narrative master design.
