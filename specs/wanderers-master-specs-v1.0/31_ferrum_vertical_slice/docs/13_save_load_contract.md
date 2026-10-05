# Save/Load Contract

Persist authoritative state only.

Required:
- player capabilities;
- equipment;
- faction state;
- NPC state;
- evidence state;
- economy deltas;
- world events;
- mission state;
- narrative state references.

After save/load:

- no duplicated rewards;
- no duplicated consequences;
- no lost evidence;
- no reset NPC memory;
- no reset faction reactions;
- no duplicated market changes.
