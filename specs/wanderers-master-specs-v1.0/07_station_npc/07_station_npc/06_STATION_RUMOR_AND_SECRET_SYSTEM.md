# Station Rumor & Secret System v0.6

## Purpose
Make information discovery feel like exploration without adding artificial GPS.

## Information types

### Rumor
Unverified local claim.

### Lead
Actionable but incomplete information.

### Evidence
A concrete discovered fact with source/provenance.

### Interpretation
A conclusion derived from evidence.

### Secret
Information deliberately withheld by an actor.

## Example

```text
RUMOR
"Someone changed the convoy route."

↓ player investigates

LEAD
Registry record was amended.

↓

EVIDENCE
Amendment has no normal issuer signature.

↓

INTERPRETATION A
Administrative fraud.

INTERPRETATION B
Someone used an obsolete authority.

INTERPRETATION C
Automated process.
```

## Rule
NPCs must not all know the truth.

Each NPC gets:
- what they know;
- what they believe;
- what they hide;
- what they misunderstand.

## Navigation
A rumor can provide:
- station;
- region;
- route;
- actor;
- time window;
- cargo type;
- risk.

This becomes the game's natural navigation layer.
