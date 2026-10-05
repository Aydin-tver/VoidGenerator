# Wanderers — Content Toolchain Architecture v0.9

## Goal

Provide a repeatable pipeline for producing large amounts of RPG content without breaking runtime contracts.

```text
Author / AI
   ↓
Authoring Templates
   ↓
JSON Content
   ↓
Schema Validation
   ↓
Reference Validation
   ↓
Dependency Graph
   ↓
Narrative QA
   ↓
Build Content Pack
   ↓
Void Event / Wanderers Runtime
```

## Source of truth

Authored content is canonical JSON.

Markdown is:
- design documentation;
- authoring guidance;
- review material.

Runtime should consume validated content packs, not arbitrary Markdown.

## Content domains

```text
mission
dialogue
evidence
character
faction_context
station
consequence
localization
```

## Build rule

Invalid content never reaches the runtime content pack.

Build must fail on hard validation errors.

Warnings may be allowed but must be reported.
