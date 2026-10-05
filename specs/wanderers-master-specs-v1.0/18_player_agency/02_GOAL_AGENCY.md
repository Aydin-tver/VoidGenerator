# Goal Agency v1.0

## Objective

Players should be able to create objectives from information rather than only accepting authored quest objectives.

## Goal sources

- NPC request
- rumor
- discovered evidence
- contradiction
- economic opportunity
- faction conflict
- personal curiosity
- equipment discovery
- unexplored location
- previous consequence

## Goal lifecycle

```text
OBSERVATION
→ INTEREST
→ HYPOTHESIS
→ GOAL
→ PLAN
→ ACTION
→ RESULT
→ REASSESSMENT
```

## Player-created goal examples

Instead of:
> "Go to Ferrum and scan the relay."

Player may discover:
> "Tidari says the route was changed by OmniCorp, but the registry has no matching signature."

Possible self-generated goals:
- verify the registry
- ask OmniCorp
- ask Tidari why the claim exists
- investigate Ferrum
- sell the information
- ignore it
- use it to gain faction leverage

The game may suggest possibilities, but must not require a single interpretation.

## Goal data

```text
goal_id
origin
subject
player_intent
known_information
assumptions
desired_outcome
risk_tolerance
chosen_approach
status
```
