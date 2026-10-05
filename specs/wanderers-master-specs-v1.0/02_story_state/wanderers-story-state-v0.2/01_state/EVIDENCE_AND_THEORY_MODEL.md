# Wanderers — Evidence and Theory Model v0.2

## Purpose

Turn investigation into an actual gameplay-supported narrative system using existing scan, exploration, dialogue, mission and event infrastructure.

## Evidence lifecycle

```text
unknown
  ↓
rumor
  ↓
discovered
  ↓
corroborated / contradicted
  ↓
archived
```

`rumor` is optional and should not be treated as verified evidence.

## Evidence record

Required:

- stable ID;
- source ID;
- discovery method;
- topic tags;
- reliability classification;
- supporting/contradicting links;
- optional narrative text key.

## Discovery methods

Use only registered gameplay mechanisms, for example:

- scan discovery;
- mission completion;
- station dialogue;
- cargo/salvage discovery;
- thread resonance event;
- authored narrative choice.

A new discovery mechanism requires a new event contract before content uses it.

## Theory

A theory is a player-facing interpretation, not a world fact.

```json
{
  "id": "theory.sigma.origin",
  "supportedBy": [],
  "contradictedBy": [],
  "status": "plausible"
}
```

Theory status may be:

- `unformed`
- `plausible`
- `strong`
- `contradicted`
- `unresolved`

Do not automatically convert a theory into canon.

## Technical rule

Evidence acquisition must always be backed by a real event or narrative node transition. The evidence system never invents a discovery merely because a condition was evaluated.
