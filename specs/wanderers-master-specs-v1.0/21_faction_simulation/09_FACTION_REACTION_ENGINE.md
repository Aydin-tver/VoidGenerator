# Faction Reaction Engine v1.0

Faction reactions are driven by state changes.

Inputs:
- player actions;
- mission outcomes;
- evidence exposure;
- equipment usage;
- economic changes;
- NPC relationships;
- faction conflict state.

Reaction levels:

0 Ignore
1 Notice
2 Monitor
3 Pressure
4 Reward / punish
5 Escalate
6 Structural response

Example:

Player sells sensitive cargo to rival faction.

OmniCorp:
Notice → monitor → restrict docking → pressure NPC contact.

Free Merchants:
reward → recruit → offer protected route.

The exact reaction depends on faction state, not a universal reputation number.
