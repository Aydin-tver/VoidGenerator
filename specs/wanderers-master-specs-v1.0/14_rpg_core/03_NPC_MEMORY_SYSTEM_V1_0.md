# 03 — NPC Memory System v1.0

## Purpose

Make recurring characters remember meaningful player history.

## Memory record

```json
{
  "character_id": "lena_voss",
  "trust": 35,
  "met": true,
  "helped": ["msr01"],
  "withheld": ["route_amendment"],
  "known_evidence": ["route_correction_unsigned"],
  "open_requests": ["lena_followup_01"]
}
```

## Memory categories

### Interaction
met, spoke, helped, refused.

### Choice
reported, withheld, lied, disclosed.

### Evidence
what the NPC knows the player possesses.

### Relationship
trust, suspicion, respect, dependence.

### Opportunity
requests, offers, warnings, introductions.

## Reaction levels

L0 static
L1 mission completion remembered
L2 choice remembered
L3 faction/world state remembered
L4 relationship changes
L5 new opportunity or obstruction

## Rules

- Do not simulate full NPC lives.
- Remember player-relevant facts.
- Memory updates are event-driven.
- Repeated dialogue must not erase history.
- One-time reactions require idempotent effect keys.

## Example

Player withholds registry evidence.

Later:

Lena:
"I heard you found something at Solaris."

If trust is low, she may ask indirectly.
If trust is high, she may ask directly.
If the evidence became public, her context changes again.
