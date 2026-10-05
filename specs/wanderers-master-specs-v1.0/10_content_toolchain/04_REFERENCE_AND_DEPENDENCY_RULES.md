# Reference & Dependency Rules v0.9

## Every reference must resolve

Examples:

```text
mission → dialogue
mission → evidence
dialogue → character
dialogue → station
choice → consequence
evidence → source
```

Missing reference = hard error.

## Dependency graph

```text
station
  ↓
character
  ↓
dialogue
  ↓
choice
  ↓
consequence
  ↓
mission
  ↓
evidence
  ↓
future content
```

The graph is not required to be acyclic globally because story content can intentionally revisit state.

However:
- definition dependencies must resolve;
- circular hard prerequisites are errors;
- mission availability loops must be explicitly marked.

## Orphan detection

Warn or fail when:
- mission is never reachable;
- dialogue is never referenced;
- evidence can never be acquired;
- character has no reachable dialogue;
- localization key is unused.
