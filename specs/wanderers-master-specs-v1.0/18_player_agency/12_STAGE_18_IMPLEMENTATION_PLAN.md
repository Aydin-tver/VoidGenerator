# Stage 18 Implementation Plan

## Phase 1 — Contracts

Implement/align:
- PlayerGoal
- PlayerAction
- PlayerApproach
- AgencyResult
- RiskProfile
- PlayerIdentitySignal

## Phase 2 — Goal layer

Add:
- goal creation from information
- goal persistence
- goal abandonment
- goal completion
- goal transformation

## Phase 3 — Approach layer

Every major action should expose:
- requirements
- cost
- risk
- expected information gain
- possible consequences

## Phase 4 — Consequence branching

Implement:
- success
- partial success
- failure with information
- failure with consequence
- delayed consequence

## Phase 5 — Vertical slice

Convert the existing Convoy/Ferrum chain.

## Phase 6 — QA

Measure:
- Agency Score
- Systemic Density
- number of viable approaches
- number of meaningful outcomes
- number of propagated consequences

## Acceptance gate

Stage 18 passes when the vertical slice allows:
- 3+ practical approaches;
- player-created investigation objective;
- meaningful abandonment;
- partial success;
- delayed consequence;
- NPC/faction reaction;
- different future opportunities;
- no GPS requirement.
