# Evidence-Aware Dialogue v0.7

## Principle

NPC dialogue reacts to what the player actually knows.

Example evidence:

```text
evidence.route_correction_unsigned
evidence.registry_timestamp_conflict
evidence.ferrum_scan_anomaly
```

## Evidence states

```text
UNKNOWN
KNOWN
PRESENTED
DENIED
CORROBORATED
CONTRADICTED
```

## Example

Without evidence:
> "The route changed. Registry probably made an error."

With unsigned correction:
> "That's not a normal registry correction."

After Ferrum scan:
> "So it wasn't only paperwork. Something produced the same pattern here."

## Important rule

Evidence does not automatically equal truth.

A player can possess evidence and still have multiple interpretations.

## Dialogue consequences

Presenting evidence may:
- unlock investigation;
- increase/decrease trust;
- cause denial;
- reveal a secret;
- trigger a faction response;
- create a follow-up mission.

It should not silently rewrite canon.
