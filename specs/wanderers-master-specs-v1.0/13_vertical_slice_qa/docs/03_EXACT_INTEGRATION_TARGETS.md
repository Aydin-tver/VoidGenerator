# Exact Integration Targets

The following targets are required, but their source paths remain
`SOURCE_PENDING` until the actual repository is inspected.

| Target | Required source evidence | Desired result |
|---|---|---|
| Event catalog | SOURCE_PENDING | Stage 11 events resolve |
| Event producer: convoy | SOURCE_PENDING | MSR-01 progresses |
| Event producer: scan | SOURCE_PENDING | MSR-03 progresses |
| Event producer: docking | SOURCE_PENDING | MSR-04 progresses |
| Event producer: Thread resonance | SOURCE_PENDING | MSR-05 progresses |
| Mission runtime | SOURCE_PENDING | objectives/gates work |
| Dialogue runtime | SOURCE_PENDING | choices/effects work |
| Evidence state | SOURCE_PENDING | evidence persists |
| Consequence adapter | SOURCE_PENDING | effects are host-approved |
| Save/load | SOURCE_PENDING | narrative state persists |
| Event journal/replay | SOURCE_PENDING | effects idempotent |

## Required adapter boundary

```text
game systems
  ↓
canonical event
  ↓
narrative event mapper
  ↓
mission/dialogue runtime
  ↓
host adapter
  ↓
authoritative state
```
