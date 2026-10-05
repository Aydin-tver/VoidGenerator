# Character & Faction State Package v0.8

## Lena

### Before C01
```text
context: normal_convoy
trust: baseline
```

### Report branch
```text
context: player_reports_discrepancy
trust: unchanged_or_cautious
```

### Withhold branch
```text
context: player_kept_route_private
trust: increased_context
```

The exact numeric relationship change should only be added if the host relationship system supports it.

## Dispatcher Tidari

After E-01:
```text
context: registry_discrepancy_active
```

If player reports:
```text
context: report_received
```

If player withholds:
```text
context: player_withheld_discrepancy
```

## Nova

After E-02:
```text
context: technical_anomaly_observed
```

After E-01 + E-02:
```text
context: cross_source_pattern
```

## OmniCorp

The mission should create a narrative context proposal, not silently mutate an unrelated authoritative reputation value.

## Free Merchants

Same rule: preserve the distinction between:
- actual gameplay reputation;
- narrative interpretation of the player's decision.
