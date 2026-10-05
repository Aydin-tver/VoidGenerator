# Wanderers — Faction Story State v0.2

## Authority split

Gameplay Faction system owns numeric reputation and any gameplay rules around it.

Narrative domain owns:

- faction arc progression;
- faction-specific story flags;
- discovered secrets;
- completed faction story milestones;
- narrative relationships between factions.

## State example

```json
{
  "factionId": "omnicorp",
  "arcStage": 3,
  "completedMilestones": ["registry_audit"],
  "flags": ["knows_player_identity"],
  "secrets": ["secret.karmacore_archive"]
}
```

## Inter-faction conflict

Do not create a separate political simulation unless gameplay requires it. Story consequences can update a small registered world/faction state that future missions read.

Example:

```text
convoy.destroyed
→ faction.reputation
→ world.consequence: trade_route_insecurity
→ future convoy mission availability
```

## Design rule

A faction choice is meaningful when it changes at least one future dialogue, mission, reward/access condition, world state or ending variable.
