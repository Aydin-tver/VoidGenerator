# Wanderers — Narrative Gating Model v0.2

## Goal

Make branching content depend on information and game state that actually exists.

## Gate sources

### A. Narrative

- story flag;
- milestone;
- narrative completion.

### B. Evidence

- evidence discovered;
- evidence combination;
- contradiction present.

### C. Character

- trust threshold;
- memory present;
- status.

### D. Faction

- authoritative reputation threshold;
- faction story milestone;
- faction state.

### E. Gameplay capability

- ship/system capability already exposed by the game.

### F. World

- registered world consequence/state.

## Gate rule

A gate may read only. It cannot mutate state.

## Avoid stat explosion

Do not introduce generic RPG attributes such as persuasion, intelligence, charisma, stealth level, etc. unless the game already has or explicitly adds the corresponding gameplay system.

## Examples

Valid:

```text
requires evidence.sigma.archive_fragment
```

Valid:

```text
requires faction reputation >= threshold
```

Valid:

```text
requires capability.scan
```

Invalid without new gameplay support:

```text
requires charisma >= 12
```

Invalid:

```text
requires player.has_read_lore_book_17
```

unless reading the book is an actual authored event/fact.
