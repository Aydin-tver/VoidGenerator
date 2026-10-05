# ID Namespace & Naming Convention v0.9

## Rule

Every content ID is globally unique and semantically stable.

## Namespaces

```text
mission.*
dialogue.*
node.*
choice.*
evidence.*
character.*
faction.*
station.*
consequence.*
story.*
loc.*
```

## Examples

```text
mission.msr01_convoy_irregularity
dialogue.solaris.lena.route_irregularity
choice.solaris.route_decision
evidence.route_correction_unsigned
character.lena_voss
faction.free_merchants
station.solaris
```

## Rules

- lowercase;
- ASCII;
- underscore or dot separators;
- never encode localized text;
- never encode temporary implementation details;
- never reuse an ID for a different meaning.

## Versioning

Content ID stays stable when wording changes.

Schema version changes when the contract changes.

Example:

```text
id = mission.msr01_convoy_irregularity
schema_version = 2
```

Do not create:
`mission.msr01_convoy_irregularity_v2`
unless it is genuinely a separate content entity.
