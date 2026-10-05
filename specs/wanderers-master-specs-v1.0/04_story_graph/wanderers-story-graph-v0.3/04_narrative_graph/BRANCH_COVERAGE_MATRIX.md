# Branch Coverage Matrix v0.3

## Branch dimensions

| Dimension | Early | Mid | Late | Ending |
|---|---|---|---|---|
| faction alignment | low | medium | high | high |
| character trust | low | medium | high | high |
| evidence/knowledge | low | high | high | high |
| ship capability | medium | high | high | high |
| world consequences | low | medium | high | high |
| player identity | hidden | emerging | explicit | resolved/ambiguous |

## Coverage rules
- Every major branch must converge into at least one later authored consequence or resolution.
- Branches may reconverge; reconvergence is preferable to exponential content growth.
- A choice without a represented consequence is a flavor choice, not a major branch.
- A branch may change information rather than world state when that is the intended design.

## Target structure
Use `branch -> consequence -> altered future context`, not `branch -> completely separate game`.
