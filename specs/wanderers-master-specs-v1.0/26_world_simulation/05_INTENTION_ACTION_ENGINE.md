# Intention & Action Engine v1.0

Actors convert goals into candidate actions.

Example:

Faction goal:
protect high-value trade route.

Available actions:
- increase patrols;
- hire escorts;
- change insurance cost;
- restrict access;
- investigate suspected pirates;
- negotiate with another faction.

Each action has:

```yaml
action:
  actor:
  goal:
  target:
  requirements:
  cost:
  risk:
  expected_result:
  possible_results:
  consequences:
```

The simulation selects or resolves actions according to priorities, resources and constraints.
