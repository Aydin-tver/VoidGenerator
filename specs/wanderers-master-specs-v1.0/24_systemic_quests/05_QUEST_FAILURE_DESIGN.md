# Quest Failure Design v1.0

Failure must not automatically mean:

GAME OVER
or
RELOAD SAVE.

Possible consequences:
- NPC dies or leaves;
- faction loses trust;
- price increases;
- route becomes dangerous;
- evidence is lost;
- rival gains influence;
- new enemy appears;
- objective changes;
- recovery mission becomes available.

Failure creates history.

## Fail-forward rule

Whenever reasonable, failure should create a new playable state.

Example:

Player fails to protect a convoy.

Instead of:
`Quest failed → nothing happens`

Use:
`Convoy attacked → survivors arrive → investigation opens → merchant faction changes policy`.
