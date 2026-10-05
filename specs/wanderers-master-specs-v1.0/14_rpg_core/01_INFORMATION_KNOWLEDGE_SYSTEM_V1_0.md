# 01 — Information / Knowledge System v1.0

## Purpose

Turn information into a gameplay resource.

The player should not receive the world's truth directly. They receive
sources, observations and interpretations.

## Knowledge states

```text
UNKNOWN
RUMORED
OBSERVED
SUSPECTED
CORROBORATED
CONFIRMED
CONTRADICTED
DISPROVEN
```

## Knowledge object

```json
{
  "id": "knowledge.route_amendment",
  "state": "OBSERVED",
  "sources": ["tidari.registry"],
  "related_factions": ["tidari", "omnicorp"],
  "related_locations": ["solaris", "ferrum"],
  "contradicts": [],
  "unlocks": ["mission.investigate_route"]
}
```

## Source hierarchy

1. Player observation
2. Physical/gameplay result
3. NPC statement
4. Faction record
5. Rumor
6. Player interpretation

The UI may distinguish confidence without exposing the final truth.

## Rules

- Rumor is not fact.
- NPC claims can be wrong.
- Faction records can be incomplete.
- Two independent sources can corroborate a hypothesis.
- Contradictions are valuable content, not errors.

## Player actions

The player may:
- collect information;
- compare information;
- ask an NPC;
- test a hypothesis through gameplay;
- ignore a clue;
- share information;
- withhold information;
- act on an unconfirmed hypothesis.

## Narrative effect

Information can unlock:
- missions;
- dialogue;
- discoveries;
- alternative approaches;
- faction opportunities;
- locations;
- evidence chains.

## Anti-GPS rule

Knowledge can reveal WHERE to go, but never through an omniscient quest
arrow. Navigation remains knowledge-based.
