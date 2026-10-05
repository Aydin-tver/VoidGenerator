# Validation Error Catalog v0.9

## Hard errors

`E001` Duplicate ID
`E002` Missing required field
`E003` Invalid enum
`E004` Broken reference
`E005` Missing localization
`E006` Unsupported event
`E007` Unsupported effect
`E008` Circular hard prerequisite
`E009` Unreachable required content
`E010` Missing dialogue fallback
`E011` Invalid evidence dependency
`E012` Invalid station/character/faction reference

## Warnings

`W001` Orphan content
`W002` Repeated lore
`W003` Choice with no meaningful downstream difference
`W004` Long dialogue
`W005` Single-source critical revelation
`W006` Excessive exposition
`W007` Unused localization key
`W008` Branch imbalance

## Build policy

Any E-code fails the content build.

W-codes are reported and may be waived with an explicit review note.
