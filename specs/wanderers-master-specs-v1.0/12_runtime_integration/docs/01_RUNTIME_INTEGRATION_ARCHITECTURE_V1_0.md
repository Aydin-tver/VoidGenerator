# Runtime Integration Architecture v1.0

## Goal

Integrate the Stage 11 Vertical Slice Content Pack with the real Wanderers/Void Event runtime without duplicating authoritative game state.

```text
Gameplay systems
    ↓
Domain events
    ↓
Void Event / Narrative Runtime
    ↓
Host Adapter
    ↓
Wanderers authoritative state
    ↓
UI / missions / dialogue
```

## Ownership

Narrative Runtime owns:
- narrative node progression;
- active mission projection;
- dialogue progression;
- evidence acquisition state;
- narrative flags defined by the narrative domain.

Wanderers remains authoritative for:
- credits;
- cargo;
- modules;
- ship state;
- combat;
- travel;
- trade;
- reputation if already owned by the faction/domain system.

## Hard rule

Narrative code must never create a second authoritative copy of gameplay state.

## Integration modes

### Shadow
Observe real events and compare expected narrative results.

### Controlled
Narrative may request adapter operations, while the host remains authoritative.

### Full
Approved adapter operations are authoritative through the host contract.

Stage 12 target: Shadow → Controlled for the vertical slice.
