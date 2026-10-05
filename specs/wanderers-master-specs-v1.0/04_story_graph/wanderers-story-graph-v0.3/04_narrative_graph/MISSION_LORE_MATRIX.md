# Mission ↔ Lore Matrix v0.3

## Production contract
Every major mission must declare:

| Field | Requirement |
|---|---|
| mission_id | stable ID |
| narrative purpose | one sentence |
| gameplay systems | minimum 2 for major missions |
| lore introduced | IDs |
| lore reinforced | IDs |
| lore contradicted | IDs, if any |
| characters | IDs |
| factions | IDs |
| mystery | IDs |
| evidence produced | IDs |
| choice | yes/no + choice IDs |
| consequences | registered consequence IDs |
| follow-up | next content IDs |

## Coverage rule
A major mission should normally perform at least two of:
- reveal a character;
- reveal/reframe lore;
- generate evidence;
- change faction state;
- change character relationship;
- create a future opportunity;
- expose a gameplay risk;
- resolve or escalate a mystery.

## Forbidden pattern
`travel -> dialogue -> reward` with no state, knowledge, conflict, or gameplay consequence is not a major RPG mission.
