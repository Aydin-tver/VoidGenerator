# Next after 0.13

## 0.14 — Branching Narrative Runtime

Build a host-neutral narrative runtime on top of the vocabulary:

1. story conditions;
2. evidence/knowledge gates;
3. relationship gates;
4. capability gates;
5. deterministic branching outcomes;
6. mission activation/deactivation;
7. narrative state transition replay;
8. explicit outcome IDs rather than hidden mutation.

The runtime should produce proposals and transitions; Wanderers remains the owner of StoryState, CharacterState and other persistent domain state.

## 0.15 — Separate Wanderers Integration

Create a separate branch/release with adapters for the actual Flutter project. Keep Legacy Mission Runtime authoritative first.

## 0.16 — Shadow Migration

Run legacy and new runtimes together for Convoy, Scan, Salvage, Station, Trade, Combat and selected branching missions. Require zero mismatches before authority switching.

## 0.17 — Authority Switching

Introduce per-domain `legacy`, `shadow`, and `modern` authority. Enable modern authority one domain at a time.

## 0.18 — Production Hardening

Crash recovery, journal compaction, schema migrations, performance, memory limits, CI content validation, deterministic replay and telemetry.

## 1.0

Stable event/mission/consequence/narrative API and completed migration path. Wanderers-specific state remains outside the standalone engine.
