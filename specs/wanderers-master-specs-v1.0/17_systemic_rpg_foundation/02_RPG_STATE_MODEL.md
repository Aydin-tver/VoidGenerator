# RPG State Model v1.0

## State layers

### PlayerState
- identity
- skills
- capabilities
- equipment capabilities
- reputation
- faction relations
- NPC relations
- knowledge
- evidence
- discovered locations
- active goals
- completed actions
- unresolved consequences
- economic assets

### NPCState
- disposition
- trust
- fear
- respect
- memory
- goals
- knowledge
- secrets
- faction affiliation
- relationships
- current availability
- reaction flags

### FactionState
- reputation
- trust
- rank
- influence
- internal alignment
- faction resources
- active conflicts
- unlocked privileges
- player obligations
- known player actions

### LocationState
- security
- prosperity
- faction influence
- traffic
- scarcity
- active conflicts
- discovered secrets
- available services
- local rumors

### WorldState
- global conflicts
- route states
- piracy
- security
- major faction influence
- economic pressures
- story state
- anomaly state
- world events

## Ownership rule

Every mutable state value must have one authoritative owner.

NarrativeRuntime may read and request changes through adapters, but must not maintain a shadow copy of:
- credits
- ship HP
- cargo
- installed modules
- combat state
- flight state
- authoritative faction economy

## State change contract

Every significant mutation should be representable as:

StateChange {
  change_id
  source_action
  target_domain
  target_id
  operation
  value
  reason
  timestamp_or_sequence
  idempotency_key
}

The same idempotency key must not apply the same consequence twice.
