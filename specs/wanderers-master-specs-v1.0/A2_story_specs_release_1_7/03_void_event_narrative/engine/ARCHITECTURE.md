# Void Event Engine — architecture

## Goal

A standalone, engine-agnostic event/progression layer that can be embedded in Wanderers of the Void or extracted into a separate repository/package.

The key separation is:

**Game systems -> Events -> Mission/Event Engine -> Effects -> Game systems**

Combat, flight, trading, dialogue, exploration and NPC AI publish facts. They do not know which mission consumes those facts.

## 1. Events are facts, not commands

Example:

`convoy.detected { convoyId: "convoy.kairos_001", regionId: "kairos.outer_trade_corridor" }`

Not:

`startMissionConvoy()`

This prevents mission logic from leaking into combat/flight code.

## 2. Commands are separate

A command requests an action. The host game validates and executes it, then publishes facts.

Example:

`Command: scanTarget(convoy.kairos_001)`

becomes:

`Event: scan.completed { targetId: "convoy.kairos_001" }`

## 3. Event envelope

Every event should support:

- stable `type`;
- `version`;
- payload;
- tags;
- source system;
- entity id;
- sequence number;
- timestamp;
- correlation id;
- causation id.

The last three are important for debugging chains such as:

`mission -> combat -> salvage -> reputation -> world consequence`.

## 4. Event bus vs event journal

The bus is for immediate reactions.

The journal/store is for deterministic replay, save migration, debugging and analytics.

Do not make the bus itself the save system.

Recommended production flow:

`Game action -> domain event -> append journal -> dispatch subscribers -> project runtime state`

For a single-player game, the journal can initially be local and compact. It does not need MMO infrastructure.

## 5. Mission is a projection over events

A mission definition contains:

- prerequisites;
- steps/objectives;
- event conditions;
- counts;
- optional steps;
- informational navigation data;
- outcomes;
- declarative effects.

Runtime state contains only progress/state, never the whole mission definition.

This mirrors established data-driven approaches: SUQS keeps quest definitions static and runtime progress separate, while SimpleQuest uses an event bus and objectives that observe tagged events. citeturn0search0turn0search12

## 6. Why JSON

For this project, JSON should be the **canonical authored format** for missions and event contracts.

Reasons:

- AI can read/write it reliably;
- Git diffs are understandable;
- JSON Schema gives editor autocomplete and validation;
- it can be generated from spreadsheets/tools later;
- it is independent of Flutter/Flame;
- missions can be loaded by a future external mission editor.

This is not unusual: SUQS explicitly supports quests authored as JSON with schema-based editor validation. citeturn0search0

Do not put arbitrary Dart code, expressions or callbacks in JSON.

## 7. Recommended content split

Do NOT put all game logic into one mission JSON.

Use separate content contracts:

`events.catalog.json`
- event type
- version
- payload schema
- tags
- producer

`missions/*.json`
- mission structure
- conditions
- outcomes

`effects.catalog.json`
- supported effect types
- payload schema

`localization/*`
- player-facing text

`fixtures/events/*.json`
- deterministic event samples for AI/test validation

This makes the event layer reusable outside Wanderers.

## 8. Event taxonomy

Recommended namespaces:

`flight.*`
`combat.*`
`trade.*`
`cargo.*`
`ship.*`
`station.*`
`npc.*`
`convoy.*`
`exploration.*`
`thread.*`
`faction.*`
`story.*`
`world.*`
`mission.*`
`player.*`

Examples:

- `flight.entered_region`
- `flight.docked`
- `combat.started`
- `combat.victory`
- `combat.retreat`
- `cargo.item_acquired`
- `trade.completed`
- `convoy.detected`
- `convoy.escort_tick`
- `convoy.destroyed`
- `faction.reputation_changed`
- `thread.resonance_detected`
- `world.consequence_changed`

## 9. Avoid tick events as a default

Do not publish `flight.tick` every frame and let missions inspect it.

Instead expose semantic events:

`flight.entered_region`
`convoy.escort_tick`
`ship.heat_band_changed`
`scan.completed`

Continuous conditions can use a dedicated sampler later.

This keeps the event volume bounded and makes mission behavior deterministic.

## 10. Branching

The engine should support:

`prerequisite -> step -> outcome -> next step/mission`

Outcomes should be named, not only success/failure:

- `success`
- `retreat`
- `convoy_lost`
- `negotiated`
- `betrayed`
- `evidence_found`

This is more expressive for the planned RPG story.

## 11. Risk/reward integration

Missions should not calculate economy directly.

A mission emits an effect such as:

`economy.credit { amount: 420 }`

The host Economy system decides how that enters the ledger.

Likewise:

`faction.reputation { factionId: "free_merchants", amount: 4 }`

The faction system owns reputation rules.

The event engine orchestrates; domain systems own their rules.

## 12. Save model

Save:

- active mission ids;
- mission definition version;
- current step/progress;
- selected branch/outcome;
- relevant correlation ids if needed for recovery.

Do not serialize the Dart object graph.

When a mission definition changes, use explicit migration rules.

## 13. Scaling

For hundreds of missions:

- index subscribers by event type;
- only activate conditions for active missions;
- compile JSON conditions into immutable runtime objects;
- avoid scanning every mission on every event;
- unload inactive mission definitions if memory becomes relevant.

For thousands of events, use sequence numbers and a compact journal.

For procedural missions, allow generated definitions to use the same schema, but mark them with `source: procedural` and a lifecycle/expiry.

## 14. AI development model

The system is intentionally split into contracts so separate AI threads can work independently.

### Thread A — Event Contract Engineer
Owns:
- `events.catalog.json`
- payload schemas
- event naming/versioning

### Thread B — Mission Content Designer
Owns:
- `missions/*.json`
- no engine code

### Thread C — Mission Validator
Owns:
- schema validation
- semantic validation
- unreachable step detection
- missing clue/location detection
- reward/effect validation

### Thread D — Runtime Engineer
Owns:
- event bus
- journal
- mission runtime
- save/load

### Thread E — Game Adapters
Owns:
- combat -> events
- flight -> events
- trade -> events
- NPC -> events

### Thread F — Narrative/UX
Owns:
- localization keys
- clues
- sources
- mission readability

These threads can work in parallel because JSON contracts are the interface.

## 15. AI merge rule

AI must never silently invent a new event type.

If a mission needs `convoy.arrived` and the catalog does not define it:

1. propose the event contract;
2. add/update schema;
3. add fixture;
4. then author the mission.

Every new event should have at least one fixture and one consumer test.

## 16. Known implementation lessons

Unreal data tables and Gameplay Tags are a common data-driven approach for configurable gameplay; the important architectural idea is that gameplay code emits/handles semantic tags while configuration lives in data. citeturn0search10turn0search5

Unity's Open Project also separates event channels from game data and keeps quests/events as data assets. citeturn0search4

Ink demonstrates another useful principle: story content can be compiled to a runtime data format, while the runtime interprets the data. For Wanderers, JSON is preferable because missions must also interact with gameplay systems outside dialogue. citeturn0search9

Paradox has described mission scripting as a high-level representation of story state and events that drive progression; this is close to the intended role of the engine here. citeturn0search17

## 17. Final architectural rule

The mission engine must never become a second game engine.

It should answer only:

- Is this mission available?
- What event advances it?
- How much progress happened?
- What branch/outcome was produced?
- Which declarative effects should be requested?

The actual game remains the owner of combat, economy, movement, factions, world simulation and persistence.
