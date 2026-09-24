# Roadmap after 0.6

## 0.7 — Wanderers shadow integration

Connect the real 3.17.x game domain to the producer facade. Start with Convoy,
then Combat, Salvage, Trade, Station and Scan. Keep legacy mission rewards
authoritative.

## 0.8 — Mission family migration

Migrate one family at a time. For each family:

1. author canonical JSON;
2. validate against catalog;
3. replay fixtures;
4. run legacy/new shadow comparison;
5. enable feature flag for event-engine authority;
6. keep shadow telemetry;
7. remove legacy objective mapping only after stable verification.

## 0.9 — Persistent world event layer

Add durable event journal, WorldState/FactionState projections, evidence and
consequence effects. Keep projections derived from facts where practical.

## 1.0 — Production cutover

Remove legacy mission runtime, finalize save/version migration, add performance
benchmarks, replay regression suite and production diagnostics.

### Do not build yet

Do not build a visual mission editor before the event catalog, fixtures and
shadow telemetry have stabilized. JSON remains the canonical authored format.
