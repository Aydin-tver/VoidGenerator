# NPC Runtime Contract

Each recurring NPC exposes:

```text
identity
faction
goals
needs
fears
beliefs
knowledge
memories
relationships
secrets
capabilities
availability
reaction_profile
```

## Memory

Memory entry:

```text
event
observer
interpretation
certainty
importance
emotional_weight
decay
consequence
```

## NPC reaction

NPC reaction must be derived from state.

Examples:

- Lena learns player protected convoy → trust increases.
- Tidari learns player concealed registry evidence → cooperation decreases.
- Nova receives corroborated anomaly evidence → opens technical dialogue.
- Security officer observes suspicious route behavior → inspection probability increases.
