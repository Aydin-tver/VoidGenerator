# Ferrum → Nova Dialogue Package v0.7

## S05 — Engineer Nova: Technical Anomaly

Condition:
`flight.entered_region.ferrum`
and relevant investigation mission active.

Nova:
> "This isn't a clean equipment failure."

Player:
- "What makes you say that?"
- "Can you reproduce it?"
- "Could someone have caused it?"

Nova:
> "A failure leaves a pattern. This looks like two systems agreeing on the wrong answer."

Effect:
- investigation advances;
- technical interpretation added.

---

## S06 — Evidence Comparison

Condition:
`evidence.route_correction_unsigned`
AND
`evidence.ferrum_scan_anomaly`

Player:
> "The registry correction and your scan have the same timestamp pattern."

Nova:
> "Then stop calling this a paperwork problem."

Choices:
- "What does it mean?"
- "Show the data to Arcani."
- "Keep it between us."

### What does it mean?
Nova:
> "I have three explanations. None of them are comfortable."

### Show Arcani
Effect proposal:
- Arcani interest increases;
- new investigation dialogue.

### Keep private
Effect proposal:
- character trust/context changes;
- later faction request may differ.

---

## S07 — Faction Pressure

A faction representative requests the evidence.

Player choices:
- present evidence;
- deny possession;
- ask what they already know.

If asked what they know:
NPC provides a claim, not truth.

This prevents the faction from becoming an exposition machine.

---

## S08 — Cross-source Interpretation

Nova:
> "We have two facts from two systems."

Player:
- "So someone is manipulating them."
- "Or both systems are reading the same old instruction."
- "We don't know enough yet."

The third option preserves uncertainty.

## S09 — Next Mystery Lead

Nova:
> "There is one more place I would check."

The next lead should point through knowledge:
- region;
- station;
- signal;
- known route;
- or faction information.

Do not create a forced GPS marker.
