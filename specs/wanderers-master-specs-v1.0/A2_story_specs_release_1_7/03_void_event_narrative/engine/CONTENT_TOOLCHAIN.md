# Void Event Engine 0.3 — Content Toolchain

The engine now treats content validation as a first-class system.

## Contracts

- `events.catalog.json` — allowed semantic facts and payload contracts.
- `effects.catalog.json` — allowed declarative outcome effects.
- `schema/mission.schema.json` — structural JSON schema.
- `MissionValidator` — semantic validation: references, graph reachability, cycles, catalog membership, impossible ranges.
- `MissionSimulator` — deterministic fixture replay.

## Authoring rule

A mission JSON may consume catalogued events and effects only. If a new event is needed, update the event contract first and add a fixture. Do not silently invent event types inside a mission.

## CI target

For every mission content change:

1. JSON schema validation.
2. semantic validator.
3. fixture replay for critical branches.
4. golden result comparison.
5. localization key check.
6. effect payload contract check.

## 0.3 limitations

The Dart CLI is intentionally small and dependency-light. A production CI layer can add a JSON Schema validator and localization/effect payload adapters in the host project.
