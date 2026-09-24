# VoidGenerator — Void Event Engine

Standalone, host-neutral Dart package (`void_event_engine`) providing the event/mission/consequence/journal/branching-narrative runtime for the Wanderers of the Void game. The game itself lives in a separate repo (`C:\dev\Wanderers`, Flutter) — this package must stay game-agnostic: no Flutter imports, no `space_rpg_mvp`/Wanderers imports, no domain rule logic in the engine.

## Environment / commands

- `dart` is **not on PATH** in PowerShell on this machine; use `C:\flutter\bin\dart.bat` (Dart 3.13.4) or open a shell where it resolves.
- Run `dart pub get` first (only dev dependency: `test`).
- Run `dart analyze` before trusting `dart test` (an analyzer error fails every test at load time, not just the affected suite).
- Single test file: `dart test test/narrative_authoring_test.dart`.
- Validation CLIs (all exit 1 on errors, 64 on bad usage):
  - `dart run bin/validate_missions.dart [dir=examples] [events.catalog.json]`
  - `dart run bin/validate_narratives.dart <story.json> [events.catalog.json] [vocabulary.catalog.json]`
  - `dart run bin/validate_narrative_authoring.dart <authoring.json> [events.catalog.json] [vocabulary-or-consequences.catalog.json]`

## Known issues at time of writing (verify with `dart analyze`, they may be fixed)

- `pubspec.yaml` SDK constraint is `>=3.3.0` but `lib/src/session/session_snapshot.dart` was previously written against newer SDKs — keep an eye on the constraint when touching that file.
- Git: the repo was synced from the vendored copy in Wanderers (`C:\dev\Wanderers\packages\void_event_engine`); that copy is the integration source of truth for engine API changes (see `docs/WANDERERS_INTEGRATION_SPEC_0_18.md`, "Integration branch policy").

## Structure

- Barrel file: `lib/void_event_engine.dart` exports everything. Any new `lib/src/` module must be added to it.
- Two similarly named shadow-run modules — check which you mean before editing: `lib/src/adapter/shadow_run.dart` (host-adapter side) vs `lib/src/shadow/shadow_run.dart` (core engine).
- Content contracts live at repo root: `events.catalog.json`, `effects.catalog.json`, `vocabulary.catalog.json`; JSON Schemas in `schema/`; deterministic test samples in `fixtures/`; authored missions in `examples/`.
- `docs/` contains per-version design docs; `ARCHITECTURE.md` and `AI_WORKFLOW.md` are the binding rulebooks. Latest design state: `docs/NARRATIVE_AUTHORING_0_17.md`, `docs/WANDERERS_INTEGRATION_SPEC_0_18.md`.

## Binding content rules (from `docs/AI_WORKFLOW.md` — enforced by validators)

- Never invent event/effect/consequence types not in the catalogs. A new type needs: catalog entry + payload schema + fixture + consumer test, in a separate change, before content uses it.
- IDs are immutable once released; version the definition instead. Narrative node/choice IDs follow the declared stable prefix (`act02.kairos.signal.node.*`).
- No executable code/expressions in JSON; never use localized text as a gameplay identifier; never use per-frame/tick events for mission progression (emit semantic events like `convoy.escort_tick` instead).
- Events are facts, not commands: name them after the fact (`scan.completed`), never `startMissionX()`.
- Authoring units declare `owner.agentId`; do not silently modify another agent's owned content unit or reuse deleted IDs.
- Every mission objective needs a deterministic completion event; player-facing objectives need a location key or clue key.

## Verification order for content changes

1. `dart analyze` (must be clean)
2. `dart test`
3. Run the relevant `bin/validate_*.dart` CLI against the changed JSON
4. Add/update a fixture for non-linear or critical behavior
