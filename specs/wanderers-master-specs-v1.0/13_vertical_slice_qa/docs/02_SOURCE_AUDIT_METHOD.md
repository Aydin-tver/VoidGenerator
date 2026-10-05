# Source Audit Method v1.1

## Search order

1. Event bus / event catalog
2. Mission runtime
3. Narrative state / story state
4. Dialogue runtime
5. Save/load
6. Event journal / replay
7. Station state
8. Character/faction state
9. Host adapter
10. Existing tests

## Search terms

```text
EventBus
Event
Mission
MissionRuntime
Dialogue
StoryState
Evidence
Save
Load
Journal
Replay
Station
Faction
Character
Consequence
Effect
Adapter
```

## Evidence required for every integration claim

```text
SOURCE_PATH
SYMBOL
CURRENT_BEHAVIOR
TARGET_CONTRACT
CHANGE_REQUIRED
TEST
```

No source evidence = `SOURCE_PENDING`.

## Anti-hallucination rule

Do not infer an implementation from a documentation filename.
Do not infer an API from a JSON contract.
Do not invent a class because its conceptual name exists in the architecture.
