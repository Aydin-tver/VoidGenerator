# What to do next in Wanderers of the Void

## Recommended order

### A. Freeze the event contract
Before adding many missions, approve namespaces and payload conventions. Existing types should remain semantic and stable; avoid per-frame events.

### B. Build the content toolchain
The next standalone milestone is 0.3: catalog loader, condition compiler, graph validator, effect catalog, fixtures and simulator CLI.

### C. Add publishers in Wanderers
Each domain owns its facts:
- Flight -> `flight.*`
- Station -> `station.*`
- Combat -> `combat.*`
- Trade -> `trade.*`
- Salvage -> `cargo.*`
- Convoy -> `convoy.*`
- Scan -> `scan.*`
- Faction -> `faction.*`
- World -> `world.*`

Mission code must not reach into those domains to ask how they work.

### D. Shadow migration
Run legacy `GameplayMissionUseCase` and the event engine simultaneously. Do not award twice. Compare only:
- objective progress
- completion/failure
- selected outcome
- reward/effect payload

### E. Migrate mission families
1. convoy
2. combat
3. salvage/trade
4. docking/station
5. scan/exploration
6. story/consequence missions
7. repeatable contracts

### F. Extend the same backbone carefully
After mission migration, event consumers can support evidence, achievements, codex, world consequences and analytics. Keep each consumer read-only unless it owns an explicit effect handler.

## AI parallel-development contract

Each AI thread owns one layer:
- Event Contract: event catalog/schema only.
- Runtime: engine code/tests only.
- Content: mission JSON only.
- Validation: validator/fixtures only.
- Adapter: Wanderers publishers/migration only.
- UX: localization/clues/source keys only.

A thread must not invent a new event type while editing a mission. If a fact is missing, change the event contract first and add a fixture.
