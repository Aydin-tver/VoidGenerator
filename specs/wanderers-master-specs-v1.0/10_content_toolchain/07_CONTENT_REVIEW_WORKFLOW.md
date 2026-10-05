# Content Review Workflow v0.9

## Review gates

### Gate A — Technical
Can the game actually perform the required actions?

### Gate B — Schema
Does JSON satisfy the content schema?

### Gate C — References
Do all IDs resolve?

### Gate D — Narrative
Does the content advance character/story/evidence?

### Gate E — Canon
Does it contradict established canon?

### Gate F — Gameplay
Is there a real player action rather than pure exposition?

### Gate G — Persistence
Can save/load and replay preserve the intended state?

## Approval

```text
DRAFT
 ↓
TECH_REVIEW
 ↓
NARRATIVE_REVIEW
 ↓
QA
 ↓
APPROVED
 ↓
PACKAGED
```

Content cannot skip directly from AI draft to runtime.
