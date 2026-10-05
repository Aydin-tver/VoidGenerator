# JSON Authoring Examples v0.7

## Dialogue example

```json
{
  "id": "dlg_solaris_lena_route_irregularity",
  "speaker": "lena_voss",
  "listener": "player",
  "station": "solaris",
  "type": "investigative",
  "purpose": "introduce_unsigned_route_correction",
  "conditions": [
    {
      "fact": "mission.msr01_convoy_irregularity",
      "equals": "active"
    }
  ],
  "nodes": [
    {
      "id": "start",
      "line_key": "dlg.lena.route_irregularity.start",
      "choices": [
        {
          "id": "ask_why",
          "text_key": "dlg.choice.ask_why",
          "next": "why"
        },
        {
          "id": "ask_issuer",
          "text_key": "dlg.choice.ask_issuer",
          "next": "issuer"
        }
      ]
    },
    {
      "id": "issuer",
      "line_key": "dlg.lena.route_irregularity.issuer",
      "effects": [
        {
          "type": "evidence.add",
          "id": "evidence.route_correction_unsigned"
        }
      ],
      "next": "end"
    }
  ]
}
```

## Choice example

```json
{
  "id": "choice_solaris_report_or_withhold",
  "choices": [
    {
      "id": "report",
      "text_key": "choice.report_discrepancy",
      "effects": [
        {
          "type": "faction.reputation",
          "faction_id": "omnicorp",
          "delta": 1
        }
      ],
      "follow_up": "mission.registry_inspection"
    },
    {
      "id": "withhold",
      "text_key": "choice.withhold_discrepancy",
      "effects": [
        {
          "type": "character.trust",
          "character_id": "lena_voss",
          "delta": 1
        }
      ],
      "follow_up": "mission.private_route"
    }
  ]
}
```

These examples are authoring contracts, not a claim that every field is already implemented in the host runtime. Unsupported effect types must first pass the adapter contract.
