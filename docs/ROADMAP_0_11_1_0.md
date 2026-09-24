# Void Event Engine Roadmap 0.11 → 1.0

| Release | Purpose | Wanderers integration |
|---|---|---|
| 0.11 | Validation + conflict resolution | No |
| 0.12 | Persistent consequence audit | No |
| 0.13 | Domain-neutral story/world vocabulary | No |
| 0.14 | Branching narrative runtime | No |
| 0.15 | Real Wanderers adapter branch | Separate release |
| 0.16 | Shadow migration coverage | Separate release |
| 0.17 | Legacy/modern authority switching | Separate release |
| 0.18 | Production persistence/performance hardening | Separate release |
| 1.0 | Stable engine API + completed migration path | Game-specific branch only |

## Parallel AI work model

Agents should work by isolated package boundary:

- `content-validation`: schemas, validators, fixtures;
- `runtime`: event/consequence runtime;
- `persistence`: journal/snapshot/audit;
- `narrative`: conditions and branching;
- `wanderers-adapter`: only after 0.15;
- `qa`: replay, determinism, mismatch fixtures.

No agent should directly edit another agent's domain without an explicit interface change.
