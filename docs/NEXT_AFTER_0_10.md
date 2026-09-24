# Next stages after 0.10

## 0.11 — Consequence validation and conflict resolution

Add:

- consequence catalog;
- payload contracts;
- rule validator;
- priority/order policy;
- caps and clamping policies;
- mutually exclusive consequences;
- deterministic conflict resolution;
- dry-run report.

No game integration yet.

## 0.12 — Persistent consequence journal

Persist proposals separately from source events so the host can audit:

`event → rule → proposal → accepted/rejected → state mutation`

Do not make proposals authoritative facts until the host accepts them.

## 0.13 — Story/evidence vocabulary

Add generic proposal contracts for:

- story flags;
- evidence discovered;
- character trust;
- faction reputation;
- world pressure.

Keep the actual state implementations outside the engine.

## 0.14 — Branching narrative runtime

Use event facts + world state queries + consequence proposals to support missions with branches and persistent consequences.

## 0.15 — Integration branch for Wanderers

Only now connect the engine to the real Flutter project. The integration branch should implement adapters and run shadow comparison before changing player-facing behavior.

## 1.0 — Stable event/consequence platform

Required before 1.0:

- deterministic replay;
- persistent journal;
- consequence contracts;
- migration tooling;
- full shadow coverage;
- production integration tests;
- no duplicate rewards/effects;
- documented compatibility policy.
