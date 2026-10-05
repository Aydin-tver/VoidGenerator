# Station State Transitions v0.8

## Solaris

```text
normal
  ↓ MSR-01
route_irregularity
  ↓ C01
report_received
or
private_route_context
```

The state must only be applied if the host has a corresponding narrative/world state owner.

## Ferrum

```text
normal
  ↓ MSR-03
technical_investigation
  ↓ MSR-04
anomaly_documented
```

## Nova

```text
normal
  ↓ cross-source evidence
investigation_open
  ↓ MSR-05
next_lead_available
```

## Important

A "station state" is not automatically a visual transformation.

It may initially affect:
- available dialogue;
- mission pool;
- information;
- NPC context;
- evidence;
- station messaging.

Visual changes can be added later when supported.
