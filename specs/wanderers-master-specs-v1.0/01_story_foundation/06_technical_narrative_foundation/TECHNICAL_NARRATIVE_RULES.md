# Wanderers Story — Technical Narrative Rules

## Rule 1 — Gameplay is authoritative

Narrative never becomes a second game engine.

## Rule 2 — Events are facts

Gameplay publishes semantic facts. Narrative consumes them.

## Rule 3 — Consequences are proposals

Narrative requests state changes. Host systems validate and apply them.

## Rule 4 — No invented mechanics

Every player action in a quest must map to a registered gameplay capability.

## Rule 5 — No invented event types

Every event dependency must exist in the canonical Event Catalog.

## Rule 6 — No invented consequence types

Every effect must exist in the Consequence Catalog.

## Rule 7 — Stable IDs

Content IDs, node IDs, choice IDs, event types and consequence types are stable contracts.

## Rule 8 — Failure is content

If the game can produce failure/retreat/loss events, narrative should use them as legitimate outcomes rather than requiring reloads.

## Rule 9 — No artificial GPS requirements

Narrative may provide clues, station/region information and informational navigation data. It must not require a universal quest-point/autopilot system that the design does not want.

## Rule 10 — Every major choice has a state representation

A major choice must influence at least one registered narrative/domain state, evidence item, future availability or world consequence.

## Rule 11 — Gameplay loop compatibility

Future content should strengthen at least two links in:

`route -> risk -> decision -> reward -> progression -> next route`

as required by the existing One Loop design.

## Rule 12 — Authoring before implementation

Narrative designers work from contracts. If content needs a new capability/event/consequence, that contract is proposed and implemented first.

## Rule 13 — Deterministic replay

Critical narrative branches must be reproducible from the same event/choice sequence.

## Rule 14 — Test every critical branch

Main-story branches, faction outcomes and ending conditions require deterministic fixtures.

## Rule 15 — Morrowind-depth through recombination

Do not increase narrative depth by inventing unsupported gameplay. Increase it by combining existing mechanics, information, characters, factions, evidence and consequences.
