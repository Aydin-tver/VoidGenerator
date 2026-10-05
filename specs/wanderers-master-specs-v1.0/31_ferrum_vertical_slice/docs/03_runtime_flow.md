# Runtime Flow

```text
Player Action
    ↓
Capability Check
    ↓
Authoritative Domain Action
    ↓
Domain Event
    ↓
Narrative Event Adapter
    ↓
Narrative State Update
    ↓
NPC/Faction/Economy/World Reaction
    ↓
Persisted State
    ↓
New Opportunities
```

## Rules

1. Narrative code never becomes a second authoritative inventory/economy/faction system.
2. Domain state is authoritative.
3. Narrative observes domain events.
4. Consequences are idempotent.
5. Re-entering a station must not duplicate effects.
6. Save/load must preserve state.
7. Unsupported capabilities must never silently succeed.
