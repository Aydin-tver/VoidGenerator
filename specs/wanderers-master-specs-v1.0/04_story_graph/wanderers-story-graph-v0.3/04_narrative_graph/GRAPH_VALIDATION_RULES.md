# Narrative Graph Validation Rules v0.3

## Hard errors
- duplicate stable ID;
- missing referenced ID;
- unreachable major mission;
- dead-end major branch without intentional ending/resolution;
- consequence with no authoritative owner;
- gate referencing non-existent state;
- mission requiring unsupported gameplay capability;
- lore fact with no reveal path;
- major character with no mission/story relationship;
- major faction with no story or gameplay relationship.

## Warnings
- mission touches only one system;
- character appears in too many disconnected locations;
- lore fact repeated without changed perspective;
- branch creates no measurable consequence;
- act has only one faction active;
- mystery has only one evidence source;
- station has no local conflict or narrative hook.

## Review output
Validator should report:
`ERROR`, `WARNING`, `INFO` plus stable IDs and exact edge/reference causing the finding.
