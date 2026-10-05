# 15-Minute Vertical Slice — Implementation Contract

The first playable session should demonstrate the complete product loop without requiring the player to understand the whole universe.

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

## Exit criteria

- No dead-end state after combat, event, jump or docking.
- Every reward shown to the player matches the actual mutated state.
- A fresh install can complete the loop without external instructions.
- Save/load preserves fuel, discovery, location, cargo, upgrades and progression.
