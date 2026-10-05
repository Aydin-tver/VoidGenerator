# NPC Simulation → Dialogue Gameplay Handoff

Dialogue should query NPC state.

Before presenting important dialogue:

1. Load NPC state.
2. Determine relevant memories.
3. Determine current goal.
4. Determine available knowledge.
5. Determine relationship.
6. Determine faction pressure.
7. Determine possible lies / omissions.
8. Generate allowed dialogue branches.

Dialogue must not overwrite authoritative NPC state directly.

Conversation outcomes emit events such as:

- npc.trust_changed
- npc.secret_revealed
- npc.promise_created
- npc.relationship_changed
- npc.goal_changed
- npc.mission_requested
