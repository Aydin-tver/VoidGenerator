# Next after 0.17

## 0.18 — Wanderers Integration Branch

Do not expand the standalone engine indefinitely. Create a separate integration branch/release against the real Flutter source tree.

Required source:
- `pubspec.yaml`
- `lib/`
- `assets/`
- `test/`

Initial integration remains Shadow Mode. Legacy mission behavior remains authoritative.

## 0.18 integration layers

1. Event producer adapters: combat, scan, salvage, station, trade, convoy.
2. Mission adapter and shadow comparator.
3. Narrative adapter for StoryState.
4. Consequence adapters for WorldState, FactionState, CharacterState, Evidence and Economy.
5. Unified persistence adapter using the 0.15 coordinator.
6. Content pipeline that validates real Wanderers narrative assets.

## Migration sequence

`Convoy → Scan → Salvage → Station → Trade → Combat → Missions → Story → Evidence → World/Faction consequences`.

Each domain follows:

```text
Legacy → Shadow → compare → 0 mismatches → Modern authority
```

No legacy removal before deterministic shadow parity.

## 0.19 — Production migration hardening

- real save/load recovery;
- event journal persistence;
- crash-safe writes;
- deterministic replay;
- performance profiling on mobile;
- telemetry for shadow mismatches;
- schema migrations.

## 1.0 — Engine contract

Freeze public APIs, remove deprecated paths only after migration, document supported schema versions, and publish a clean integration guide.
