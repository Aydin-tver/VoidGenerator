# MSR-01 → MSR-05 Mission Chain v0.8

## MSR-01 — Convoy Irregularity

### Purpose
Establish normal commerce, Lena and the first anomaly.

### Gameplay
- accept convoy-related task;
- travel;
- observe/inspect route information;
- return or report.

### Start
Lena at Solaris.

### Objective chain
1. accept Lena's request;
2. inspect convoy route information;
3. identify unsigned correction;
4. return to Lena.

### Success
`evidence.route_correction_unsigned`

### Failure
If the supported gameplay event cannot complete the inspection, mission remains active or enters a recoverable state. Never silently complete.

---

## MSR-02 — Registry Report

### Purpose
Provide an independent source.

### Start condition
MSR-01 completed.

### Objective chain
1. contact Dispatcher Tidari;
2. request original registry record;
3. compare amendment;
4. decide whether to report or withhold.

### Choice C01

#### Report
Narrative:
- registry receives discrepancy;
- OmniCorp context becomes more favorable;
- Lena's response becomes cautious/observational;
- follow-up inspection is available.

#### Withhold
Narrative:
- Lena trusts player's discretion more;
- OmniCorp context becomes suspicious;
- private investigation route is available.

Neither branch is labelled morally correct.

---

## MSR-03 — Ferrum Anomaly

### Purpose
Corroborate the first clue independently.

### Gameplay
- travel to Ferrum;
- scan/discovery;
- optionally resolve a supported encounter/combat;
- collect technical evidence.

### Success
`evidence.ferrum_scan_anomaly`

### Failure
No fabricated completion. Player can retry if the gameplay event remains available.

---

## MSR-04 — Nova Interpretation

### Purpose
Compare independent evidence.

### Condition
`evidence.route_correction_unsigned`
AND
`evidence.ferrum_scan_anomaly`

### Dialogue outcome
Nova acknowledges a pattern but refuses premature certainty.

### Player responses
1. ask for interpretation;
2. involve Arcani;
3. keep information private.

Each response changes future narrative context.

---

## MSR-05 — SIGMA Signal / Next Lead

### Purpose
Open the next mystery layer without explaining SIGMA completely.

### Rule
The player receives:
- a new signal/lead;
- enough location knowledge to continue;
- no artificial GPS requirement.

### End state
The slice ends with an unanswered question, not a lore dump.
