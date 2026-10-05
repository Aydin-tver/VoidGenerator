# AI Authoring Rules v0.9

## Purpose

AI may accelerate content production but must operate inside the technical and lore contracts.

## AI must NOT invent

- unsupported gameplay mechanics;
- events absent from the event catalog;
- faction state not owned by a domain;
- NPC schedules;
- station interiors;
- new canon without approval;
- unexplained consequences;
- arbitrary IDs already in use.

## AI workflow

```text
1. Read capability bible
2. Read canon
3. Read relevant faction/character/station specs
4. Read event catalog
5. Select existing gameplay capabilities
6. Draft content
7. Generate stable IDs
8. Validate references
9. Validate lore
10. Produce dependency report
```

## Content request must specify

```text
content_type
story_act
station
factions
characters
gameplay_capabilities
required_evidence
allowed_effects
tone
desired_branching
```

## AI output

AI should produce:
- JSON;
- localization entries;
- dependency list;
- validation notes;
- unresolved questions.

Never silently resolve an unknown canon fact.

## Safety against lore drift

If a requested detail is absent from canon:
```text
STATUS: CANON_GAP
```

Then propose a candidate addition separately.
