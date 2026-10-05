# Wanderers — Story State Adapter Contract v0.2

## Purpose

Expose Wanderers domain state to the neutral Void Event Engine without coupling the engine to Wanderers classes.

## Required adapter responsibilities

The integration layer should provide read adapters for:

```text
StoryStateReader
EvidenceReader
CharacterStateReader
FactionStateReader
WorldStateReader
PlayerCapabilityReader
```

Each reader returns engine-neutral values.

## Suggested interface semantics

```text
readFlag(flagId) -> bool
readNumber(path) -> number?
readFact(factId) -> fact?
readEvidence(evidenceId) -> EvidenceView?
readCharacter(characterId) -> CharacterView?
readFaction(factionId) -> FactionView?
readCapability(capabilityId) -> bool
```

The exact Dart interface belongs in the Wanderers integration repository; this document is the contract, not an implementation.

## Writes

Use consequence sinks:

```text
StoryConsequenceSink
EvidenceConsequenceSink
CharacterConsequenceSink
FactionConsequenceSink
WorldConsequenceSink
```

Each sink validates proposals and mutates the authoritative repository/domain through existing application boundaries.

## Security/integrity rule

Narrative JSON must never receive a repository, service locator, Dart callback or arbitrary expression.
