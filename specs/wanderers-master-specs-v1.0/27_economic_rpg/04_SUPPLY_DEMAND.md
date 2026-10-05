# Supply & Demand v1.0

Supply sources:
- station production;
- imports;
- player deliveries;
- faction logistics;
- recovered cargo;
- exploration discoveries.

Demand sources:
- population;
- industry;
- faction operations;
- shortages;
- repairs;
- military/security activity;
- NPC goals.

Basic model:

```text
effective_supply = production + imports + player_delivery - losses
effective_demand = consumption + strategic_demand + shortage_pressure

scarcity = demand / max(supply, minimum_supply)
price = base_price × scarcity_modifier × risk_modifier × market_modifier
```

The exact formula can be tuned during economy telemetry.

Avoid extreme price oscillation with smoothing and caps.
