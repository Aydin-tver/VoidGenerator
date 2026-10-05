# Save / Load Requirements

Persist:

```text
knowledge state
knowledge sources
faction story state
NPC memory
station narrative state
consequence effect keys
active narrative missions
dialogue context
```

Do NOT duplicate authoritative:

```text
credits
cargo
ship modules
combat state
travel physics
```

unless the existing save system already owns them.

After load, replaying an already applied consequence must not duplicate it.
