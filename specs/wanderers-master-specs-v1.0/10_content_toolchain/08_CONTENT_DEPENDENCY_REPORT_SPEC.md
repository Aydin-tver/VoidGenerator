# Content Dependency Report v0.9

Each build produces a report containing:

```text
content_id
dependencies
dependents
unresolved references
unsupported capabilities
localization gaps
orphan content
branch coverage
evidence coverage
canon warnings
```

## Example

```text
mission.msr04_nova_interpretation
  requires:
    evidence.route_correction_unsigned
    evidence.ferrum_scan_anomaly

  starts:
    dialogue.ferrum.nova.evidence_comparison

  produces:
    evidence.cross_source_pattern

  unlocks:
    mission.msr05_sigma_signal
```

## Why this matters

The report makes a 500-mission narrative graph inspectable rather than relying on manual memory.
