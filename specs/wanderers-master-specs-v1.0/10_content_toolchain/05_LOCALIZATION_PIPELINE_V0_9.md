# Localization Pipeline v0.9

## Principle

Narrative content stores localization keys, not display text.

```json
{
  "line_key": "dlg.lena.route_irregularity.start"
}
```

Localization:

```json
{
  "dlg.lena.route_irregularity.start": "The registry sent a correction."
}
```

## Key rules

- keys are stable;
- keys never contain translated text;
- deleted keys require migration/removal review;
- missing localization is a hard error for shipping languages.

## Language strategy

Initial production language can be one source language.

Every line still gets a key so translation can be added later without changing narrative IDs.

## Variables

Use explicit placeholders:

```text
"Route to {region_name} was amended."
```

Variable names must be stable and validated.
