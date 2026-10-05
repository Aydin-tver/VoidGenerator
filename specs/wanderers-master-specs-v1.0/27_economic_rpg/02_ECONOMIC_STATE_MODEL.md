# Economic State Model v1.0

Each station/region has an economic state.

```yaml
market_id:
location:
goods:
  good_id:
    stock:
    production:
    consumption:
    demand:
    base_price:
    current_price:
    price_trend:
    scarcity:
    strategic_value:
    legal_status:
    faction_control:
routes:
  incoming:
  outgoing:
actors:
  suppliers:
  buyers:
  traders:
  smugglers:
events:
  shortages:
  surpluses:
  disruptions:
```

Prices should be derived from state, not arbitrary quest rewards.
