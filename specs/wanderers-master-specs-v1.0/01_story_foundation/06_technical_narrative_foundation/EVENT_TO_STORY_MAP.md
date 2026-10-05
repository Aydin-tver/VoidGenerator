# Wanderers Story — Event to Story Map

## Purpose

Canonical mapping between gameplay facts and narrative uses. Events are facts, never commands.

## Event matrix

| Event | Producer | Narrative meaning | Typical objectives | Typical consequences |
|---|---|---|---|---|
| `flight.entered_region` | Flight | player arrived | reach region, search, intercept | story progress, encounter activation |
| `station.docked` | Station | player returned/arrived | meet NPC, deliver, investigate | dialogue, mission completion |
| `combat.started` | Combat | conflict began | survive/engage | branch setup |
| `combat.victory` | Combat | encounter won | defeat target | evidence, reputation, world state |
| `combat.retreat` | Combat | player escaped/withdrew | survive, retreat | failure branch, trust/reputation |
| `scan.discovery_completed` | Scan | player learned something | identify/search | evidence, mystery progress |
| `cargo.salvaged` | Salvage | object recovered | recover cargo/evidence | inventory/evidence/follow-up |
| `trade.completed` | Trade | transaction happened | buy/sell/deliver | economic/faction state |
| `convoy.detected` | Convoy | convoy entered awareness | locate convoy | mission activation |
| `convoy.escort_tick` | Convoy | escort state advanced | protect convoy | progress |
| `convoy.protected` | Convoy | convoy survived | complete escort | faction/world consequences |
| `convoy.destroyed` | Convoy | convoy lost | failure state | faction/world consequences |
| `thread.resonance_detected` | Thread system | anomaly detected | investigate resonance | mystery/evidence/story |
| `faction.reputation_changed` | Faction | reputation changed | observe gate | access/dialogue/mission gating |
| `world.consequence_changed` | World system | persistent state changed | observe changed world | future content |
| `stealth.passed` | Stealth gameplay | stealth action succeeded | pass threat | branch where supported |
| `mobility.escaped` | Mobility gameplay | escape action succeeded | escape | branch where supported |

## Event consumption rules

1. A story may consume only catalogued event types.
2. An event does not itself change story state unless a narrative rule consumes it.
3. An event does not directly mutate faction/economy/world state.
4. Mission-critical events must be deterministic/idempotent.
5. Stable entity IDs must be used for lifecycle entities.
6. A new event requires a catalog entry and fixture before production content may depend on it.

## Event composition patterns

### Reach-and-investigate

`flight.entered_region -> scan.discovery_completed -> station.docked`

### Escort

`convoy.detected -> convoy.escort_tick -> combat.victory/retreat -> convoy.protected/destroyed`

### Recover evidence

`flight.entered_region -> combat.victory -> cargo.salvaged -> station.docked`

### Mystery

`flight.entered_region -> thread.resonance_detected -> scan.discovery_completed -> narrative choice`

### Economic faction story

`station.docked -> trade.completed -> faction.reputation_changed -> future mission gate`

## Forbidden patterns

- `startMission()` as an event;
- `changeFactionReputation()` as an event;
- arbitrary story commands hidden inside gameplay events;
- per-frame events for mission progression;
- UI text in domain event payloads.
