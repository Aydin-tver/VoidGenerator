# Real Repository Handoff

Before applying the patch:

1. Attach the actual Wanderers source repository/ZIP.
2. Identify:
   - `pubspec.yaml`
   - main `FlameGame`
   - custom `World`
   - event bus/journal
   - mission runtime
   - save/load
   - dialogue runtime
   - faction state
   - NPC state
   - station state
   - ship capability/stat systems
3. Map the interfaces in this package to real classes.
4. Do not rename the existing architecture unnecessarily.

## Required file-level audit

For every integration point record:

```text
File
Class
Method
Current responsibility
Target responsibility
Migration risk
Tests
```

No guessed paths.
