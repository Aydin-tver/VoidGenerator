# Content Traceability Matrix v0.3

## Required chain

```text
CAPABILITY
  ↓
EVENT
  ↓
MISSION / NARRATIVE NODE
  ↓
CHOICE (optional)
  ↓
CONSEQUENCE
  ↓
AUTHORITATIVE STATE
  ↓
GATE / FUTURE CONTENT
  ↓
EVENT
```

## Example

```text
convoy.escort_tick
  ↓
mission: convoy anomaly investigation
  ↓
choice: report / conceal
  ↓
faction.reputation OR evidence.add
  ↓
FactionState / EvidenceState
  ↓
future dialogue / mission availability
```

## Validation questions
1. Does every gameplay event used by content exist in the event catalog?
2. Does every consequence exist in the consequence catalog?
3. Is the authoritative owner of the changed state known?
4. Can the future gate read that state through an adapter?
5. Can the branch be tested deterministically?
6. Is the result visible through gameplay, information, access, relationship, or world response?

## Forbidden
- direct mutation of arbitrary domain state from narrative JSON;
- invented event names;
- invented gameplay capabilities;
- text-only claims that a world state changed when no state exists;
- mission completion dependent on per-frame or unstable events.
