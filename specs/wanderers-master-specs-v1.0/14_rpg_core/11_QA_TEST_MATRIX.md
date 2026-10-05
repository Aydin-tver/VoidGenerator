# 11 — RPG Core QA Matrix

## Information

- rumor is not confirmation;
- contradictory sources are represented;
- independent evidence can corroborate;
- missing evidence does not soft-lock story.

## Factions

- reputation changes correctly;
- rank requirements work;
- rival reaction works;
- exclusive opportunity opens;
- incompatible choice closes the intended opportunity.

## NPCs

- memory survives save/load;
- repeated dialogue reflects state;
- one-time reactions are idempotent;
- NPC knows only permitted information.

## Consequences

- immediate effect works;
- delayed effect works;
- failure produces valid continuation;
- replay does not duplicate effects.

## World

- station state persists;
- revisit shows changed context;
- mission pool reacts;
- old dialogue does not incorrectly override new state.

## Equipment

- capability gate works;
- alternative capability works;
- insufficient capability produces valid alternative or failure;
- no unsupported gameplay is implied.
