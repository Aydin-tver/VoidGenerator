# Production Content QA v0.8

## Mission QA

- [ ] MSR-01 has a valid start.
- [ ] Every objective has a real event source.
- [ ] MSR-02 requires MSR-01.
- [ ] C01 persists its branch.
- [ ] MSR-03 can only complete from valid Ferrum gameplay.
- [ ] MSR-04 requires both independent clues.
- [ ] MSR-05 has a valid follow-up.

## Dialogue QA

- [ ] every speaker exists;
- [ ] every localization key exists;
- [ ] every choice has a valid target/effect;
- [ ] revisit dialogue differs by state;
- [ ] no unsupported effect is used;
- [ ] fallback dialogue exists.

## Evidence QA

- [ ] evidence has provenance;
- [ ] evidence does not claim more than it proves;
- [ ] interpretations are marked as interpretations;
- [ ] contradictions are representable.

## Persistence QA

Test:

### T01
Start → save → load.

### T02
Acquire E-01 → save → load → inspect dialogue.

### T03
Choose REPORT → save → load → revisit Lena.

### T04
Choose WITHHOLD → save → load → revisit Lena.

### T05
Re-emit completion event → verify no duplicate effect.

### T06
Fail an objective → reload → verify deterministic recovery.

## Narrative QA

- [ ] both branches are playable;
- [ ] branches reconverge without erasing branch context;
- [ ] player receives enough information to continue;
- [ ] no artificial GPS dependency;
- [ ] mystery remains uncertain at the intended point.
