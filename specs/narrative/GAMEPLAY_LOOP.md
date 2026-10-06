# Gameplay Loop — контракты игрового цикла

> Слияние ONE_LOOP_DESIGN + JOURNEY_EVENTS_SPEC + VERTICAL_SLICE_15_MIN.

## 1. One-loop design contract

Every 5–15 minute session should repeatedly connect:

`route → risk → decision → reward → progression → next route`

- **route:** tap-to-move + Star Map jump graph;
- **risk:** danger-scaled combat + journey events;
- **decision:** movement, trade, event choices, quest choices;
- **reward:** credits, cargo, reputation, upgrades;
- **progression:** ship modules, reputation ranks, discovered systems;
- **next route:** new system and fuel-gated jump options.

Future content is rejected if it does not strengthen at least two links in this chain.

## 2. Journey Events (spec 1.0)

Non-combat events turn travel into a sequence of small decisions. They complement, not replace, combat encounters.

**Trigger:**
- The flight scene checks once per `encounterGraceSeconds`; combat gets the first roll.
- If combat does not trigger, a journey event may trigger; `journeyEventCooldownSec` prevents repetition.
- Events are modal and block docking/second triggers until resolved.

**Content contract** (`assets/data/journey_events.json`):
- `id`: stable unique identifier; `title`, `text`: localized-ready strings;
- `danger`: `any|low|mid|high|frontier`; `choices[]`: player decisions;
- effects: money, reputation, fuel, damage, or cargo.

**Design rules:**
- At least one choice must have no direct resource gain.
- Risky choices expose their consequence before selection.
- Damage can never reduce the player to zero through a random event.
- Cargo rewards are rejected when the hold is full (no silent deletion).
- Events must remain understandable without a tutorial.

## 3. 15-Minute Vertical Slice — implementation contract

1. Spawn at Solari with a working ship and 200 credits.
2. First hint teaches tap-to-move.
3. Player can dock, trade and inspect quests.
4. Leaving the station enables combat/event risk.
5. Combat rewards real rolled credits and loot; full cargo converts loot to credits.
6. Journey events offer at least one meaningful risk/reward decision.
7. Star Map exposes discovered/unknown systems, route edges and fuel-gated jumps.
8. A jump consumes fuel and creates a new flight scene.
9. Docking restores hull, shield and fuel.
10. The player finishes the slice with credits, cargo, reputation or a new route to pursue.

**Exit criteria:**
- No dead-end state after combat, event, jump or docking.
- Every reward shown to the player matches the actual mutated state.
- A fresh install can complete the loop without external instructions.
- Save/load preserves fuel, discovery, location, cargo, upgrades and progression.
