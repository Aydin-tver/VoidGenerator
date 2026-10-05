# Ferrum State Contract

Recommended authoritative state domains:

```dart
PlayerState
InventoryState
EquipmentState
SkillState
FactionState
NpcState
EconomyState
WorldState
MissionState
ExplorationState
EvidenceState
```

Narrative state references these domains but does not duplicate them.

## Event examples

```text
convoy.detected
route.correction_discovered
evidence.acquired
evidence.correlated
npc.informed
faction.reacted
market.changed
world_state.changed
mission.completed
mission.failed_forward
```
