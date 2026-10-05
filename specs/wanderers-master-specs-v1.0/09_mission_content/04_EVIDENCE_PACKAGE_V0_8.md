# Evidence Package v0.8

## E-01 — Unsigned Route Correction

```text
id: evidence.route_correction_unsigned
source: solaris_registry
type: documentary
status: known
```

### What it proves
A convoy route amendment exists without the expected issuer signature.

### What it does NOT prove
- who created it;
- why it was created;
- whether it was malicious;
- whether it is connected to SIGMA.

---

## E-02 — Ferrum Scan Anomaly

```text
id: evidence.ferrum_scan_anomaly
source: ferrum_scan
type: technical
status: known
```

### What it proves
A technical anomaly shares a structural/timing pattern relevant to the earlier discrepancy.

### What it does NOT prove
- deliberate manipulation;
- SIGMA involvement;
- Thread involvement.

---

## E-03 — Cross-source Pattern

Derived only after E-01 + E-02.

```text
id: evidence.cross_source_pattern
source: narrative_inference
type: interpretation
status: interpreted
```

This is an interpretation, not raw evidence.

## Knowledge ladder

```text
RUMOR
 ↓
LEAD
 ↓
EVIDENCE
 ↓
CORROBORATION
 ↓
INTERPRETATION
 ↓
REVELATION
```

The player should never receive E-03 as if it were an objective physical fact.
