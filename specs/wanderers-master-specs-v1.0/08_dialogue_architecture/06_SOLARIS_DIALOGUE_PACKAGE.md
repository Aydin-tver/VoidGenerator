# Solaris Dialogue Package v0.7

## S01 — Lena: A Normal Run

**Purpose:** establish Lena, convoy work and the normal baseline.

Lena:
> "You look like you're waiting for a reason to leave."

Player:
- "I'm checking the route."
- "What do you need?"
- "Nothing. Just watching."

Lena:
> "Good. A convoy captain learns to distrust anything that looks too tidy."

**Effect:** opens ordinary convoy mission.

---

## S02 — Lena: Route Irregularity

Condition:
`mission.msr01_convoy_irregularity.active`

Lena:
> "The registry sent a correction."

Player:
- "What's wrong with it?"
- "Who issued it?"
- "You don't trust it."

Lena:
> "I trust corrections with names on them. This one has a timestamp and nothing else."

If `evidence.route_correction_unsigned` is not yet acquired:
- create lead;
- no final interpretation.

---

## S03 — Dispatcher Tidari: Registry Report

Condition:
`lead.route_correction`

Tidari:
> "You want the original record?"

Player:
- "Yes. The convoy received an unsigned correction."
- "I only need the destination."
- "Who can modify this registry?"

Tidari:
> "The destination is ordinary. The amendment isn't."

If player asks who can modify:
Tidari:
> "That is a longer answer than you're currently authorized to hear."

**Effect:** evidence becomes available.

---

## C01 — Report or Withhold

### Report
Player:
> "I'll submit the discrepancy."

Effect proposal:
- faction reputation: OmniCorp +;
- merchant context: cautious;
- follow-up: inspection.

### Withhold
Player:
> "I'll keep the discrepancy off the report."

Effect proposal:
- merchant trust +;
- OmniCorp context: suspicious;
- follow-up: private route.

Neither option is labelled morally correct.

---

## S04 — Consequence Revisit

If report:
Lena:
> "They inspected the route. Slowed us down, but nobody disappeared."

If withhold:
Lena:
> "The private route worked. Now I need to know why someone wanted the official route changed."

The same NPC therefore remembers the player.
