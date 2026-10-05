# Vertical Slice Runtime Mapping v1.0

| Narrative requirement | Runtime event / operation | Authority |
|---|---|---|
| Convoy detected | `convoy.detected` | gameplay |
| Convoy escort progress | `convoy.escort_tick` | gameplay |
| Convoy protected | `convoy.protected` | gameplay |
| Registry interaction | dialogue + host context | narrative/host |
| Ferrum anomaly | `scan.discovery_completed` | gameplay |
| Compare sources | narrative gate | narrative |
| Cross-source evidence | `addEvidence` | narrative |
| SIGMA resonance | `thread.resonance_detected` | gameplay/event system |
| Future mission unlock | `unlockMission` | narrative |

## Missing implementation

The Stage 11 pack assumes the following adapter vocabulary:
- evidence.add
- story.flag
- character.trust/context
- mission.unlock
- station narrative context

If the current codebase uses different APIs, create a mapping layer.
Do not rename content IDs merely to fit implementation details.
