# Knowledge Gameplay Model v1.0

Knowledge is an active gameplay resource.

## Knowledge item

```text
knowledge_id
subject
content
source
reliability
confidence
contradictions
location
related_factions
related_npcs
unlock_conditions
```

## Player knowledge states

UNKNOWN
→ HEARD
→ SUSPECTED
→ CORROBORATED
→ CONFIRMED
→ INTERPRETED

The game should distinguish:
- what is true,
- what the player believes,
- what an NPC believes,
- what a faction publicly claims.

## Contradiction rule

When sources disagree, the game should not automatically resolve the contradiction unless the player has a capability or evidence chain that justifies it.

## Knowledge can unlock

- destinations
- mission approaches
- dialogue branches
- faction access
- economic opportunities
- secrets
- equipment uses
- alternative conclusions
